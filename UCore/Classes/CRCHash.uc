//==============================================================================
// Darklight Games (c) 2008-2023
//==============================================================================
// Implementation based on crc32c function:
// http://www.hackersdelight.org/hdcodetxt/crc.c.txt
//==============================================================================

class CRCHash extends Object
    abstract;

var private int Table[256];

final static function int FromString(string S)
{
    return FromBytes(class'UString'.static.ToBytes(S));
}

final static function int FromBytes(array<int> Bytes)
{
    local int i, j, Mask, CRC;

    if (default.Table[0] == 0)
    {
        for (i = 0; i < 256; ++i)
        {
            CRC = i;

            for (j = 7; j >= 0; --j)
            {
                Mask = -(CRC & 1);
                CRC = (CRC >> 1) ^ (0xEDB88320 & Mask);
            }

            default.Table[i] = CRC;
        }
    }

    CRC = 0xFFFFFFFF;

    for (i = 0; i < Bytes.Length; ++i)
    {
        CRC = (CRC >> 8) ^ default.Table[(CRC ^ Bytes[i]) & 0xFF];
    }

    return ~CRC;
}

