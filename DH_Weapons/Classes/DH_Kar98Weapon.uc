//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Kar98Weapon extends DH_BoltActionWeapon;

#exec OBJ LOAD FILE=..\Animations\Axis_Kar98_1st.ukx

defaultproperties
{
     MagEmptyReloadAnim="Reload"
     IronIdleAnim="Iron_idle"
     IronBringUp="iron_in"
     IronBringUpRest="iron_inrest"
     IronPutDown="iron_out"
     BayoAttachAnim="Bayonet_on"
     BayoDetachAnim="Bayonet_off"
     BayonetBoneName="bayonet"
     bHasBayonet=true
     BoltHipAnim="bolt"
     BoltIronAnim="iron_boltrest"
     PostFireIronIdleAnim="Iron_idlerest"
     PostFireIdleAnim="Idle"
     MaxNumPrimaryMags=13
     InitialNumPrimaryMags=13
     CrawlForwardAnim="crawlF"
     CrawlBackwardAnim="crawlB"
     CrawlStartAnim="crawl_in"
     CrawlEndAnim="crawl_out"
     IronSightDisplayFOV=25.000000
     ZoomInTime=0.400000
     ZoomOutTime=0.400000
     FireModeClass(0)=Class'DH_Weapons.DH_Kar98Fire'
     FireModeClass(1)=Class'DH_Weapons.DH_Kar98MeleeFire'
     SelectAnim="Draw"
     PutDownAnim="Put_away"
     SelectAnimRate=1.000000
     PutDownAnimRate=1.000000
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.400000
     CurrentRating=0.400000
     bSniping=true
     DisplayFOV=70.000000
     bCanRestDeploy=true
     PickupClass=Class'DH_Weapons.DH_Kar98Pickup'
     BobDamping=1.600000
     AttachmentClass=Class'DH_Weapons.DH_Kar98Attachment'
     ItemName="Karabiner 98k"
     Mesh=SkeletalMesh'Axis_Kar98_1st.kar98k_mesh'
     HighDetailOverlay=Shader'Weapons1st_tex.Rifles.k98_s'
     bUseHighDetailOverlayIndex=true
     HighDetailOverlayIndex=2
}
