import configparser
import glob
import os
from configparser import RawConfigParser
from pathlib import Path
from collections import OrderedDict
import re
from typing import List, Tuple

import iso639

import argparse

from iso639 import LanguageNotFoundError, Language
from parsimonious.exceptions import IncompleteParseError, ParseError
from parsimonious.grammar import Grammar
from parsimonious.nodes import NodeVisitor


def parse_unt(contents: str) -> List[Tuple[str, str]]:
    """
    Parse an Unreal Tournament translation file.
    :param contents: The contents of the file.
    :return: A list of key-value pairs.
    """

    grammar = Grammar(
        """
        value = string / name / array / struct
        string = ~'"[^\"]*"'
        name = ~"[A-Z_0-9]+"i
        comma = ","
        empty_value = ","
        array_values = (comma / value)*
        array = "(" array_values? ")"
        struct_key = ~"[A-Z0-9]*"i
        struct_value = struct_key '=' value
        struct_values = struct_value (',' struct_value)* 
        struct = '(' struct_values? ')'
        """
    )

    class ValueVisitor(NodeVisitor):

        def visit_value(self, node, visited_children):
            return visited_children[0]

        def visit_name(self, node, visited_children):
            return node.text

        def visit_comma(self, node, visited_children):
            return None

        def visit_array_values(self, node, visited_children):
            values = []
            last_value = None
            for child in visited_children:
                value = child[0]
                if value is None:   # comma
                    values.append(last_value)
                last_value = value
            values.append(last_value)
            return values

        def visit_array(self, node, visited_children):
            if len(visited_children) == 3:
                return visited_children[1][0]
            return []

        def visit_struct(self, node, visited_children):
            if len(visited_children) == 3:
                return visited_children[1][0]
            return dict()

        def visit_string(self, node, visited_children):
            return node.text.lstrip('"').rstrip('"')

        def visit_struct_value(self, node, visited_children):
            return (visited_children[0], visited_children[2])

        def visit_struct_values(self, node, visited_children):
            struct_values = []
            struct_values.append(visited_children[0])
            for child in visited_children[1]:
                struct_values.append(child[1])
            return {k: v for k, v in struct_values}

        def visit_struct_key(self, node, visited_children):
            return node.text

        def generic_visit(self, node, visited_children):
            return visited_children or node

    config = RawConfigParser()
    config.optionxform = str

    try:
        config.read_string(contents)
    except configparser.MissingSectionHeaderError as e:
        raise RuntimeError(f'Failed to parse file: {e}')

    key_value_pairs: List[Tuple[str, str]] = []

    for section in config.sections():
        for key in config[section]:
            value = config[section][key]
            visitor = ValueVisitor()
            try:
                value = visitor.visit(grammar.parse(value))
            except IncompleteParseError:
                print('IncompleteParseError', section, key, value)
                continue
            except ParseError:
                print('ParseError', section, key, value)
                continue

            id = f'{section}.{key}'

            def add_key_value_pairs_recursive(id: str, value):
                if type(value) == str:
                    key_value_pairs.append((id, str(value)))
                elif type(value) == list:
                    for i, item in enumerate(value):
                        add_key_value_pairs_recursive(f'{id}<{i}>', item)
                elif type(value) == dict:
                    for k, v in value.items():
                        id = f'{id}.{k}'
                        add_key_value_pairs_recursive(id, v)

            add_key_value_pairs_recursive(id, value)

    return key_value_pairs


def write_po(path: str, key_value_pairs: list, language_code: str):
    with open(path, 'wb') as f:
        lines = [
            "msgid \"\"",
            "msgstr \"\"",
            f"\"Language: {language_code}\"",
            "\"MIME-Version: 1.0\"",
            "\"Content-Type: text/plain\"",
            "\"Content-Transfer-Encoding: 8bit; charset=UTF-8\"",
            ""
        ]

        for key, value in key_value_pairs:
            lines.append(f'msgid "{key}"')
            lines.append(f'msgstr "{value}"')
            lines.append('')

        contents = '\n'.join(lines)

        f.write(contents.encode('utf-8'))


def po_to_unt(contents: str) -> str:
    import polib
    po = polib.pofile(contents)
    sections = OrderedDict()

    for entry in po:
        parts = entry.msgid.split('.')
        section = parts.pop(0)

        if section not in sections:
            sections[section] = OrderedDict()

        section = sections[section]
        target = section
        target_key = None

        while parts:
            key = parts.pop(0)

            # Check if this is an array of the form Name[Index] with regex.
            regex = r"^(?P<id>[A-Za-z0-9_]+)\<(?P<index>\d+)\>$"
            match = re.match(regex, key)

            if match:
                # Array
                key = match['id']
                if key in target:
                    if not isinstance(target[key], list):
                        raise Exception(f'Expected {key} to be a list (found {type(target[key])})')
                else:
                    target[match['id']] = []
                target = target[match['id']]
                index = int(match['index'])
                # Ensure that the list is long enough.
                while len(target) <= index:
                    target.append(None)
                target_key = index
            elif target is not section:
                # Struct
                target[target_key] = OrderedDict()
                target = target[target_key]
                target_key = key
            else:
                target_key = key

        target[target_key] = entry.msgstr

    def write_value(value):
        if isinstance(value, str):
            return f'"{value}"'
        elif isinstance(value, list):
            return '(' + ','.join(map(write_value, value)) + ')'
        elif isinstance(value, dict):
            return '(' + ','.join(f'{k}={write_value(v)}' for k, v in value.items()) + ')'
        elif value is None:
            return ''
        else:
            raise Exception(f'Unknown type: {type(value)}')

    for section_name, section in sections.items():
        print(f'[{section_name}]')

        for key, value in section.items():
            print(f'{key}={write_value(value)}')

        print('')


