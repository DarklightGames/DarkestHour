//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_StuartMountedMGPawn extends DHMountedTankMGPawn;

defaultproperties
{
    OverlayCenterSize=0.7
    MGOverlay=texture'DH_VehicleOptics_tex.Common.MG_sight'
    WeaponFOV=72.0
    GunClass=class'DH_Vehicles.DH_StuartMountedMG'
    bHasAltFire=false
    CameraBone="mg_yaw"
    bDrawDriverInTP=false
    bDesiredBehindView=false
    EntryRadius=130.0
    FPCamViewOffset=(X=-1.0,Z=4.0)
    TPCamDistance=300.0
    TPCamLookat=(X=-25.0,Z=0.0)
    TPCamWorldOffset=(Z=120.0)
    PitchUpLimit=3000
    PitchDownLimit=63000
}
