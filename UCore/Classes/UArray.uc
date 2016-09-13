//==============================================================================
// Darklight Games (c) 2008-2016
//==============================================================================
// Since array types are copied when passed to these functions, frequent use of
// these functions is not recommended on large datasets.
//==============================================================================

class UArray extends Object
    abstract;

// https://en.wikipedia.org/wiki/Filter_(higher-order_function)
static final function array<Object> Filter(array<Object> A, Functor_bool_Object FilterFunction)
{
    local int i;
    local array<Object> B;

    for (i = 0; i < A.Length; ++i)
    {
        if (FilterFunction.DelegateFunction(A[i]))
        {
            B[B.Length] = A[i];
        }
    }

    return B;
}

// https://en.wikipedia.org/wiki/Map_(higher-order_function)
static final function array<Object> Map(array<Object> A, Functor_Object_Object MapFunction)
{
    local int i;
    local array<Object> B;

    for (i = 0; i < A.Length; ++i)
    {
        B[B.Length] = MapFunction.DelegateFunction(A[i]);
    }

    return B;
}

// Slice tries to immitate Python's slice syntax.
static final function array<Object> Slice(array<Object> A, int Start, int End, int Step)
{
    local int i;
    local array<Object> B;

    if (Step <= 0)
    {
        Warn("Slice step must be a positive integer.");

        return B;
    }

    for (i = Start; i <= End; i += Step)
    {
        B[B.Length] = A[i];
    }

    return B;
}

static final function array<int> ISlice(array<int> A, int Start, int End, int Step)
{
    local int i;
    local array<int> B;

    if (Step <= 0)
    {
        Warn("Slice step must be a positive integer.");

        return B;
    }

    for (i = Start; i <= End; i += Step)
    {
        B[B.Length] = A[i];
    }

    return B;
}

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

static final function Shuffle(out array<Object> _Array)
{
    local int i, j;

    for (i = _Array.Length - 1; i >= 0; --i)
    {
        j = Rand(i);

        class'UCore'.static.Swap(_Array[i], _Array[j]);
    }
}

static final function IShuffle(out array<int> _Array)
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

static final function array<string> ToStringArray(array<Object> A)
{
    local int i;
    local array<string> Strings;

    for (i = 0; i < A.Length; ++i)
    {
        Strings[i] = string(A[i]);
    }

    return Strings;
}

static final function string ToString(array<Object> A)
{
    return "[" $ class'UString'.static.Join(", ", ToStringArray(A)) $ "]";
}

static final function array<string> IToStringArray(array<int> A)
{
    local int i;
    local array<string> Strings;

    for (i = 0; i < A.Length; ++i)
    {
        Strings[i] = string(A[i]);
    }

    return Strings;
}

static final function string IToString(array<int> A)
{
    return "[" $ class'UString'.static.Join(", ", IToStringArray(A)) $ "]";
}

static final function array<string> FToStringArray(array<float> A)
{
    local int i;
    local array<string> Strings;

    for (i = 0; i < A.Length; ++i)
    {
        Strings[i] = string(A[i]);
    }

    return Strings;
}

static final function string FToString(array<float> A)
{
    return "[" $ class'UString'.static.Join(", ", FToStringArray(A)) $ "]";
}

static final function string SToString(array<string> A)
{
    local int i;

    // Escape double-quote (") characters.
    for (i = 0; i < A.Length; ++i)
    {
        A[i] = Repl(A[i], "\"", "\\\"");
    }

    return "[" $ class'UString'.static.Join(", ", A) $ "]";
}

static final function array<int> Range(int Min, int Max)
{
    local array<int> A;

    while (Min <= Max)
    {
        A[A.Length] = Min++;
    }

    return A;
}
