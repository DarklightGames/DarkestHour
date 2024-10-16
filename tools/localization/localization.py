import argparse
from configparser import RawConfigParser, MissingSectionHeaderError
from collections import OrderedDict
import glob
from pathlib import Path

from pprint import pprint

import polib
from iso639 import LanguageNotFoundError, Language
import os
from parsimonious.exceptions import IncompleteParseError, ParseError
from parsimonious.grammar import Grammar
from parsimonious.nodes import NodeVisitor
import re
from typing import List, Tuple, Optional

import git
import fnmatch
import yaml


# Unreal has different extensions for different languages, so map the ISO 639-1 code to the extension.
iso639_to_language_extension = {
    'deu': 'det',  # German
    'eng': 'int',  # English
    'fra': 'frt',  # French
    'spa': 'est',  # Spanish
    'ita': 'itt',  # Italian
    'nld': 'dut',  # Dutch
    'jpn': 'jap',  # Japanese
}


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
    import polib
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


def command_import_directory(args):
    """
    Convert all .po files in a directory to Unreal translation files (.int, .det, etc.).
    """
    input_path = args.input_path

    # Make sure the input path is a directory.
    if not os.path.isdir(input_path):
        print(f'"{input_path}" is not a directory')
        return

    count = 0
    pattern = f'{input_path}\\*\\*.po'

    for filename in glob.glob(pattern, recursive=True):
        basename = os.path.basename(filename)

        # Get the language code from the filename.
        regex = r'([^\.]+)\.([a-z]{2})\.po$'
        match = re.search(regex, basename)

        if match is None:
            print(f'Failed to parse language code from filename "{basename}"')
            continue

        basename = match.group(1)
        language_code = match.group(2)

        # Look up the language code in the ISO 639-1 table.
        try:
            language = Language.from_part1(language_code)
        except LanguageNotFoundError:
            print(f'Unknown language code {language_code} for file {filename}')
            continue

        # Skip this file if the language code doesn't match the one we're looking for.
        if args.language_code is not None and args.language_code != language_code:
            if args.verbose:
                print(f'Skipping {filename}, language code {language_code} does not match {args.language_code}')
            continue

        if language_code == 'en':
            # In Unreal, English is "international", or "in".
            language_code = 'in'

        if args.verbose:
            print(f'Processing {filename} - {language.name} ({language_code})')

        input_filename = os.path.join(input_path, filename)

        with open(input_filename, 'r', encoding='utf-8') as file:
            try:
                # Parse the Unreal translation file to a list of key-value pairs.
                unt_contents = po_to_unt(file.read())
            except RuntimeError as e:
                print(f'Failed to parse file {filename}: {e}')
                continue

            output_path = args.output_path
            output_path = output_path.replace('{l}', language_code)
            output_path = output_path.replace('{f}', basename)

            if not args.dry:
                os.makedirs(os.path.dirname(output_path), exist_ok=True)

                if args.verbose:
                    print(f'Writing to {output_path}')

                # Note: we use utf-8-sig to write the file because Unreal Tournament expects the file to be encoded with
                # utf-8 with a BOM (byte order mark).
                with open(output_path, 'wb') as output_file:
                    # Write the BOM.
                    output_file.write(b'\xff\xfe')
                    output_file.write(unt_contents.encode('utf-16-le'))

                count += 1

    print(f'Imported {count} file(s)')


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


def command_export_directory(args):
    input_path = args.input_path

    # Make sure the input path is a directory.
    if not os.path.isdir(input_path):
        print(f'"{input_path}" is not a directory')
        return

    count = 0

    for filename in glob.glob(f'{input_path}/*.*t'):
        filename = os.path.relpath(filename, input_path)
        basename, extension = os.path.splitext(filename)

        if args.filter is not None and not fnmatch.fnmatch(filename, args.filter):
            continue

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

        input_filename = os.path.join(input_path, filename)

        # This is a bit of a hack, but our .int files are windows-1252, and all others are supposed to be utf-16-le.
        with open(input_filename, 'rb') as file:
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

            output_filename = args.pattern
            output_filename = output_filename.replace('{l}', language.part1)
            output_filename = output_filename.replace('{f}', basename)

            output_path = os.path.join(args.output_directory, output_filename)

            if not args.dry:
                os.makedirs(os.path.dirname(output_path), exist_ok=True)

                if args.verbose:
                    print(f'Writing to {output_path}')

                write_po(output_path, key_value_pairs, language.part1)

                count += 1

    print(f'Exported {count} file(s)')


