//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHLib extends Object
    abstract;

static final function FisherYatesShuffle(out array<int> _Array)
{
    local int i, j;

    for (i = _Array.Length - 1; i >= 0; --i)
    {
        j = Rand(i);

        ISwap(_Array[i], _Array[j]);
    }
}

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

static final function int IndexOf(array<Object> _Array, Object O)
{
    local int i;

    for (i = 0; i < _Array.Length; ++i)
    {
        if (_Array[i] == O)
        {
            return i;
        }
    }

    return -1;
}

static final function int Erase(out array<Object> _Array, Object O)
{
    local int i, j;

    j = -1;

    for (i = 0; i < _Array.Length; ++i)
    {
        if (_Array[i] == O)
        {
            j = i;

            break;
        }
    }

    if (j >= 0)
    {
        _Array.Remove(j, 1);

        return 1;
    }

    return 0;
}
