//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_ChurchillMountedMGPawn extends DHVehicleMGPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_ChurchillMountedMG'
    GunsightOverlay=Texture'DH_VehicleOptics_tex.Allied.BesaMG_sight'
    WeaponFOV=38.0
    FPCamPos=(X=10.0,Y=-7.0,Z=0.0)
    PitchUpLimit=4500
    PitchDownLimit=64000
}
