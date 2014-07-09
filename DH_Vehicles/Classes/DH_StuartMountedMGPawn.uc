//==============================================================================
// DH_StuartMountedMGPawn
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// American M5A1 (Stuart) light tank MG pawn
//==============================================================================
class DH_StuartMountedMGPawn extends DH_ROMountedTankMGPawn;

defaultproperties
{
     OverlayCenterSize=0.700000
     MGOverlay=Texture'Vehicle_Optic.Scopes.MG_sight'
     WeaponFov=72.000000
     GunClass=Class'DH_Vehicles.DH_StuartMountedMG'
     bHasAltFire=False
     CameraBone="mg_yaw"
     bDrawDriverInTP=False
     bDesiredBehindView=False
     DrivePos=(Z=130.000000)
     ExitPositions(0)=(X=90.000000,Y=100.000000,Z=156.000000)
     ExitPositions(1)=(Y=100.000000,Z=156.000000)
     EntryRadius=130.000000
     FPCamViewOffset=(X=-1.000000,Z=4.000000)
     TPCamDistance=300.000000
     TPCamLookat=(X=-25.000000,Z=0.000000)
     TPCamWorldOffset=(Z=120.000000)
     VehiclePositionString="in a Stuart Mounted MG"
     VehicleNameString="Stuart Mounted MG"
     PitchUpLimit=3000
     PitchDownLimit=63000
}
