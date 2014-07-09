//===================================================================
// KubelwagenPassengerTwo
//
// Copyright (C) 2004 John "Ramm-Jaeger"  Gibson
//
// Kubel passenger that rides in back
//===================================================================
class DH_KubelwagenPassengerTwo extends DH_ROPassengerPawn;

defaultproperties
{
     PositionInArray=1
     CameraBone="body"
     DrivePos=(X=-42.000000,Y=-30.000000,Z=3.000000)
     DriveAnim="VHalftrack_Rider2_idle"
     ExitPositions(0)=(X=-10.000000,Y=-100.000000,Z=60.000000)
     ExitPositions(1)=(X=-10.000000,Y=100.000000,Z=60.000000)
     EntryRadius=200.000000
     FPCamViewOffset=(X=0.000000,Z=0.000000)
     VehiclePositionString="in a VW Type 82"
     VehicleNameString="VW Type 82 passenger"
}
