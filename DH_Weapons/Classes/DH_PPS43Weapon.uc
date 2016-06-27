//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PPS43Weapon extends DHFastAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\Allies_Pps43_1st.ukx

defaultproperties
{
     MagEmptyReloadAnim="reload_empty"
     MagPartialReloadAnim="reload_half"
     IronIdleAnim="Iron_idle"
     IronBringUp="iron_in"
     IronPutDown="iron_out"
     MaxNumPrimaryMags=4
     InitialNumPrimaryMags=4
     bPlusOneLoading=true
     CrawlForwardAnim="crawlF"
     CrawlBackwardAnim="crawlB"
     CrawlStartAnim="crawl_in"
     CrawlEndAnim="crawl_out"
     IronSightDisplayFOV=35.000000
     ZoomInTime=0.400000
     ZoomOutTime=0.200000
     FireModeClass(0)=class'DH_Weapons.DH_PPS43Fire'
     FireModeClass(1)=class'DH_Weapons.DH_PPS43MeleeFire'
     SelectAnim="Draw"
     PutDownAnim="Put_away"
     SelectAnimRate=1.000000
     PutDownAnimRate=1.000000
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.700000
     CurrentRating=0.700000
     DisplayFOV=70.000000
     bCanRestDeploy=true
     PickupClass=class'DH_Weapons.DH_PPS43Pickup'
     BobDamping=1.600000
     AttachmentClass=class'DH_Weapons.DH_PPS43Attachment'
     ItemName="PPS-43"
     Mesh=SkeletalMesh'Allies_Pps43_1st.PPS-43-Mesh'
     HighDetailOverlay=Shader'Weapons1st_tex.SMG.PPS43_S'
     bUseHighDetailOverlayIndex=true
     HighDetailOverlayIndex=2
}
