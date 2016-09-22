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
    MaxNumPrimaryMags=8
    InitialNumPrimaryMags=8
    bPlusOneLoading=true
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IronSightDisplayFOV=35.0
    ZoomInTime=0.4
    ZoomOutTime=0.2
    FireModeClass(0)=class'DH_Weapons.DH_PPS43Fire'
    FireModeClass(1)=class'DH_Weapons.DH_PPS43MeleeFire'
    SelectAnim="Draw"
    PutDownAnim="Put_away"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.7
    CurrentRating=0.7
    DisplayFOV=70.0
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_PPS43Pickup'
    BobDamping=1.6
    AttachmentClass=class'DH_Weapons.DH_PPS43Attachment'
    ItemName="PPS-43"
    Mesh=SkeletalMesh'Allies_Pps43_1st.PPS-43-Mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.SMG.PPS43_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
