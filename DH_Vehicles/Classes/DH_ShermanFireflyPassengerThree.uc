//===================================================================
// DH_ShermanPassenger
//
// Copyright (C) 2004 John "Ramm-Jaeger"  Gibson
//
// M4 Sherman passenger that rides in back
//===================================================================
class DH_ShermanFireflyPassengerThree extends DH_ROPassengerPawn;

defaultproperties
{
     PositionInArray=3
     CameraBone="body"
     DrivePos=(X=-155.000000,Y=25.000000,Z=35.000000)
     DriveRot=(Yaw=32768)
     DriveAnim="VHalftrack_Rider5_idle"
     ExitPositions(2)=(X=-100.000000,Z=100.000000)
     EntryRadius=375.000000
     FPCamViewOffset=(X=0.000000,Z=0.000000)
     TPCamDistance=200.000000
     VehiclePositionString="riding on a Sherman Mk.VC"
     VehicleNameString="Sherman Mk.VC Sherman passenger"
}
