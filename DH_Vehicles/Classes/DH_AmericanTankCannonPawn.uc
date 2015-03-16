//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_AmericanTankCannonPawn extends DH_ROTankCannonPawn
    abstract;

defaultproperties
{
    PeriscopeOverlay=texture'DH_VehicleOptics_tex.Allied.PERISCOPE_overlay_Allied'
    bShowRangeText=false
    OverlayCenterSize=1.0
    DestroyedScopeOverlay=texture'DH_VehicleOptics_tex.Allied.Destroyed'
    ScopePositionX=0.215
    ScopePositionY=0.5
    BinocsOverlay=texture'DH_VehicleOptics_tex.Allied.BINOC_overlay_7x50Allied'
    RangeText="Yards"
}
