//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PPD40Weapon extends DHFastAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\Allies_Ppd40_1st.ukx

defaultproperties
{
    MagEmptyReloadAnim="reload_empty"
    MagPartialReloadAnim="reload_half"
    IronIdleAnim="Iron_idle"
    IronBringUp="iron_in"
    IronPutDown="iron_out"
    MaxNumPrimaryMags=2
    InitialNumPrimaryMags=2
    bPlusOneLoading=true
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IronSightDisplayFOV=35.000000
    ZoomInTime=0.400000
    ZoomOutTime=0.200000
    FireModeClass(0)=class'DH_Weapons.DH_PPD40Fire'
    FireModeClass(1)=class'DH_Weapons.DH_PPD40MeleeFire'
    SelectAnim="Draw"
    PutDownAnim="Put_away"
    SelectAnimRate=1.000000
    PutDownAnimRate=1.000000
    AIRating=0.700000
    CurrentRating=0.700000
    DisplayFOV=70.000000
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_PPD40Pickup'
    BobDamping=1.600000
    AttachmentClass=class'DH_Weapons.DH_PPD40Attachment'
    ItemName="PPD-40"
    Mesh=SkeletalMesh'Allies_Ppd40_1st.PPD-40-Mesh'
}
