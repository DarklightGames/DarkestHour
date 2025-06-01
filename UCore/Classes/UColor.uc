//==============================================================================
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// http://www.flounder.com/csharp_color_table.htm
//==============================================================================

class UColor extends Object
    abstract;

struct HSV
{
    var float H;
    var float S;
    var float V;
};

var Color AliceBlue;
var Color AntiqueWhite;
var Color Aqua;
var Color Aquamarine;
var Color Azure;
var Color Beige;
var Color Bisque;
var Color Black;
var Color BlanchedAlmond;
var Color Blue;
var Color BlueViolet;
var Color Brown;
var Color BurlyWood;
var Color CadetBlue;
var Color Chartreuse;
var Color Chocolate;
var Color Coral;
var Color CornflowerBlue;
var Color Cornsilk;
var Color Crimson;
var Color Cyan;
var Color DarkBlue;
var Color DarkCyan;
var Color DarkGoldenrod;
var Color DarkGray;
var Color DarkGreen;
var Color DarkKhaki;
var Color DarkMagena;
var Color DarkOliveGreen;
var Color DarkOrange;
var Color DarkOrchid;
var Color DarkRed;
var Color DarkSalmon;
var Color DarkSeaGreen;
var Color DarkSlateBlue;
var Color DarkSlateGray;
var Color DarkTurquoise;
var Color DarkViolet;
var Color DeepPink;
var Color DeepSkyBlue;
var Color DimGray;
var Color DodgerBlue;
var Color Firebrick;
var Color FloralWhite;
var Color ForestGreen;
var Color Fuschia;
var Color Gainsboro;
var Color GhostWhite;
var Color Gold;
var Color Goldenrod;
var Color Gray;
var Color Green;
var Color GreenYellow;
var Color Honeydew;
var Color HotPink;
var Color IndianRed;
var Color Indigo;
var Color Ivory;
var Color Khaki;
var Color Lavender;
var Color LavenderBlush;
var Color LawnGreen;
var Color LemonChiffon;
var Color LightBlue;
var Color LightCoral;
var Color LightCyan;
var Color LightGoldenrodYellow;
var Color LightGray;
var Color LightGreen;
var Color LightPink;
var Color LightSalmon;
var Color LightSeaGreen;
var Color LightSkyBlue;
var Color LightSlateGray;
var Color LightSteelBlue;
var Color LightYellow;
var Color Lime;
var Color LimeGreen;
var Color Linen;
var Color Magenta;
var Color Maroon;
var Color MediumAquamarine;
var Color MediumBlue;
var Color MediumOrchid;
var Color MediumPurple;
var Color MediumSeaGreen;
var Color MediumSlateBlue;
var Color MediumSpringGreen;
var Color MediumTurquoise;
var Color MediumVioletRed;
var Color MidnightBlue;
var Color MintCream;
var Color MistyRose;
var Color Moccasin;
var Color NavajoWhite;
var Color Navy;
var Color OldLace;
var Color Olive;
var Color OliveDrab;
var Color Orange;
var Color OrangeRed;
var Color Orchid;
var Color PaleGoldenrod;
var Color PaleGreen;
var Color PaleTurquoise;
var Color PaleVioletRed;
var Color PapayaWhip;
var Color PeachPuff;
var Color Peru;
var Color Pink;
var Color Plum;
var Color PowderBlue;
var Color Purple;
var Color Red;
var Color RosyBrown;
var Color RoyalBlue;
var Color SaddleBrown;
var Color Salmon;
var Color SandyBrown;
var Color SeaGreen;
var Color Seashell;
var Color Sienna;
var Color Silver;
var Color SkyBlue;
var Color SlateBlue;
var Color SlateGray;
var Color Snow;
var Color SpringGreen;
var Color SteelBlue;
var Color Tan_;
var Color Teal;
var Color Thistle;
var Color Tomato;
var Color Turquoise;
var Color Violet;
var Color Wheat;
var Color White;
var Color WhiteSmoke;
var Color Yellow;
var Color YellowGreen;

final static function bool IsZero(Color C)
{
    return C.R == 0 && C.G == 0 && C.B == 0 && C.A == 0;
}

