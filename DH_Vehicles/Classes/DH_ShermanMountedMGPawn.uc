//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ShermanMountedMGPawn extends DH_ROMountedTankMGPawn;

defaultproperties
{
    OverlayCenterSize=0.700000
    MGOverlay=Texture'DH_VehicleOptics_tex.Common.MG_sight'
    WeaponFov=72.000000
    GunClass=class'DH_Vehicles.DH_ShermanMountedMG'
    bHasAltFire=false
    CameraBone="mg_yaw"
    bDrawDriverInTP=false
    DrivePos=(Z=130.000000)
    EntryRadius=130.000000
    FPCamViewOffset=(X=-2.000000,Z=5.000000)
    TPCamDistance=300.000000
    TPCamLookat=(X=-25.000000,Z=0.000000)
    TPCamWorldOffset=(Z=120.000000)
    VehiclePositionString="in a Sherman Mounted MG"
    VehicleNameString="Sherman Mounted MG"
    PitchUpLimit=3000
    PitchDownLimit=63000
}
