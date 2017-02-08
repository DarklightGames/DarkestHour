# -*- coding: utf-8 -*-

import os
import sys
import argparse
import ConfigParser
from collections import OrderedDict
from xlsxwriter import Workbook
from xlsxwriter.utility import xl_rowcol_to_cell


def read_localization_file(sections, language, path, default_language='int'):
    config = ConfigParser.ConfigParser()
    config.read(path)
    # iterate over sections
    for section_name in config.sections():
        # add section if it doesn't already exist
        if not sections.has_key(section_name):
            sections[section_name] = OrderedDict()
        section = sections[section_name]
        # add key if it doesn't already exist
        for item in config.items(section_name):
            key, value = item
            if not section.has_key(key):
                section[key] = dict()
            # update key language value
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

    # do a clean recompile of the project and run dumpint
    #if subprocess.call(['python', os.path.join(args.dir, 'tools', 'make', 'make.py'), '-dumpint', '-clean', '-mod', 'DarkestHourDev', args.dir]) != 0:
        #raise RuntimeError

    args.dir = os.path.abspath(args.dir)

    if not os.path.isdir(args.dir):
        print 'error: "{}" is not a directory'.format(dir)
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

    # mod config path
    config_path = os.path.join(mod_sys_dir, args.mod + '.ini')

    # TODO: write to mod folder
    workbook = Workbook('{0}.xlsx'.format(modname))

    # TODO: set up formats
    section_format = workbook.add_format({'bg_color': '#808080', 'font_color': '#ffffff'})
    value_format = workbook.add_format({'text_wrap': True})
    languages_format = workbook.add_format({'locked': True, 'bg_color': '#000000', 'font_color': '#ffffff', 'bold': True})
    key_format = workbook.add_format({'locked': True, 'bold': True, 'bg_color': '#C0C0C0'})
    int_value_format = workbook.add_format({'bg_color': '#FFFFE0'})

    no_data_format = workbook.add_format({'bg_color': '#FFCCCB'})
    data_format = workbook.add_format({'bg_color': '#CCFFCB'})

    # read languages file
    with open('languages.txt') as f:
        languages = f.read().splitlines()
        print languages

    # gather .int files
    packages = filter(lambda x: x.endswith('.int'), os.listdir(mod_sys_dir))
    for package in packages:
        # read localization files
        sections = OrderedDict()
        for language in languages:
            sections = read_localization_file(sections, language,
                                              os.path.join(mod_sys_dir, os.path.splitext(package)[0] + '.' + language))

        # strip sections files down
        sections_to_remove = []
        for section in sections.keys():
            # go through keys
            keys_to_delete = []
            for key in sections[section].keys():
                values = sections[section][key]
                if 'int' not in values.keys():
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
        # TODO: go through all the languages and write them starting at column 2
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
                # TODO: possibly split into multiple records depending on formatting
                if 'int' in sections[section][key].keys():
                    worksheet.write(row, col, key, key_format)
                    for language in languages:
                        col += 1
                        if language in sections[section][key].keys():
                            format = int_value_format if language == 'int' else None
                            worksheet.write(row, col, sections[section][key][language].decode('cp1252'), format) # TODO: light yellow formatting
                            if language != 'int':
                                worksheet.conditional_format(xl_rowcol_to_cell(row, col), {'type': 'blanks',
                                                                                           'format': no_data_format})
                                worksheet.conditional_format(xl_rowcol_to_cell(row, col), {'type': 'no_blanks',
                                                                                           'format': data_format})
                        else:
                            if language != 'int':
                                worksheet.conditional_format(xl_rowcol_to_cell(row, col), {'type': 'blanks',
                                                                                           'format': no_data_format})
                                worksheet.conditional_format(xl_rowcol_to_cell(row, col), {'type': 'no_blanks',
                                                                                           'format': data_format})
                row += 1

    workbook.close()


if __name__ == "__main__":
    main()
