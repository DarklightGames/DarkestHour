//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHLib extends Object
    abstract;

static final function array<int> CreateIndicesArray(int Length)
{
    local int i;
    local array<int> Indices;

    for (i = 0; i < Length; ++i)
    {
        Indices[i] = i;
    }

    return Indices;
}

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

static final function vector VClamp(vector V, vector A, vector B)
{
    local vector R;

    R.X = FClamp(V.X, A.X, B.X);
    R.Y = FClamp(V.Y, A.Y, B.Y);
    R.Z = FClamp(V.Z, A.Z, B.Z);

    return R;
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

static final function float MetersToUnreal(coerce float Meters)
{
    return Meters * 60.352;
}

static final function float UnrealToMeters(coerce float Unreal)
{
    return Unreal * 0.01656945917285259809119830328738;
}

static final function string GetNumberString(int N, int Digits)
{
    local string NumberString;

    NumberString = string(N);

    N = Digits - Len(NumberString);

    while (N-- > 0)
    {
        NumberString = "0" $ NumberString;
    }

    return NumberString;
}

static final function string GetDurationString(int Seconds, string Format)
{
    local int TotalYears;
    local int TotalDays;
    local int TotalHours;
    local int TotalMinutes;
    local int TotalSeconds;
    local int Years;
    local int Days;
    local int Hours;
    local int Minutes;
    local int i;
    local int Precision;
    local int N;
    local string Token, S;
    local bool bIsOptional;

    const SECONDS_PER_YEAR = 31536000;
    const SECONDS_PER_DAY = 86400;
    const SECONDS_PER_HOUR = 3600;
    const SECONDS_PER_MINUTE = 60;

    TotalYears = Seconds / SECONDS_PER_YEAR;
    TotalDays = Seconds / SECONDS_PER_DAY;
    TotalHours = Seconds / SECONDS_PER_HOUR;
    TotalMinutes = Seconds / SECONDS_PER_MINUTE;

    Years = Seconds / SECONDS_PER_YEAR;
    Seconds = Seconds % SECONDS_PER_YEAR;

    Days = Seconds / SECONDS_PER_DAY;
    Seconds = Seconds % SECONDS_PER_DAY;

    Hours = Seconds / SECONDS_PER_HOUR;
    Seconds = Seconds % SECONDS_PER_HOUR;

    Minutes = Seconds / SECONDS_PER_MINUTE;
    Seconds = Seconds % SECONDS_PER_MINUTE;

    while (i < Len(Format))
    {
        Token = Mid(Format, i++, 1);

        if (Token == "\\")
        {
            if (i < Len(Format) - 1)
            {
                S $= Mid(Format, i++, 1);

                continue;
            }
        }
        else if (Token == "[")
        {
            bIsOptional = true;

            continue;
        }
        else if (Token == "]")
        {
            bIsOptional = false;

            continue;
        }
        else if (Token == "Y")
        {
            N = TotalYears;
        }
        else if (Token == "H")
        {
            N = TotalHours;
        }
        else if (Token == "M")
        {
            N = TotalMinutes;
        }
        else if (Token == "S")
        {
            N = TotalSeconds;
        }
        else if (Token == "y")
        {
            N = Years;
        }
        else if (Token == "d")
        {
            N = Days;
        }
        else if (Token == "h")
        {
            N = Hours;
        }
        else if (Token == "m")
        {
            N = Minutes;
        }
        else if (Token == "s")
        {
            N = Seconds;
        }
        else
        {
            if (!bIsOptional || N > 0)
            {
                S $= Token;
            }

            continue;
        }

        Precision = 1;

        // accumulate identical tokens to get the precision
        while (i < Len(Format))
        {
            if (Token != Mid(Format, i, 1))
            {
                break;
            }

            ++i;
            ++Precision;
        }

        if (!bIsOptional || N > 0)
        {
            S $= GetNumberString(N, Precision);
        }
    }

    return S;
}
