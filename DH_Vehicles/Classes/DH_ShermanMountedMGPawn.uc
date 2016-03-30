//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ShermanMountedMGPawn extends DHVehicleMGPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_ShermanMountedMG'
    MGOverlay=texture'DH_VehicleOptics_tex.Common.MG_sight'
    OverlayCenterSize=0.7
    WeaponFOV=72.0
    FPCamPos=(X=-0.5,Y=0.0,Z=3.5)
    PitchUpLimit=3000
    PitchDownLimit=63000
}
