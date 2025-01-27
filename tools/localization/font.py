import copy
import glob
import os
import sys
from collections import OrderedDict
from pathlib import Path
from typing import List, Union, Tuple, Iterable, Optional, Dict
from iso639 import Language
from fontTools.ttLib import TTFont
import yaml

from unt import iso639_to_language_extension, read_unique_characters_from_unt_file


class UnicodeRanges:
    def __init__(self, ranges: List[Union[int, Tuple[int, int]]] = None):
        # Initialize the ranges as an empty list of tuples (start, end)
        if ranges is None:
            ranges: List[Tuple[int, int]] = []
        # Convert any single integers to tuples
        ranges = [(r, r) if isinstance(r, int) else r for r in ranges]
        self._ranges = []
        self.add_ranges(ranges)

    def _merge_in_place(self, start: int, end: int, insert_index: int):
        """Merge the new range in place starting at insert_index."""
        n = len(self._ranges)
        i = insert_index

        # Expand the start and end if overlapping or contiguous ranges are found
        while i < n and self._ranges[i][0] <= end + 1:
            start = min(start, self._ranges[i][0])
            end = max(end, self._ranges[i][1])
            i += 1

        # Replace the current range and delete any overlapped ranges
        self._ranges[insert_index: i] = [(start, end)]

    def add_ranges(self, ranges: Iterable[Tuple[int, int]]):
        for start, end in ranges:
            self.add_range(start, end)

    def add_range(self, start: int, end: int):
        """Add a new range (start, end) while maintaining sorted order and merging if necessary."""
        if start > end:
            start, end = end, start

        n = len(self._ranges)
        i = 0

        # Find the insertion point
        while i < n and self._ranges[i][1] < start - 1:
            i += 1

        # Merge the new range into the correct position
        self._merge_in_place(start, end, i)

    def add_ordinal(self, ordinal: int):
        """Add a single ordinal and merge it with existing ranges if necessary."""
        self.add_range(ordinal, ordinal)

    def add_ordinals(self, ordinals: Iterable[int]):
        """Add a list of ordinals and merge them with existing ranges if necessary."""
        for ordinal in ordinals:
            self.add_ordinal(ordinal)

    def get_ranges(self) -> List[Tuple[int, int]]:
        return self._ranges

    def merge(self, other):
        print(other.get_ranges())
        for start, end in other.get_ranges():
            self.add_range(start, end)
        return self

    def get_unicode_ranges_string(self):
        def int_to_hex(i: int) -> str:
            return hex(i)[2:].upper()
        parts = []
        for unicode_range in self._ranges:
            parts.append(f'{int_to_hex(unicode_range[0])}-{int_to_hex(unicode_range[1])}')
        return ','.join(parts)

    def contains_ordinal(self, ordinal: int) -> bool:
        for start, end in self._ranges:
            if start <= ordinal <= end:
                return True
        return False

    def contains_range(self, start: int, end: int) -> bool:
        for s, e in self._ranges:
            if s <= start and end <= e:
                return True
        return False

    def iter_ordinals(self) -> Iterable[int]:
        for start, end in self._ranges:
            yield from range(start, end + 1)

    def intersect(self, other: 'UnicodeRanges') -> 'UnicodeRanges':
        """
        Get the intersection of two unicode ranges, returning a new UnicodeRanges object that contains the ordinals that
        are in both ranges.
        """
        # TODO: this is pretty inefficient to be iterating over all ordinals.
        result = UnicodeRanges()
        for ordinal in self.iter_ordinals():
            if other.contains_ordinal(ordinal):
                result.add_ordinal(ordinal)
        return result


