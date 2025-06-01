//==============================================================================
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class UCore extends Object;

final static function Swap(out Object A, out Object B)
{
    local Object T;

    T = A;
    A = B;
    B = T;
}

final static function ISwap(out int A, out int B)
{
    local int T;

    T = A;
    A = B;
    B = T;
}

final static function FSwap(out float A, out float B)
{
    local float T;

    T = A;
    A = B;
    B = T;
}

final static function VSwap(out Vector A, out Vector B)
{
    FSwap(A.X, B.X);
    FSwap(A.Y, B.Y);
    FSwap(A.Z, B.Z);
}

final static function SSwap(out string A, out string B)
{
    local string T;

    T = A;
    A = B;
    B = T;
}

final static function Vector VReflect(Vector V, Vector N)
{
    return V - (N * 2.0 * (V dot N));
}

final static function Vector VHalf(Vector A, Vector B)
{
    return (A + B) / VSize(A + B);
}

final static function Vector VClamp(Vector V, Vector A, Vector B)
{
    local Vector R;

    R.X = FClamp(V.X, A.X, B.X);
    R.Y = FClamp(V.Y, A.Y, B.Y);
    R.Z = FClamp(V.Z, A.Z, B.Z);

    return R;
}

final static function Vector VClampSize(Vector V, float Min, float Max)
{
    // Avoid divide-by-zero error.
    if (V == vect(0, 0, 0))
    {
        return V;
    }

    return Normal(V) * FClamp(VSize(V), Min, Max);
}

