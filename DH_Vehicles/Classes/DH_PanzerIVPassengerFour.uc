//===================================================================
// DH_ShermanPassenger
//
// Copyright (C) 2004 John "Ramm-Jaeger"  Gibson
//
// M4 Sherman passenger that rides in back
//===================================================================
class DH_PanzerIVPassengerFour extends DH_ROPassengerPawn;

defaultproperties
{
     PositionInArray=5
     CameraBone="body"
     DrivePos=(X=-115.000000,Y=70.000000)
     DriveRot=(Yaw=16384)
     DriveAnim="VHalftrack_Rider6_idle"
     ExitPositions(0)=(X=-115.000000,Y=150.000000)
     ExitPositions(1)=(X=-115.000000,Y=-200.000000)
     ExitPositions(2)=(X=-180.000000,Y=90.000000,Z=100.000000)
     EntryRadius=375.000000
     FPCamPos=(X=-115.000000,Y=70.000000,Z=100.000000)
     FPCamViewOffset=(X=0.000000,Z=0.000000)
     TPCamDistance=200.000000
     VehiclePositionString="riding on a Panzer IV"
     VehicleNameString="Panzer IV passenger"
}
