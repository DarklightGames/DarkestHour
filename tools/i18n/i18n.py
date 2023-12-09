import glob
import os
from configparser import RawConfigParser
from pathlib import Path
from collections import OrderedDict
import re

import argparse
from parsimonious.exceptions import IncompleteParseError
from parsimonious.grammar import Grammar
from parsimonious.nodes import NodeVisitor

def unt_to_po(contents: str) -> str:

    grammar = Grammar(
        """
        value = string / name / array / struct
        string = ~'"[^\"]+"'
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
    config.read_string(contents)

    contents = ''
    contents += "msgid \"\"\n"
    contents += "msgstr \"\"\n"
    contents += "\"Language: en\"\n"
    contents += "\"MIME-Version: 1.0\"\n"
    contents += "\"Content-Type: text/plain\"\n"
    contents += "\"Content-Transfer-Encoding: 8bit; charset=utf-8\"\n"
    contents += "\n"

    key_value_pairs = []

    for section in config.sections():
        for key in config[section]:

            value = config[section][key]

            visitor = ValueVisitor()
            try:
                value = visitor.visit(grammar.parse(value))
            except IncompleteParseError:
                print('IncompleteParseError', value)
                print(value)
                continue

            id = f'{section}.{key}'

            def add_key_value_pairs_recursive(id, value):
                if type(value) == str:
                    key_value_pairs.append((id, value))
                elif type(value) == list:
                    for i, item in enumerate(value):
                        add_key_value_pairs_recursive(f'{id}[{i}]', item)
                elif type(value) == dict:
                    for k, v in value.items():
                        id = f'{id}.{k}'
                        add_key_value_pairs_recursive(id, v)

            add_key_value_pairs_recursive(id, value)

    for key, value in key_value_pairs:
        contents += f'msgid "{key}"\n'
        contents += f'msgstr "{value}"\n'
        contents += '\n'

    # Encode to UTF-8
    return contents


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
            regex = r"^(?P<id>[A-Za-z0-9_]+)\[(?P<index>\d+)\]$"
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


def import_po(args):
    with open(args.input_path, 'r') as file:
        po_to_unt(file.read())

def export_po(args):
    input_path = args.input_path
    filename = os.path.splitext(os.path.basename(input_path))[0]

    with open(input_path, 'r') as file:
        unt_contents = file.read()
        po_contents = unt_to_po(unt_contents)

        # Write the file with the name {filename}.en.po
        os.makedirs(filename, exist_ok=True)
        with open(Path(f'{filename}/{filename}.en.po'), 'wb') as file:
            file.write(po_contents.encode('utf-8'))

    pass

# Create the top-level parser
argparse = argparse.ArgumentParser(prog='i18n', description='Unreal Tournament translation file utilities')

# Make two commands with subparsers: import and export
subparsers = argparse.add_subparsers(dest='command', required=True)

# Add the import command
import_parser = subparsers.add_parser('import', help='Import a .po file to an Unreal Tournament translation file')
import_parser.add_argument('input_path')
import_parser.add_argument('output_path')
import_parser.set_defaults(func=import_po)

# Add the export command
export_parser = subparsers.add_parser('export', help='Export an Unreal Tournament translation file to a .po file')
export_parser.add_argument('input_path')
export_parser.add_argument('output_path')
export_parser.set_defaults(func=export_po)

if __name__ == '__main__':
    args = argparse.parse_args()
    args.func(args)
