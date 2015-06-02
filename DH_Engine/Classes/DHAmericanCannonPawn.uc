//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHAmericanCannonPawn extends DHVehicleCannonPawn
    abstract;

defaultproperties
{
    RangeText="yards" // US sights don't show range text as default, but if any cannons do then this is the range text to use
    PeriscopeOverlay=texture'DH_VehicleOptics_tex.Allied.PERISCOPE_overlay_Allied'
    BinocsOverlay=texture'DH_VehicleOptics_tex.Allied.BINOC_overlay_7x50Allied'
}