class TrueTypeFont:
    def __init__(self, package: str, group: str, name: str, fontname: str, height: int, unicode_ranges: str, anti_alias: int, drop_shadow_x: int, drop_shadow_y: int, u_size: int, v_size: int, x_pad: int, y_pad: int, extend_bottom: int, extend_top: int, extend_left: int, extend_right: int, kerning: int, style: int, italic: int, resolution: Optional[int] = None):
        self.package = package
        self.group = group
        self.name = name
        self.fontname = fontname
        self.height = height
        self.unicode_ranges = unicode_ranges
        self.anti_alias = anti_alias
        self.drop_shadow_x = drop_shadow_x
        self.drop_shadow_y = drop_shadow_y
        self.u_size = u_size
        self.v_size = v_size
        self.x_pad = x_pad
        self.y_pad = y_pad
        self.extend_bottom = extend_bottom
        self.extend_top = extend_top
        self.extend_left = extend_left
        self.extend_right = extend_right
        self.kerning = kerning
        self.style = style
        self.italic = italic
        self.resolution = resolution


def generate_font_scripts(args):
    # Load the YAML file
    mod = args.mod

    root_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))

    print(f'Root path: {root_path}')

    mod_path = os.path.join(root_path, mod)
    fonts_path = os.path.join(mod_path, 'Fonts')
    fonts_config_path = os.path.join(fonts_path, 'fonts.yml')
    output_path = os.path.join(fonts_path, 'ImportFonts.exec.txt')

    with open(fonts_config_path, 'r') as file:
        data = yaml.load(file, Loader=yaml.FullLoader)
        font_styles = data['font_styles']
        languages = data['languages']
        fonts_package_name = data['package_name']

        def int_to_hex(i: int) -> str:
            return hex(i)[2:].upper()

        proportional_data = data.get('proportional', None)
        resolution_baseline = None
        resolution_groups = None

        resolution_data = proportional_data.get('resolution', None)

        if proportional_data:
            resolution_baseline = resolution_data.get('baseline', 1080)
            resolution_groups = resolution_data.get('groups', {})

            # Ensure that resolution groups is a dictionary of strings to integer lists.
            if not isinstance(resolution_groups, dict):
                raise Exception('resolution_groups must be a dictionary')

            if any(not isinstance(key, str) or not isinstance(value, list) for (key, value) in resolution_groups.items()):
                raise Exception('resolution_groups must be a dictionary of strings to lists')

            for key, value in resolution_groups.items():
                if any(not isinstance(i, int) for i in value):
                    raise Exception(f'Values in resolution_group "{key}" must only be integers')

        # Defaults
        defaults = data['defaults']
        default_font_style = defaults.get('font_style', None)
        default_unicode_ranges = defaults.get('unicode_ranges', None)
        default_resolution_group = defaults.get('resolution_group', resolution_groups[0] if isinstance(resolution_groups, list) and resolution_groups is not None else None)

        font_style_true_type_fonts = {}

        for language_code, language in languages.items():
            if args.language_code is not None and args.language_code != language_code:
                continue

            package_name = fonts_package_name
            unicode_ranges = default_unicode_ranges + language.get('unicode_ranges', [])

            language_suffix = 'int'

            if language_code != 'en':
                part3 = Language.from_part1(language_code).part3
                language_suffix = iso639_to_language_extension.get(part3, part3)
                package_name = f'{fonts_package_name}_{language_suffix}'

            # Go through each of the Unreal translation files for this language and get the characters that are used.
            pattern = f'{mod_path}\\System\\*.{language_suffix}'

            ensure_all_characters = language.get('ensure_all_characters', False)

            if ensure_all_characters:
                characters = set()
                for filename in glob.glob(pattern):
                    # Load the config file.
                    print(filename)
                    with open(filename, 'r', encoding='utf-16-le') as file:
                        file.seek(2)  # Skip the BOM.
                        contents = file.read()
                        key_value_pairs = parse_unt(contents)

                        for _, value in key_value_pairs:
                            for character in value:
                                characters.add(ord(character))

                # For each of the characters, see if it's in the unicode ranges.
                # If it's not, add it to the unicode ranges.
                added_characters = set()
                for character in characters:
                    found = False
                    for unicode_range in unicode_ranges:
                        if type(unicode_range) == int:
                            if character == unicode_range:
                                found = True
                        if type(unicode_range) == list:
                            # Make sure it's a range of two numbers.
                            if len(unicode_range) != 2:
                                raise Exception(f'Invalid unicode range: {unicode_range}')
                            if character >= unicode_range[0] and character <= unicode_range[1]:
                                found = True
                    if not found:
                        added_characters.add(character)
                        # There is (surprise), a bug in Unreal where it appears to support having a single character
                        # in the UNICODERANGE string (e.g., 0-FF,1234,1235). However, it doesn't actually work, so we
                        # have to add the character to the unicode ranges as a range of two numbers.
                        unicode_ranges.append([character, character])

                if len(added_characters) > 0:
                    print(f'Added {len(added_characters)} characters to unicode ranges for language {language["name"]} ({language_code}): {[hex(c) for c in added_characters]}')

            for font_style_name, font_style in font_styles.items():

                font_style_true_type_fonts[font_style_name] = []

                # Merge the default font style with the language's font style.
                font_style = {**default_font_style, **font_style}

                font = font_style['font']
                font_substitutions = language.get('font_substitutions', {})

                if font in font_substitutions:
                    # Use the language's font substitution, if it exists.
                    font = font_substitutions[font]

                font_style_size = font_style['size']

                size_method = font_style_size.get('method', 'proportional')

                match size_method:
                    case 'proportional':
                        # Get the resolution group we're using.
                        font_size_baseline = font_style_size['baseline']
                        resolution_group = font_style_size.get('resolution_group', default_resolution_group)

                        # Make sure the resolution group exists.
                        if resolution_group not in resolution_groups:
                            raise Exception(f'Resolution group "{resolution_group}" does not exist')

                        resolutions = resolution_groups[resolution_group]
                        sizes = [int(font_size_baseline * resolution / resolution_baseline) for resolution in resolutions]
                        # Round the sizes round up to a multiple of 2 (stops there from being a 1px difference between
                        # sizes, wasting space).
                        sizes = [size + 1 if size % 2 == 1 else size for size in sizes]
                    case 'fixed':
                        sizes = font_style_size['sizes']
                        resolutions = [0] * len(sizes)
                    case _:
                        raise Exception(f'Invalid size method: {size_method}, expected one of {["proportional", "fixed"]}')

                if type(sizes) == int:
                    sizes = [sizes]
                elif type(sizes) != list:
                    raise Exception(f'Invalid sizes for font style {font_style_name}: {sizes}')

                padding = font_style.get('padding', {'x': 1, 'y': 1})
                margin = font_style.get('margin', {})
                anti_alias = int(font_style.get('anti_alias', 1))
                drop_shadow = font_style.get('drop_shadow', {})
                kerning = int(font_style.get('kerning', 0))
                weight = int(font_style.get('weight', 500))
                italic = bool(font_style.get('italic', False))
                texture_size = font_style.get('texture_size', 512)

                def get_unicode_ranges_string(unicode_ranges):
                    unicode_ranges_parts = []
                    for unicode_range in unicode_ranges:
                        if type(unicode_range) == int:
                            unicode_ranges_parts.append(f'{int_to_hex(unicode_range)}')
                        if type(unicode_range) == list:
                            # Make sure it's a range of two numbers.
                            if len(unicode_range) != 2:
                                raise Exception(f'Invalid unicode range: {unicode_range}')
                            unicode_ranges_parts.append(f'{int_to_hex(unicode_range[0])}-{int_to_hex(unicode_range[1])}')
                    unicode_ranges_string = ','.join(unicode_ranges_parts)
                    return unicode_ranges_string

                has_drop_shadow = 'x' in drop_shadow or 'y' in drop_shadow and (drop_shadow['x'] != 0 or drop_shadow['y'] != 0)

                for resolution, size in zip(resolutions, sizes):
                    font_name = f'{font.replace(" ", "")}{"DS" if has_drop_shadow else ""}{size}'
                    true_type_font = TrueTypeFont(
                        package=package_name,
                        group=font_style_name,
                        name=font_name,
                        fontname=font,
                        height=size,
                        unicode_ranges=unicode_ranges,
                        anti_alias=anti_alias,
                        drop_shadow_x=drop_shadow.get("x", 0),
                        drop_shadow_y=drop_shadow.get("y", 0),
                        u_size=texture_size.get("x", 256),
                        v_size=texture_size.get("y", 256),
                        x_pad=padding.get("x", 0),
                        y_pad=padding.get("y", 0),
                        extend_bottom=margin.get("bottom", 0),
                        extend_top=margin.get("top", 0),
                        extend_left=margin.get("left", 0),
                        extend_right=margin.get("right", 0),
                        kerning=kerning,
                        style=weight,
                        italic=int(italic),
                        resolution=resolution
                    )
                    font_style_true_type_fonts[font_style_name].append(true_type_font)

        # Write the font generation script.
        lines = []
        for font_style_name, fonts in font_style_true_type_fonts.items():
            for font in fonts:
                lines.append(f'NEW TRUETYPEFONTFACTORY '
                             f'PACKAGE={font.package} '
                             f'GROUP={font.group} '
                             f'NAME={font.name} '
                             f'FONTNAME="{font.fontname}" '
                             f'HEIGHT={font.height} '
                             f'UNICODERANGE="{get_unicode_ranges_string(font.unicode_ranges)}" '
                             f'ANTIALIAS={font.anti_alias} '
                             f'DROPSHADOWX={font.drop_shadow_x} '
                             f'DROPSHADOWY={font.drop_shadow_y} '
                             f'USIZE={font.u_size} '
                             f'VSIZE={font.v_size} '
                             f'XPAD={font.x_pad} '
                             f'YPAD={font.y_pad} '
                             f'EXTENDBOTTOM={font.extend_bottom} '
                             f'EXTENDTOP={font.extend_top} '
                             f'EXTENDLEFT={font.extend_left} '
                             f'EXTENDRIGHT={font.extend_right} '
                             f'KERNING={font.kerning} '
                             f'STYLE={font.style} '
                             f'ITALIC={font.italic} '
                             )
            lines.append('')

        lines.append(F'OBJ SAVEPACKAGE PACKAGE={package_name} FILE="..\\DarkestHourDev\\Textures\\{package_name}.utx"')
        lines.append('')
        lines.append('; Execute this with the following command:')
        lines.append(f'; EXEC "{os.path.abspath(output_path)}"')

        for line in lines:
            print(line)

        with open(output_path, 'w') as file:
            file.write('\n'.join(lines))

        unrealscript = data['unrealscript']
        unrealscript_gui_fonts = unrealscript.get('gui_fonts', None)
        gui_font_parent_class = unrealscript_gui_fonts.get('parent_class', 'GUIFont')

        unrealscript_gui_font_path = Path(root_path) / unrealscript_gui_fonts['directory']
        for font_style_name in font_style_true_type_fonts.keys():
            gui_font_path = unrealscript_gui_font_path / f'{font_style_name}.uc'
            with open(gui_font_path, 'w') as f:
                lines = [
                    '//==============================================================================',
                    '// This file was automatically generated by the localization tool.',
                    '// Do not edit this file directly.',
                    '// To regenerate this file, run ./tools/localization/generate_fonts.bat',
                    '//==============================================================================',
                    '',
                    f'class {font_style_name} extends {gui_font_parent_class};',
                    '',
                    f'event Font GetFont(int ResX)',
                    '{',
                    '    local int ResYGuess;',
                    '    ResYGuess = ResX * (9.0 / 16.0);',
                    '',
                    f'    return class\'{package_name}\'.static.Get{font_style_name}ByResolution(ResYGuess);',
                    '}',
                    '',
                    'defaultproperties',
                    '{',
                    f'    KeyName="{font_style_name}"',
                    '}',
                ]
                for line in lines:
                    f.write(line + '\n')


        # Write the UnrealScript fonts file.
        unrealscript_fonts = unrealscript.get('fonts', None)
        unrealscript_fonts_path = Path(root_path) / unrealscript_fonts['directory'] / f'{unrealscript_fonts["class_name"]}.uc'

        lines = []
        with open(unrealscript_fonts_path, 'w') as file:
            lines += [
                '//==============================================================================',
                '// This file was automatically generated by the localization tool.',
                '// Do not edit this file directly.',
                '// To regenerate this file, run ./tools/localization/generate_fonts.bat',
                '//==============================================================================',
                '',
                'class DHFonts extends Object',
                '    abstract;',
                '',
            ]
            lines += [
                'struct FontStyleSize {',
                '    var string FontName;',
                '    var Font Font;',
                '    var int Size;',
                '    var int Resolution;',
                '};',
                '',
            ]

            # Create the string arrays for the font style.
            for font_style_name, fonts in font_style_true_type_fonts.items():
                lines.append(f'var FontStyleSize {font_style_name}Sizes[{len(fonts)}];')

            lines.append('')

            # Create the function to load the fonts.
            for font_style_name, fonts in font_style_true_type_fonts.items():
                sizes_array_name = f'{font_style_name}Sizes'
                lines += [
                    f'static function Font Get{font_style_name}ByIndex(int i) {{',
                    f'    if (default.{sizes_array_name}[i].Font == none) {{',
                    f'        default.{sizes_array_name}[i].Font = Font(DynamicLoadObject(default.{sizes_array_name}[i].FontName, class\'Font\'));',
                    f'        if (default.{sizes_array_name}[i].Font == none) {{',
                    f'            Warn("Could not dynamically load" @ default.{sizes_array_name}[i].FontName);',
                    f'        }}',
                    f'    }}',
                    f'    return default.{sizes_array_name}[i].Font;',
                    f'}}',
                    f'',
                    f'// Load a font by the nearest target size',
                    f'static function Font Get{font_style_name}BySize(int Size) {{',
                    f'    local int i;',
                    f'    for (i = 0; i < arraycount(default.{sizes_array_name}); i++) {{',
                    f'        if (Size >= default.{sizes_array_name}[i].Size) {{',
                    f'            return Get{font_style_name}ByIndex(i);',
                    f'        }}',
                    f'    }}',
                    f'    return Get{font_style_name}ByIndex(arraycount(default.{sizes_array_name}) - 1);',
                    f'}}',
                    f'',
                    f'// Load a font by the nearest target resolution',
                    f'static function Font Get{font_style_name}ByResolution(int Resolution) {{',
                    f'    local int i;',
                    f'    for (i = 0; i < arraycount(default.{sizes_array_name}); i++) {{',
                    f'        if (Resolution >= default.{sizes_array_name}[i].Resolution) {{',
                    f'            return Get{font_style_name}ByIndex(i);',
                    f'        }}',
                    f'    }}',
                    f'    return Get{font_style_name}ByIndex(arraycount(default.{sizes_array_name}) - 1);',
                    f'}}',
                    '',
                ]

            lines.append('defaultproperties')
            lines.append('{')

            for font_style_name, fonts in font_style_true_type_fonts.items():
                for font_index, font in enumerate(fonts):
                    lines.append(f'    {font_style_name}Sizes({font_index})=(FontName="{font.package}.{font.name}",Size={font.height},Resolution={font.resolution})')

            lines.append('}')

            # Write the lines to the file.
            for line in lines:
                file.write(line + '\n')


