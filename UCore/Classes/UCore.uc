//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class UCore extends Object;

static function int Hex2Int(string S)
{
    local int i, j, R;
    local int Factor;

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

