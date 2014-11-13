//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_EnfieldNo2Weapon extends DH_PistolWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_EnfieldNo2_1st.ukx

defaultproperties
{
     MagEmptyReloadAnim="reload_empty"
     MagPartialReloadAnim="reload_half"
     IronIdleAnim="Iron_idle"
     IronBringUp="iron_in"
     IronPutDown="iron_out"
     IdleEmptyAnim="Idle"
     IronIdleEmptyAnim="Iron_idle"
     IronBringUpEmpty="iron_in"
     IronPutDownEmpty="iron_out"
     SprintStartEmptyAnim="Sprint_Start"
     SprintLoopEmptyAnim="Sprint_Middle"
     SprintEndEmptyAnim="Sprint_end"
     CrawlForwardEmptyAnim="crawlF"
     CrawlBackwardEmptyAnim="crawlB"
     CrawlStartEmptyAnim="crawl_in"
     CrawlEndEmptyAnim="crawl_out"
     SelectEmptyAnim="Draw"
     PutDownEmptyAnim="putaway"
     MaxNumPrimaryMags=5
     InitialNumPrimaryMags=5
     bPlusOneLoading=true
     PlayerIronsightFOV=70.000000
     CrawlForwardAnim="crawlF"
     CrawlBackwardAnim="crawlB"
     CrawlStartAnim="crawl_in"
     CrawlEndAnim="crawl_out"
     IronSightDisplayFOV=40.000000
     ZoomInTime=0.400000
     ZoomOutTime=0.200000
     FireModeClass(0)=class'DH_Weapons.DH_EnfieldNo2Fire'
     FireModeClass(1)=class'DH_Weapons.DH_EnfieldNo2MeleeFire'
     SelectAnim="Draw"
     PutDownAnim="putaway"
     SelectAnimRate=1.000000
     PutDownAnimRate=1.000000
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.350000
     CurrentRating=0.350000
     DisplayFOV=70.000000
     bCanRestDeploy=true
     PickupClass=class'DH_Weapons.DH_EnfieldNo2Pickup'
     BobDamping=1.600000
     AttachmentClass=class'DH_Weapons.DH_EnfieldNo2Attachment'
     ItemName="Enfield No2 Revolver"
     Mesh=SkeletalMesh'DH_EnfieldNo2_1st.EnfieldNo2'
}
