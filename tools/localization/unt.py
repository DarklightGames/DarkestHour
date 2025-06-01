import re
from collections import OrderedDict
from configparser import RawConfigParser, MissingSectionHeaderError
from typing import Tuple, List, Set, Iterable

import polib
from parsimonious.exceptions import IncompleteParseError, ParseError
from parsimonious.grammar import Grammar
from parsimonious.nodes import NodeVisitor


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


def _add_entry(msgid: str, msgstr: str, sections):
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


def unt_from_key_value_pairs(key_value_pairs: Iterable[Tuple[str, str]]) -> str:
    sections = OrderedDict()

    for key, value in key_value_pairs:
        try:
            _add_entry(key, value, sections)
        except Exception as e:
            print(f'Failed to add entry {key}: {e}')

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


def po_to_unt(contents: str) -> str:
    po = polib.pofile(contents)

    # Convert PO to key-value pairs.
    key_value_pairs = []
    for entry in po:
        key_value_pairs.append((entry.msgid, entry.msgstr))

    return unt_from_key_value_pairs(key_value_pairs)


def read_unique_characters_from_unt_file(path: str) -> Set[int]:
    characters = set()
    with open(path, 'r', encoding='utf-16-le') as file:
        file.seek(2)  # Skip the BOM.
        contents = file.read()
        key_value_pairs = parse_unt(contents)
        for _, value in key_value_pairs:
            for character in value:
                characters.add(ord(character))
    return characters
