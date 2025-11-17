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
    def __init__(self, fontname: str, height: int, anti_alias: bool, drop_shadow_x: int, drop_shadow_y: int, u_size: int, v_size: int, x_pad: int, y_pad: int, extend_box_bottom: int, extend_box_top: int, extend_box_left: int, extend_box_right: int, kerning: int, style: int, italic: bool, compression: Compression, resolution: Optional[int] = None, package: Optional[str] = None, group: Optional[str] = None):
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
        self.extend_box_bottom = extend_box_bottom
        self.extend_box_top = extend_box_top
        self.extend_box_left = extend_box_left
        self.extend_box_right = extend_box_right
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
                f'FONTNAME="{self.font.fontname}" ' \
                f'NAME={self.font.name} ' \
                f'PATH="{self.path}" ' \
                f'WILDCARD="{self.wildcard}" ' \
                f'COMPRESSION={self.font.compression.value} ' \
        
        if self.font.style != 400:
            command_string += f'STYLE={self.font.style} '
        
        if self.font.height != 16:
            command_string += f'HEIGHT={self.font.height} '
        
        if self.font.u_size != 256:
            command_string += f'USIZE={self.font.u_size} '
        
        if self.font.v_size != 256:
            command_string += f'VSIZE={self.font.v_size} '
        
        if self.font.extend_box_bottom != 0:
            command_string += f'EXTENDBOXBOTTOM={self.font.extend_box_bottom} '

        if self.font.extend_box_top != 0:
            command_string += f'EXTENDBOXTOP={self.font.extend_box_top} '
        
        if self.font.extend_box_left != 0:
            command_string += f'EXTENDBOXLEFT={self.font.extend_box_left} '

        if self.font.extend_box_right != 0:
            command_string += f'EXTENDBOXRIGHT={self.font.extend_box_right} '

        if self.font.package is not None:
            command_string += f'PACKAGE={self.font.package} '
        
        if self.font.group is not None:
            command_string += f'GROUP={self.font.group} '
        
        if self.font.kerning != 0:
            command_string += f'KERNING={self.font.kerning} '
        
        if self.font.drop_shadow_x != 0:
            command_string += f'DROPSHADOWX={self.font.drop_shadow_x} '
    
        if self.font.drop_shadow_y != 0:
            command_string += f'DROPSHADOWY={self.font.drop_shadow_y} '
        
        if self.font.anti_alias:
            command_string += f'ANTIALIAS={int(self.font.anti_alias)} '
        
        if self.font.italic:
            command_string += f'ITALIC={int(self.font.italic)} '
        
        if self.font.x_pad != 1:
            command_string += f'XPAD={self.font.x_pad}'
        
        if self.font.y_pad != 1:
            command_string += f'YPAD={self.font.y_pad}'
        
        return command_string
        
            #  f'UNDERLINE={self.underline} ' \
            #  f'GAMMA={self.gamma} ' \