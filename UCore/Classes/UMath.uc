//==============================================================================
// Darklight Games (c) 2008-2021
//==============================================================================

class UMath extends Object
    abstract;

static final function int Sign(int I)
{
    if (I >= 0.0)
    {
        return 1;
    }

    return -1;
}

static final function float FSign(float F)
{
    if (F >= 0.0)
    {
        return 1.0;
    }

    return -1.0;
}

// Swaps 0 and 1
static final function byte SwapFirstPair(byte Num)
{
    if (Num < 2)
    {
        return Num ^ 1;
    }

    return Num;
}