final static function string ToString(Color C)
{
    return "(R=" $ C.R $ ",G=" $ C.G $ ",B=" $ C.B $ ",A=" $ C.A $ ")";
}

final static function Color Interp(float X, Color A, Color B)
{
    local Color C;

    C.R = byte(Lerp(X, A.R, B.R));
    C.G = byte(Lerp(X, A.G, B.G));
    C.B = byte(Lerp(X, A.B, B.B));
    C.A = byte(Lerp(X, A.A, B.A));

    return C;
}

// Given a string eg. #ffba23, will return the color (R=255,G=181,B=35)
final static function Color FromHex(string S)
{
    local Color C;

    C.A = 255;

    class'UInteger'.static.ToBytes(class'UInteger'.static.FromHex(S), C.B, C.G, C.R);

    return C;
}

final static function Color HSV2RGB(HSV HSV)
{
    local int i;
    local float P, Q, T, FF;
    local Color RGB;

    if (HSV.S <= 0.0)
    {
        RGB.R = HSV.V * 255;
        RGB.G = HSV.V * 255;
        RGB.B = HSV.V * 255;
        return RGB;
    }

    if (HSV.H >= 360.0)
    {
        HSV.H = 0.0;
    }

    HSV.H /= 60.0;
    i = HSV.H;
    FF = HSV.H - i;
    P = HSV.V * (1.0 - HSV.S);
    Q = HSV.V * (1.0 - (HSV.S * FF));
    T = HSV.V * (1.0 - (HSV.S * (1.0 - FF)));

    switch(i) {
    case 0:
        RGB.R = HSV.V * 255;
        RGB.G = T * 255;
        RGB.B = P * 255;
        break;
    case 1:
        RGB.R = Q * 255;
        RGB.G = HSV.V * 255;
        RGB.B = P * 255;
        break;
    case 2:
        RGB.R = P * 255;
        RGB.G = HSV.V * 255;
        RGB.B = T * 255;
        break;

    case 3:
        RGB.R = P * 255;
        RGB.G = Q * 255;
        RGB.B = HSV.V * 255;
        break;
    case 4:
        RGB.R = T * 255;
        RGB.G = P * 255;
        RGB.B = HSV.V * 255;
        break;
    case 5:
    default:
        RGB.R = HSV.V * 255;
        RGB.G = P * 255;
        RGB.B = Q * 255;
        break;
    }

    return RGB;
}

// http://www.javascripter.net/faq/rgb2hsv.htm
final static function HSV RGB2HSV(Color RGB)
{
    local float R, G, B, MinRGB, MaxRGB, D, H;
    local HSV HSV;

    R = float(RGB.R) / 255;
    G = float(RGB.G) / 255;
    B = float(RGB.B) / 255;

    MinRGB = FMin(R, FMin(G, B));
    MaxRGB = FMax(R, FMax(G, B));

    if (MinRGB == MaxRGB)
    {
        HSV.V = MinRGB;
        return HSV;
    }

    if (R == MinRGB)
    {
        D = G - B;
    }
    else if (B == MinRGB)
    {
        D = R - G;
    }
    else
    {
        D = B - R;
    }

    if (R == MinRGB)
    {
        H = 3;
    }
    else if (B == MinRGB)
    {
        H = 1;
    }
    else
    {
        H = 5;
    }

    HSV.H = 60.0 * (H - D / (MaxRGB - MinRGB));
    HSV.S = (MaxRGB - MinRGB) / MaxRGB;
    HSV.V = MaxRGB;
    return HSV;
}

