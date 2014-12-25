//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_StuartMountedMGPawn extends DH_ROMountedTankMGPawn;

defaultproperties
{
    OverlayCenterSize=0.700000
    MGOverlay=texture'DH_VehicleOptics_tex.Common.MG_sight'
    WeaponFov=72.000000
    GunClass=class'DH_Vehicles.DH_StuartMountedMG'
    bHasAltFire=false
    CameraBone="mg_yaw"
    bDrawDriverInTP=false
    bDesiredBehindView=false
    DrivePos=(Z=130.000000)
    EntryRadius=130.000000
    FPCamViewOffset=(X=-1.000000,Z=4.000000)
    TPCamDistance=300.000000
    TPCamLookat=(X=-25.000000,Z=0.000000)
    TPCamWorldOffset=(Z=120.000000)
    VehicleNameString="Stuart Mounted MG"
    PitchUpLimit=3000
    PitchDownLimit=63000
}
