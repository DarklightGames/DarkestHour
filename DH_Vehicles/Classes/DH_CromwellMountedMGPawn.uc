//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_CromwellMountedMGPawn extends DH_ROMountedTankMGPawn;

defaultproperties
{
    MGOverlay=texture'DH_VehicleOptics_tex.Allied.BesaMG_sight'
    WeaponFov=38.000000
    GunClass=class'DH_Vehicles.DH_CromwellMountedMG'
    bHasAltFire=false
    CameraBone="mg_yaw"
    bDrawDriverInTP=false
    DrivePos=(Z=130.000000)
    EntryRadius=130.000000
    FPCamViewOffset=(X=5.000000,Y=-8.000000,Z=-1.000000)
    TPCamDistance=300.000000
    TPCamLookat=(X=-25.000000,Z=0.000000)
    TPCamWorldOffset=(Z=120.000000)
    VehiclePositionString="in a Cromwell mounted MG"
    VehicleNameString="Cromwell mounted MG"
    PitchUpLimit=4500
    PitchDownLimit=64000
}
