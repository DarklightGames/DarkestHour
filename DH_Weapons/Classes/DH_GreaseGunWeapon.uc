//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_GreaseGunWeapon extends DHAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_M3GreaseGun_1st.ukx

defaultproperties
{
    MagEmptyReloadAnim="reload_empty"
    MagPartialReloadAnim="reload_half"
    IronIdleAnim="Iron_idle"
    IronBringUp="iron_in"
    IronPutDown="iron_out"
    MaxNumPrimaryMags=7
    InitialNumPrimaryMags=7
    bPlusOneLoading=true
    PlayerIronsightFOV=65.0
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IronSightDisplayFOV=30.0
    ZoomInTime=0.4
    ZoomOutTime=0.2
    FireModeClass(0)=class'DH_Weapons.DH_GreaseGunFire'
    FireModeClass(1)=class'DH_Weapons.DH_GreaseGunMeleeFire'
    SelectAnim="Draw"
    PutDownAnim="putaway"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.7
    CurrentRating=0.7
    DisplayFOV=70.0
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_GreaseGunPickup'
    BobDamping=1.6
    AttachmentClass=class'DH_Weapons.DH_GreaseGunAttachment'
    ItemName="M3 Grease Gun"
    Mesh=SkeletalMesh'DH_M3GreaseGun_1st.M3GreaseGun'
    HighDetailOverlay=Shader'DH_Weapon_tex.Spec_Maps.M3GeaseGun_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
