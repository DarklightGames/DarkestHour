//=============================================================================
// DH_OrangeSmokeWeapon
//=============================================================================
// Weapon class for the German Rauchsichtzeichen
//=============================================================================

class DH_OrangeSmokeWeapon extends DH_GrenadeWeapon;

simulated function bool CanThrow()
{
	return false;
}

simulated function BringUp(optional Weapon PrevWeapon)
{
	local DHPlayer DHP;

	super.BringUp(PrevWeapon);

	DHP = DHPlayer(Instigator.Controller);

	if(DHP != none)
		DHP.QueueHint(3, false);
}

defaultproperties
{
     PreFireHoldAnim="pre_fire_idle"
     FuzeLength=5.000000
     CrawlForwardAnim="crawlF"
     CrawlBackwardAnim="crawlB"
     CrawlStartAnim="crawl_in"
     CrawlEndAnim="crawl_out"
     FireModeClass(0)=Class'DH_Equipment.DH_OrangeSmokeFire'
     FireModeClass(1)=Class'DH_Equipment.DH_OrangeSmokeTossFire'
     SelectAnim="Draw"
     PutDownAnim="Put_away"
     SelectAnimRate=1.000000
     PutDownAnimRate=1.000000
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.400000
     CurrentRating=0.400000
     bCanThrow=False
     DisplayFOV=70.000000
     InventoryGroup=8
     PickupClass=Class'DH_Equipment.DH_OrangeSmokePickup'
     PlayerViewOffset=(X=5.000000,Y=5.000000)
     BobDamping=1.600000
     AttachmentClass=Class'DH_Equipment.DH_OrangeSmokeAttachment'
     ItemName="RauchSichtzeichen Orange 160"
     Mesh=SkeletalMesh'DH_GermanSmokeGrenade_1st.OrangeSmokeGrenade'
}
