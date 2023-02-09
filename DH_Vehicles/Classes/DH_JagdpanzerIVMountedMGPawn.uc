//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JagdpanzerIVMountedMGPawn extends DHVehicleMGPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_JagdpanzerIVMountedMG'
    GunsightOverlay=Texture'DH_VehicleOptics_tex.General.MG_sight'
    GunsightSize=0.5 // TODO: reduce size as this was just a crude peephole that gave a very restricted field of view down the MG's ironsights (same for T-34 MG)
    WeaponFOV=72.0
    FPCamPos=(X=0.0,Y=0.0,Z=3.0)
    PitchUpLimit=2730
    PitchDownLimit=64000
}
