//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class UVector extends Object
    abstract;

static final function vector RandomRange(rangevector Range)
{
    local vector V;

    V.X = class'UFloat'.static.RandomRange(Range.X.Min, Range.X.Max);
    V.Y = class'UFloat'.static.RandomRange(Range.Y.Min, Range.Y.Max);
    V.Z = class'UFloat'.static.RandomRange(Range.Z.Min, Range.Z.Max);

    return V;
}

static final function float MaxElement(vector V)
{
    return FMax(V.X, FMax(V.Y, V.Z));
}

static final function float MinElement(vector V)
{
    return FMin(V.X, FMin(V.Y, V.Z));
}

static final function vector VLerp(float T, vector Start, vector End)
{
    return Start + ((End - Start) * T);
}

