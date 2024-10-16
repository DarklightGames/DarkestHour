//==============================================================================
// This file was automatically generated by the localization tool.
// Do not edit this file directly.
// To regenerate this file, run ./tools/localization/generate_fonts.bat
//==============================================================================

class DHFonts extends Object
    abstract;

struct FontStyleSize {
    var string FontName;
    var Font Font;
    var int Size;
    var int Resolution;
};

var FontStyleSize DHConsoleFontSizes[8];
var FontStyleSize DHConsoleFontDSSizes[8];
var FontStyleSize DHButtonFontSizes[3];
var FontStyleSize DHButtonFontDSSizes[3];
var FontStyleSize DHHugeButtonFontSizes[3];
var FontStyleSize DHLargeFontSizes[3];
var FontStyleSize DHLargeFontDSSizes[3];
var FontStyleSize DHMenuFontSizes[3];
var FontStyleSize DHMenuFontDSSizes[3];
var FontStyleSize DHSmallFontSizes[3];
var FontStyleSize DHSmallFontDSSizes[3];

static function Font GetDHConsoleFontByIndex(int i) {
    if (default.DHConsoleFontSizes[i].Font == none) {
        default.DHConsoleFontSizes[i].Font = Font(DynamicLoadObject(default.DHConsoleFontSizes[i].FontName, class'Font'));
        if (default.DHConsoleFontSizes[i].Font == none) {
            Warn("Could not dynamically load" @ default.DHConsoleFontSizes[i].FontName);
        }
    }
    return default.DHConsoleFontSizes[i].Font;
}

// Load a font by the nearest target size
static function Font GetDHConsoleFontBySize(int Size) {
    local int i;
    for (i = 0; i < arraycount(default.DHConsoleFontSizes); i++) {
        if (Size >= default.DHConsoleFontSizes[i].Size) {
            return GetDHConsoleFontByIndex(i);
        }
    }
    return GetDHConsoleFontByIndex(arraycount(default.DHConsoleFontSizes) - 1);
}

// Load a font by the nearest target resolution
static function Font GetDHConsoleFontByResolution(int Resolution) {
    local int i;
    for (i = 0; i < arraycount(default.DHConsoleFontSizes); i++) {
        if (Resolution >= default.DHConsoleFontSizes[i].Resolution) {
            return GetDHConsoleFontByIndex(i);
        }
    }
    return GetDHConsoleFontByIndex(arraycount(default.DHConsoleFontSizes) - 1);
}

static function Font GetDHConsoleFontDSByIndex(int i) {
    if (default.DHConsoleFontDSSizes[i].Font == none) {
        default.DHConsoleFontDSSizes[i].Font = Font(DynamicLoadObject(default.DHConsoleFontDSSizes[i].FontName, class'Font'));
        if (default.DHConsoleFontDSSizes[i].Font == none) {
            Warn("Could not dynamically load" @ default.DHConsoleFontDSSizes[i].FontName);
        }
    }
    return default.DHConsoleFontDSSizes[i].Font;
}

// Load a font by the nearest target size
static function Font GetDHConsoleFontDSBySize(int Size) {
    local int i;
    for (i = 0; i < arraycount(default.DHConsoleFontDSSizes); i++) {
        if (Size >= default.DHConsoleFontDSSizes[i].Size) {
            return GetDHConsoleFontDSByIndex(i);
        }
    }
    return GetDHConsoleFontDSByIndex(arraycount(default.DHConsoleFontDSSizes) - 1);
}

// Load a font by the nearest target resolution
static function Font GetDHConsoleFontDSByResolution(int Resolution) {
    local int i;
    for (i = 0; i < arraycount(default.DHConsoleFontDSSizes); i++) {
        if (Resolution >= default.DHConsoleFontDSSizes[i].Resolution) {
            return GetDHConsoleFontDSByIndex(i);
        }
    }
    return GetDHConsoleFontDSByIndex(arraycount(default.DHConsoleFontDSSizes) - 1);
}

static function Font GetDHButtonFontByIndex(int i) {
    if (default.DHButtonFontSizes[i].Font == none) {
        default.DHButtonFontSizes[i].Font = Font(DynamicLoadObject(default.DHButtonFontSizes[i].FontName, class'Font'));
        if (default.DHButtonFontSizes[i].Font == none) {
            Warn("Could not dynamically load" @ default.DHButtonFontSizes[i].FontName);
        }
    }
    return default.DHButtonFontSizes[i].Font;
}

