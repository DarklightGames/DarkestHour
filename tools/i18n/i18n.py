import argparse
import fnmatch
import git
import glob
from iso639 import LanguageNotFoundError, Language
import os
import re
import shutil
import tempfile
from typing import Optional
import yaml

from data import LocalizationData


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

    # Write the file with the name {filename}.en.po
    os.makedirs(basename, exist_ok=True)

    localization_data = LocalizationData.new_from_unt_file(input_path)
    localization_data.write_po(args.output_path, language_code)


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
                localization_data = LocalizationData.new_from_po_contents(file.read())
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

                localization_data.write_unt(output_path)

                count += 1

    print(f'Imported {count} file(s)')


def fix_unt(args):
    # Walk the directory and fix issues in the Unreal translation files.
    input_directory = args.input_directory
    extension = args.extension

    for filename in glob.glob(f'{input_directory}/**/*.{extension}', recursive=True):
        localization_data = LocalizationData.new_from_unt_file(filename)

        count = localization_data.remove_empty_dynamic_arrays()

        if count == 0:
            print(f'No empty dynamic arrays found in {filename}')
        else:
            print(f'Removed {count} empty dynamic arrays from {filename}')

        if not args.dry and count > 0:
            localization_data.write_unt(filename)

            # TODO: make an option to not overwrite the file, but make a new one.

            print('Overwrote file')


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

        localization_data = LocalizationData.new_from_unt_file(input_filename)

        output_path = args.output_path
        output_path = output_path.replace('{l}', language.part1)
        output_path = output_path.replace('{f}', basename)

        if not args.dry:
            os.makedirs(os.path.dirname(output_path), exist_ok=True)

            if args.verbose:
                print(f'Writing to {output_path}')

            localization_data.write_po(output_path, language.part1)

            count += 1

    print(f'Exported {count} file(s)')


