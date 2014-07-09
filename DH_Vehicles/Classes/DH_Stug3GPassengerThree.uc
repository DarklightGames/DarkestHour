//===================================================================
// DH_Stug3GPassenger
//
// Copyright (C) 2004 John "Ramm-Jaeger"  Gibson
//
// StuGIII passenger that rides in back
//===================================================================
class DH_Stug3GPassengerThree extends DH_ROPassengerPawn;

defaultproperties
{
     PositionInArray=4
     CameraBone="passenger_03"
     DrivePos=(X=10.000000,Y=0.000000,Z=84.000000)
     DriveRot=(Pitch=32768,Yaw=26500)
     DriveAnim="VHalftrack_Rider3_idle"
     ExitPositions(0)=(Y=200.000000)
     ExitPositions(1)=(Y=-200.000000)
     ExitPositions(2)=(X=-100.000000,Z=100.000000)
     EntryRadius=375.000000
     FPCamViewOffset=(X=0.000000,Z=0.000000)
     VehiclePositionString="riding on a StuG III Ausf.G"
     VehicleNameString="StuG III Ausf.G passenger"
}
