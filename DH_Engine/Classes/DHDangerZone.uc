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

// This function will return a positive number if the pointer is OUTSIDE of
// `TeamIndex` influence.
static function float GetIntensity(DHGameReplicationInfo GRI, float PointerX, float PointerY, byte TeamIndex)
{
    local float Intensity, IntensityA, IntensityB;
    local int TotalA, TotalB, i;
    local vector V1, V2;

    V2.X = PointerX;
    V2.Y = PointerY;

    for (i = 0; i < arraycount(GRI.DHObjectives); i++)
    {
        if (GRI.DHObjectives[i] == none)
        {
            continue;
        }

        V1.X = GRI.DHObjectives[i].Location.X;
        V1.Y = GRI.DHObjectives[i].Location.Y;

        Intensity = 1 / FMax(VSizeSquared(V1 - V2), class'UFloat'.static.Epsilon());

        if (GRI.DHObjectives[i].IsActive() || GRI.DHObjectives[i].IsOwnedByTeam(TeamIndex))
        {
            TotalA++;
            IntensityA += Intensity;
        }
        else
        {
            TotalB++;
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

protected static function AddSegment(out array<vector>Contour, byte Mask, byte Normal, vector CellCoords, int X_Step, int Y_Step)
{
    local vector StartOffset, EndOffset;

    if (Mask < 1 || Mask > 14)
    {
        return;
    }

    if (Mask == 1 || Mask == 14)
    {
        // NW
        StartOffset.Y += Y_Step;
        EndOffset.X -= X_Step;
    }
    else if (Mask == 2 || Mask == 13)
    {
        // NE
        StartOffset.Y += Y_Step;
        EndOffset.X += X_Step;
    }
    else if (Mask == 3 || Mask == 12)
    {
        // W-E
        StartOffset.X -= X_Step;
        EndOffset.X += X_Step;
    }
    else if (Mask == 4 || Mask == 11)
    {
        // SE
        StartOffset.Y -= Y_Step;
        EndOffset.X += X_Step;
    }
    else if ((Mask == 5 && Normal > 0) || (Mask == 10 && Normal == 0))
    {
        // NE
        StartOffset.Y += Y_Step;
        EndOffset.X += X_Step;

        Contour[Contour.Length] = CellCoords + StartOffset;
        Contour[Contour.Length] = CellCoords + EndOffset;

        // SW
        StartOffset.Y -= Y_Step;
        EndOffset.X -= X_Step;
    }
    else if ((Mask == 5 && Normal == 0) || (Mask == 10 && Normal > 0))
    {
        // NW
        StartOffset.Y += Y_Step;
        EndOffset.X -= X_Step;

        Contour[Contour.Length] = CellCoords + StartOffset;
        Contour[Contour.Length] = CellCoords + EndOffset;

        // SE
        StartOffset.Y -= Y_Step;
        EndOffset.X += X_Step;
    }
    else if (Mask == 6 || Mask == 9)
    {
        // N-S
        StartOffset.Y += Y_Step;
        EndOffset.Y -= Y_Step;
    }
    else if (Mask == 7 || Mask == 8)
    {
        // SW
        StartOffset.Y -= Y_Step;
        EndOffset.X -= X_Step;
    }
    else
    {
        return;
    }

    Contour[Contour.Length] = CellCoords + StartOffset;
    Contour[Contour.Length] = CellCoords + EndOffset;
}

static function array<vector> GetContour(DHGameReplicationInfo GRI, int Resolution, byte TeamIndex, out string DebugInfo)
{
    local int x, y;
    local float XL, YL, X_Step, Y_Step;
    local vector Origin, CellCoords;
    local byte Mask;
    local array<byte> Normal;
    local array<vector> Contour;

    Resolution = Clamp(Resolution, 3, 255);
    Resolution += 1 - Ceil(Resolution % 2);

    XL = FMax(1.0, Abs(GRI.SouthWestBounds.X) + Abs(GRI.NorthEastBounds.X));
    YL = FMax(1.0, Abs(GRI.SouthWestBounds.Y) + Abs(GRI.NorthEastBounds.Y));

    X_Step = XL / (Resolution - 1);
    Y_Step = YL / (Resolution - 1);

    Origin.X = GRI.SouthWestBounds.X;
    Origin.Y = GRI.NorthEastBounds.Y;

    // Get the normalized field
    for (x = 0; x < Resolution; x++)
    {
        for (y = 0; y < Resolution; y++)
        {
            CellCoords = static.IndicesToCoords(x, y, X_Step, Y_Step, Origin);

            if (static.IsIn(GRI, CellCoords.X, CellCoords.Y, TeamIndex))
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

            AddSegment(Contour, Mask, Normal[class'UArray'.static.RavelIndices(x, y, Resolution)], CellCoords, X_Step, Y_Step);
        }
    }

    DebugInfo = string(Contour.Length / 2) @ "lines @" @ string(Resolution) @ "resolution";

    return Contour;
}

defaultproperties
{
    ContourColor=(R=255,G=0,B=0,A=255)
}
