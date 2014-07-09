//===================================================================
// DH_ShermanPassenger
//
// Copyright (C) 2004 John "Ramm-Jaeger"  Gibson
//
// M4 Sherman passenger that rides in back
//===================================================================
class DH_ShermanJumboPassengerFour extends DH_ROPassengerPawn;

defaultproperties
{
     PositionInArray=5
     CameraBone="passenger_4"
     DrivePos=(X=0.000000,Y=10.000000,Z=3.000000)
     DriveRot=(Yaw=16384)
     DriveAnim="VHalftrack_Rider5_idle"
     ExitPositions(0)=(Y=200.000000)
     ExitPositions(1)=(Y=-200.000000)
     ExitPositions(2)=(X=-100.000000,Z=100.000000)
     EntryRadius=375.000000
     FPCamViewOffset=(X=0.000000,Z=0.000000)
     TPCamDistance=200.000000
     VehiclePositionString="riding on a M4A3E2 Sherman"
     VehicleNameString="M4A3E2 Sherman passenger"
}
