//==============================================================================
// DH_ShermanCannonPawn_DDay
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// American M4A1 (Sherman) 75mm tank cannon pawn - "swimming" version
//==============================================================================
class DH_ShermanCannonPawn_DDay extends DH_ShermanCannonPawn;

defaultproperties
{
     DriverPositions(0)=(ViewPositiveYawLimit=23666,ViewNegativeYawLimit=-23666)
     DriverPositions(1)=(DriverTransitionAnim="stand_idlehip_binoc")
     DriverPositions(2)=(DriverTransitionAnim="stand_idleiron_binoc")
     GunClass=Class'DH_Vehicles.DH_ShermanCannon_DDay'
}
