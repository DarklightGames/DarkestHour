//===================================================================
// DH_StuartPassenger
//
// Copyright (C) 2004 John "Ramm-Jaeger"  Gibson
//
// M5 Stuart passenger that rides in back
//===================================================================
class DH_StuartPassengerThree extends DH_ROPassengerPawn;

defaultproperties
{
     PositionInArray=4
     CameraBone="body"
     DrivePos=(X=-80.000000,Y=57.000000,Z=50.000000)
     DriveRot=(Yaw=16384)
     DriveAnim="VHalftrack_Rider3_idle"
     ExitPositions(0)=(Y=200.000000)
     ExitPositions(1)=(X=-100.000000,Y=0.000000)
     ExitPositions(2)=(Y=-200.000000,Z=100.000000)
     EntryRadius=375.000000
     FPCamViewOffset=(X=0.000000,Z=0.000000)
     VehiclePositionString="riding a M5 Stuart"
     VehicleNameString="M5 Stuart passenger"
}
