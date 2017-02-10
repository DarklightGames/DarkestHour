# -*- coding: utf-8 -*-

import os
import re
import sys
import argparse
import subprocess
import time
import ConfigParser
from collections import OrderedDict
from xlsxwriter import Workbook
from xlsxwriter.utility import xl_rowcol_to_cell
from openpyxl import load_workbook
from openpyxl.utils import get_column_letter
from collections import defaultdict
import json

def parse_array(s, i):
    if s[i] != '(':
        raise RuntimeError('invalid array syntax')
    i += 1
    items = []
    while True:
        r = parse_array_item(s, i)
        if r is None:
            break
        i, item = r
        items.append(item)
        if s[i] == ',':
            i += 1
            continue
        for j, c in enumerate(s[i:]):
            # skip whitespace
            if c != ' ':
                i += j
                break
        if s[i] == ')':
            # end of the list
            break
        i += 1
    return items


def parse_array_item(s, i):
    if s[i] == '\"':
        i += 1
        st = ''
        for j, c in enumerate(s[i:]):
            if c == '\"':
                # string ended, break out
                break
            else:
                st += c
        return i + j + 1, st
    elif s[i] == '(':
        # TODO: parse struct
        return len(s) - 1, s[i + 1:]
    else:
        return None

def read_localization_file(sections, language, path):
    config = ConfigParser.ConfigParser()
    config.optionxform = str
    config.read(path)
    # iterate over sections
    for section_name in config.sections():
        # add section if it doesn't already exist
        if section_name not in sections:
            sections[section_name] = OrderedDict()
        section = sections[section_name]
        # add key if it doesn't already exist
        for item in config.items(section_name):
            key, value = item
            if key not in section:
                section[key] = dict()
            # update key language value
            match = re.match(r'^\"(.+)\"$', value)
            if match is not None:
                value = [match.group(1)]
            else:
                match = re.match(r'^\((.+)\)$', value)
                # TODO: split these
                if match is None:
                    #print section_name, key, value
                    pass
                else:
                    value = parse_array(value, 0)
            values = section[key]
            values[language] = value
    return sections


