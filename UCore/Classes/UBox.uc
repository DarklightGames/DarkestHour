//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class UBox extends Object
    abstract;

static function vector Center(Box B)
{
    return (B.Max - B.Min) / 2.0;
}

static function vector Extents(Box B)
{
    return B.Max - B.Min;
}

static function Box Translate(Box B, vector V)
{
    local Box Result;

    Result.Min = B.Min + V;
    Result.Max = B.Max + V;

    return Result;
}

static function Box Interp(float T, Box A, Box B)
{
    local Box C;

    C.Min = A.Min + (T * (B.Min - A.Min));
    C.Max = A.Max + (T * (B.Max - A.Max));

    return C;
}
