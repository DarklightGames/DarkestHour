//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHLib extends Object
    abstract;

static final function string GetMapName(LevelInfo L)
{
    local string MapName;
    local int i, j;

    MapName = L.GetLocalURL();
    i = InStr(MapName, "/");

    if (i < 0)
    {
        i = 0;
    }

    j = InStr(MapName, "?");

    if (j < 0)
    {
        j = Len(MapName);
    }

    if (Mid(MapName, j - 3, 3) ~= "rom")
    {
        j -= 5;
    }

    return Mid(MapName, i, j - i);
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
            S $= class'UString'.static.ZFill(N, Precision);
        }
    }

    return S;
}

// Draws a debugging cylinder out of wireframe lines - same as in ROHud but uses DrawStayingDebugLine(), so they stay on the screen
static final function DrawStayingDebugCylinder(Actor A, vector Base, vector X, vector Y, vector Z, float Radius, float HalfHeight, int NumSides, byte R, byte G, byte B)
{
    local float  AngleDelta;
    local vector LastVertex, Vertex;
    local int    SideIndex;

    if (A != none && Radius > 0.0 && HalfHeight > 0.0 && NumSides > 0)
    {
        AngleDelta = 2.0 * PI / NumSides;
        LastVertex = Base + X * Radius;

        for (SideIndex = 0; SideIndex < NumSides; ++SideIndex)
        {
            Vertex = Base + (X * Cos(AngleDelta * (SideIndex + 1.0)) + Y * Sin(AngleDelta * (SideIndex + 1.0))) * Radius;

            A.DrawStayingDebugLine(LastVertex - Z * HalfHeight, Vertex - Z * HalfHeight, R, G, B);
            A.DrawStayingDebugLine(LastVertex + Z * HalfHeight, Vertex + Z * HalfHeight, R, G, B);
            A.DrawStayingDebugLine(LastVertex - Z * HalfHeight, LastVertex + Z * HalfHeight, R, G, B);

            LastVertex = Vertex;
        }
    }
}
