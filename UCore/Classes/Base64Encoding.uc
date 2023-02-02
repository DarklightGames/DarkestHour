//==============================================================================
// Darklight Games (c) 2008-2023
//==============================================================================
// Base64 is a group of similar binary-to-text encoding schemes that represent
// binary data in an ASCII string format by translating it into a radix-64
// representation. The term Base64 originates from a specific MIME content
// transfer encoding.
//==============================================================================

class Base64Encoding extends Object
    abstract;

var private string Codes;
var private TreeMap_string_int CodeIndices;

final static function CreateCodeIndices()
{
    local int i;

    default.CodeIndices = new class'TreeMap_string_int';

    for (i = 0; i < Len(default.Codes); ++i)
    {
        default.CodeIndices.Put(Mid(default.Codes, i, 1), i);
    }
}

final static function array<byte> Decode(string S)
{
    local int i, j, b[4];
    local int Length, FirstPadIndex;
    local array<byte> Bytes;

    if (default.CodeIndices == none)
    {
        CreateCodeIndices();
    }

    if (Len(S) % 4 != 0)
    {
        return Bytes;
    }

    Length = (Len(S) * 3) / 4;

    FirstPadIndex = InStr(S, "=");

    if (FirstPadIndex > 0)
    {
        Length -= Len(S) - FirstPadIndex;
    }

    Bytes.Length = Length;

    for (i = 0; i < Len(S); i += 4)
    {
        default.CodeIndices.Get(Mid(S, i + 0, 1), b[0]);
        default.CodeIndices.Get(Mid(S, i + 1, 1), b[1]);
        default.CodeIndices.Get(Mid(S, i + 2, 1), b[2]);
        default.CodeIndices.Get(Mid(S, i + 3, 1), b[3]);

        Bytes[j++] = byte((b[0] << 2) | (b[1] >> 4));

        if (b[2] < 64)
        {
            Bytes[j++] = byte((b[1] << 4) | (b[2] >> 2));

            if (b[3] < 64)
            {
                Bytes[j++] = byte((b[2] << 6) | b[3]);
            }
        }
    }

    return Bytes;
}

final static function string Encode(array<byte> Bytes)
{
    local int b, i;
    local string S;

    for (i = 0; i < Bytes.length; i += 3)
    {
        b = (Bytes[i] & 0xFC) >> 2;

        S $= Mid(default.Codes, b, 1);

        b = (Bytes[i] & 0x03) << 4;

        if (i + 1 < Bytes.Length)
        {
            b = b | ((Bytes[i + 1] & 0xF0) >> 4);

            S $= Mid(default.Codes, b, 1);

            b = (Bytes[i + 1] & 0x0F) << 2;

            if (i + 2 < Bytes.Length)
            {
                b = b | ((Bytes[i + 2] & 0xC0) >> 6);

                S $= Mid(default.Codes, b, 1);

                b = Bytes[i + 2] & 0x3F;

                S $= Mid(default.Codes, b, 1);
            }
            else
            {
                S $= Mid(default.Codes, b, 1) $ "=";
            }
        }
        else
        {
            S $= Mid(default.Codes, b, 1) $ "==";
        }
    }

    return S;
}

defaultproperties
{
    Codes = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
}
