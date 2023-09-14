//==============================================================================
// Darklight Games (c) 2008-2023
//==============================================================================

class UString extends Object;

var string Value;

final static function UString Create(optional string Value)
{
    local UString S;

    S = new class'UString';
    S.Value = Value;

    return S;
}

final static function string Join(string Divider, array<string> Strings)
{
    local string S;
    local int i;

    if (Strings.Length == 0)
    {
        return S;
    }

    S $= Strings[0];

    for (i = 1; i < Strings.Length; ++i)
    {
        S $= Divider $ Strings[i];
    }

    return S;
}

final static function int FindLastOf(string Haystack, string Needle)
{
    local int i, j;

    if (Len(Needle) > Len(Haystack))
    {
        return -1;
    }

    for (i = Len(Haystack) - 1; i >= 0; --i)
    {
        if (Mid(Haystack, i, 1) == Mid(Needle, Len(Needle) - 1 - j, 1))
        {
            ++j;
        }
        else
        {
            j = 0;
        }

        if (j == Len(Needle))
        {
            return i;
        }
    }

    return -1;
}

final static function string Remove(string S, int Offset, int Count)
{
    return Mid(S, 0, Offset) $ Mid(S, Offset + Count);
}

final static function string Insert(string Dst, string Src, int Offset)
{
    return Left(Dst, Offset) $ Src $ Mid(Dst, Offset, Len(Dst));
}

final static function array<int> ToBytes(string S)
{
    local int i;
    local array<int> Bytes;

    for (i = 0; i < Len(S); ++i)
    {
        Bytes[i] = Asc(Mid(S, i, 1));
    }

    return Bytes;
}

final static function string FromBytes(array<int> Bytes)
{
    local int i;
    local string S;

    for (i = 0; i < Bytes.Length; ++i)
    {
        S $= Chr(Bytes[i]);
    }

    return S;
}

final static function bool IsWhitespace(string S)
{
    local int A;

    A = Asc(S);

    return (A >= 0x0009 && A <= 0x000D) || (A == 0x0020 || A == 0x1680) ||
           (A >= 0x2000 && A <= 0x200A) || (A >= 0x2028 && A <= 0x2029) ||
           (A == 0x202F || A == 0x205F  || A == 0x3000  || A == 0x180E ||
            A == 0x200B || A == 0x200C  || A == 0x200D  || A == 0x2060 ||
            A == 0xFEFF);
}

final static function bool IsAlpha(string S)
{
    local int A;

    A = Asc(S);

    return (A >= 0x41 && A <= 0x5A) || (A >= 0x61 && A <= 0x7A);
}

final static function bool IsDigit(string S)
{
    local int A;

    A = Asc(S);

    return A >= 0x30 && A <= 0x39;
}

final static function bool IsAlphanumeric(string S)
{
    return IsAlpha(S) || IsDigit(S);
}

final static function string Trim(string S)
{
    local int i, j;

    // Get the index of the first non-whitespace character.
    for (i = 0; i < Len(S); ++i)
    {
        if (!IsWhitespace(Mid(S, i, 1)))
        {
            break;
        }
    }

    // Get the index of the last non-whitespace character.
    for (j = Len(S) - 1; j > i; --j)
    {
        if (!IsWhitespace(Mid(S, j, 1)))
        {
            break;
        }
    }

    return Mid(S, i, j - i + 1);
}

final static function string ZFill(coerce string S, int N)
{
    N -= Len(S);

    while (N-- > 0)
    {
        S = "0" $ S;
    }

    return S;
}

final static function string CRLF()
{
    return Chr(13) $ Chr(10);
}

// This is essentially a redeclaration of the same function found in GameInfo.
// Unfortunately, that function is not static, which is why this one is
// necessary.
final static function string StripColor(string S)
{
    local int i;

    i = InStr(S, Chr(27));

    while (i >= 0)
    {
        S = Left(S, i) $ Mid(S, i + 4);
        i = InStr(S, Chr(27));
    }

    return S;
}

