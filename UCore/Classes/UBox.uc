//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class UBox extends Object
    abstract;

final static function Box Create(vector Origin, float Extents)
{
    local Box Box;

    Box.Min.X = Origin.X - (Extents * 0.5);
    Box.Min.Y = Origin.Y - (Extents * 0.5);
    Box.Max.X = Origin.X + (Extents * 0.5);
    Box.Max.Y = Origin.Y + (Extents * 0.5);

    return Box;
}

final static function vector Center(Box B)
{
    return B.Min + ((B.Max - B.Min) / 2.0);
}

final static function vector Extents(Box B)
{
    return B.Max - B.Min;
}

final static function Box Translate(Box B, vector V)
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

static function Box Scale(Box B, vector Origin, float Scale)
{
    B = Translate(B, -Origin);
    B.Min *= Scale;
    B.Max *= Scale;
    B = Translate(B, Origin);
    return B;
}

