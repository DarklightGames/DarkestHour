//==============================================================================
// Darklight Games (c) 2008-2017
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
