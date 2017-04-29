//==============================================================================
// Darklight Games (c) 2008-2016
//==============================================================================

class UFloat extends Object;

var float Value;

static final function UFloat Create(optional float Value)
{
    local UFloat F;

    F = new class'UFloat';
    F.Value = Value;

    return F;
}

static final function float Infinity()
{
    return 1.0 / 0.0;
}

static final function float MaxValue()
{
    return 3.40282347E+38f;
}

static final function float MinValue()
{
    return -3.40282347E+38f;
}

static final function float Epsilon()
{
    return 1.401298E-45f;
}

