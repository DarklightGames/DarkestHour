from configparser import RawConfigParser, MissingSectionHeaderError
from collections import OrderedDict
from parsimonious.exceptions import IncompleteParseError, ParseError
from parsimonious.grammar import Grammar
from parsimonious.nodes import NodeVisitor
import polib
from typing import List, Tuple
import re


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


class LocalizationData:
    def __init__(self):
        self.sections: OrderedDict[str, OrderedDict[str, str | list | dict]] = OrderedDict()

    def add(self, section: str, key: str, value: str | list | dict):
        if section not in self.sections:
            self.sections[section] = OrderedDict()
        self.sections[section][key] = value

    @classmethod
    def new_from_unt_contents(cls, contents: str) -> 'LocalizationData':
        """
        Parse an Unreal Tournament translation file.
        :param contents: The contents of a UNT file.
        :return: A new localization data object.
        """
        config = RawConfigParser(strict=False)
        config.optionxform = str

        try:
            config.read_string(contents)
        except MissingSectionHeaderError as e:
            raise RuntimeError(f'Failed to parse file: {e}')

        localization_data = LocalizationData()

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

                if isinstance(value, str):
                    # We need to fix string values that are not quoted.
                    if value.startswith('"') and value.endswith('"'):
                        value = value[1:-1]
                        # Escape quotes.
                        value = value.replace('"', '\\"')

                localization_data.add(section, key, value)

        return localization_data

    @classmethod
    def _read_unt_contents(cls, filename: str) -> str:
        with open(filename, 'rb') as file:
            # Look for the BOM.
            bom = file.read(2)

            if bom == b'\xff\xfe':
                # utf-16-le
                file.seek(2)
                return file.read().decode('utf-16-le')
            else:
                # windows-1252
                file.seek(0)
                return file.read().decode('windows-1252')

    @classmethod
    def new_from_unt_file(cls, filename: str) -> 'LocalizationData':
        return LocalizationData.new_from_unt_contents(cls._read_unt_contents(filename))

    def remove_empty_dynamic_arrays(self) -> int:
        """
        Find and remove keys whose values are empty dynamic arrays.
        This is required because the game engine does not properly parse empty dynamic arrays, interpreting them as
        having one less element than they actually do (e.g., "(,,)" is interpreted as having 2 elements instead of 3).
        """

        def should_remove_value(value):
            if isinstance(value, list):
                # Check if this is an empty dynamic array or if it's a list of empty values.
                return len(value) == 0 or all(x is None for x in value)
            return False

        # Do a recursive walk, and delete any keys whose value is an empty dynamic array.
        def remove_empty_dynamic_arrays_recursive(data: str | dict | list) -> int:
            ret = 0
            if isinstance(data, dict):
                items = list(data.items())
                for key, value in items:
                    if should_remove_value(value):
                        ret += 1
                        del data[key]
                    else:
                        ret += remove_empty_dynamic_arrays_recursive(value)
            elif isinstance(data, list):
                # Iterate backwards over the list so that we can remove items without affecting the iteration.
                for i in range(len(data) - 1, -1, -1):
                    item = data[i]
                    if should_remove_value(item):
                        ret += 1
                        del data[i]
                    else:
                        ret += remove_empty_dynamic_arrays_recursive(item)
            return ret

        count = 0

        for section, keys in self.sections.items():
            count += remove_empty_dynamic_arrays_recursive(keys)

        return count

    def to_po_contents(self, language_code: str) -> str:
        def _get_po_key_value_pairs() -> List[Tuple[str, str]]:
            po_key_value_pairs: List[Tuple[str, str]] = []

            def add_po_key_value_pairs_recursive(id: str, value):
                if isinstance(value, str):
                    po_key_value_pairs.append((id, str(value)))
                elif isinstance(value, list):
                    for i, item in enumerate(value):
                        add_po_key_value_pairs_recursive(f'{id}<{i}>', item)
                elif isinstance(value, dict):
                    for k, v in value.items():
                        add_po_key_value_pairs_recursive(f'{id}.{k}', v)

            for section, keys in self.sections.items():
                for key, value in keys.items():
                    id = f'{section}.{key}'
                    add_po_key_value_pairs_recursive(id, value)

            return po_key_value_pairs

        key_value_pairs = _get_po_key_value_pairs()

        lines = [
            "msgid \"\"",
            "msgstr \"\"",
            f"\"Language: {language_code}\\n\"",
            "\"MIME-Version: 1.0\\n\"",
            "\"Content-Type: text/plain; charset=UTF-8\\n\"",
            "\"Content-Transfer-Encoding: 8bit\\n\"",
            ""
        ]

        for key, value in key_value_pairs:
            lines.append(f'msgid "{key}"')
            lines.append(f'msgstr "{value}"')
            lines.append('')

        return '\n'.join(lines)

    def write_po(self, path: str, language_code: str):
        with open(path, 'wb') as f:
            f.write(self.to_po_contents(language_code).encode('utf-8'))

    def to_unt_contents(self) -> str:
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
                raise Exception(f'Unhandled type: {type(value)}')

        lines = []

        for section_name, section in self.sections.items():
            lines.append(f'[{section_name}]')
            write_key_value_pairs_recursive(section.items())
            lines.append('')

        return '\n'.join(lines)

    @staticmethod
    def new_from_po_contents(contents: str) -> 'LocalizationData':
        localization_data = LocalizationData()

        # TODO: this doesn't use the normal add method for historical reasons. It should be refactored.
        def _add_entry(msgid: str, msgstr: str):
            parts = msgid.split('.')
            section_key = parts.pop(0)

            if section_key not in localization_data.sections:
                localization_data.sections[section_key] = OrderedDict()

            section = localization_data.sections[section_key]
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

        # Add each entry.
        for entry in polib.pofile(contents):
            try:
                _add_entry(entry.msgid, entry.msgstr)
            except Exception as e:
                print(f'Failed to add entry {entry.msgid}: {e}')

        return localization_data

    def write_unt(self, output_path):
        unt_contents = self.to_unt_contents()

        with open(output_path, 'wb') as output_file:
            # Write the UTF-16-LE byte order mark.
            output_file.write(b'\xff\xfe')
            output_file.write(unt_contents.encode('utf-16-le'))

    @classmethod
    def new_from_po_file(cls, filename) -> 'LocalizationData':
        with open(filename, 'r', encoding='utf-8') as file:
            return cls.new_from_po_contents(file.read())

    def get_unique_characters(self) -> set[int]:
        # TODO: Use visitor pattern so we don't have to keep re-implementing the data traversal.
        unique_characters = set()

        # Recursively walk the data and return a set of all the unique characters.
        def get_unique_characters_recursive(data: str | dict | list):
            if isinstance(data, str):
                for character in data:
                    unique_characters.add(ord(character))
            elif isinstance(data, list):
                for item in data:
                    get_unique_characters_recursive(item)
            elif isinstance(data, dict):
                for v in data.values():
                    get_unique_characters_recursive(v)

        for section, keys in self.sections.items():
            for key, value in keys.items():
                get_unique_characters_recursive(value)

        return unique_characters