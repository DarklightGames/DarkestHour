//==============================================================================
// DH_ShermanCannonPawn_Camo
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// American M4A1 (Sherman) 75mm tank cannon pawn - camo version
//==============================================================================
class DH_ShermanCannonPawn_Camo extends DH_ShermanCannonPawn;

defaultproperties
{
     DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Sherman_anm.ShermanM4A1_turret_ext')
     DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Sherman_anm.ShermanM4A1_turret_ext')
     DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Sherman_anm.ShermanM4A1_turret_ext')
     DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_Sherman_anm.ShermanM4A1_turret_ext')
     GunClass=Class'DH_Vehicles.DH_ShermanCannon_Camo'
}
