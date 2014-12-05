//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_MP40Weapon extends DH_AutoWeapon;

#exec OBJ LOAD FILE=..\Animations\Axis_Mp40_1st.ukx

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
    PlayerIronsightFOV=65.000000
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IronSightDisplayFOV=35.000000
    ZoomInTime=0.400000
    ZoomOutTime=0.150000
    FireModeClass(0)=class'DH_Weapons.DH_MP40Fire'
    FireModeClass(1)=class'DH_Weapons.DH_MP40MeleeFire'
    SelectAnim="Draw"
    PutDownAnim="Put_away"
    SelectAnimRate=1.000000
    PutDownAnimRate=1.000000
    SelectForce="SwitchToAssaultRifle"
    AIRating=0.700000
    CurrentRating=0.700000
    DisplayFOV=70.000000
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_MP40Pickup'
    BobDamping=1.600000
    AttachmentClass=class'DH_Weapons.DH_MP40Attachment'
    ItemName="Maschinenpistole 40"
    Mesh=SkeletalMesh'Axis_Mp40_1st.mp40-mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.SMG.MP40_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
