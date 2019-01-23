//-----------------------------------------------------------
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//-----------------------------------------------------------
class DHDangerZone extends Object
    abstract;

var color ContourColor;

static final function vector IndicesToCoords(int X_Index, int Y_Index, float X_Step, float Y_Step, vector Origin)
{
    local vector L;

    L.X = X_Index * X_Step;
    L.Y = Y_Index * Y_Step;

    return L + Origin;
}

static final function vector GetInterpCoords(vector A, vector B, float A_Value, float B_Value, float Value)
{
    local float T;

    T = FClamp((Value - A_Value) / (B_Value - A_Value), 0.0, 1.0);

    return (1 - T) * A + T * B;
}

// This function will return a positive number if the pointer is OUTSIDE of
// `TeamIndex` influence.
static function float GetIntensity(DHGameReplicationInfo GRI, float PointerX, float PointerY, byte TeamIndex)
{
    local float Intensity, IntensityA, IntensityB;
    local int TotalA, TotalB, i;
    local vector V1, V2;

    V2.X = PointerX;
    V2.Y = PointerY;

    for (i = 0; i < arraycount(GRI.DHObjectives); ++i)
    {
        if (GRI.DHObjectives[i] == none)
        {
            continue;
        }

        V1.X = GRI.DHObjectives[i].Location.X;
        V1.Y = GRI.DHObjectives[i].Location.Y;

        Intensity = 1.0 / FMax(VSizeSquared(V1 - V2), class'UFloat'.static.Epsilon());

        if (GRI.DHObjectives[i].IsActive() || GRI.DHObjectives[i].IsOwnedByTeam(TeamIndex))
        {
            ++TotalA;
            IntensityA += Intensity;
        }
        else
        {
            ++TotalB;
            IntensityB += Intensity;
        }
    }

    return FClamp(GRI.DangerZoneIntensityScale, 0.1, 2.0) * IntensityB / Max(TotalB, 1) - IntensityA / Max(TotalA, 1);
}

static function bool IsIn(DHGameReplicationInfo GRI, float PointerX, float PointerY, byte TeamIndex)
{
    if (!GRI.bIsDangerZoneEnabled)
    {
        return false;
    }

    return GetIntensity(GRI, PointerX, PointerY, TeamIndex) >= 0.0;
}

static final function array<Intbox> GetVertexIndices(int X, int Y, byte Mask, byte Normal)
{
    local array<Intbox> Indices;
    local Intbox North, East, West, South;

    North.X1 = X - 1;
    North.Y1 = Y + 1;
    North.X2 = X + 1;
    North.Y2 = Y + 1;

    South.X1 = X + 1;
    South.Y1 = Y - 1;
    South.X2 = X - 1;
    South.Y2 = Y - 1;

    West.X1 = South.X2;
    West.Y1 = South.Y2;
    West.X2 = North.X1;
    West.Y2 = North.Y1;

    East.X1 = North.X2;
    East.Y1 = North.Y2;
    East.X2 = South.X1;
    East.Y2 = South.Y1;

    if (Mask == 1 || Mask == 14)
    {
        // NW
        Indices[Indices.Length] = North;
        Indices[Indices.Length] = West;
    }
    else if (Mask == 2 || Mask == 13)
    {
        // NE
        Indices[Indices.Length] = North;
        Indices[Indices.Length] = East;
    }
    else if (Mask == 3 || Mask == 12)
    {
        // W-E
        Indices[Indices.Length] = West;
        Indices[Indices.Length] = East;
    }
    else if (Mask == 4 || Mask == 11)
    {
        // SE
        Indices[Indices.Length] = South;
        Indices[Indices.Length] = East;
    }
    else if ((Mask == 5 && Normal > 0) || (Mask == 10 && Normal == 0))
    {
        // NE
        Indices[Indices.Length] = North;
        Indices[Indices.Length] = East;

        // SW
        Indices[Indices.Length] = South;
        Indices[Indices.Length] = West;
    }
    else if ((Mask == 5 && Normal == 0) || (Mask == 10 && Normal > 0))
    {
        // NW
        Indices[Indices.Length] = North;
        Indices[Indices.Length] = West;

        // SE
        Indices[Indices.Length] = South;
        Indices[Indices.Length] = East;
    }
    else if (Mask == 6 || Mask == 9)
    {
        // N-S
        Indices[Indices.Length] = North;
        Indices[Indices.Length] = South;
    }
    else if (Mask == 7 || Mask == 8)
    {
        // SW
        Indices[Indices.Length] = South;
        Indices[Indices.Length] = West;
    }

    return Indices;
}

