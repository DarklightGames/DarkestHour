import argparse
import glob
from pathlib import Path

import git
import polib
import os
import re
from collections import OrderedDict
from configparser import MissingSectionHeaderError, RawConfigParser
from iso639 import LanguageNotFoundError, Language
from parsimonious.exceptions import IncompleteParseError, ParseError
from parsimonious.grammar import Grammar
from parsimonious.nodes import NodeVisitor
from typing import List, Optional, Tuple
from unt import iso639_to_language_extension
import yaml


grammar = Grammar(
    """
    value = string / name / array / struct
    string = ~'"[^\"]*"'
    name = ~"[A-Z_0-9\.]+"i
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
            if value is None:  # comma
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


def parse_unt(contents: str) -> List[Tuple[str, str]]:
    """
    Parse an Unreal Tournament translation file.
    :param contents: The contents of the file.
    :return: A list of key-value pairs.
    """
    config = RawConfigParser(strict=False)
    config.optionxform = str

    try:
        config.read_string(contents)
    except MissingSectionHeaderError as e:
        raise RuntimeError(f'Failed to parse file: {e}')

    key_value_pairs: List[Tuple[str, str]] = []

    for section in config.sections():
        for key in config[section]:
            value = config[section][key]
            visitor = ValueVisitor()
            try:
                value = visitor.visit(grammar.parse(value))
            except IncompleteParseError:
                # This will handle the case where the strings are simply unquoted. The entirety of the value will be
                # considered a string.
                pass
            except ParseError:
                pass

            if type(value) == str:
                # We need to fix string values that are not quoted.
                if value.startswith('"') and value.endswith('"'):
                    value = value[1:-1]
                    # Escape quotes.
                    value = value.replace('"', '\\"')

            id = f'{section}.{key}'

            def add_key_value_pairs_recursive(id: str, value):
                if isinstance(value, str):
                    key_value_pairs.append((id, str(value)))
                elif isinstance(value, list):
                    for i, item in enumerate(value):
                        add_key_value_pairs_recursive(f'{id}<{i}>', item)
                elif isinstance(value, dict):
                    for k, v in value.items():
                        add_key_value_pairs_recursive(f'{id}.{k}', v)

            add_key_value_pairs_recursive(id, value)

    return key_value_pairs


def write_po(path: str, key_value_pairs: list, language_code: str):
    with open(path, 'wb') as f:
        lines = [
            "msgid \"\"",
            "msgstr \"\"",
            f"\"Language: {language_code}\\n\"",
            "\"MIME-Version: 1.0\\n\"",
            "\"Content-Type: text/plain\\n\"",
            "\"Content-Transfer-Encoding: 8bit; charset=UTF-8\\n\"",
            ""
        ]

        for key, value in key_value_pairs:
            lines.append(f'msgid "{key}"')
            lines.append(f'msgstr "{value}"')
            lines.append('')

        contents = '\n'.join(lines)

        f.write(contents.encode('utf-8'))


def add_entry(msgid: str, msgstr: str, sections):
    parts = msgid.split('.')
    section = parts.pop(0)

    if section not in sections:
        sections[section] = OrderedDict()

    section = sections[section]
    target = section
    target_key = None

    while len(parts) > 0:
        key = parts.pop(0)

        # Check if this is an array of the form Name<Index> with regex.
        regex = r"^(?P<id>[A-Za-z0-9_]+)\<(?P<index>\d+)\>$"
        match = re.match(regex, key)
        has_more_parts = len(parts) > 0

        is_dynamic_array = match is not None

        if is_dynamic_array:
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
        else:
            if has_more_parts:
                if isinstance(target, list):
                    # Target is a list, so add a struct to it.
                    target[target_key] = OrderedDict()
                    target = target[target_key]
                    target_key = key
                else:
                    # Struct
                    if key not in target:
                        # TODO: Doesn't work if the target is a list.
                        target[key] = OrderedDict()
                    target = target[key]
                    # target_key = key

        if not is_dynamic_array:
            if isinstance(target, list):
                # This is a list of structs, so add the struct if it doesn't exist.
                # TODO: this is incorrect, this can just be a list of strings. How do we detect that?
                target[target_key] = OrderedDict()
                target = target[target_key]
                target_key = key
            else:
                target_key = key

    target[target_key] = msgstr


def po_to_unt(contents: str) -> str:
    po = polib.pofile(contents)

    sections = OrderedDict()

    # Add each entry.
    for entry in po:
        try:
            add_entry(entry.msgid, entry.msgstr, sections)
        except Exception as e:
            print(f'Failed to add entry {entry.msgid}: {e}')

    def write_key_value_pairs_recursive(key_value_pairs, parent_key=None):
        for key, value in key_value_pairs:
            if isinstance(value, OrderedDict):
                write_key_value_pairs_recursive(value.items(), key)
            else:
                written_key = key
                if parent_key is not None:
                    written_key = f'{parent_key}.{key}'
                lines.append(f'{written_key}={write_value(value)}')

    def write_value(value):
        if isinstance(value, str):
            return f'"{value}"'
        elif isinstance(value, list):
            return '(' + ','.join(map(write_value, value)) + ')'
        elif isinstance(value, dict) or isinstance(value, OrderedDict):
            return '(' + ','.join(f'{k}={write_value(v)}' for k, v in value.items()) + ')'
        elif value is None:
            return ''
        else:
            raise Exception(f'Unknown type: {type(value)}')

    lines = []

    for section_name, section in sections.items():
        lines.append(f'[{section_name}]')
        write_key_value_pairs_recursive(section.items())
        lines.append('')

    return '\n'.join(lines)


def command_export_file(args):
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
        Language.from_part1(language_code)
    except LanguageNotFoundError:
        print(f'Unknown language code {language_code} for file {basename}')
        return

    with open(input_path, 'r') as file:
        unt_contents = file.read()
        key_value_pairs = parse_unt(unt_contents)

        # Write the file with the name {filename}.en.po
        os.makedirs(basename, exist_ok=True)

        write_po(args.output_path, key_value_pairs, language_code)


def get_language_from_unt_extension(extension: str) -> Optional[Language]:
    # Make sure the extension is 4 characters long (e.g., ".int")
    if len(extension) != 4:
        raise LanguageNotFoundError(f'Invalid file extension "{extension}"')

    # Get the first 2 characters of the extension and map it to an ISO 639-1 language code.
    language_code = extension[1:3]

    if language_code == 'in':
        # Unreal Tournament uses "in" to mean "international", which in practice means English.
        language_code = 'en'

    # Look up the language code in the ISO 639-1 table.
    return Language.from_part1(language_code)


def update_keys(args, source_language_code: str = 'en'):
    """
    This function was made for the purpose of fixing the key format in the .po files for dynamic arrays.
    In the original export, dynamic arrays were indistinguishable from static arrays, so re-ingested .po files would
    result in the loss of dynamic array data.

    This does a simple key substitution where it converts each msgid to a regex pattern, substituting square brackets
    for angle brackets. Then, it searches for each pattern in the output file and replaces it with the updated msgid
    from the input file.
    """
    input_directory = args.input_directory
    output_directory = args.output_directory

    # Read each .po file, recursively, in the input directory.
    # Match it to a file in the output directory with the same relative path.
    # Assume the order is the same, and update the msgid in the output file with the msgid in the input file.
    input_glob_pathname = f'{input_directory}/**/*.{source_language_code}.po'

    for input_filename in glob.glob(input_glob_pathname, recursive=True):
        relative_input_filename = os.path.relpath(input_filename, input_directory)

        # Get the base name of the file and separate out the language code.
        basename = os.path.basename(input_filename)
        regex = r'([^\.]+)\.([a-z]{2})\.po$'
        match = re.search(regex, basename)
        basename = match.group(1)

        print(basename)

        with open(input_filename, 'r') as input_file:
            input_contents = input_file.read()
            po = polib.pofile(input_contents)

            # Turn each string into a regex pattern, and make it so that square and angle brackets are interchangeable.
            msgid_patterns = list()
            for entry in po:
                pattern = entry.msgid.replace('<', '[').replace('>', ']')
                pattern = re.escape(pattern).replace('\[', '[\[<]').replace('\]', '[\]>]')
                # Surround the pattern with ^ and $ to make sure it matches the entire string.
                pattern = f'^{pattern}$'
                msgid_patterns.append((entry.msgid, pattern))

            output_glob_pathname = f'{output_directory}/{basename}/{basename}.??.po'

            # Iterate over each language file that matches the input file's relative path.
            for output_filename in glob.glob(output_glob_pathname, recursive=True):
                print(output_filename)
                output_msgid_patterns = msgid_patterns.copy()
                with open(output_filename, 'r', encoding='utf-8') as output_file:
                    output_contents = output_file.read()
                    output_po = polib.pofile(output_contents, encoding='utf-8')

                for output_entry in output_po:
                    for msgid_index, (msgid, pattern) in enumerate(output_msgid_patterns):
                        match = re.match(pattern, output_entry.msgid)
                        if msgid != output_entry.msgid and match:
                            print(f'{output_entry.msgid} -> {msgid}')
                            output_entry.msgid = msgid
                            # Remove the pattern from the list so that we don't match it again.
                            del output_msgid_patterns[msgid_index]
                            break

                if not args.dry:
                    output_po.save(output_filename)


def read_localization_config(path: Path, mod: Optional[str] = None) -> dict:
    if mod is not None:
        path /= mod

    localization_config_path = path / 'localization.yml'

    # Make sure the configuration file exists.
    if not localization_config_path.is_file():
        raise FileNotFoundError(f'Configuration file {localization_config_path} not found')

    # Load the YAML configuration file.
    with open(str(localization_config_path), 'r') as file:
        localization_data = yaml.load(file, Loader=yaml.FullLoader)

    return localization_data


def command_export(args):
    root_path = Path(args.path).absolute().resolve()
    localization_data = read_localization_config(root_path, args.mod)

    input_patterns = localization_data['export']['input_patterns']

    count = 0

    for pattern in input_patterns:
        glob_pattern = str(root_path / pattern)
        for input_path in glob.glob(glob_pattern):
            # Get the file name without the path.
            filename = Path(input_path).name
            basename, extension = os.path.splitext(filename)

            # Look up the language code in the ISO 639-1 table.
            try:
                language = get_language_from_unt_extension(extension)
            except LanguageNotFoundError:
                print(f'Unknown language code for file {filename}')
                continue

            # Skip this file if the language code doesn't match the one we're looking for.
            if args.language_code is not None and args.language_code != language.part1:
                if args.verbose:
                    print(f'Skipping {filename}, language code {language.part1} does not match {args.language_code}')
                continue

            if args.verbose:
                print(f'Processing {filename} - {language.name} ({language.part1})')

            # This is a bit of a hack, but our .int files are windows-1252, and all others are supposed to be utf-16-le.
            with open(input_path, 'rb') as file:
                try:
                    # Look for the BOM.
                    bom = file.read(2)

                    if bom == b'\xff\xfe':
                        # utf-16-le
                        file.seek(2)
                        unt_contents = file.read().decode('utf-16-le')
                    else:
                        # windows-1252
                        file.seek(0)
                        unt_contents = file.read().decode('windows-1252')

                    # Parse the Unreal translation file to a list of key-value pairs.
                    key_value_pairs = parse_unt(unt_contents)
                except RuntimeError as e:
                    print(f'Failed to parse file {filename}: {e}')
                    continue

                if args.verbose:
                    print(f'Found {len(key_value_pairs)} key-value pairs')

                output_filename = localization_data['export']['output_pattern']
                output_filename = output_filename.replace('{l}', language.part1)
                output_filename = output_filename.replace('{f}', basename)

                repository_path = root_path / localization_data['repository']['path']
                output_path = repository_path / output_filename

                if not args.dry:
                    os.makedirs(os.path.dirname(output_path), exist_ok=True)

                    if args.verbose:
                        print(f'Writing to {output_path}')

                    write_po(output_path, key_value_pairs, language.part1)

                    count += 1

    print(f'Exported {count} file(s)')


def sync(args):
    root_path = Path(args.path).absolute().resolve()
    localization_data = read_localization_config(root_path, args.mod)
    repository_path = root_path / localization_data['repository']['path']

    # For each .po file in the repository, convert it to a .xxt file and move it to the System folder inside the mod.
    pattern = str(repository_path / '**' / '*.po')

    # Print out the latest commit info (author, date, message etc.)
    repo = git.Repo(repository_path)
    latest_commit = repo.head.commit
    print(f'Latest commit: {latest_commit} by {latest_commit.author} on {latest_commit.authored_datetime} with message "{latest_commit.message}"')

    files_processed = 0
    language_files_processed = dict()
    sync_languages = set(localization_data['sync']['languages'])

    for filename in glob.glob(pattern, recursive=True):

        # Get the base name of the file and separate out the language code.
        basename = os.path.basename(filename)
        # TODO: have this regex be part of the configuration file.
        regex = r'([^\.]+)\.([a-z]{2})\.po$'
        match = re.search(regex, basename)
        basename = match.group(1)
        language_code = match.group(2)

        # Look up the language code in the ISO 639-1 table.
        try:
            language = Language.from_part1(language_code)
        except LanguageNotFoundError:
            print(f'Unknown language code for file {filename}')
            continue

        # Skip this file if the language code doesn't match the one we're looking for.
        if args.language_code is not None:
            if args.language_code != language.part1:
                continue
        else:
            if language.part1 not in sync_languages:
                # Language is not in the list of languages to sync.
                continue

        if args.verbose:
            print(f'Processing {filename} - {language.name} ({language.part1})')

        # Convert the .po file to a .unt file.
        with open(filename, 'r', encoding='utf-8') as file:
            unt_contents = po_to_unt(file.read())

        if not args.dry:
            # Write the .unt file to the mod's System folder.
            extension = iso639_to_language_extension.get(language.part3, language.part3)
            output_path = os.path.join(root_path, args.mod, 'System', f'{basename}.{extension}')

            if args.verbose:
                print(f'Writing to {output_path}')

            with open(output_path, 'wb') as output_file:
                output_file.write(b'\xff\xfe')  # Byte-order-mark.
                output_file.write(unt_contents.encode('utf-16-le'))

        if language not in language_files_processed:
            language_files_processed[language] = 0
        language_files_processed[language] += 1

        files_processed += 1

    print(f'Processed {files_processed} file(s)')
    for language_code, count in language_files_processed.items():
        print(f'{language_code.name}: {count} file(s)')


# Create the top-level parser
argparse = argparse.ArgumentParser(prog='u18n', description='Unreal Tournament localization file utilities')

subparsers = argparse.add_subparsers(dest='command', required=True)

# Add the file export command
file_export_parser = subparsers.add_parser('export_file', help='Export an Unreal Tournament translation file to a .po file')
file_export_parser.add_argument('input_path')
file_export_parser.add_argument('output_path')
file_export_parser.set_defaults(func=command_export_file)

export_parser = subparsers.add_parser('export', help='Export all Unreal Tournament translation files in a directory to .po files')
export_parser.add_argument('path', default='.', help='The game\'s root directory')
export_parser.add_argument('--mod', help='The path to the configuration file', required=False)
export_parser.add_argument('-d', '--dry', help='Dry run', default=False, action='store_true', required=False)
export_parser.add_argument('-l', '--language_code', help='The language to export (ISO 639-1 codes)', required=False)
export_parser.add_argument('-v', '--verbose', help='Verbose output', default=False, action='store_true', required=False)
export_parser.set_defaults(func=command_export)

update_keys_parser = subparsers.add_parser('update_keys', help='Update the keys in a directory of .po files to match the keys in another directory of .po files.')
update_keys_parser.add_argument('input_directory', help='The directory to read the keys from.')
update_keys_parser.add_argument('output_directory', help='The directory to write the keys to.')
update_keys_parser.add_argument('-d', '--dry', help='Dry run', default=False, action='store_true', required=False)
update_keys_parser.set_defaults(func=update_keys)

sync_parser = subparsers.add_parser('sync', help='Sync a Git repository with a directory of .po files.')
sync_parser.add_argument('path', help='The game\'s root directory')
sync_parser.add_argument('-m', '--mod', help='The name of the mod to sync.', required=False)
sync_parser.add_argument('-a', '--all', help='Sync all available translations, regardless of the configuration.', default=False, action='store_true', required=False)
sync_parser.add_argument('-d', '--dry', help='Dry run', default=False, action='store_true', required=False)
sync_parser.add_argument('-l', '--language_code', help='The language to sync (ISO 639-1 codes)', required=False)
sync_parser.add_argument('-v', '--verbose', help='Verbose output', default=False, action='store_true', required=False)
sync_parser.set_defaults(func=sync)


if __name__ == '__main__':
    args = argparse.parse_args()
    args.func(args)
