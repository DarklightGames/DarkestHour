//==============================================================================
// Darklight Games (c) 2008-2023
//==============================================================================

class UInteger extends Object;

var int Value;

final static function UInteger Create(optional int Value)
{
    local UInteger I;

    I = new class'UInteger';
    I.Value = Value;

    return I;
}

final static function ToBytes(int Integer, optional out byte Byte1, optional out byte Byte2, optional out byte Byte3, optional out byte Byte4)
{
    Byte1 = Integer & 0xFF;
    Byte2 = (Integer >> 8) & 0xFF;
    Byte3 = (Integer >> 16) & 0xFF;
    Byte4 = (Integer >> 24) & 0xFF;
}

final static function int FromBytes(optional byte Byte1, optional byte Byte2, optional byte Byte3, optional byte Byte4)
{
    return (Byte4 << 24) | (Byte3 << 16) | (Byte2 << 8) | Byte1;
}

final static function ToShorts(int Integer, optional out int Short1, optional out int Short2)
{
    Short1 = Integer & 0xFFFF;
    Short2 = (Integer >> 16) & 0xFFFF;
}

final static function int FromShorts(optional int Short1, optional int Short2)
{
    return ((Short2 & 0xFFFF) << 16) | (Short1 & 0xFFFF);
}

final static function int FromHex(string S)
{
    local int i, j, R;
    local int Factor;

    // Remove the leading '#' character, if it exists
    if (InStr(S, "#") == 0)
    {
        S = Mid(S, 1);
    }

    Factor = 1;

    S = Caps(S);

    for (i = Len(S) - 1; i >= 0; --i)
    {
        j = Asc(Mid(S, i, 1));

        if (j >= 0x30 && j <= 0x39)
        {
            R += int(Mid(S, i, 1)) * Factor;
        }
        else if (j >= 0x41 && j <= 0x46)
        {
            R += (10 + (j - 0x41)) * Factor;
        }
        else if (j == 0x58)
        {
            break;
        }

        Factor *= 16;
    }

    return R;
}

