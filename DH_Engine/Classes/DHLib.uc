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

        Swap(_Array[i], _Array[j]);
    }
}

static final function Swap(out int A, out int B)
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
    local float T;

    T = A.X;
    A.X = B.X;
    B.X = T;

    T = A.Y;
    A.Y = B.Y;
    B.Y = T;

    T = A.Z;
    A.Z = B.Z;
    B.Z = T;
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

static final function bool Contains(array<Object> _Array, Object O)
{
    return IndexOf(_Array, O) >= 0;
}

static final function int Erase(out array<Object> _Array, Object O)
{
    local int i;

    i = IndexOf(_Array, O);

    if (i >= 0)
    {
        _Array.Remove(i, 1);

        return 1;
    }

    return 0;
}