def update(args):
    # Update the submodule.
    root_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
    repository_path = os.path.join(root_path)

    repo = git.Repo(repository_path)
    for submodule in repo.submodules:
        submodule.update(init=True, recursive=True)


def sync(args):
    root_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
    repository_path = os.path.join(root_path, 'submodules', 'weblate-darklightgames')

    # For each .po file in the repository, convert it to a .xxt file and move it to the System folder inside the mod.
    pattern = f'{repository_path}\\**\\*.po'

    # Print out the latest commit info (author, date, message etc.)
    repo = git.Repo(repository_path)
    latest_commit = repo.head.commit
    print(f'Latest commit: {latest_commit} by {latest_commit.author} on {latest_commit.authored_datetime} with message "{latest_commit.message}"')

    files_processed = 0
    language_files_processed = dict()

    for filename in glob.glob(pattern, recursive=True):

        if args.filter is not None and not fnmatch.fnmatch(filename, args.filter):
            continue

        # Get the base name of the file and separate out the language code.
        basename = os.path.basename(filename)
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
        if args.language_code is not None and args.language_code != language.part1:
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


def debug_value(args):
    while True:
        line = input('Value: ')
        if line == 'quit':
            break
        visitor = ValueVisitor()
        try:
            value = visitor.visit(grammar.parse(line))
            print(value, type(value))
        except IncompleteParseError as e:
            print('IncompleteParseError', line)
            print(e)
            continue
        except ParseError:
            print('ParseError', line)
            continue