def command_import(args):
    with open(args.input_path, 'r') as file:
        # TODO: fill this in
        po_to_unt(file.read())


def command_export(args):
    input_path = args.input_path
    basename, extension = os.path.splitext(os.path.basename(input_path))

    # Make sure the extension is 4 characters long (e.g., ".int")
    if len(extension) != 4:
        print('Invalid file extension "{extension}"')
        return

    # Get the first 2 characters of the extension and map it to an ISO 639-1 language code.
    language_code = extension[1:3]

    if language_code == 'in':
        # Unreal Tournament uses "in" to mean "international", which in practice means English.
        language_code = 'en'

    # Look up the language code in the ISO 639-1 table.
    try:
        language = Language.from_part1(language_code)
    except LanguageNotFoundError:
        print(f'Unknown language code {language_code} for file {basename}')
        return

    with open(input_path, 'r') as file:
        unt_contents = file.read()
        key_value_pairs = parse_unt(unt_contents)

        # Write the file with the name {filename}.en.po
        os.makedirs(basename, exist_ok=True)

        write_po(args.output_path, key_value_pairs, language_code)


def command_export_directory(args):
    input_path = args.input_path

    for filename in glob.glob(f'{input_path}/*.*t'):
        filename = os.path.relpath(filename, input_path)

        basename, extension = os.path.splitext(filename)

        # Make sure the extension is 4 characters long (e.g., ".int")
        if len(extension) != 4:
            continue

        # Get the first 2 characters of the extension and map it to an ISO 639-1 language code.
        language_code = extension[1:3]

        if language_code == 'in':
            # Unreal Tournament uses "in" to mean "international", which in practice means English.
            language_code = 'en'

        # Look up the language code in the ISO 639-1 table.
        try:
            language = Language.from_part1(language_code)
        except LanguageNotFoundError:
            print(f'Unknown language code {language_code} for file {filename}')
            continue

        if args.verbose:
            print(f'Processing {filename} - {language.name} ({language.part1})')

        input_filename = os.path.join(input_path, filename)

        with open(input_filename, 'r') as file:
            try:
                key_value_pairs = parse_unt(file.read())
            except RuntimeError as e:
                print(f'Failed to parse file {filename}: {e}')
                continue

            if args.verbose:
                print(f'Found {len(key_value_pairs)} key-value pairs')

            output_path = args.output_path
            output_path = output_path.replace('{l}', language.part1)
            output_path = output_path.replace('{f}', basename)

            if args.verbose:
                print(f'Writing to {os.path.abspath(output_path)}')

            if not args.dry:
                os.makedirs(os.path.dirname(output_path), exist_ok=True)
                write_po(output_path, key_value_pairs, language_code)

# Create the top-level parser
argparse = argparse.ArgumentParser(prog='u18n', description='Unreal Tournament localization file utilities')

# Make two commands with subparsers: import and export
subparsers = argparse.add_subparsers(dest='command', required=True)

# Add the import command
import_parser = subparsers.add_parser('import', help='Import a .po file to an Unreal Tournament translation file')
import_parser.add_argument('input_path')
import_parser.add_argument('output_path')
import_parser.set_defaults(func=command_import)

# Add the export command
export_parser = subparsers.add_parser('export', help='Export an Unreal Tournament translation file to a .po file')
export_parser.add_argument('input_path')
export_parser.add_argument('output_path')
export_parser.set_defaults(func=command_export)

export_directory_parser = subparsers.add_parser('export_directory', help='Export all Unreal Tournament translation files in a directory to .po files')
export_directory_parser.add_argument('input_path',
                                     help='The directory to search for Unreal Tournament translation files'
                                     )
export_directory_parser.add_argument('-o', '--output_path',
                                     help='The pattern to use for the output path. Use {l} to substitute the ISO-3608 language code and {f} to substitute the filename.',
                                     default='{f}/{f}.{l}.po',
                                     required=False
                                     )
export_directory_parser.add_argument('-d', '--dry', help='Dry run', default=False, action='store_true', required=False)
export_directory_parser.add_argument('-l', '--language_code', help='The language to export (ISO 639-1 codes)', required=False)
export_directory_parser.add_argument('-w', '--overwrite', help='Overwrite existing files', default=False, action='store_true', required=False)
export_directory_parser.add_argument('-v', '--verbose', help='Verbose output', default=False, action='store_true', required=False)
export_directory_parser.set_defaults(func=command_export_directory)

if __name__ == '__main__':
    args = argparse.parse_args()
    args.func(args)
