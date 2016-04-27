//==============================================================================
// Darklight Games (c) 2008-2016
//==============================================================================
// Since array types are copied when passed to these functions using these
// functions is not recommended on large datasets.
//==============================================================================
class UArray extends Object
    abstract;

static final function Reverse(out array<Object> A)
{
    local int i;

    for (i = 0; i < (A.Length - 1) / 2; ++i)
    {
        class'UCore'.static.Swap(A[i], A[A.Length - 1 - i]);
    }
}

static final function IReverse(out array<int> A)
{
    local int i;

    for (i = 0; i < (A.Length - 1) / 2; ++i)
    {
        class'UCore'.static.ISwap(A[i], A[A.Length - 1 - i]);
    }
}

static final function FisherYatesShuffle(out array<Object> _Array)
{
    local int i, j;

    for (i = _Array.Length - 1; i >= 0; --i)
    {
        j = Rand(i);

        class'UCore'.static.Swap(_Array[i], _Array[j]);
    }
}

static final function IFisherYatesShuffle(out array<int> _Array)
{
    local int i, j;

    for (i = _Array.Length - 1; i >= 0; --i)
    {
        j = Rand(i);

        class'UCore'.static.ISwap(_Array[i], _Array[j]);
    }
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

static final function int SIndexOf(array<string> _Array, string O)
{
    local int i;

    for (i = 0; i < _Array.Length; ++i)
    {
        if (_Array[i] ~= O)
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

static final function int SErase(out array<string> _Array, string O)
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
