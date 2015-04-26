//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ThompsonWeapon extends DHAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Thompson_1st.ukx

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
    FireModeClass(0)=class'DH_Weapons.DH_ThompsonFire'
    FireModeClass(1)=class'DH_Weapons.DH_ThompsonMeleeFire'
    SelectAnim="Draw"
    PutDownAnim="putaway"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.7
    CurrentRating=0.7
    DisplayFOV=70.0
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_ThompsonPickup'
    BobDamping=1.6
    AttachmentClass=class'DH_Weapons.DH_ThompsonAttachment'
    ItemName="M1A1 Thompson"
    Mesh=SkeletalMesh'DH_Thompson_1st.M1A1_Thompson'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