def main():

    modname = 'DarkestHourDev'

    # parse options
    argparser = argparse.ArgumentParser()
    argparser.add_argument('dir', default='.', help='root directory')
    argparser.add_argument('-mod', required=True, help='mod name')
    args = argparser.parse_args(['-mod', modname, 'C:\Users\colin_000\Documents\GitHub\DarkestHour'])

    # TODO: prompt to do a clean recompile
    print os.path.join(args.dir, 'tools', 'make', 'make.py')

    '''
    # do a clean recompile of the project and run dumpint
    if subprocess.call(['python', os.path.join(args.dir, 'tools', 'make', 'make.py'), '-dumpint', '-clean', '-mod', 'DarkestHourDev', args.dir]) != 0:
        raise RuntimeError
    '''

    args.dir = os.path.abspath(args.dir)

    if not os.path.isdir(args.dir):
        print 'error: "{}" is not a directory'.format(args.dir)
        sys.exit(1)

    # system directory
    sys_dir = os.path.join(args.dir, 'System')

    if not os.path.isdir(sys_dir):
        print 'error: could not resolve System directory'
        sys.exit(1)

    # mod directory
    mod_dir = os.path.join(args.dir, args.mod)

    if not os.path.isdir(mod_dir):
        print 'error: could not resolve mod directory'
        sys.exit(1)

    # mod system directory
    mod_sys_dir = os.path.join(mod_dir, 'System')

    if not os.path.isdir(mod_sys_dir):
        print 'error could not resolve mod system directory'
        sys.exit(1)

    workbook_name = '{0}.xlsx'.format(modname)

    # TODO: write to mod folder
    workbook = Workbook(workbook_name)

    # TODO: set up formats
    section_format = workbook.add_format({'bg_color': '#808080', 'font_color': '#ffffff'})
    value_format = workbook.add_format({'text_wrap': True})
    languages_format = workbook.add_format({'locked': True, 'bg_color': '#000000', 'font_color': '#ffffff', 'bold': True})
    key_format = workbook.add_format({'locked': True, 'bold': True, 'bg_color': '#c0c0c0'})
    int_value_format = workbook.add_format({'bg_color': '#ffffe0', 'text_wrap': True})
    no_data_format = workbook.add_format({'bg_color': '#ffcccb'})
    data_format = workbook.add_format({'bg_color': '#ccffcb'})

    # read languages file
    with open('languages.txt') as f:
        languages = f.read().splitlines()

    default_language = languages[0]

    # gather default language files
    packages = filter(lambda x: x.endswith('.{0}'.format(default_language)), os.listdir(mod_sys_dir))
    for package in packages:
        # read localization files
        sections = OrderedDict()
        for language in languages:
            path = os.path.join(mod_sys_dir, os.path.splitext(package)[0] + '.' + language)
            sections = read_localization_file(sections, language, path)

        # strip sections files down
        sections_to_remove = []
        for section in sections.keys():
            # go through keys
            keys_to_delete = []
            for key in sections[section].keys():
                values = sections[section][key]
                if default_language not in values.keys():
                    keys_to_delete.append(key)
            for key in keys_to_delete:
                del sections[section][key]
            if len(sections[section]) == 0:
                sections_to_remove.append(section)
        for section in sections_to_remove:
            del sections[section]

        worksheet = workbook.add_worksheet(os.path.splitext(package)[0])
        worksheet.freeze_panes(1, 0)
        worksheet.freeze_panes(0, 2)
        worksheet.set_column('A:A', 32)
        worksheet.set_column('B:Z', 64, value_format)
        col = 1
        # TODO: go through all the languages, write them starting at column 2
        for lang in languages:
            worksheet.write(0, col, lang, languages_format)
            col += 1
        row = 1
        for section in sections.keys():
            col = 0
            worksheet.set_row(row, None, section_format)
            worksheet.write(row, col, section)
            row += 1
            for key in sections[section].keys():
                col = 0
                # TODO: split into multiple records depending on formatting
                if default_language in sections[section][key].keys():
                    # write the key name
                    worksheet.write(row, col, key, key_format)

                    # TODO; go through through the values of the BASE one, iterate row, do look-ups (left-to-right) for other languages
                    for i, value in enumerate(sections[section][key][default_language]):
                        col = 1
                        worksheet.write(row, col, value.decode('cp1252'), int_value_format)
                        for language in languages[1:]:
                            col += 1
                            if language not in sections[section][key]:
                                # TODO: no value, mark red
                                pass
                            else:
                                vals = sections[section][key][language]
                                if i >= 0 and i < len(vals):
                                    worksheet.write(row, col, vals[i].decode('cp1252'))
                            cell = xl_rowcol_to_cell(row, col)
                            worksheet.conditional_format(cell, {'type': 'blanks', 'format': no_data_format})
                            worksheet.conditional_format(cell, {'type': 'no_blanks', 'format': data_format})
                        row += 1
                    # start_row = row
                    # for language in languages:
                    #     row = start_row
                    #     col += 1
                    #     cell = xl_rowcol_to_cell(row, col)
                    #     # check that this key has a value for the language
                    #     if language in sections[section][key].keys():
                    #         # get static formatting based on language
                    #         format = int_value_format if language == default_language else None
                    #         # fetch the value from the key/language combo
                    #         value = sections[section][key][language]
                    #         array_row = 0
                    #         for v in value:
                    #             worksheet.write(row + array_row, col, v.decode('cp1252'), format)
                    #             array_row += 1
                    #         row += array_row

    workbook.close()

    # TODO: now READ IT IN
    workbook = load_workbook(workbook_name)

    for sheet_name in workbook.get_sheet_names():
        sheet = workbook.get_sheet_by_name(sheet_name)
        # gather up languages in the file
        col = 2
        row = 1
        languages = []
        while True:
            cell = '{0}{1}'.format(get_column_letter(col), row)
            if sheet[cell].value is None:
                break
            languages.append(sheet[cell].value)
            col += 1
        # TODO: go down the rows, find the first section:
        # sections are ones where the first column is filled, but there's nothing in the `int` column
        row += 1
        col = 1
        sections = OrderedDict()
        section = None
        key = None
        while True:
            cell = 'A{0}'.format(row)
            cell2 = 'B{0}'.format(row)
            if sheet[cell].value is None and sheet[cell2].value is None:
                # EOF, basically
                break
            if sheet[cell].value is not None and sheet[cell2].value is None:
                # new section, add it!
                section = OrderedDict()
                sections[sheet[cell].value] = section
            else:
                # we got a key/value row on our hands here
                if sheet[cell].value is not None:
                    key = sheet[cell].value
                col = 3
                for language in languages[1:]:
                    # TODO: go searching for the translations across the rows, do a look-up for the 
                    cell = '{0}{1}'.format(get_column_letter(col), row)
                    value = sheet[cell].value
                    if value is None:
                        continue
                    if key not in section:
                        # add key to section
                        section[key] = dict()
                        section[key][language] = list()
                    section[key][language].append(value)
                    col += 1
            row += 1
        # TODO: now write out to an .ini file
        for language in languages[1:]:
            with open(sheet_name + '.' + language, 'wb') as f:
                # don't write anything if there's nothing to write!
                for section_name in sections.keys():
                    kvs = []
                    for key in sections[section_name].keys():
                        # TODO: make sure present language has anything for this key
                        if language in sections[section_name][key]:
                            values = sections[section_name][key][language]
                            # TODO: check length of values, parse depending on size etc.
                            if len(values) == 1:
                                kvs.append((key, '"' + values[0].encode('cp1252') + '"'))
                            else:
                                print key
                                kvs.append((key, '(' + ','.join(map(lambda x: '"' + x.encode('cp1252') + '"', values)) + ')'))
                    if len(kvs) == 0:
                        continue
                    f.write('[{0}]\n'.format(section_name))
                    for kv in kvs:
                        f.write('{0}={1}\n'.format(kv[0], kv[1]))
                    f.write('\n')
        # s = json.dumps(sections)
        # print s


if __name__ == "__main__":
    main()
