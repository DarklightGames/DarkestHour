//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_JagdpantherMountedMGPawn extends DH_ROMountedTankMGPawn;

defaultproperties
{
    OverlayCenterSize=0.700000
    MGOverlay=texture'DH_VehicleOptics_tex.German.KZF2_MGSight'
    WeaponFOV=41.000000
    GunClass=class'DH_Vehicles.DH_JagdpantherMountedMG'
    bHasAltFire=false
    CameraBone="mg_yaw"
    bDrawDriverInTP=false
    bDesiredBehindView=false
    DrivePos=(Z=130.000000)
    EntryRadius=130.000000
    FPCamViewOffset=(X=10.000000,Y=-5.000000,Z=1.000000)
    TPCamDistance=300.000000
    TPCamLookat=(X=-25.000000,Z=0.000000)
    TPCamWorldOffset=(Z=120.000000)
    PitchUpLimit=2730
    PitchDownLimit=64000
}
