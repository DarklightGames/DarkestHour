//==============================================================================
// DH_StuartCannonPawn_British
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// British M5A1 (Stuart) light tank cannon pawn
//==============================================================================
class DH_StuartCannonPawn_British extends DH_StuartCannonPawn;

defaultproperties
{
     DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_turret_extB')
     DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_turret_extB')
     DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_turret_extB')
     DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_turret_extB')
     GunClass=Class'DH_Vehicles.DH_StuartCannon_British'
     VehiclePositionString="in a M5A1 Stuart cannon"
     VehicleNameString="M5A1 Stuart Cannon"
}
