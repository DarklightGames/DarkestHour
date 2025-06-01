//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class UVector extends Object
    abstract;

final static function Vector RandomRange(RangeVector Range)
{
    local Vector V;

    V.X = class'UFloat'.static.RandomRange(Range.X.Min, Range.X.Max);
    V.Y = class'UFloat'.static.RandomRange(Range.Y.Min, Range.Y.Max);
    V.Z = class'UFloat'.static.RandomRange(Range.Z.Min, Range.Z.Max);

    return V;
}

final static function float MaxElement(Vector V)
{
    return FMax(V.X, FMax(V.Y, V.Z));
}

final static function float MinElement(Vector V)
{
    return FMin(V.X, FMin(V.Y, V.Z));
}

final static function Vector VLerp(float T, Vector Start, Vector End)
{
    return Start + ((End - Start) * T);
}

final static function Vector MinComponent(Vector A, Vector B)
{
    local Vector V;

    V.X = FMin(A.X, B.X);
    V.Y = FMin(A.Y, B.Y);
    V.Z = FMin(A.Z, B.Z);

    return V;
}

final static function Vector MaxComponent(Vector A, Vector B)
{
    local Vector V;

    V.X = FMax(A.X, B.X);
    V.Y = FMax(A.Y, B.Y);
    V.Z = FMax(A.Z, B.Z);

    return V;
}

final static function float SignedAngle(Vector From, Vector To, Vector PlaneNormal)
{
    return ATan((From cross To) dot PlaneNormal, From dot To);
}

static function float InverseSquareLaw(Vector PointA, Vector PointB)
{
    return 1.0 / FMax(VSizeSquared(PointA - PointB), class'UFloat'.static.Epsilon());
}

static function bool IsInsideCylinder(Vector Point, Vector BaseA, Vector BaseB, float Radius)
{
    local float D; // Distance to the cylinder axis
    local float T; // Position along the axis

    D = VSize((BaseB - BaseA) cross (BaseA - Point)) / VSize(BaseB - BaseA);
    T = ((Point - BaseA) dot (BaseB - BaseA)) / VSizeSquared(BaseB - BaseA);

    return T >= 0.0 && T <= 1.0 && D <= Radius;
}
