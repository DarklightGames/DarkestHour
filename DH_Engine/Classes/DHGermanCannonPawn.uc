//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGermanCannonPawn extends DHVehicleCannonPawn
    abstract;

var     TexRotator  RangeRingRotator;        // overlay for range ring (renamed from RO's ScopeCenterRotator)
var     int         RangeRingRotationFactor; // scales the rotation of the range ring, so it correctly aligns the range markings (renamed from RO's CenterRotationFactor)
var     float       RangeRingScale;          // scale of the range ring (renamed from RO's ScopeCenterScale)

// Modified to draw any range indicator ring
simulated function DrawGunsightOverlay(Canvas C)
{
    local float ScaledTexureSize, Scale;
    local int   RotationFactor;

    super.DrawGunsightOverlay(C);

    if (RangeRingRotator != none && Gun != none)
    {
        // Set rotation of range ring
        RotationFactor = Gun.CurrentRangeIndex * RangeRingRotationFactor;

        if (Gun.CurrentRangeIndex > 20) // after range index 20 the range increments are in 200m instead of 100m, so we need to double up to adjust for that
        {
            RotationFactor += (Gun.CurrentRangeIndex - 20) * RangeRingRotationFactor;
        }

        RangeRingRotator.Rotation.Yaw = RotationFactor;

        // Position & draw range ring
        ScaledTexureSize = float(C.SizeX) * GunsightSize * RangeRingScale;
        Scale = ScaledTexureSize / float(RangeRingRotator.MaterialUSize());
        C.SetPos((float(C.SizeX) - ScaledTexureSize) / 2.0, (float(C.SizeY) - ScaledTexureSize) / 2.0);

        C.DrawTileScaled(RangeRingRotator, Scale, Scale);
    }
}

// Modified to add RangeRingRotator
static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    if (default.RangeRingRotator != none)
    {
        L.AddPrecacheMaterial(default.RangeRingRotator);
    }
}

simulated function UpdatePrecacheMaterials()
{
    super.UpdatePrecacheMaterials();

    Level.AddPrecacheMaterial(RangeRingRotator);
}

defaultproperties
{
    RangePositionX=0.02
    RangeRingScale=0.67
    GunsightOverlay=Texture'DH_VehicleOptics_tex.German.German_sight_background'
}