// Load a font by the nearest target size
static function Font GetDHButtonFontBySize(int Size) {
    local int i;
    for (i = 0; i < arraycount(default.DHButtonFontSizes); i++) {
        if (Size >= default.DHButtonFontSizes[i].Size) {
            return GetDHButtonFontByIndex(i);
        }
    }
    return GetDHButtonFontByIndex(arraycount(default.DHButtonFontSizes) - 1);
}

// Load a font by the nearest target resolution
static function Font GetDHButtonFontByResolution(int Resolution) {
    local int i;
    for (i = 0; i < arraycount(default.DHButtonFontSizes); i++) {
        if (Resolution >= default.DHButtonFontSizes[i].Resolution) {
            return GetDHButtonFontByIndex(i);
        }
    }
    return GetDHButtonFontByIndex(arraycount(default.DHButtonFontSizes) - 1);
}

static function Font GetDHButtonFontDSByIndex(int i) {
    if (default.DHButtonFontDSSizes[i].Font == none) {
        default.DHButtonFontDSSizes[i].Font = Font(DynamicLoadObject(default.DHButtonFontDSSizes[i].FontName, class'Font'));
        if (default.DHButtonFontDSSizes[i].Font == none) {
            Warn("Could not dynamically load" @ default.DHButtonFontDSSizes[i].FontName);
        }
    }
    return default.DHButtonFontDSSizes[i].Font;
}

// Load a font by the nearest target size
static function Font GetDHButtonFontDSBySize(int Size) {
    local int i;
    for (i = 0; i < arraycount(default.DHButtonFontDSSizes); i++) {
        if (Size >= default.DHButtonFontDSSizes[i].Size) {
            return GetDHButtonFontDSByIndex(i);
        }
    }
    return GetDHButtonFontDSByIndex(arraycount(default.DHButtonFontDSSizes) - 1);
}

// Load a font by the nearest target resolution
static function Font GetDHButtonFontDSByResolution(int Resolution) {
    local int i;
    for (i = 0; i < arraycount(default.DHButtonFontDSSizes); i++) {
        if (Resolution >= default.DHButtonFontDSSizes[i].Resolution) {
            return GetDHButtonFontDSByIndex(i);
        }
    }
    return GetDHButtonFontDSByIndex(arraycount(default.DHButtonFontDSSizes) - 1);
}

static function Font GetDHHugeButtonFontByIndex(int i) {
    if (default.DHHugeButtonFontSizes[i].Font == none) {
        default.DHHugeButtonFontSizes[i].Font = Font(DynamicLoadObject(default.DHHugeButtonFontSizes[i].FontName, class'Font'));
        if (default.DHHugeButtonFontSizes[i].Font == none) {
            Warn("Could not dynamically load" @ default.DHHugeButtonFontSizes[i].FontName);
        }
    }
    return default.DHHugeButtonFontSizes[i].Font;
}

// Load a font by the nearest target size
static function Font GetDHHugeButtonFontBySize(int Size) {
    local int i;
    for (i = 0; i < arraycount(default.DHHugeButtonFontSizes); i++) {
        if (Size >= default.DHHugeButtonFontSizes[i].Size) {
            return GetDHHugeButtonFontByIndex(i);
        }
    }
    return GetDHHugeButtonFontByIndex(arraycount(default.DHHugeButtonFontSizes) - 1);
}

// Load a font by the nearest target resolution
static function Font GetDHHugeButtonFontByResolution(int Resolution) {
    local int i;
    for (i = 0; i < arraycount(default.DHHugeButtonFontSizes); i++) {
        if (Resolution >= default.DHHugeButtonFontSizes[i].Resolution) {
            return GetDHHugeButtonFontByIndex(i);
        }
    }
    return GetDHHugeButtonFontByIndex(arraycount(default.DHHugeButtonFontSizes) - 1);
}

static function Font GetDHLargeFontByIndex(int i) {
    if (default.DHLargeFontSizes[i].Font == none) {
        default.DHLargeFontSizes[i].Font = Font(DynamicLoadObject(default.DHLargeFontSizes[i].FontName, class'Font'));
        if (default.DHLargeFontSizes[i].Font == none) {
            Warn("Could not dynamically load" @ default.DHLargeFontSizes[i].FontName);
        }
    }
    return default.DHLargeFontSizes[i].Font;
}

