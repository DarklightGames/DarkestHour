//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_STG44Weapon extends DHAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\Axis_Stg44_1st.ukx

defaultproperties
{
    SelectFireAnim="select_fire"
    SelectFireIronAnim="Iron_select_fire"
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
    IronSightDisplayFOV=25.0
    ZoomInTime=0.4
    ZoomOutTime=0.1
    FreeAimRotationSpeed=7.0
    bHasSelectFire=true
    FireModeClass(0)=class'DH_Weapons.DH_STG44Fire'
    FireModeClass(1)=class'DH_Weapons.DH_STG44MeleeFire'
    SelectAnim="Draw"
    PutDownAnim="Put_away"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.7
    CurrentRating=0.7
    bSniping=true
    DisplayFOV=70.0
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_STG44Pickup'
    BobDamping=1.6
    AttachmentClass=class'DH_Weapons.DH_STG44Attachment'
    ItemName="Sturmgewehr 44"
    Mesh=SkeletalMesh'Axis_Stg44_1st.STG44-Mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.SMG.STG44_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
