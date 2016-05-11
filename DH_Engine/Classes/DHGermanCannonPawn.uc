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
    ScopeCenterScale=0.75 // these 3 are range ring properties
    ScopePositionX=0.237
    ScopePositionY=0.15
    CannonScopeOverlay=texture'DH_VehicleOptics_tex.German.German_sight_background'
    BinocsOverlay=texture'DH_VehicleOptics_tex.German.BINOC_overlay_6x30Germ'
}
