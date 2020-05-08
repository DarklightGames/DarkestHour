//==============================================================================
// Darklight Games (c) 2008-2019
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

// Normal integer division in UnrealScript (truncated division) does this:
// 1/2      = 0, 3/2     = 1, -1/2   = 0, -3/2   = -1
// This functions (floored divion) does this:
// 1/2      = 0, 3/2     = 1, -1/2  = -1, -3/2   = -2
// See more on https://en.wikipedia.org/wiki/Modulo_operation
static final function int FlooredDivision(float Value, float Divisor)
{
    if(Value%Divisor < 0)
        return int((Value - Divisor) / Divisor);
    return int(Value/Divisor);
}


static final function int Floor(float Value, float Divisor)
{
    if(Value%Divisor < 0)
        return int(Value - (Divisor + Value%Divisor));
    return int(Value - Value%Divisor);
}
        