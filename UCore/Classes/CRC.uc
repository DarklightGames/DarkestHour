//==============================================================================
// Darklight Games (c) 2008-2016
//==============================================================================
// Implementation based on crc32c function:
// http://www.hackersdelight.org/hdcodetxt/crc.c.txt
//==============================================================================

class CRC extends Object
    abstract;

private var int Table[256];

static final function int CRC(array<byte> Bytes)
{
    local int i, j, CRC;

    if (default.Table[0] == 0)
    {
        for (i = 0; i <= 255; ++i)
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

    for (i = 0; i  < Bytes.Length; ++i)
    {
        CRC = (CRC >> 8) ^ Table[(CRC ^ Bytes[i]) & 0xFF];
    }

    return ~CRC;
}