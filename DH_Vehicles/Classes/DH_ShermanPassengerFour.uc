//===================================================================
// DH_ShermanPassenger
//
// Copyright (C) 2004 John "Ramm-Jaeger"  Gibson
//
// M4 Sherman passenger that rides in back
//===================================================================
class DH_ShermanPassengerFour extends DH_ROPassengerPawn;

defaultproperties
{
     PositionInArray=5
     CameraBone="passenger_4"
     DrivePos=(X=0.000000,Y=15.000000,Z=0.000000)
     DriveRot=(Yaw=16384)
     DriveAnim="VHalftrack_Rider5_idle"
     EntryRadius=375.000000
     FPCamViewOffset=(X=0.000000,Z=0.000000)
     TPCamDistance=200.000000
     VehiclePositionString="riding on a M4A1 Sherman"
     VehicleNameString="M4A1 Sherman passenger"
}
