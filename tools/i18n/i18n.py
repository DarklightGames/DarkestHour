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
        time.sleep(0.25)
    return items


def parse_array_item(s, i):
    #print s
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
        raise RuntimeError('uh oh')
    else:
        return None
        #print s
        #raise RuntimeError(s)

def read_localization_file(sections, language, path, default_language='int'):
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
                    print section_name, key, value
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
    args = argparser.parse_args(['-mod', modname, 'D:\Steam\steamapps\common\Red Orchestra'])

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

    # TODO: write to mod folder
    workbook = Workbook('{0}.xlsx'.format(modname))

    # TODO: set up formats
    section_format = workbook.add_format({'bg_color': '#808080', 'font_color': '#ffffff'})
    value_format = workbook.add_format({'text_wrap': True})
    languages_format = workbook.add_format({'locked': True, 'bg_color': '#000000', 'font_color': '#ffffff', 'bold': True})
    key_format = workbook.add_format({'locked': True, 'bold': True, 'bg_color': '#c0c0c0'})
    int_value_format = workbook.add_format({'bg_color': '#ffffe0'})
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
                                    # TODO: write it here man
                                print vals
                        row += 1
                                # TODO: has value, do index lookup
                            #print langval
                            # TODO: use i to query other language

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
                    #         #if language != 'int':
                    #             #worksheet.conditional_format(cell, {'type': 'blanks', 'format': no_data_format})
                    #             #worksheet.conditional_format(cell, {'type': 'no_blanks', 'format': data_format})

    workbook.close()


if __name__ == "__main__":
    main()
