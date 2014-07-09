//===================================================================
// DH_Stug3GPassenger
//
// Copyright (C) 2004 John "Ramm-Jaeger"  Gibson
//
// StuGIII passenger that rides in back
//===================================================================
class DH_Stug3GPassengerFour extends DH_ROPassengerPawn;

defaultproperties
{
     PositionInArray=5
     CameraBone="passenger_04x"
     DrivePos=(X=0.000000,Y=0.000000,Z=57.000000)
     DriveRot=(Pitch=1800)
     DriveAnim="crouch_idle_binoc"
     ExitPositions(0)=(X=-120.000000,Y=0.000000)
     ExitPositions(2)=(Y=-200.000000,Z=100.000000)
     EntryRadius=375.000000
     FPCamViewOffset=(X=0.000000,Z=0.000000)
     VehiclePositionString="riding on a StuG III Ausf.G"
     VehicleNameString="StuG III Ausf.G passenger"
}
