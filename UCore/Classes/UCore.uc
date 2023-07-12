//==============================================================================
// Darklight Games (c) 2008-2023
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

final static function VSwap(out vector A, out vector B)
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

final static function vector VReflect(vector V, vector N)
{
    return V - (N * 2.0 * (V dot N));
}

final static function vector VHalf(vector A, vector B)
{
    return (A + B) / VSize(A + B);
}

final static function vector VClamp(vector V, vector A, vector B)
{
    local vector R;

    R.X = FClamp(V.X, A.X, B.X);
    R.Y = FClamp(V.Y, A.Y, B.Y);
    R.Z = FClamp(V.Z, A.Z, B.Z);

    return R;
}

final static function vector VClampSize(vector V, float Min, float Max)
{
    // Avoid divide-by-zero error.
    if (V == vect(0, 0, 0))
    {
        return V;
    }

    return Normal(V) * FClamp(VSize(V), Min, Max);
}