// Load a font by the nearest target size
static function Font GetDHLargeFontBySize(int Size) {
    local int i;
    for (i = 0; i < arraycount(default.DHLargeFontSizes); i++) {
        if (Size >= default.DHLargeFontSizes[i].Size) {
            return GetDHLargeFontByIndex(i);
        }
    }
    return GetDHLargeFontByIndex(arraycount(default.DHLargeFontSizes) - 1);
}

// Load a font by the nearest target resolution
static function Font GetDHLargeFontByResolution(int Resolution) {
    local int i;
    for (i = 0; i < arraycount(default.DHLargeFontSizes); i++) {
        if (Resolution >= default.DHLargeFontSizes[i].Resolution) {
            return GetDHLargeFontByIndex(i);
        }
    }
    return GetDHLargeFontByIndex(arraycount(default.DHLargeFontSizes) - 1);
}

static function Font GetDHLargeFontDSByIndex(int i) {
    if (default.DHLargeFontDSSizes[i].Font == none) {
        default.DHLargeFontDSSizes[i].Font = Font(DynamicLoadObject(default.DHLargeFontDSSizes[i].FontName, class'Font'));
        if (default.DHLargeFontDSSizes[i].Font == none) {
            Warn("Could not dynamically load" @ default.DHLargeFontDSSizes[i].FontName);
        }
    }
    return default.DHLargeFontDSSizes[i].Font;
}

// Load a font by the nearest target size
static function Font GetDHLargeFontDSBySize(int Size) {
    local int i;
    for (i = 0; i < arraycount(default.DHLargeFontDSSizes); i++) {
        if (Size >= default.DHLargeFontDSSizes[i].Size) {
            return GetDHLargeFontDSByIndex(i);
        }
    }
    return GetDHLargeFontDSByIndex(arraycount(default.DHLargeFontDSSizes) - 1);
}

// Load a font by the nearest target resolution
static function Font GetDHLargeFontDSByResolution(int Resolution) {
    local int i;
    for (i = 0; i < arraycount(default.DHLargeFontDSSizes); i++) {
        if (Resolution >= default.DHLargeFontDSSizes[i].Resolution) {
            return GetDHLargeFontDSByIndex(i);
        }
    }
    return GetDHLargeFontDSByIndex(arraycount(default.DHLargeFontDSSizes) - 1);
}

static function Font GetDHMenuFontByIndex(int i) {
    if (default.DHMenuFontSizes[i].Font == none) {
        default.DHMenuFontSizes[i].Font = Font(DynamicLoadObject(default.DHMenuFontSizes[i].FontName, class'Font'));
        if (default.DHMenuFontSizes[i].Font == none) {
            Warn("Could not dynamically load" @ default.DHMenuFontSizes[i].FontName);
        }
    }
    return default.DHMenuFontSizes[i].Font;
}

// Load a font by the nearest target size
static function Font GetDHMenuFontBySize(int Size) {
    local int i;
    for (i = 0; i < arraycount(default.DHMenuFontSizes); i++) {
        if (Size >= default.DHMenuFontSizes[i].Size) {
            return GetDHMenuFontByIndex(i);
        }
    }
    return GetDHMenuFontByIndex(arraycount(default.DHMenuFontSizes) - 1);
}

// Load a font by the nearest target resolution
static function Font GetDHMenuFontByResolution(int Resolution) {
    local int i;
    for (i = 0; i < arraycount(default.DHMenuFontSizes); i++) {
        if (Resolution >= default.DHMenuFontSizes[i].Resolution) {
            return GetDHMenuFontByIndex(i);
        }
    }
    return GetDHMenuFontByIndex(arraycount(default.DHMenuFontSizes) - 1);
}

static function Font GetDHMenuFontDSByIndex(int i) {
    if (default.DHMenuFontDSSizes[i].Font == none) {
        default.DHMenuFontDSSizes[i].Font = Font(DynamicLoadObject(default.DHMenuFontDSSizes[i].FontName, class'Font'));
        if (default.DHMenuFontDSSizes[i].Font == none) {
            Warn("Could not dynamically load" @ default.DHMenuFontDSSizes[i].FontName);
        }
    }
    return default.DHMenuFontDSSizes[i].Font;
}

// Load a font by the nearest target size
static function Font GetDHMenuFontDSBySize(int Size) {
    local int i;
    for (i = 0; i < arraycount(default.DHMenuFontDSSizes); i++) {
        if (Size >= default.DHMenuFontDSSizes[i].Size) {
            return GetDHMenuFontDSByIndex(i);
        }
    }
    return GetDHMenuFontDSByIndex(arraycount(default.DHMenuFontDSSizes) - 1);
}

