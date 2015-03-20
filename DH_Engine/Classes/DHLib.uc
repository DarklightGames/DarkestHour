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

static final function float DegreesToRadians(coerce float Degrees)
{
    return Degrees * 0.01745329251994329576923690768489;
}

static final function float RadiansToDegrees(coerce float Radians)
{
    return Radians * 57.295779513082320876798154814105;
}

static final function float DegreesToUnreal(coerce float Degrees)
{
    return Degrees * 182.04444444444444444444444444444;
}

static final function float RadiansToUnreal(coerce float Radians)
{
    return Radians * 10430.378350470452724949566316381;
}

static final function float UnrealToDegrees(coerce float Unreal)
{
    return Unreal * 0.0054931640625;
}

static final function float UnrealToRadians(coerce float Unreal)
{
    return Unreal * 9.5873799242852576857380474343247e-5;
}
