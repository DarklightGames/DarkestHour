//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
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
    IronSightDisplayFOV=20.0
    ZoomInTime=0.4
    ZoomOutTime=0.2
    FreeAimRotationSpeed=7.0
    FireModeClass(0)=class'DH_Weapons.DH_M1CarbineFire'
    FireModeClass(1)=class'DH_Weapons.DH_M1CarbineMeleeFire'
    SelectAnim="Draw"
    PutDownAnim="putaway"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.4
    CurrentRating=0.4
    bSniping=true
    DisplayFOV=70.0
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_M1CarbinePickup'
    BobDamping=1.6
    AttachmentClass=class'DH_Weapons.DH_M1CarbineAttachment'
    ItemName="M1 Carbine"
    Mesh=SkeletalMesh'DH_M1Carbine_1st.M1Carbine'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
    SwayModifyFactor=0.9
    BobModifyFactor=0.1
}
