//==============================================================================
// DH_CromwellMountedMGPawn
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// British Cruiser Tank Mk.VIII Cromwell Mk.IV - Besa Hull MG
//==============================================================================
class DH_CromwellMountedMGPawn extends DH_ROMountedTankMGPawn;

defaultproperties
{
     MGOverlay=Texture'DH_VehicleOptics_tex.Allied.BesaMG_sight'
     WeaponFov=38.000000
     GunClass=Class'DH_Vehicles.DH_CromwellMountedMG'
     bHasAltFire=False
     CameraBone="mg_yaw"
     bDrawDriverInTP=False
     DrivePos=(Z=130.000000)
     ExitPositions(0)=(X=100.000000,Y=-100.000000,Z=100.000000)
     ExitPositions(1)=(Y=-100.000000,Z=100.000000)
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
