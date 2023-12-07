import glob
import os
from configparser import RawConfigParser
from pathlib import Path

from parsimonious.exceptions import IncompleteParseError
from parsimonious.grammar import Grammar
from parsimonious.nodes import NodeVisitor

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


dir = r'C:\dev\RedOrchestra\DarkestHourDev\System'

count = 0

for path in glob.glob(os.path.join(dir, '*.int')):

    print(path)

    config = RawConfigParser()
    config.optionxform = str
    config.read(path)

    basename = os.path.basename(path)
    filename = os.path.splitext(basename)[0]

    contents = ''
    contents += "msgid \"\"\n"
    contents += "msgstr \"\"\n"
    contents += "\"Language: en\"\n"
    contents += "\"MIME-Version: 1.0\"\n"
    contents += "\"Content-Type: text/plain\"\n"
    contents += "\"Content-Transfer-Encoding: 8bit\"\n"
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
                        id =f'{id}.{k}'
                        add_key_value_pairs_recursive(id, v)

            add_key_value_pairs_recursive(id, value)

    count += len(key_value_pairs)

    for key, value in key_value_pairs:
        contents += f'msgid "{key}"\n'
        contents += f'msgstr "{value}"\n'
        contents += '\n'

    # Encode to UTF-8
    contents = contents.encode('utf-8')

    # Write the file with the name {filename}.en.po
    os.makedirs(filename, exist_ok=True)

    with open(Path(f'{filename}/{filename}.en.po'), 'wb') as file:
        file.write(contents)