// Load a font by the nearest target resolution
static function Font GetDHMenuFontDSByResolution(int Resolution) {
    local int i;
    for (i = 0; i < arraycount(default.DHMenuFontDSSizes); i++) {
        if (Resolution >= default.DHMenuFontDSSizes[i].Resolution) {
            return GetDHMenuFontDSByIndex(i);
        }
    }
    return GetDHMenuFontDSByIndex(arraycount(default.DHMenuFontDSSizes) - 1);
}

static function Font GetDHSmallFontByIndex(int i) {
    if (default.DHSmallFontSizes[i].Font == none) {
        default.DHSmallFontSizes[i].Font = Font(DynamicLoadObject(default.DHSmallFontSizes[i].FontName, class'Font'));
        if (default.DHSmallFontSizes[i].Font == none) {
            Warn("Could not dynamically load" @ default.DHSmallFontSizes[i].FontName);
        }
    }
    return default.DHSmallFontSizes[i].Font;
}

// Load a font by the nearest target size
static function Font GetDHSmallFontBySize(int Size) {
    local int i;
    for (i = 0; i < arraycount(default.DHSmallFontSizes); i++) {
        if (Size >= default.DHSmallFontSizes[i].Size) {
            return GetDHSmallFontByIndex(i);
        }
    }
    return GetDHSmallFontByIndex(arraycount(default.DHSmallFontSizes) - 1);
}

// Load a font by the nearest target resolution
static function Font GetDHSmallFontByResolution(int Resolution) {
    local int i;
    for (i = 0; i < arraycount(default.DHSmallFontSizes); i++) {
        if (Resolution >= default.DHSmallFontSizes[i].Resolution) {
            return GetDHSmallFontByIndex(i);
        }
    }
    return GetDHSmallFontByIndex(arraycount(default.DHSmallFontSizes) - 1);
}

static function Font GetDHSmallFontDSByIndex(int i) {
    if (default.DHSmallFontDSSizes[i].Font == none) {
        default.DHSmallFontDSSizes[i].Font = Font(DynamicLoadObject(default.DHSmallFontDSSizes[i].FontName, class'Font'));
        if (default.DHSmallFontDSSizes[i].Font == none) {
            Warn("Could not dynamically load" @ default.DHSmallFontDSSizes[i].FontName);
        }
    }
    return default.DHSmallFontDSSizes[i].Font;
}

// Load a font by the nearest target size
static function Font GetDHSmallFontDSBySize(int Size) {
    local int i;
    for (i = 0; i < arraycount(default.DHSmallFontDSSizes); i++) {
        if (Size >= default.DHSmallFontDSSizes[i].Size) {
            return GetDHSmallFontDSByIndex(i);
        }
    }
    return GetDHSmallFontDSByIndex(arraycount(default.DHSmallFontDSSizes) - 1);
}

// Load a font by the nearest target resolution
static function Font GetDHSmallFontDSByResolution(int Resolution) {
    local int i;
    for (i = 0; i < arraycount(default.DHSmallFontDSSizes); i++) {
        if (Resolution >= default.DHSmallFontDSSizes[i].Resolution) {
            return GetDHSmallFontDSByIndex(i);
        }
    }
    return GetDHSmallFontDSByIndex(arraycount(default.DHSmallFontDSSizes) - 1);
}