def generate_font_scripts(args):
    # Load the YAML file
    mod = args.mod

    root_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))

    mod_path = os.path.join(root_path, mod)
    fonts_path = os.path.join(mod_path, 'Fonts')

    fonts_config_path = os.path.join(fonts_path, 'fonts.yml')

    print(f'Loading fonts config from {fonts_config_path}')

    output_path = os.path.join(fonts_path, 'ImportFonts.exec.txt')

    with open(fonts_config_path, 'r') as file:
        data = yaml.load(file, Loader=yaml.FullLoader)
        default_font_style = data['default_font_style']
        font_styles = data['font_styles']
        languages = data['languages']
        default_unicode_ranges = data['default_unicode_ranges']
        fonts_package_name = data['package_name']
        lines = []

        def int_to_hex(i: int) -> str:
            return hex(i)[2:].upper()

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
            ensure_all_characters = language.get('ensure_all_characters', False)

            if ensure_all_characters:
                unique_characters = set()
                pattern = f'{mod_path}\\System\\*.{language_suffix}'
                for filename in glob.glob(pattern):
                    # Load the config file.
                    unique_characters |= LocalizationData.new_from_unt_file(filename).get_unique_characters()

                # For each of the characters, see if it's in the unicode ranges.
                # If it's not, add it to the unicode ranges.
                added_characters = set()
                for character in unique_characters:
                    found = False
                    for unicode_range in unicode_ranges:
                        if isinstance(unicode_range, int):
                            if character == unicode_range:
                                found = True
                        elif isinstance(unicode_range, list):
                            # Make sure it's a range of two numbers.
                            if len(unicode_range) != 2:
                                raise Exception(f'Invalid unicode range: {unicode_range}')
                            if unicode_range[0] <= character <= unicode_range[1]:
                                found = True
                    if not found:
                        added_characters.add(character)
                        # There is (surprise), a bug in Unreal where it appears to support having a single character
                        # in the UNICODERANGE string (e.g., 0-FF,1234,1235). However, it doesn't actually work, so we
                        # have to add the character to the unicode ranges as a range of two numbers.
                        unicode_ranges.append([character, character])

                if len(added_characters) > 0:
                    print(
                        f'Added {len(added_characters)} characters to unicode ranges for language {language["name"]} ({language_code}): {[hex(c) for c in added_characters]}')

            lines.append(f'; {language["name"]} ({language_code})')

            for font_style_name, font_style in font_styles.items():

                # Merge the default font style with the language's font style.
                font_style = {**default_font_style, **font_style}

                font = font_style['font']
                font_substitutions = language.get('font_substitutions', {})

                if font in font_substitutions:
                    # Use the language's font substitution, if it exists.
                    font = font_substitutions[font]

                sizes = font_style['sizes']

                if isinstance(sizes, int):
                    sizes = [sizes]
                elif not isinstance(sizes, list):
                    raise Exception(f'Invalid sizes for font style {font_style_name}: {sizes}')

                padding = font_style.get('padding', {'x': 1, 'y': 1})
                margin = font_style.get('margin', {})
                anti_alias = int(font_style.get('anti_alias', 1))
                drop_shadow = font_style.get('drop_shadow', {})
                kerning = int(font_style.get('kerning', 0))
                weight = int(font_style.get('weight', 500))
                italic = bool(font_style.get('italic', False))
                texture_size = font_style.get('texture_size', 256)

                def get_unicode_ranges_string(unicode_ranges):
                    parts = []
                    for unicode_range in unicode_ranges:
                        if isinstance(unicode_range, int):
                            parts.append(f'{int_to_hex(unicode_range)}')
                        if isinstance(unicode_range, list):
                            # Make sure it's a range of two numbers.
                            if len(unicode_range) != 2:
                                raise Exception(f'Invalid unicode range: {unicode_range}')
                            parts.append(
                                f'{int_to_hex(unicode_range[0])}-{int_to_hex(unicode_range[1])}')
                    return ','.join(parts)

                unicode_ranges_string = get_unicode_ranges_string(unicode_ranges)
                has_multiple_sizes = len(sizes) > 1

                for size in sizes:
                    if has_multiple_sizes:
                        name = f'{font_style_name}{size}'
                    else:
                        name = font_style_name
                    lines.append(f'NEW TRUETYPEFONTFACTORY '
                                 f'PACKAGE={package_name} '
                                 f'GROUP={font_style_name} '
                                 f'NAME={name} '
                                 f'FONTNAME="{font}" '
                                 f'HEIGHT={size} '
                                 f'UNICODERANGE="{unicode_ranges_string}" '
                                 f'ANTIALIAS={anti_alias} '
                                 f'DROPSHADOWX={drop_shadow.get("x", 0)} '
                                 f'DROPSHADOWY={drop_shadow.get("y", 0)} '
                                 f'USIZE={texture_size.get("x", 256)} '
                                 f'VSIZE={texture_size.get("y", 256)} '
                                 f'XPAD={padding.get("x", 0)} '
                                 f'YPAD={padding.get("y", 0)} '
                                 f'EXTENDBOTTOM={margin.get("bottom", 0)} '
                                 f'EXTENDTOP={margin.get("top", 0)} '
                                 f'EXTENDLEFT={margin.get("left", 0)} '
                                 f'EXTENDRIGHT={margin.get("right", 0)} '
                                 f'KERNING={kerning} '
                                 f'STYLE={weight} '
                                 f'ITALIC={int(italic)} '
                                 )

            lines.append(
                F'OBJ SAVEPACKAGE PACKAGE={package_name} FILE="..\\DarkestHourDev\\Textures\\{package_name}.utx"')
            lines.append('')

        lines.append('; Execute this with the following command:')
        lines.append(f'; EXEC "{os.path.abspath(output_path)}"')

        with open(output_path, 'w') as file:
            file.write('\n'.join(lines))

    print(f'Font generation script written to {output_path}')


def sync(args):
    # Clone the repository to a temporary directory.
    root_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
    i18n_config_path = os.path.join(root_path, args.mod, 'i18n.yml')  # TODO: lazy
    i18n_config = yaml.load(open(i18n_config_path, 'r'), Loader=yaml.FullLoader)

    temp_dir = tempfile.mkdtemp()
    repository = i18n_config['repository']

    print('Cloning repository...')

    git.Repo.clone_from(repository['url'], temp_dir)

    print('Done.')

    # For each .po file in the repository, convert it to a .xxt file and move it to the System folder inside the mod.
    pattern = f'{temp_dir}\\**\\*.po'

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

        print(f'Processing {filename} - {language.name} ({language.part1})')

        # Convert the .po file to a .unt file.
        localization_data = LocalizationData.new_from_po_file(filename)

        if not args.dry:
            # Write the .unt file to the mod's System folder.
            extension = iso639_to_language_extension.get(language.part3, language.part3)
            output_path = os.path.join(root_path, args.mod, 'System', f'{basename}.{extension}')

            if args.verbose:
                print(f'Writing to {output_path}')

            localization_data.write_unt(output_path)

    # Delete the temporary directory.
    if not args.dry:
        shutil.rmtree(temp_dir, ignore_errors=True)