defaultproperties
{
    AliceBlue=(R=240,G=248,B=255,A=255)
    AntiqueWhite=(R=250,G=235,B=215,A=255)
    Aqua=(R=0,G=255,B=255,A=255)
    Aquamarine=(R=127,G=255,B=212,A=255)
    Azure=(R=240,G=255,B=255,A=255)
    Beige=(R=245,G=245,B=220,A=255)
    Bisque=(R=255,G=228,B=196,A=255)
    Black=(R=0,G=0,B=0,A=255)
    BlanchedAlmond=(R=255,G=255,B=205,A=255)
    Blue=(R=0,G=0,B=255,A=255)
    BlueViolet=(R=138,G=43,B=226,A=255)
    Brown=(R=165,G=42,B=42,A=255)
    BurlyWood=(R=222,G=184,B=135,A=255)
    CadetBlue=(R=95,G=158,B=160,A=255)
    Chartreuse=(R=127,G=255,B=0,A=255)
    Chocolate=(R=210,G=105,B=30,A=255)
    Coral=(R=255,G=127,B=80,A=255)
    CornflowerBlue=(R=100,G=149,B=237,A=255)
    Cornsilk=(R=255,G=248,B=220,A=255)
    Crimson=(R=220,G=20,B=60,A=255)
    Cyan=(R=0,G=255,B=255,A=255)
    DarkBlue=(R=0,G=0,B=139,A=255)
    DarkCyan=(R=0,G=139,B=139,A=255)
    DarkGoldenrod=(R=184,G=134,B=11,A=255)
    DarkGray=(R=169,G=169,B=169,A=255)
    DarkGreen=(R=0,G=100,B=0,A=255)
    DarkKhaki=(R=189,G=183,B=107,A=255)
    DarkMagena=(R=139,G=0,B=139,A=255)
    DarkOliveGreen=(R=85,G=107,B=47,A=255)
    DarkOrange=(R=255,G=140,B=0,A=255)
    DarkOrchid=(R=153,G=50,B=204,A=255)
    DarkRed=(R=139,G=0,B=0,A=255)
    DarkSalmon=(R=233,G=150,B=122,A=255)
    DarkSeaGreen=(R=143,G=188,B=143,A=255)
    DarkSlateBlue=(R=72,G=61,B=139,A=255)
    DarkSlateGray=(R=40,G=79,B=79,A=255)
    DarkTurquoise=(R=0,G=206,B=209,A=255)
    DarkViolet=(R=148,G=0,B=211,A=255)
    DeepPink=(R=255,G=20,B=147,A=255)
    DeepSkyBlue=(R=0,G=191,B=255,A=255)
    DimGray=(R=105,G=105,B=105,A=255)
    DodgerBlue=(R=30,G=144,B=255,A=255)
    Firebrick=(R=178,G=34,B=34,A=255)
    FloralWhite=(R=255,G=250,B=240,A=255)
    ForestGreen=(R=34,G=139,B=34,A=255)
    Fuschia=(R=255,G=0,B=255,A=255)
    Gainsboro=(R=220,G=220,B=220,A=255)
    GhostWhite=(R=248,G=248,B=255,A=255)
    Gold=(R=255,G=215,B=0,A=255)
    Goldenrod=(R=218,G=165,B=32,A=255)
    Gray=(R=128,G=128,B=128,A=255)
    Green=(R=0,G=128,B=0,A=255)
    GreenYellow=(R=173,G=255,B=47,A=255)
    Honeydew=(R=240,G=255,B=240,A=255)
    HotPink=(R=255,G=105,B=180,A=255)
    IndianRed=(R=205,G=92,B=92,A=255)
    Indigo=(R=75,G=0,B=130,A=255)
    Ivory=(R=255,G=240,B=240,A=255)
    Khaki=(R=240,G=230,B=140,A=255)
    Lavender=(R=230,G=230,B=250,A=255)
    LavenderBlush=(R=255,G=240,B=245,A=255)
    LawnGreen=(R=124,G=252,B=0,A=255)
    LemonChiffon=(R=255,G=250,B=205,A=255)
    LightBlue=(R=173,G=216,B=230,A=255)
    LightCoral=(R=240,G=128,B=128,A=255)
    LightCyan=(R=224,G=255,B=255,A=255)
    LightGoldenrodYellow=(R=250,G=250,B=210,A=255)
    LightGray=(R=211,G=211,B=211,A=255)
    LightGreen=(R=144,G=238,B=144,A=255)
    LightPink=(R=255,G=182,B=193,A=255)
    LightSalmon=(R=255,G=160,B=122,A=255)
    LightSeaGreen=(R=32,G=178,B=170,A=255)
    LightSkyBlue=(R=135,G=206,B=250,A=255)
    LightSlateGray=(R=119,G=136,B=153,A=255)
    LightSteelBlue=(R=176,G=196,B=222,A=255)
    LightYellow=(R=255,G=255,B=224,A=255)
    Lime=(R=0,G=255,B=0,A=255)
    LimeGreen=(R=50,G=205,B=50,A=255)
    Linen=(R=250,G=240,B=230,A=255)
    Magenta=(R=255,G=0,B=255,A=255)
    Maroon=(R=128,G=0,B=0,A=255)
    MediumAquamarine=(R=102,G=205,B=170,A=255)
    MediumBlue=(R=0,G=0,B=205,A=255)
    MediumOrchid=(R=186,G=85,B=211,A=255)
    MediumPurple=(R=147,G=112,B=219,A=255)
    MediumSeaGreen=(R=60,G=179,B=113,A=255)
    MediumSlateBlue=(R=123,G=104,B=238,A=255)
    MediumSpringGreen=(R=0,G=250,B=154,A=255)
    MediumTurquoise=(R=72,G=209,B=204,A=255)
    MediumVioletRed=(R=199,G=21,B=112,A=255)
    MidnightBlue=(R=25,G=25,B=112,A=255)
    MintCream=(R=245,G=255,B=250,A=255)
    MistyRose=(R=255,G=228,B=225,A=255)
    Moccasin=(R=255,G=228,B=181,A=255)
    NavajoWhite=(R=255,G=222,B=173,A=255)
    Navy=(R=0,G=0,B=128,A=255)
    OldLace=(R=253,G=245,B=230,A=255)
    Olive=(R=128,G=128,B=0,A=255)
    OliveDrab=(R=107,G=142,B=45,A=255)
    Orange=(R=255,G=165,B=0,A=255)
    OrangeRed=(R=255,G=69,B=0,A=255)
    Orchid=(R=218,G=112,B=214,A=255)
    PaleGoldenrod=(R=238,G=232,B=170,A=255)
    PaleGreen=(R=152,G=251,B=152,A=255)
    PaleTurquoise=(R=175,G=238,B=238,A=255)
    PaleVioletRed=(R=219,G=112,B=147,A=255)
    PapayaWhip=(R=255,G=239,B=213,A=255)
    PeachPuff=(R=255,G=218,B=155,A=255)
    Peru=(R=205,G=133,B=63,A=255)
    Pink=(R=255,G=192,B=203,A=255)
    Plum=(R=221,G=160,B=221,A=255)
    PowderBlue=(R=176,G=224,B=230,A=255)
    Purple=(R=128,G=0,B=128,A=255)
    Red=(R=255,G=0,B=0,A=255)
    RosyBrown=(R=188,G=143,B=143,A=255)
    RoyalBlue=(R=65,G=105,B=225,A=255)
    SaddleBrown=(R=139,G=69,B=19,A=255)
    Salmon=(R=250,G=128,B=114,A=255)
    SandyBrown=(R=244,G=164,B=96,A=255)
    SeaGreen=(R=46,G=139,B=87,A=255)
    Seashell=(R=255,G=245,B=238,A=255)
    Sienna=(R=160,G=82,B=45,A=255)
    Silver=(R=192,G=192,B=192,A=255)
    SkyBlue=(R=135,G=206,B=235,A=255)
    SlateBlue=(R=106,G=90,B=205,A=255)
    SlateGray=(R=112,G=128,B=144,A=255)
    Snow=(R=255,G=250,B=250,A=255)
    SpringGreen=(R=0,G=255,B=127,A=255)
    SteelBlue=(R=70,G=130,B=180,A=255)
    Tan_=(R=210,G=180,B=140,A=255)
    Teal=(R=0,G=128,B=128,A=255)
    Thistle=(R=216,G=191,B=216,A=255)
    Tomato=(R=253,G=99,B=71,A=255)
    Turquoise=(R=64,G=224,B=208,A=255)
    Violet=(R=238,G=130,B=238,A=255)
    Wheat=(R=245,G=222,B=179,A=255)
    White=(R=255,G=255,B=255,A=255)
    WhiteSmoke=(R=245,G=245,B=245,A=255)
    Yellow=(R=255,G=255,B=0,A=255)
    YellowGreen=(R=154,G=205,B=50,A=255)
}