def debug_keys(args):
    sections = OrderedDict()
    while True:
        key = input('Key: ')
        if key == 'quit':
            break
        elif key == 'dump':
            pprint(sections)
        add_entry(key, 'My Value', sections)
    pprint(sections)


# Create the top-level parser
argparse = argparse.ArgumentParser(prog='u18n', description='Unreal Tournament localization file utilities')

# Make two commands with subparsers: import and export
subparsers = argparse.add_subparsers(dest='command', required=True)

# Add the export command
export_parser = subparsers.add_parser('export', help='Export an Unreal Tournament translation file to a .po file')
export_parser.add_argument('input_path')
export_parser.add_argument('output_path')
export_parser.set_defaults(func=command_export)

export_directory_parser = subparsers.add_parser('export_directory', help='Export all Unreal Tournament translation files in a directory to .po files')
export_directory_parser.add_argument('input_path',
                                     help='The directory to search for Unreal Tournament translation files'
                                     )
export_directory_parser.add_argument('-o', '--output_directory',
                                     help='The directory to write the .po files to',
                                     required=True
                                     )
export_directory_parser.add_argument('-p', '--pattern',
                                     help='The pattern to use for the output file names. Use {l} to substitute the ISO-3608 language code and {f} to substitute the filename.',
                                     default='{f}/{f}.{l}.po',
                                     required=False
                                     )
