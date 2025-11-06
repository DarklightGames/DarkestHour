import tempfile

from typing import Optional
from unicode_ranges import UnicodeRanges
from enum import Enum


class Compression(Enum):
    P8 = 0x00
    RGBA7 = 0x01
    RGB16 = 0x02
    DXT1 = 0x03
    RGB8 = 0x04
    RGBA8 = 0x05
    NODATA = 0x06
    DXT3 = 0x07
    DXT5 = 0x08
    L8 = 0x09
    G16 = 0x0A
    RRRGGGBBB = 0x0B


class TrueTypeFont:
    def __init__(self, package: Optional[str], group: str, fontname: str, height: int, anti_alias: bool, drop_shadow_x: int, drop_shadow_y: int, u_size: int, v_size: int, x_pad: int, y_pad: int, extend_bottom: int, extend_top: int, extend_left: int, extend_right: int, kerning: int, style: int, italic: int, compression: Compression, resolution: Optional[int] = None):
        self.package = package
        self.group = group
        self.fontname = fontname
        self.height = height
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
        # This is called the style, but this is really more the "weight".
        self.style = style
        self.italic = italic
        self.resolution = resolution
        self.compression = compression
    
    @property
    def has_drop_shadow(self):
        return self.drop_shadow_x != 0 or self.drop_shadow_y != 0
    
    @property
    def name(self):
        return (f'{self.fontname.replace(" ", "")}'
                        f'{"A" if self.anti_alias else ""}'
                        f'{"D" if self.has_drop_shadow else ""}'
                        f'{"I" if self.italic else ""}'
                        f'{f"W{self.style}" if self.style is not None and self.style != 500 else ""}'
                        f'{self.height}')


class TrueTypeFactory:
    
    def __init__(self, font: TrueTypeFont, unicode_ranges: UnicodeRanges):
        self.font = font
        self.unicode_ranges = unicode_ranges
    
    def write_characters_to_disk(self):
        contents = ''
        for codepoint in self.unicode_ranges.iter_ordinals():
            contents += chr(codepoint)
        self.path = tempfile.mkdtemp()
        fd, name = tempfile.mkstemp(dir=self.path)
        from pathlib import Path
        self.wildcard = Path(name).name
        with open(fd, 'wb') as fp:
            fp.write(b'\xff\xfe')  # Byte-order-mark.
            fp.write(contents.encode('utf-16-le'))

    def get_command_string(self) -> str:
        command_string = f'NEW TRUETYPEFONTFACTORY ' \
                f'STYLE={self.font.style} ' \
                f'ITALIC={self.font.italic} ' \
                f'FONTNAME="{self.font.fontname}" ' \
                f'HEIGHT={self.font.height} ' \
                f'USIZE={self.font.u_size} ' \
                f'VSIZE={self.font.v_size} ' \
                f'XPAD={self.font.x_pad} ' \
                f'YPAD={self.font.y_pad} ' \
                f'ANTIALIAS={int(self.font.anti_alias)} ' \
                f'KERNING={self.font.kerning} ' \
                f'DROPSHADOWX={self.font.drop_shadow_x} ' \
                f'DROPSHADOWY={self.font.drop_shadow_y} ' \
                f'EXTENDBOTTOM={self.font.extend_bottom} ' \
                f'EXTENDTOP={self.font.extend_top} ' \
                f'EXTENDLEFT={self.font.extend_left} ' \
                f'EXTENDRIGHT={self.font.extend_right} ' \
                f'GROUP={self.font.group} ' \
                f'NAME={self.font.name} ' \
                f'PATH="{self.path}" ' \
                f'WILDCARD="{self.wildcard}" ' \
                f'COMPRESSION={self.font.compression.value} ' \
            
        if self.font.package is not None:
            command_string += f'PACKAGE={self.font.package} ' \
        
        return command_string
        
            #  f'UNDERLINE={self.underline} ' \
            #  f'GAMMA={self.gamma} ' \