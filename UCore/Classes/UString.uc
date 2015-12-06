//==============================================================================
// UCore
// Darklight Games (c) 2008-2015
//==============================================================================

class UString extends Object
    abstract;

static final function string Join(string Divider, array<string> Strings)
{
    local string S;
    local int i;

    for (i = 0; i < Strings.Length; ++i)
    {
        S $= Strings[i];

        if (i != Strings.Length - 1)
        {
            S $= Divider;
        }
    }

    return S;
}

static final function string Remove(string S, int Offset, int Count)
{
    return Mid(S, 0, Offset) $ Mid(S, Offset + Count);
}

static final function string Insert(string Dst, string Src, int Offset)
{
    return Left(Dst, Offset) $ Src $ Mid(Dst, Offset, Len(Dst));
}
