//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_JagdpantherMountedMGPawn extends DHMountedTankMGPawn;

defaultproperties
{
    OverlayCenterSize=0.7
    MGOverlay=texture'DH_VehicleOptics_tex.German.KZF2_MGSight'
    WeaponFOV=41.0
    GunClass=class'DH_Vehicles.DH_JagdpantherMountedMG'
    bHasAltFire=false
    CameraBone="mg_yaw"
    bDrawDriverInTP=false
    EntryRadius=130.0
    FPCamViewOffset=(X=10.0,Y=-5.0,Z=1.0)
    PitchUpLimit=2730
    PitchDownLimit=64000
}
