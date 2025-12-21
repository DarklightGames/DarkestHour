from ttf import Compression
from unicode_ranges import UnicodeRanges
from typing import Optional, Dict, List, Literal
import yaml

FontSizeMethod = Literal['proportial', 'fixed']

class Vec2:
    def __init__(self, x: int, y: int):
        self.x = x
        self.y = y
    
    @staticmethod
    def from_data(data: dict):
        return Vec2(data.get('x', 0), data.get('y', 0))


class Box:
    def __init__(self, bottom: int, top: int, left: int, right: int):
        self.bottom = bottom
        self.top = top
        self.left = left
        self.right = right
    
    @staticmethod
    def from_data(data: dict) -> 'Box':
        return Box(
            data['bottom'], data['top'], data['left'], data['right']
        )


class FontSize:
    def __init__(self):
        self.method: FontSizeMethod = 'proportional'
        self.baseline: int = 1080
        self.resolution_group: Optional[str] = None
        self.sizes: List[int] = []
    
    @staticmethod
    def from_data(data: dict) -> 'FontSize':
        font_size = FontSize()
        font_size.method = data.get('method', 'proportial')
        font_size.baseline = data.get('baseline', 1080)
        font_size.resolution_group = data.get('resolution_group', None)
        font_size.sizes = data.get('sizes', [])
        return font_size


class FontStyle:
    def __init__(self):
        self.font: Optional[str] = None
        self.texture_size: Optional[Vec2] = None
        self.size: Optional[FontSize] = None
        self.weight: Optional[int] = None
        self.padding: Optional[Vec2] = None
        self.margin: Optional[Box] = None
        self.anti_alias: Optional[bool] = None
        self.kerning: Optional[int] = None
        self.italic: Optional[bool] = None
        self.drop_shadow: Optional[Vec2] = None
        self.compression: Optional[Compression] = None
    
    @staticmethod
    def from_data(data: dict) -> 'FontStyle':
        font_style = FontStyle()
        font_style.font = data.get('font', None)
        font_style.texture_size = Vec2.from_data(data['texture_size']) if 'texture_size' in data else None
        font_style.size = FontSize.from_data(data['size']) if 'size' in data else None
        font_style.weight = data.get('weight', None)
        font_style.padding = Vec2.from_data(data['padding']) if 'padding' in data else None
        font_style.margin = Box.from_data(data['margin']) if 'margin' in data else None
        font_style.anti_alias = bool(data['anti_alias']) if 'anti_alias' in data else None
        font_style.kerning = data.get('kerning', None)
        font_style.italic = bool(data['italic']) if 'italic' in data else None
        font_style.drop_shadow = Vec2.from_data(data['drop_shadow']) if 'drop_shadow' in data else None
        font_style.compression = Compression[data['compression']] if 'compression' in data else None
        return font_style
    
    @property
    def has_drop_shadow(self):
        return self.drop_shadow and (self.drop_shadow.x != 0 or self.drop_shadow.y != 0)

    def merge_with_default(self, default: 'FontStyle'):
        self.font = default.font if self.font is None else self.font
        self.texture_size = default.texture_size if self.texture_size is None else self.texture_size
        self.size = default.size if self.size is None else self.size
        self.weight = default.weight if self.weight is None else self.weight
        self.padding = default.padding if self.padding is None else self.padding
        self.margin = default.margin if self.margin is None else self.margin
        self.anti_alias = default.anti_alias if self.anti_alias is None else self.anti_alias
        self.kerning = default.kerning if self.kerning is None else self.kerning
        self.italic = default.italic if self.italic is None else self.italic
        self.drop_shadow = default.drop_shadow if self.drop_shadow is None else self.drop_shadow
        self.compression = default.compression if self.compression is None else self.compression


class Package:
    def __init__(self):
        self.languages: List[str] = []
        self.ensure_all_used_characters: bool = False
        self.font_substitutions: Dict[str, str] = {}
        self.unicode_ranges = UnicodeRanges()
    
    @staticmethod
    def from_data(data: dict) -> 'Package':
        package = Package()
        package.languages = data.get('languages', [])
        package.ensure_all_used_characters = data.get('ensure_all_used_characters', False)
        package.unicode_ranges = UnicodeRanges(data.get('unicode_ranges', None))
        package.font_substitutions = data.get('font_substitutions', dict())
        return package


class Resolution:
    def __init__(self):
        self.baseline: int
        self.groups: Dict[str, List[int]] = {}
    
    @staticmethod
    def from_data(data: dict) -> 'Resolution':
        resolution = Resolution()
        resolution.baseline = data['baseline']
        resolution.groups = data['groups']

        if resolution.groups is not None and not isinstance(resolution.groups, dict):
            raise Exception('resolution_groups must be a dictionary')
        
        if any(not isinstance(key, str) or not isinstance(value, list) for (key, value) in resolution.groups.items()):
            raise Exception('resolution_groups must be a dictionary of strings to lists')

        for key, value in resolution.groups.items():
            if any(not isinstance(i, int) for i in value):
                raise Exception(f'Values in resolution_group "{key}" must only be integers')

        return resolution


class Defaults:
    def __init__(self):
        self.unicode_ranges = UnicodeRanges()
        self.font_style = FontStyle()
        self.resolution_group: Optional[str] = None
    
    @staticmethod
    def from_data(data: dict) -> 'Defaults':
        defaults = Defaults()
        defaults.unicode_ranges = UnicodeRanges(data['unicode_ranges'])
        defaults.font_style = FontStyle.from_data(data['font_style'])
        defaults.resolution_group = data.get('resolution_group', None)
        return defaults


class UnrealScript:
    def __init__(self):
        self.gui_fonts_directory: str = ''
        self.fonts_package_name: str = ''
        self.fonts_class_name: str = ''
    
    @staticmethod
    def from_data(data: dict) -> 'UnrealScript':
        unrealscript = UnrealScript()
        unrealscript.gui_fonts_directory = data['gui_fonts_directory']
        unrealscript.fonts_package_name = data['fonts_package_name']
        unrealscript.fonts_class_name = data['fonts_class_name']
        return unrealscript


class Dimensions:
    def __init__(self):
        self.resolution = Resolution()

    @staticmethod
    def from_data(data: dict) -> 'Dimensions':
        dimensions = Dimensions()
        dimensions.resolution = Resolution.from_data(data['resolution'])
        return dimensions


class FontConfiguration:
    def __init__(self):
        self.package_name: str
        self.defaults = Defaults()
        self.unrealscript = UnrealScript()
        self.font_styles: Dict[str, FontStyle] = dict()
        self.packages: Dict[str, Package] = dict()
        self.resolution = Resolution()

    @staticmethod
    def from_file(path: str) -> 'FontConfiguration':
        with open(path, 'r') as file:
            data = yaml.load(file, Loader=yaml.FullLoader)
        config = FontConfiguration()
        config.package_name = data['package_name']
        config.defaults = Defaults.from_data(data['defaults'])
        config.unrealscript = UnrealScript.from_data(data['unrealscript'])
        config.resolution = Resolution.from_data(data['resolution'])
        if 'font_styles' in data:
            for key, font_style_data in data['font_styles'].items():
                config.font_styles[key] = FontStyle.from_data(font_style_data)
        if 'packages' in data:
            for key, package_data in data['packages'].items():
                config.packages[key] = Package.from_data(package_data)
        return config
