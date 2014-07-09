//=============================================================================
// DH_G43Weapon
//=============================================================================
// Weapon class for the German G43 semi auto rifle
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================
class DH_G43Weapon extends DH_SemiAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\Axis_G43_1st.ukx

defaultproperties
{
     MagEmptyReloadAnim="reload_empty"
     MagPartialReloadAnim="reload_half"
     IronIdleAnim="Iron_idle"
     IronBringUp="iron_in"
     IronPutDown="iron_out"
     BayoAttachAnim="Bayonet_on"
     BayoDetachAnim="Bayonet_off"
     BayonetBoneName="bayonet"
     MaxNumPrimaryMags=7
     InitialNumPrimaryMags=7
     bPlusOneLoading=True
     CrawlForwardAnim="crawlF"
     CrawlBackwardAnim="crawlB"
     CrawlStartAnim="crawl_in"
     CrawlEndAnim="crawl_out"
     IronSightDisplayFOV=20.000000
     ZoomInTime=0.400000
     ZoomOutTime=0.200000
     FireModeClass(0)=Class'DH_Weapons.DH_G43Fire'
     FireModeClass(1)=Class'DH_Weapons.DH_G43MeleeFire'
     SelectAnim="Draw"
     PutDownAnim="Put_away"
     SelectAnimRate=1.000000
     PutDownAnimRate=1.000000
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.400000
     CurrentRating=0.400000
     bSniping=True
     DisplayFOV=70.000000
     bCanRestDeploy=True
     PickupClass=Class'DH_Weapons.DH_G43Pickup'
     BobDamping=1.600000
     AttachmentClass=Class'DH_Weapons.DH_G43Attachment'
     ItemName="Gewehr 43"
     Mesh=SkeletalMesh'Axis_G43_1st.G-43-Mesh'
     HighDetailOverlay=Shader'Weapons1st_tex.Rifles.G43_S'
     bUseHighDetailOverlayIndex=True
     HighDetailOverlayIndex=2
}
