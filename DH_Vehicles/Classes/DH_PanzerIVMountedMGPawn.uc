//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PanzerIVMountedMGPawn extends DHVehicleMGPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_PanzerIVMountedMG'
    GunsightOverlay=Texture'DH_VehicleOptics_tex.German.KZF2_MGSight'
    GunsightSize=0.381 // 18 degrees visible FOV at 1.8x magnification (KFZ2 sight)
    WeaponFOV=47.22
    FPCamPos=(X=10.0,Y=-5.0,Z=1.0)
    PitchUpLimit=3640
    PitchDownLimit=63715
}
