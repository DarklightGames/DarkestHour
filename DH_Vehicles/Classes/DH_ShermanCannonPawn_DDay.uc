//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ShermanCannonPawn_DDay extends DH_ShermanCannonPawn;

defaultproperties
{
    DriverPositions(0)=(ViewPositiveYawLimit=23666,ViewNegativeYawLimit=-23666)
    DriverPositions(1)=(DriverTransitionAnim="stand_idlehip_binoc")
    DriverPositions(2)=(DriverTransitionAnim="stand_idleiron_binoc")
    GunClass=class'DH_Vehicles.DH_ShermanCannon_DDay'
}
