//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_JagdpanzerIVMountedMGPawn extends DHVehicleMGPawn;

defaultproperties
{
    OverlayCenterSize=0.5
    MGOverlay=texture'DH_VehicleOptics_tex.Common.MG_sight'
    WeaponFOV=72.0
    GunClass=class'DH_Vehicles.DH_JagdpanzerIVMountedMG'
    bHasAltFire=false
    CameraBone="mg_yaw"
    bDrawDriverInTP=false
    EntryRadius=130.0
    FPCamViewOffset=(Z=3.0)
    PitchUpLimit=2730
    PitchDownLimit=64000
}