class TrueTypeFont:
    def __init__(self, package: str, group: str, name: str, fontname: str, height: int, unicode_ranges: UnicodeRanges, anti_alias: int, drop_shadow_x: int, drop_shadow_y: int, u_size: int, v_size: int, x_pad: int, y_pad: int, extend_bottom: int, extend_top: int, extend_left: int, extend_right: int, kerning: int, style: int, italic: int, resolution: Optional[int] = None):
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

    root_path = Path(args.root_path).absolute()

    # Make sure that the root path exists and is a directory.
    if not root_path.exists() or not root_path.is_dir():
        print(f'Error: root path "{root_path}" does not exist or is not a directory', file=sys.stderr)
        return

    mod_path = root_path / mod

    # Make sure the mod path exists and is a directory.
    if not mod_path.exists() or not mod_path.is_dir():
        print(f'Error: mod path "{mod_path}" does not exist or is not a directory', file=sys.stderr)
        return

    font_paths = mod_path / 'Fonts'
    fonts_config_path = font_paths / 'fonts.yml'

    # Make sure the fonts.yml file exists.
    if not fonts_config_path.exists():
        # Print out to stderr so that it can be captured by the caller.
        print(f'Error: fonts.yml not found at {fonts_config_path}', file=sys.stderr)
        return

    import_font_script_path = font_paths / 'ImportFonts.exec.txt'

    with open(fonts_config_path, 'r') as file:
        data = yaml.load(file, Loader=yaml.FullLoader)

    font_styles = data['font_styles']
    languages = data['languages']
    fonts_package_name = data['package_name']

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
    default_unicode_ranges = UnicodeRanges(defaults.get('unicode_ranges', []))

    default_resolution_group = defaults.get('resolution_group', resolution_groups[0] if isinstance(resolution_groups, list) and resolution_groups is not None else None)

    fonts: Dict[str, TrueTypeFont] = OrderedDict()

    class FontStyleItem:
        def __init__(self, font_index: int, resolution: int):
            self.font_index = font_index
            self.resolution = resolution

    font_style_items: Dict[str, List[FontStyleItem]] = {}

    for language_code, language in languages.items():
        if args.language_code is not None and args.language_code != language_code:
            continue

        package_name = fonts_package_name
        language_unicode_ranges = UnicodeRanges()
        language_unicode_ranges.add_ranges(language.get('unicode_ranges', []))
        unicode_ranges = copy.deepcopy(default_unicode_ranges).merge(language_unicode_ranges)

        language_suffix = 'int'

        if language_code != 'en':
            part3 = Language.from_part1(language_code).part3
            language_suffix = iso639_to_language_extension.get(part3, part3)
            package_name = f'{fonts_package_name}_{language_suffix}'

        # Go through each of the Unreal translation files for this language and get the characters that are used.
        ensure_all_characters = language.get('ensure_all_characters', False)

        if ensure_all_characters:
            characters = set()
            pattern = f'{mod_path}\\System\\*.{language_suffix}'

            for filename in glob.glob(pattern):
                characters |= read_unique_characters_from_unt_file(filename)

            # For each of the characters, see if it's in the unicode ranges.
            # If it's not, add it to the unicode ranges.
            unicode_ranges.add_ordinals(characters)

            # if len(added_characters) > 0:
            #     print(f'Added {len(characters)} characters to unicode ranges for language {language["name"]} ({language_code}): {[hex(c) for c in added_characters]}')

        for font_style_name, style in font_styles.items():
            font_style_items[font_style_name] = []

            # Merge the default font style with the language's font style.
            style = {**default_font_style, **style}

            font = style['font']
            font_substitutions = language.get('font_substitutions', {})

            if font in font_substitutions:
                # Use the language's font substitution, if it exists.
                font = font_substitutions[font]

            font_style_size = style['size']
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

            padding = style.get('padding', {'x': 1, 'y': 1})
            margin = style.get('margin', {})
            anti_alias = int(style.get('anti_alias', 1))
            drop_shadow = style.get('drop_shadow', {})
            kerning = int(style.get('kerning', 0))
            weight = int(style.get('weight', 500))
            italic = bool(style.get('italic', False))
            texture_size = style.get('texture_size', {'x': 512, 'y': 512})

            for size, resolution in zip(sizes, resolutions):
                has_drop_shadow = 'x' in drop_shadow or 'y' in drop_shadow and (
                            drop_shadow['x'] != 0 or drop_shadow['y'] != 0)
                font_name = (f'{font.replace(" ", "")}'
                             f'{"A" if anti_alias else ""}'
                             f'{"D" if has_drop_shadow else ""}'
                             f'{"I" if italic else ""}'
                             f'{f"W{weight}" if weight != 500 else ""}'
                             f'{size}')
                if font_name not in fonts:
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
                    )
                    fonts[font_name] = true_type_font

                font_index = list(fonts.keys()).index(font_name)

                item = FontStyleItem(font_index=font_index, resolution=resolution)

                font_style_items[font_style_name].append(item)

    # Get the list of all installed Fonts.
    def get_installed_fonts() -> Dict[str, Dict[str, str]]:
        from os import walk

        font_directories = [
            Path(r'C:\Windows\Fonts').resolve(),
            Path(fr'{os.getenv("LOCALAPPDATA")}\Microsoft\Windows\Fonts').resolve(),
        ]

        print(font_directories)

        font_extensions = ['.ttf', '.otf', '.ttc', '.ttz', '.woff', '.woff2']
        font_paths = []
        for font_directory in font_directories:
            for (dirpath, dirnames, filenames) in walk(font_directory):
                for filename in filenames:
                    if any(filename.endswith(ext) for ext in font_extensions):
                        font_paths.append(dirpath.replace('\\\\', '\\') + '\\' + filename)

        def get_font(font: TTFont, font_path: str):
            x = lambda x: font['name'].getDebugName(x)
            if x(16) is None:
                return x(1), x(2), font_path
            elif x(16) is not None:
                return x(16), x(17), font_path
            else:
                return None

        ttf_fonts = []

        for font_path in font_paths:
            if font_path.endswith('.ttc'):
                try:
                    # Try to get the sizes of the font from 0 to 100.
                    for font_index in range(100):
                        ttf_font = get_font(TTFont(font_path, fontNumber=font_index), font_path)
                        if ttf_font is not None:
                            ttf_fonts.append(ttf_font)
                except:
                    pass
            else:
                ttf_fonts.append(get_font(TTFont(font_path), font_path))

        installed_fonts: Dict[str, Dict[str, str]] = {}
        for (family, style, path) in ttf_fonts:
            if family not in installed_fonts:
                installed_fonts[family] = {}
            installed_fonts[family][style] = path

        return installed_fonts

    def weight_to_style(weight: int) -> str:
        if weight < 400:
            return 'Thin'
        elif weight < 600:
            return 'Regular'
        elif weight < 700:
            return 'Medium'
        elif weight < 800:
            return 'Bold'
        else:
            return 'Black'

    installed_fonts = get_installed_fonts()

    # Write the font generation script.
    lines = []
    for _, font in fonts.items():
        font_weight = font.style

        style_name = weight_to_style(font_weight)

        # Check if the font is installed.
        font_path = installed_fonts[font.fontname][style_name]
        if font_path is None:
            raise Exception(f'Could not find font "{font.fontname}" with style "{style_name}"')

        # Load the font and get the supported unicode ranges.
        font_unicode_ranges = UnicodeRanges()
        with TTFont(font_path) as ttf:
            from itertools import chain
            x = chain.from_iterable(x.cmap.keys() for x in ttf['cmap'].tables)
            for ordinal in x:
                font_unicode_ranges.add_ordinal(ordinal)

        # Intersect the font's unicode ranges with the supported unicode ranges.
        font_unicode_ranges = font_unicode_ranges.intersect(font.unicode_ranges)

        lines.append(f'NEW TRUETYPEFONTFACTORY '
                     f'PACKAGE={font.package} '
                     f'GROUP={font.group} '
                     f'NAME={font.name} '
                     f'FONTNAME="{font.fontname}" '
                     f'HEIGHT={font.height} '
                     f'UNICODERANGE="{font_unicode_ranges.get_unicode_ranges_string()}" '
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

    lines += [
        f'OBJ SAVEPACKAGE PACKAGE={package_name} FILE="..\\DarkestHourDev\\Textures\\{package_name}.utx"',
        '',
        '; Execute this with the following command:',
        f'; EXEC "{import_font_script_path.resolve()}"'
    ]

    for line in lines:
        print(line)

    with open(import_font_script_path, 'w') as file:
        file.write('\n'.join(lines))

    # UnrealScript
    unrealscript = data['unrealscript']
    unrealscript_gui_fonts = unrealscript.get('gui_fonts', None)
    unrealscript_gui_font_path = Path(root_path) / unrealscript_gui_fonts['directory']

    def write_font_style_class_file(path: Path, font_style_name: str, package_name: str):
        with open(path, 'w') as f:
            lines = [
                '//==============================================================================',
                '// This file was automatically generated by the localization tool.',
                '// Do not edit this file directly.',
                '// To regenerate this file, run ./tools/localization/generate_fonts.bat',
                '//==============================================================================',
                '',
                f'class {font_style_name} extends GUIFont;',
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

    # Write the font style classes.
    for font_style_name in font_style_items.keys():
        gui_font_path = unrealscript_gui_font_path / f'{font_style_name}.uc'
        write_font_style_class_file(gui_font_path, font_style_name, package_name)

    # Write the fonts class.
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
            f'class {unrealscript_fonts["class_name"]} extends Object',
            '    abstract;',
            '',
            'struct FontStyleItem {',
            '    var int FontIndex;',
            '    var int Resolution;',
            '};',
            '',
            f'var string FontNames[{len(fonts)}];',
            f'var Font Fonts[{len(fonts)}];',
        ]

        # Create the string arrays for the font style.
        for font_style_name, items in font_style_items.items():
            lines.append(f'var FontStyleItem {font_style_name}Items[{len(items)}];')

        lines.append('')

        lines += [
            'static function Font GetFontByIndex(int i) {',
            '    if (default.Fonts[i] == none) {',
            '        default.Fonts[i] = Font(DynamicLoadObject(default.FontNames[i], class\'Font\'));',
            '        if (default.Fonts[i] == none) {',
            '            Warn("Could not dynamically load" @ default.FontNames[i]);',
            '        }',
            '    }',
            '    return default.Fonts[i];',
            '}',
            '',
        ]

        # Create the function to load the fonts.
        for font_style_name in font_style_items.keys():
            items_array_name = f'{font_style_name}Items'
            lines += [
                f'static function Font Get{font_style_name}ByIndex(int i) {{',
                f'    return GetFontByIndex(default.{items_array_name}[i].FontIndex);',
                f'}}',
                f'',
                f'// Load a font by the nearest target resolution',
                f'static function Font Get{font_style_name}ByResolution(int Resolution) {{',
                f'    local int i;',
                f'    for (i = 0; i < arraycount(default.{items_array_name}); i++) {{',
                f'        if (Resolution >= default.{items_array_name}[i].Resolution) {{',
                f'            return Get{font_style_name}ByIndex(i);',
                f'        }}',
                f'    }}',
                f'    return Get{font_style_name}ByIndex(arraycount(default.{items_array_name}) - 1);',
                f'}}',
                '',
            ]

        lines.append('defaultproperties')
        lines.append('{')

        for font_index, (font_name, font) in enumerate(fonts.items()):
            lines.append(f'    FontNames({font_index})="{package_name}.{font_name}"')

        for font_style_name, items in font_style_items.items():
            for item_index, item in enumerate(items):
                lines.append(f'    {font_style_name}Items({item_index})=(FontIndex={item.font_index},Resolution={item.resolution})')

        lines.append('}')

        # Write the lines to the file.
        for line in lines:
            file.write(line + '\n')


if __name__ == '__main__':
    from argparse import ArgumentParser

    # Create the top-level parser
    argparse = ArgumentParser(prog='fonts', description='Unreal Tournament 2 font generation tool')

    subparsers = argparse.add_subparsers(dest='command', required=True)

    generate_font_scripts_parser = subparsers.add_parser('generate', help='Generate font scripts from a YAML file.')
    generate_font_scripts_parser.add_argument('root_path', help='The path of the game root directory.')
    generate_font_scripts_parser.add_argument('-m', '--mod', help='The name of the mod to generate font scripts for.', required=True)
    generate_font_scripts_parser.add_argument('-l', '--language_code', help='The language to generate font scripts for (ISO 639-1 codes)', required=False)
    generate_font_scripts_parser.set_defaults(func=generate_font_scripts)

    args = argparse.parse_args()
    args.func(args)
