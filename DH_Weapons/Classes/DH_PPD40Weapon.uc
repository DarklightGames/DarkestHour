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
    MaxNumPrimaryMags=3
    InitialNumPrimaryMags=3
    bPlusOneLoading=true
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IronSightDisplayFOV=35.0
    ZoomInTime=0.4
    ZoomOutTime=0.2
    FireModeClass(0)=class'DH_Weapons.DH_PPD40Fire'
    FireModeClass(1)=class'DH_Weapons.DH_PPD40MeleeFire'
    SelectAnim="Draw"
    PutDownAnim="Put_away"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.7
    CurrentRating=0.7
    DisplayFOV=70.0
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_PPD40Pickup'
    BobDamping=1.6
    AttachmentClass=class'DH_Weapons.DH_PPD40Attachment'
    ItemName="PPD-40"
    Mesh=SkeletalMesh'Allies_Ppd40_1st.PPD-40-Mesh'
}