defaultproperties
{
    DHConsoleFontSizes(0)=(FontName="DHFonts.Inter38",Size=38,Resolution=2880)
    DHConsoleFontSizes(1)=(FontName="DHFonts.Inter28",Size=28,Resolution=2160)
    DHConsoleFontSizes(2)=(FontName="DHFonts.Inter24",Size=24,Resolution=1800)
    DHConsoleFontSizes(3)=(FontName="DHFonts.Inter18",Size=18,Resolution=1440)
    DHConsoleFontSizes(4)=(FontName="DHFonts.Inter14",Size=14,Resolution=1080)
    DHConsoleFontSizes(5)=(FontName="DHFonts.Inter14",Size=14,Resolution=1024)
    DHConsoleFontSizes(6)=(FontName="DHFonts.Inter12",Size=12,Resolution=900)
    DHConsoleFontSizes(7)=(FontName="DHFonts.Inter10",Size=10,Resolution=768)
    DHConsoleFontDSSizes(0)=(FontName="DHFonts.InterDS38",Size=38,Resolution=2880)
    DHConsoleFontDSSizes(1)=(FontName="DHFonts.InterDS28",Size=28,Resolution=2160)
    DHConsoleFontDSSizes(2)=(FontName="DHFonts.InterDS24",Size=24,Resolution=1800)
    DHConsoleFontDSSizes(3)=(FontName="DHFonts.InterDS18",Size=18,Resolution=1440)
    DHConsoleFontDSSizes(4)=(FontName="DHFonts.InterDS14",Size=14,Resolution=1080)
    DHConsoleFontDSSizes(5)=(FontName="DHFonts.InterDS14",Size=14,Resolution=1024)
    DHConsoleFontDSSizes(6)=(FontName="DHFonts.InterDS12",Size=12,Resolution=900)
    DHConsoleFontDSSizes(7)=(FontName="DHFonts.InterDS10",Size=10,Resolution=768)
    DHButtonFontSizes(0)=(FontName="DHFonts.SofiaSansCondensed40",Size=40,Resolution=2160)
    DHButtonFontSizes(1)=(FontName="DHFonts.SofiaSansCondensed26",Size=26,Resolution=1400)
    DHButtonFontSizes(2)=(FontName="DHFonts.SofiaSansCondensed20",Size=20,Resolution=1080)
    DHButtonFontDSSizes(0)=(FontName="DHFonts.SofiaSansCondensedDS40",Size=40,Resolution=2160)
    DHButtonFontDSSizes(1)=(FontName="DHFonts.SofiaSansCondensedDS26",Size=26,Resolution=1400)
    DHButtonFontDSSizes(2)=(FontName="DHFonts.SofiaSansCondensedDS20",Size=20,Resolution=1080)
    DHHugeButtonFontSizes(0)=(FontName="DHFonts.SofiaSansCondensed48",Size=48,Resolution=2160)
    DHHugeButtonFontSizes(1)=(FontName="DHFonts.SofiaSansCondensed32",Size=32,Resolution=1400)
    DHHugeButtonFontSizes(2)=(FontName="DHFonts.SofiaSansCondensed24",Size=24,Resolution=1080)
    DHLargeFontSizes(0)=(FontName="DHFonts.Arial32",Size=32,Resolution=2160)
    DHLargeFontSizes(1)=(FontName="DHFonts.Arial20",Size=20,Resolution=1400)
    DHLargeFontSizes(2)=(FontName="DHFonts.Arial16",Size=16,Resolution=1080)
    DHLargeFontDSSizes(0)=(FontName="DHFonts.ArialDS32",Size=32,Resolution=2160)
    DHLargeFontDSSizes(1)=(FontName="DHFonts.ArialDS20",Size=20,Resolution=1400)
    DHLargeFontDSSizes(2)=(FontName="DHFonts.ArialDS16",Size=16,Resolution=1080)
    DHMenuFontSizes(0)=(FontName="DHFonts.SofiaSansCondensed44",Size=44,Resolution=2160)
    DHMenuFontSizes(1)=(FontName="DHFonts.SofiaSansCondensed28",Size=28,Resolution=1400)
    DHMenuFontSizes(2)=(FontName="DHFonts.SofiaSansCondensed22",Size=22,Resolution=1080)
    DHMenuFontDSSizes(0)=(FontName="DHFonts.SofiaSansCondensedDS44",Size=44,Resolution=2160)
    DHMenuFontDSSizes(1)=(FontName="DHFonts.SofiaSansCondensedDS28",Size=28,Resolution=1400)
    DHMenuFontDSSizes(2)=(FontName="DHFonts.SofiaSansCondensedDS22",Size=22,Resolution=1080)
    DHSmallFontSizes(0)=(FontName="DHFonts.Inter28",Size=28,Resolution=2160)
    DHSmallFontSizes(1)=(FontName="DHFonts.Inter18",Size=18,Resolution=1400)
    DHSmallFontSizes(2)=(FontName="DHFonts.Inter14",Size=14,Resolution=1080)
    DHSmallFontDSSizes(0)=(FontName="DHFonts.InterDS28",Size=28,Resolution=2160)
    DHSmallFontDSSizes(1)=(FontName="DHFonts.InterDS18",Size=18,Resolution=1400)
    DHSmallFontDSSizes(2)=(FontName="DHFonts.InterDS14",Size=14,Resolution=1080)
}
