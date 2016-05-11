//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_JagdpanzerIVMountedMGPawn extends DHVehicleMGPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_JagdpanzerIVMountedMG'
    GunsightOverlay=texture'DH_VehicleOptics_tex.Common.MG_sight'
    OverlayCenterSize=0.5
    WeaponFOV=72.0
    FPCamPos=(X=0.0,Y=0.0,Z=3.0)
    PitchUpLimit=2730
    PitchDownLimit=64000
}