if __name__ == '__main__':
    # Create the top-level parser
    argparse = argparse.ArgumentParser(prog='u18n', description='Unreal Tournament localization file utilities')

    # Make two commands with subparsers: import and export
    subparsers = argparse.add_subparsers(dest='command', required=True)

    # Add the export command
    export_parser = subparsers.add_parser('export', help='Export an Unreal Tournament translation file to a .po file')
    export_parser.add_argument('input_path')
    export_parser.add_argument('output_path')
    export_parser.set_defaults(func=command_export)

    export_directory_parser = subparsers.add_parser('export_directory',
                                                    help='Export all Unreal Tournament translation files in a directory to .po files')
    export_directory_parser.add_argument('input_path',
                                         help='The directory to search for Unreal Tournament translation files'
                                         )
    export_directory_parser.add_argument('-o', '--output_path',
                                         help='The pattern to use for the output path. Use {l} to substitute the ISO-3608 language code and {f} to substitute the filename.',
                                         default='{f}/{f}.{l}.po',
                                         required=False
                                         )
    export_directory_parser.add_argument('-d', '--dry', help='Dry run', default=False, action='store_true',
                                         required=False)
    export_directory_parser.add_argument('-l', '--language_code', help='The language to export (ISO 639-1 codes)',
                                         required=False)
    export_directory_parser.add_argument('-w', '--overwrite', help='Overwrite existing files', default=False,
                                         action='store_true', required=False)
    export_directory_parser.add_argument('-v', '--verbose', help='Verbose output', default=False, action='store_true',
                                         required=False)
    export_directory_parser.add_argument('-f', '--filter', help='Filter the files to export by a glob pattern',
                                         required=False)
    export_directory_parser.set_defaults(func=command_export_directory)

    import_directory_parser = subparsers.add_parser('import_directory',
                                                    help='Import all .po files in a directory to Unreal Tournament translation files')
    import_directory_parser.add_argument('input_path',
                                         help='The directory to search for .po files'
                                         )
    import_directory_parser.add_argument('-o', '--output_path',
                                         help='The pattern to use for the output path. Use {l} to substitute the ISO-3608 language code and {f} to substitute the filename.',
                                         default='{f}.{l}',
                                         required=False
                                         )
    import_directory_parser.add_argument('-d', '--dry', help='Dry run', default=False, action='store_true',
                                         required=False)
    import_directory_parser.add_argument('-l', '--language_code', help='The language to import (ISO 639-1 codes)',
                                         required=False)
    import_directory_parser.add_argument('-w', '--overwrite', help='Overwrite existing files', default=False,
                                         action='store_true', required=False)
    import_directory_parser.add_argument('-v', '--verbose', help='Verbose output', default=False, action='store_true',
                                         required=False)
    import_directory_parser.set_defaults(func=command_import_directory)

    fix_unt_parser = subparsers.add_parser('fix_unt', help='Fix errors in Unreal translation files.')
    fix_unt_parser.add_argument('input_directory', help='The directory to read the .int files from.')
    fix_unt_parser.add_argument('-e', '--extension', help='The extension of the files to read.', default='int',
                                required=False)
    fix_unt_parser.add_argument('-d', '--dry', help='Dry run', default=False, action='store_true', required=False)
    fix_unt_parser.set_defaults(func=fix_unt)

    generate_font_scripts_parser = subparsers.add_parser('generate_font_scripts',
                                                         help='Generate font scripts from a YAML file.')
    generate_font_scripts_parser.add_argument('-m', '--mod', help='The name of the mod to generate font scripts for.',
                                              required=True)
    generate_font_scripts_parser.add_argument('-l', '--language_code',
                                              help='The language to generate font scripts for (ISO 639-1 codes)',
                                              required=False)
    generate_font_scripts_parser.set_defaults(func=generate_font_scripts)

    sync_parser = subparsers.add_parser('sync', help='Sync a Git repository with a directory of .po files.')
    sync_parser.add_argument('-m', '--mod', help='The name of the mod to sync.', required=True)
    sync_parser.add_argument('-d', '--dry', help='Dry run', default=False, action='store_true', required=False)
    sync_parser.add_argument('-l', '--language_code', help='The language to sync (ISO 639-1 codes)', required=False)
    sync_parser.add_argument('-v', '--verbose', help='Verbose output', default=False, action='store_true',
                             required=False)
    sync_parser.add_argument('-f', '--filter', help='Filter the files to sync by a glob pattern', required=False)
    sync_parser.set_defaults(func=sync)

    args = argparse.parse_args()
    args.func(args)
