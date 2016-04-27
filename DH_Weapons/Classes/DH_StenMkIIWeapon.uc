//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_StenMkIIWeapon extends DHAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Sten_1st.ukx

defaultproperties
{
    SelectFireAnim="switch_fire"
    SelectFireIronAnim="Iron_switch_fire"
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
    bHasSelectFire=true
    FireModeClass(0)=class'DH_Weapons.DH_StenMkIIFire'
    FireModeClass(1)=class'DH_Weapons.DH_StenMkIIMeleeFire'
    SelectAnim="Draw"
    PutDownAnim="putaway"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.7
    CurrentRating=0.7
    DisplayFOV=70.0
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_StenMkIIPickup'
    BobDamping=1.6
    AttachmentClass=class'DH_Weapons.DH_StenMkIIAttachment'
    ItemName="Sten MkII"
    Mesh=SkeletalMesh'DH_Sten_1st.StenMkII'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
