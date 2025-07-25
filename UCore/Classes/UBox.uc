//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class UBox extends Object
    abstract;

final static function Box Create(Vector Origin, float Extents)
{
    local Box Box;

    Box.Min.X = Origin.X - (Extents * 0.5);
    Box.Min.Y = Origin.Y - (Extents * 0.5);
    Box.Max.X = Origin.X + (Extents * 0.5);
    Box.Max.Y = Origin.Y + (Extents * 0.5);

    return Box;
}

final static function Vector Center(Box B)
{
    return B.Min + ((B.Max - B.Min) / 2.0);
}

final static function Vector Extents(Box B)
{
    return B.Max - B.Min;
}

final static function Box Translate(Box B, Vector V)
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

static function Box Scale(Box B, Vector Origin, float Scale)
{
    B = Translate(B, -Origin);
    B.Min *= Scale;
    B.Max *= Scale;
    B = Translate(B, Origin);
    return B;
}