export_directory_parser.add_argument('-d', '--dry', help='Dry run', default=False, action='store_true', required=False)
export_directory_parser.add_argument('-l', '--language_code', help='The language to export (ISO 639-1 codes)', required=False)
export_directory_parser.add_argument('-w', '--overwrite', help='Overwrite existing files', default=False, action='store_true', required=False)
export_directory_parser.add_argument('-v', '--verbose', help='Verbose output', default=False, action='store_true', required=False)
export_directory_parser.add_argument('-f', '--filter', help='Filter the files to export by a glob pattern', required=False)
export_directory_parser.set_defaults(func=command_export_directory)

import_directory_parser = subparsers.add_parser('import_directory', help='Import all .po files in a directory to Unreal Tournament translation files')
import_directory_parser.add_argument('input_path',
                                     help='The directory to search for .po files'
                                     )
import_directory_parser.add_argument('-o', '--output_path',
                                        help='The pattern to use for the output path. Use {l} to substitute the ISO-3608 language code and {f} to substitute the filename.',
                                        default='{f}.{l}',
                                        required=False
                                        )
import_directory_parser.add_argument('-d', '--dry', help='Dry run', default=False, action='store_true', required=False)
import_directory_parser.add_argument('-l', '--language_code', help='The language to import (ISO 639-1 codes)', required=False)
import_directory_parser.add_argument('-w', '--overwrite', help='Overwrite existing files', default=False, action='store_true', required=False)
import_directory_parser.add_argument('-v', '--verbose', help='Verbose output', default=False, action='store_true', required=False)
import_directory_parser.set_defaults(func=command_import_directory)

