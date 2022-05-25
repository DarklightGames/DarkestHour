//==============================================================================
// Darklight Games (c) 2008-2022
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

static final function float RandomRange(float Min, float Max)
{
    return Min + (FRand() * (Max - Min));
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

static final function Mod(float Dividend, float Divisor, optional out int Quotient, optional out float Remainder)
{
    Quotient = int(Dividend / Divisor);
    Remainder = Dividend % Divisor;
}

static final function string Format(float Value, int Decimals)
{
    local int Quotient;
    local float Remainder;
    local string S;

    Mod(Value, 1.0f, Quotient, Remainder);

    if (Decimals == 0)
    {
        return string(int(Value));
    }

    S = string(Quotient) $ "." $ string(int(Remainder * (10 ** Decimals)));

    return S;
}

