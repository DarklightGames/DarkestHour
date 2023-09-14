//==============================================================================
// Darklight Games (c) 2008-2023
//==============================================================================
// Since array types are copied when passed to these functions, frequent use of
// these functions is not recommended on large datasets.
//==============================================================================

class UArray extends Object
    abstract;

// https://en.wikipedia.org/wiki/Filter_(higher-order_function)
final static function array<Object> Filter(array<Object> A, Functor_bool_Object FilterFunction)
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
final static function array<Object> Map(array<Object> A, Functor_Object_Object MapFunction)
{
    local int i;
    local array<Object> B;

    for (i = 0; i < A.Length; ++i)
    {
        B[B.Length] = MapFunction.DelegateFunction(A[i]);
    }

    return B;
}

// Creates a "union" of two arrays, eliminating duplicates.
function array<Object> Union(array<Object> LHS, array<Object> RHS)
{
    local int i;
    local array<Object> U;

    U = LHS;

    for (i = 0; i < RHS.Length; ++i)
    {
        if (class'UArray'.static.IndexOf(U, RHS[i]) == -1)
        {
            U[U.Length] = RHS[i];
        }
    }

    return U;
}

// Add an element if it doesn't already exist in the array. Returns true if the
// element was added.
final static function bool AddUnique(out array<Object> A, Object Other)
{
    local int i;

    for (i = 0; i < A.Length; ++i)
    {
        if (A[i] == Other)
        {
            return false;
        }
    }

    A[A.Length] = Other;

    return true;
}

// Add an element if it doesn't already exist in the array. Returns true if the
// element was added.
final static function bool IAddUnique(out array<int> A, int Other)
{
    local int i;

    for (i = 0; i < A.Length; ++i)
    {
        if (A[i] == Other)
        {
            return false;
        }
    }

    A[A.Length] = Other;

    return true;
}

// Slice tries to immitate Python's slice syntax.
final static function array<Object> Slice(array<Object> A, int Start, int End, int Step)
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

final static function array<int> ISlice(array<int> A, int Start, int End, int Step)
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

final static function Reverse(out array<Object> A)
{
    local int i;

    for (i = 0; i < (A.Length - 1) / 2; ++i)
    {
        class'UCore'.static.Swap(A[i], A[A.Length - 1 - i]);
    }
}

final static function IReverse(out array<int> A)
{
    local int i;

    for (i = 0; i < (A.Length - 1) / 2; ++i)
    {
        class'UCore'.static.ISwap(A[i], A[A.Length - 1 - i]);
    }
}

final static function Shuffle(out array<Object> _Array)
{
    local int i, j;

    for (i = _Array.Length - 1; i >= 0; --i)
    {
        j = Rand(i);

        class'UCore'.static.Swap(_Array[i], _Array[j]);
    }
}

final static function IShuffle(out array<int> _Array)
{
    local int i, j;

    for (i = _Array.Length - 1; i >= 0; --i)
    {
        j = Rand(i);

        class'UCore'.static.ISwap(_Array[i], _Array[j]);
    }
}

final static function int IndexOf(array<Object> Haystack, Object Needle)
{
    local int i;

    for (i = 0; i < Haystack.Length; ++i)
    {
        if (Haystack[i] == Needle)
        {
            return i;
        }
    }

    return -1;
}

final static function int SIndexOf(array<string> Haystack, string Needle)
{
    local int i;

    for (i = 0; i < Haystack.Length; ++i)
    {
        if (Haystack[i] ~= Needle)
        {
            return i;
        }
    }

    return -1;
}

final static function int IIndexOf(array<int> Haystack, int Needle)
{
    local int i;

    for (i = 0; i < Haystack.Length; ++i)
    {
        if (Haystack[i] == Needle)
        {
            return i;
        }
    }

    return -1;
}

final static function int Erase(out array<Object> _Array, Object O)
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

final static function int SErase(out array<string> _Array, string O)
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

final static function array<string> ToStringArray(array<Object> A)
{
    local int i;
    local array<string> Strings;

    for (i = 0; i < A.Length; ++i)
    {
        Strings[i] = string(A[i]);
    }

    return Strings;
}

final static function string ToString(array<Object> A)
{
    return "[" $ class'UString'.static.Join(", ", ToStringArray(A)) $ "]";
}

final static function array<string> IToStringArray(array<int> A)
{
    local int i;
    local array<string> Strings;

    for (i = 0; i < A.Length; ++i)
    {
        Strings[i] = string(A[i]);
    }

    return Strings;
}

final static function string IToString(array<int> A)
{
    return "[" $ class'UString'.static.Join(", ", IToStringArray(A)) $ "]";
}

final static function array<string> FToStringArray(array<float> A)
{
    local int i;
    local array<string> Strings;

    for (i = 0; i < A.Length; ++i)
    {
        Strings[i] = string(A[i]);
    }

    return Strings;
}

final static function string FToString(array<float> A)
{
    return "[" $ class'UString'.static.Join(", ", FToStringArray(A)) $ "]";
}

final static function string SToString(array<string> A)
{
    local int i;

    // Escape double-quote (") characters.
    for (i = 0; i < A.Length; ++i)
    {
        A[i] = Repl(A[i], "\"", "\\\"");
    }

    return "[" $ class'UString'.static.Join(", ", A) $ "]";
}

final static function array<int> Range(int Min, int Max)
{
    local array<int> A;

    while (Min <= Max)
    {
        A[A.Length] = Min++;
    }

    return A;
}

final static function int RavelIndices(int X, int Y, int Width)
{
    return X * Width + Y;
}
