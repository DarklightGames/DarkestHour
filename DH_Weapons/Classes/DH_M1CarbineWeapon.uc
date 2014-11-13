//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_M1CarbineWeapon extends DH_SemiAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_M1Carbine_1st.ukx

defaultproperties
{
     MagEmptyReloadAnim="reload_empty"
     MagPartialReloadAnim="reload_half"
     IronIdleAnim="Iron_idle"
     IronBringUp="iron_in"
     IronBringUpRest="iron_inrest"
     IronPutDown="iron_out"
     IdleEmptyAnim="idle_empty"
     IronIdleEmptyAnim="iron_idle_empty"
     MaxNumPrimaryMags=9
     InitialNumPrimaryMags=9
     bPlusOneLoading=true
     CrawlForwardAnim="crawlF"
     CrawlBackwardAnim="crawlB"
     CrawlStartAnim="crawl_in"
     CrawlEndAnim="crawl_out"
     IronSightDisplayFOV=20.000000
     ZoomInTime=0.400000
     ZoomOutTime=0.200000
     FreeAimRotationSpeed=7.000000
     FireModeClass(0)=Class'DH_Weapons.DH_M1CarbineFire'
     FireModeClass(1)=Class'DH_Weapons.DH_M1CarbineMeleeFire'
     SelectAnim="Draw"
     PutDownAnim="putaway"
     SelectAnimRate=1.000000
     PutDownAnimRate=1.000000
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.400000
     CurrentRating=0.400000
     bSniping=true
     DisplayFOV=70.000000
     bCanRestDeploy=true
     PickupClass=Class'DH_Weapons.DH_M1CarbinePickup'
     BobDamping=1.600000
     AttachmentClass=Class'DH_Weapons.DH_M1CarbineAttachment'
     ItemName="M1 Carbine"
     Mesh=SkeletalMesh'DH_M1Carbine_1st.M1Carbine'
     bUseHighDetailOverlayIndex=true
     HighDetailOverlayIndex=2
}
