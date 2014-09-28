//===================================================================
// DH_ShermanMountedTankMGPawn
//===================================================================

class DH_ShermanMountedMGPawn_M4A176W extends DH_ROMountedTankMGPawn;

defaultproperties
{
     OverlayCenterSize=0.700000
     MGOverlay=Texture'DH_VehicleOptics_tex.Common.MG_sight'
     WeaponFov=72.000000
     GunClass=Class'DH_Vehicles.DH_ShermanMountedMG'
     bHasAltFire=false
     CameraBone="mg_yaw"
     bDrawDriverInTP=false
     DrivePos=(Z=130.000000)
     ExitPositions(0)=(X=98.000000,Y=100.000000,Z=156.000000)
     ExitPositions(1)=(Y=100.000000,Z=156.000000)
     EntryRadius=130.000000
     FPCamViewOffset=(X=-1.000000,Z=4.000000)
     TPCamDistance=300.000000
     TPCamLookat=(X=-25.000000,Z=0.000000)
     TPCamWorldOffset=(Z=120.000000)
     VehiclePositionString="in a Sherman Mounted MG"
     VehicleNameString="Sherman Mounted MG"
     PitchUpLimit=3000
     PitchDownLimit=63500
}
