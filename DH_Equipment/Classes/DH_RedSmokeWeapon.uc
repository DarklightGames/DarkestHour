//=============================================================================
// DH_RedSmokeWeapon
//=============================================================================
// Weapon class for the red signal smoke grenade
//=============================================================================

class DH_RedSmokeWeapon extends DH_GrenadeWeapon;

simulated function bool CanThrow()
{
    return false;
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    local DHPlayer DHP;

    super.BringUp(PrevWeapon);

    DHP = DHPlayer(Instigator.Controller);

    if (DHP != none)
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
     FireModeClass(0)=Class'DH_Equipment.DH_RedSmokeFire'
     FireModeClass(1)=Class'DH_Equipment.DH_RedSmokeTossFire'
     SelectAnim="Draw"
     PutDownAnim="Put_away"
     SelectAnimRate=1.000000
     PutDownAnimRate=1.000000
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.400000
     CurrentRating=0.400000
     bCanThrow=false
     DisplayFOV=70.000000
     InventoryGroup=8
     PickupClass=Class'DH_Equipment.DH_RedSmokePickup'
     PlayerViewOffset=(X=5.000000,Y=5.000000)
     BobDamping=1.600000
     AttachmentClass=Class'DH_Equipment.DH_RedSmokeAttachment'
     ItemName="M16 Red Smoke Grenade"
     Mesh=SkeletalMesh'DH_USSmokeGrenade_1st.RedSmokeGrenade'
}