update_keys_parser = subparsers.add_parser('update_keys', help='Update the keys in a directory of .po files to match the keys in another directory of .po files.')
update_keys_parser.add_argument('input_directory', help='The directory to read the keys from.')
update_keys_parser.add_argument('output_directory', help='The directory to write the keys to.')
update_keys_parser.add_argument('-d', '--dry', help='Dry run', default=False, action='store_true', required=False)
update_keys_parser.set_defaults(func=update_keys)

generate_font_scripts_parser = subparsers.add_parser('generate_font_scripts', help='Generate font scripts from a YAML file.')
generate_font_scripts_parser.add_argument('-m', '--mod', help='The name of the mod to generate font scripts for.', required=True)
generate_font_scripts_parser.add_argument('-l', '--language_code', help='The language to generate font scripts for (ISO 639-1 codes)', required=False)
generate_font_scripts_parser.set_defaults(func=generate_font_scripts)

sync_parser = subparsers.add_parser('sync', help='Sync a Git repository with a directory of .po files.')
sync_parser.add_argument('-m', '--mod', help='The name of the mod to sync.', required=True)
sync_parser.add_argument('-d', '--dry', help='Dry run', default=False, action='store_true', required=False)
sync_parser.add_argument('-l', '--language_code', help='The language to sync (ISO 639-1 codes)', required=False)
sync_parser.add_argument('-v', '--verbose', help='Verbose output', default=False, action='store_true', required=False)
sync_parser.add_argument('-f', '--filter', help='Filter the files to sync by a glob pattern', required=False)
sync_parser.set_defaults(func=sync)

update_parser = subparsers.add_parser('update', help='Update the submodule.')
update_parser.set_defaults(func=update)

debug_key_parser = subparsers.add_parser('debug_key', help='Debug keys')
debug_key_parser.set_defaults(func=debug_keys)

debug_key_parser = subparsers.add_parser('debug_value', help='Debug values')
debug_key_parser.set_defaults(func=debug_value)


if __name__ == '__main__':
    args = argparse.parse_args()
    args.func(args)
