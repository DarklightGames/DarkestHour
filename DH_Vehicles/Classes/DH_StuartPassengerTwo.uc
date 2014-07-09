//===================================================================
// DH_StuartPassenger
//
// Copyright (C) 2004 John "Ramm-Jaeger"  Gibson
//
// M5 Stuart passenger that rides in back
//===================================================================
class DH_StuartPassengerTwo extends DH_ROPassengerPawn;

defaultproperties
{
     PositionInArray=3
     CameraBone="body"
     DrivePos=(X=-108.000000,Y=0.000000,Z=57.000000)
     DriveRot=(Pitch=3640,Yaw=32768)
     DriveAnim="VHalftrack_Rider2_idle"
     ExitPositions(0)=(X=-100.000000,Y=0.000000)
     ExitPositions(2)=(Y=-200.000000,Z=100.000000)
     EntryRadius=375.000000
     FPCamViewOffset=(X=0.000000,Z=0.000000)
     VehiclePositionString="riding a M5 Stuart"
     VehicleNameString="M5 Stuart passenger"
}
