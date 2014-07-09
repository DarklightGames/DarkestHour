//===================================================================
// DH_ShermanPassenger
//
// Copyright (C) 2004 John "Ramm-Jaeger"  Gibson
//
// M4 Sherman passenger that rides in back
//===================================================================
class DH_PanzerIVPassengerTwo extends DH_ROPassengerPawn;

defaultproperties
{
     PositionInArray=3
     CameraBone="body"
     DrivePos=(X=-150.000000,Y=-35.000000)
     DriveRot=(Yaw=32768)
     DriveAnim="VHalftrack_Rider4_idle"
     ExitPositions(0)=(X=-200.000000,Y=-35.000000)
     ExitPositions(1)=(X=-200.000000,Y=-35.000000)
     ExitPositions(2)=(X=-120.000000,Y=-100.000000,Z=100.000000)
     ExitPositions(3)=(X=-120.000000,Y=100.000000,Z=100.000000)
     EntryRadius=375.000000
     FPCamPos=(X=-150.000000,Y=-35.000000,Z=100.000000)
     FPCamViewOffset=(X=0.000000,Z=0.000000)
     TPCamDistance=200.000000
     VehiclePositionString="riding on a Panzer IV"
     VehicleNameString="Panzer IV passenger"
}
