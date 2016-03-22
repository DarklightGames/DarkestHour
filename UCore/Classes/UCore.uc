//==============================================================================
// Darklight Games (c) 2008-2015
//==============================================================================

class UCore extends Object;

static final function Swap(out Object A, out Object B)
{
    local Object T;

    T = A;
    A = B;
    B = T;
}

static final function ISwap(out int A, out int B)
{
    local int T;

    T = A;
    A = B;
    B = T;
}

static final function FSwap(out float A, out float B)
{
    local float T;

    T = A;
    A = B;
    B = T;
}

static final function VSwap(out vector A, out vector B)
{
    FSwap(A.X, B.X);
    FSwap(A.Y, B.Y);
    FSwap(A.Z, B.Z);
}

static final function vector VReflect(vector V, vector N)
{
    return V - (N * 2.0 * (V dot N));
}

static final function vector VHalf(vector A, vector B)
{
    return (A + B) / VSize(A + B);
}

static final function vector VClamp(vector V, vector A, vector B)
{
    local vector R;

    R.X = FClamp(V.X, A.X, B.X);
    R.Y = FClamp(V.Y, A.Y, B.Y);
    R.Z = FClamp(V.Z, A.Z, B.Z);

    return R;
}

static final function int Hex2Int(string S)
{
    local int i, j, R;
    local int Factor;

    Factor = 1;

    S = Caps(S);

    for (i = Len(S) - 1; i >= 0; --i)
    {
        j = Asc(Mid(S, i, 1));

        if (j >= 0x30 && j <= 0x39)
        {
            R += int(Mid(S, i, 1)) * Factor;
        }
        else if (j >= 0x41 && j <= 0x46)
        {
            R += (10 + (j - 0x41)) * Factor;
        }
        else if (j == 0x58)
        {
            break;
        }

        Factor *= 16;
    }

    return R;
}

