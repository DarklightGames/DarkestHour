//===================================================================
// DH_HetzerPassenger
//
// Hetzer passenger that rides on engine deck
//===================================================================
class DH_HetzerPassengerOne extends DH_ROPassengerPawn;

defaultproperties
{
     PositionInArray=2
     CameraBone="body"
     DrivePos=(X=-70.000000,Y=-25.000000,Z=112.000000)
     DriveRot=(Pitch=3850)
     DriveAnim="crouch_idle_binoc"
     ExitPositions(0)=(X=-50.000000,Y=-100.000000)
     ExitPositions(1)=(X=-50.000000,Y=150.000000)
     EntryRadius=375.000000
     FPCamViewOffset=(X=0.000000,Z=0.000000)
     VehiclePositionString="riding on a Hetzer"
     VehicleNameString="Hetzer passenger"
}
