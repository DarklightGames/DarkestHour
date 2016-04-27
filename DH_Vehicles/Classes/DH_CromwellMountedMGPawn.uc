//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_CromwellMountedMGPawn extends DHVehicleMGPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_CromwellMountedMG'
    MGOverlay=texture'DH_VehicleOptics_tex.Allied.BesaMG_sight'
    WeaponFOV=38.0
    FPCamPos=(X=5.0,Y=-8.0,Z=-1.0)
    PitchUpLimit=4500
    PitchDownLimit=64000
}
