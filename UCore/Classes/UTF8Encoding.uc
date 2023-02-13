//==============================================================================
// Darklight Games (c) 2008-2023
//==============================================================================
// http://clang.llvm.org/doxygen/ConvertUTF_8c_source.html
//==============================================================================

class UTF8Encoding extends Object
    abstract;

const BYTE_MASK = 0xBF;
const BYTE_MARK = 0x80;

final static function array<int> ToBytes(string S)
{
    local int i, j, c, BytesToWrite;
    local array<int> UTF32Bytes;
    local array<int> UTF8Bytes;

    UTF32Bytes = class'UString'.static.ToBytes(S);

    for (i = 0; i < UTF32Bytes.Length; ++i)
    {
        c = UTF32Bytes[i];

        if (c < 0x80)
        {
            BytesToWrite = 1;
        }
        else if (c < 0x800)
        {
            BytesToWrite = 2;
        }
        else if (c < 0x10000)
        {
            BytesToWrite = 3;
        }
        else if (c <= 0x10FFFF)
        {
            BytesToWrite = 4;
        }
        else
        {
            BytesToWrite = 3;
            c = 0xFFFD;
        }

        j += BytesToWrite;

        switch (BytesToWrite)
        {
            case 4:
                UTF8Bytes[--j] = ((c | BYTE_MARK) & BYTE_MASK) & 0xFF;
                c = c >> 6;
            case 3:
                UTF8Bytes[--j] = ((c | BYTE_MARK) & BYTE_MASK) & 0xFF;
                c = c >> 6;
            case 2:
                UTF8Bytes[--j] = ((c | BYTE_MARK) & BYTE_MASK) & 0xFF;
                c = c >> 6;
            case 1:
                UTF8Bytes[--j] = (c | GetFirstByteMark(BytesToWrite)) & 0xFF;
        }

        j += BytesToWrite;
    }

    return UTF8Bytes;
}

final static function string FromBytes(array<int> Bytes)
{
    local string S;
    local int i, c, ExtraBytesToRead;

    while (i < Bytes.Length)
    {
        c = 0;
        ExtraBytesToRead = GetTrailingBytesForUTF8(Bytes[i]);

        if (ExtraBytesToRead >= (Bytes.Length - i))
        {
            Warn("Exhausted bytes in conversion");
            break;
        }

        switch (ExtraBytesToRead)
        {
            case 5:
                c += Bytes[i++];
                c = c << 6;
            case 4:
                c += Bytes[i++];
                c = c << 6;
            case 3:
                c += Bytes[i++];
                c = c << 6;
            case 2:
                c += Bytes[i++];
                c = c << 6;
            case 1:
                c += Bytes[i++];
                c = c << 6;
            case 0:
                c += Bytes[i++];
        }

        S $= Chr(c);
    }

    return S;
}

final private static function int GetTrailingBytesForUTF8(int B)
{
    if (B < 0xC0)
    {
        return 0;
    }
    else if (B < 0xE0)
    {
        return 1;
    }
    else if (B < 0xF0)
    {
        return 2;
    }
    else if (B < 0xF8)
    {
        return 3;
    }
    else if (B < 0xFC)
    {
        return 4;
    }
    else
    {
        return 5;
    }
}

final private static function int GetFirstByteMark(int BytesToWrite)
{
    switch (BytesToWrite)
    {
        case 0:
        case 1:
            return 0x00;
        case 2:
            return 0xC0;
        case 3:
            return 0xE0;
        case 4:
            return 0xF0;
        case 5:
            return 0xF8;
        case 6:
            return 0xFC;
        default:
            return 0x00;
    }
}

