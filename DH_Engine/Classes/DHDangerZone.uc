//-----------------------------------------------------------
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//-----------------------------------------------------------
class DHDangerZone extends Object
    abstract;

var color ContourColor;

struct ScalarField
{
    var int Width;
    var array<float> Intensity;
    var array<byte> Normal;
    var array<byte> Mask;
};

struct OverlayData
{
    var ScalarField Data;

    var vector Center;
    var vector Origin;
    var float X_Step;
    var float Y_Step;
    var array<vector> LineStart;
    var array<vector> LineEnd;
};

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

protected static function AddContour(out OverlayData O, int X_Index, int Y_Index)
{
    local int Index;
    local byte Mask, Normal;
    local vector CellCoords, LineStartOffset, LineEndOffset;

    Index = class'UArray'.static.RavelIndices(X_Index, Y_Index, O.Data.Width);
    Mask = O.Data.Mask[Index];

    if (Mask < 1 || Mask > 14)
    {
        return;
    }

    Normal = O.Data.Normal[Index];
    CellCoords = static.IndicesToCoords(O, X_Index, Y_Index);

    if (Mask == 1 || Mask == 14)
    {
        // NW
        LineStartOffset.Y += O.Y_Step;
        LineEndOffset.X -= O.X_Step;
    }
    else if (Mask == 2 || Mask == 13)
    {
        // NE
        LineStartOffset.Y += O.Y_Step;
        LineEndOffset.X += O.X_Step;
    }
    else if (Mask == 3 || Mask == 12)
    {
        // W-E
        LineStartOffset.X -= O.X_Step;
        LineEndOffset.X += O.X_Step;
    }
    else if (Mask == 4 || Mask == 11)
    {
        // SE
        LineStartOffset.Y -= O.Y_Step;
        LineEndOffset.X += O.X_Step;
    }
    else if ((Mask == 5 && Normal > 0) || (Mask == 10 && Normal == 0))
    {
        // NE
        LineStartOffset.Y += O.Y_Step;
        LineEndOffset.X += O.X_Step;

        O.LineStart[O.LineStart.Length] = CellCoords + LineStartOffset;
        O.LineEnd[O.LineEnd.Length] = CellCoords + LineEndOffset;

        // SW
        LineStartOffset.Y -= O.Y_Step;
        LineEndOffset.X -= O.X_Step;
    }
    else if ((Mask == 5 && Normal == 0) || (Mask == 10 && Normal > 0))
    {
        // NW
        LineStartOffset.Y += O.Y_Step;
        LineEndOffset.X -= O.X_Step;

        O.LineStart[O.LineStart.Length] = CellCoords + LineStartOffset;
        O.LineEnd[O.LineEnd.Length] = CellCoords + LineEndOffset;

        // SE
        LineStartOffset.Y -= O.Y_Step;
        LineEndOffset.X += O.X_Step;
    }
    else if (Mask == 6 || Mask == 9)
    {
        // N-S
        LineStartOffset.Y += O.Y_Step;
        LineEndOffset.Y -= O.Y_Step;
    }
    else if (Mask == 7 || Mask == 8)
    {
        // SW
        LineStartOffset.Y -= O.Y_Step;
        LineEndOffset.X -= O.X_Step;
    }
    else
    {
        return;
    }

    O.LineStart[O.LineStart.Length] = CellCoords + LineStartOffset;
    O.LineEnd[O.LineEnd.Length] = CellCoords + LineEndOffset;
}

static final function vector IndicesToCoords(OverlayData O, int X_Index, int Y_Index)
{
    local vector L;

    L.X = X_Index * O.X_Step;
    L.Y = Y_Index * O.Y_Step;

    return L + O.Origin;
}

static function OverlayData GetOverlayData(DHGameReplicationInfo GRI, int Resolution, byte TeamIndex)
{
    local int x, y, i;
    local float XL, YL;
    local vector CellCoords;
    local OverlayData O;

    Resolution = Max(1, Resolution);

    XL = FMax(1.0, Abs(GRI.SouthWestBounds.X) + Abs(GRI.NorthEastBounds.X));
    YL = FMax(1.0, Abs(GRI.SouthWestBounds.Y) + Abs(GRI.NorthEastBounds.Y));

    O.X_Step = XL / Resolution;
    O.Y_Step = YL / Resolution;

    O.Origin.X = GRI.SouthWestBounds.X;
    O.Origin.Y = GRI.NorthEastBounds.Y;

    O.Data.Width = Resolution;

    // Populate the intensity and normal arrays
    for (x = 0; x < O.Data.Width; x++)
    {
        for (y = 0; y < O.Data.Width; y++)
        {
            CellCoords = static.IndicesToCoords(O, x, y);

            O.Data.Intensity[O.Data.Intensity.Length] = static.GetIntensity(GRI, CellCoords.X, CellCoords.Y, TeamIndex);

            if (O.Data.Intensity[O.Data.Intensity.Length - 1] > 0)
            {
                O.Data.Normal[O.Data.Normal.Length] = 1;
            }
            else
            {
                O.Data.Normal[O.Data.Normal.Length] = 0;
            }
        }
    }

    // Calculate bit-masks and contour coordinates
    for (x = 0; x < Ceil(O.Data.Normal.Length / O.Data.Width); x++)
    {
        for (y = 0; y < O.Data.Width; y++)
        {
            O.Data.Mask[O.Data.Mask.Length] = 0;

            if (x > 0 && y > 0 && x % 2 == 0 && y % 2 == 0 && x < O.Data.Width - 1 && y < O.Data.Normal.Length / O.Data.Width - 1)
            {
                i = O.Data.Mask.Length - 1;

                O.Data.Mask[i] += O.Data.Normal[class'UArray'.static.RavelIndices(x - 1, y - 1, O.Data.Width)] << 3;
                O.Data.Mask[i] += O.Data.Normal[class'UArray'.static.RavelIndices(x + 1, y - 1, O.Data.Width)] << 2;
                O.Data.Mask[i] += O.Data.Normal[class'UArray'.static.RavelIndices(x + 1, y + 1, O.Data.Width)] << 1;
                O.Data.Mask[i] += O.Data.Normal[class'UArray'.static.RavelIndices(x - 1, y + 1, O.Data.Width)];

                AddContour(O, x, y);
            }
        }
    }

    return O;
}

defaultproperties
{
    ContourColor=(R=255,G=0,B=0,A=255)
}