static function array<vector> GetContour(DHGameReplicationInfo GRI, int Resolution, byte TeamIndex, out string DebugInfo)
{
    local int x, y, i;
    local float XL, YL, X_Step, Y_Step;
    local vector Origin, CellCoords;
    local byte Mask;
    local array<byte> Normal;
    local array<float> Intensity;
    local array<vector> Contour;
    local array<Intbox> VertexIndices;

    Resolution = Clamp(Resolution, 3, 255);
    Resolution += 1 - Ceil(Resolution % 2);

    XL = FMax(1.0, Abs(GRI.SouthWestBounds.X) + Abs(GRI.NorthEastBounds.X));
    YL = FMax(1.0, Abs(GRI.SouthWestBounds.Y) + Abs(GRI.NorthEastBounds.Y));

    X_Step = XL / (Resolution - 1);
    Y_Step = YL / (Resolution - 1);

    Origin.X = GRI.SouthWestBounds.X;
    Origin.Y = GRI.NorthEastBounds.Y;

    // Get the normalized field
    for (x = 0; x < Resolution; ++x)
    {
        for (y = 0; y < Resolution; ++y)
        {
            CellCoords = static.IndicesToCoords(x, y, X_Step, Y_Step, Origin);

            Intensity[Intensity.Length] = static.GetIntensity(GRI, CellCoords.X, CellCoords.Y, TeamIndex);

            if (Intensity[Intensity.Length - 1] >= 0)
            {
                Normal[Normal.Length] = 1;
            }
            else
            {
                Normal[Normal.Length] = 0;
            }
        }
    }

    // Calculate bitmasks and contour coordinates
    for (x = 1; x < Ceil(Normal.Length / Resolution) - 1; x += 2)
    {
        for (y = 1; y < Resolution - 1; y += 2)
        {
            Mask = 0;
            Mask += Normal[class'UArray'.static.RavelIndices(x - 1, y - 1, Resolution)] << 3;
            Mask += Normal[class'UArray'.static.RavelIndices(x + 1, y - 1, Resolution)] << 2;
            Mask += Normal[class'UArray'.static.RavelIndices(x + 1, y + 1, Resolution)] << 1;
            Mask += Normal[class'UArray'.static.RavelIndices(x - 1, y + 1, Resolution)];

            CellCoords = static.IndicesToCoords(x, y, X_Step, Y_Step, Origin);
            VertexIndices = GetVertexIndices(x, y, Mask, Normal[class'UArray'.static.RavelIndices(x, y, Resolution)]);

            for (i = 0; i < VertexIndices.Length; ++i)
            {
                Contour[Contour.Length] = GetInterpCoords(static.IndicesToCoords(VertexIndices[i].X1, VertexIndices[i].Y1, X_Step, Y_Step, Origin),
                                                          static.IndicesToCoords(VertexIndices[i].X2, VertexIndices[i].Y2, X_Step, Y_Step, Origin),
                                                          Intensity[class'UArray'.static.RavelIndices(VertexIndices[i].X1, VertexIndices[i].Y1, Resolution)],
                                                          Intensity[class'UArray'.static.RavelIndices(VertexIndices[i].X2, VertexIndices[i].Y2, Resolution)],
                                                          0);
            }
        }
    }

    DebugInfo = string(Contour.Length / 2) @ "lines @" @ string(Resolution) @ "resolution";

    return Contour;
}

defaultproperties
{
    ContourColor=(R=255,G=0,B=0,A=255)
}
