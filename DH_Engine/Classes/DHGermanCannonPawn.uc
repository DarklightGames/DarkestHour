//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHGermanCannonPawn extends DHVehicleCannonPawn
    abstract;

defaultproperties
{
    bShowRangeText=true
    RangeText="meters"
    RangePositionX=0.02
    bShowRangeRing=true
    RangeRingScale=0.75
    GunsightOverlay=texture'DH_VehicleOptics_tex.German.German_sight_background'
    BinocsOverlay=texture'DH_VehicleOptics_tex.German.BINOC_overlay_6x30Germ'
}
