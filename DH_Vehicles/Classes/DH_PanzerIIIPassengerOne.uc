//===================================================================
// DH_ShermanPassenger
//
// Copyright (C) 2004 John "Ramm-Jaeger"  Gibson
//
// M4 Sherman passenger that rides in back
//===================================================================
class DH_PanzerIIIPassengerOne extends DH_ROPassengerPawn;

defaultproperties
{
     PositionInArray=2
     CameraBone="body"
     DrivePos=(X=-90.000000,Y=-55.000000,Z=50.000000)
     DriveRot=(Yaw=-16384)
     DriveAnim="VHalftrack_Rider4_idle"
     ExitPositions(0)=(X=-90.000000)
     ExitPositions(1)=(X=-90.000000)
     ExitPositions(2)=(X=-130.000000,Y=-250.000000,Z=100.000000)
     EntryRadius=375.000000
     FPCamPos=(X=-90.000000,Y=-55.000000,Z=95.000000)
     FPCamViewOffset=(X=0.000000,Z=0.000000)
     TPCamDistance=200.000000
     VehiclePositionString="riding on a Panzer III"
     VehicleNameString="Panzer III passenger"
}
