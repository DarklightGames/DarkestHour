//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_P38Weapon extends DH_PistolWeapon;

#exec OBJ LOAD FILE=..\Animations\Axis_P38_1st.ukx

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
    IdleEmptyAnim="idle_empty"
    IronIdleEmptyAnim="iron_idle_empty"
    IronBringUpEmpty="Iron_In_empty"
    IronPutDownEmpty="Iron_Out_empty"
    SprintStartEmptyAnim="Sprint_Empty_Start"
    SprintLoopEmptyAnim="Sprint_Empty_Middle"
    SprintEndEmptyAnim="Sprint_Empty_End"
    CrawlForwardEmptyAnim="crawlF_empty"
    CrawlBackwardEmptyAnim="crawlB_empty"
    CrawlStartEmptyAnim="crawl_in_empty"
    CrawlEndEmptyAnim="crawl_out_empty"
    SelectEmptyAnim="Draw_empty"
    PutDownEmptyAnim="put_away_empty"
    MaxNumPrimaryMags=5
    InitialNumPrimaryMags=5
    bPlusOneLoading=true
    PlayerIronsightFOV=70.0
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IronSightDisplayFOV=35.0
    ZoomInTime=0.4
    ZoomOutTime=0.4
    FireModeClass(0)=class'DH_Weapons.DH_P38Fire'
    FireModeClass(1)=class'DH_Weapons.DH_P38MeleeFire'
    SelectAnim="Draw"
    PutDownAnim="Put_away"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.35
    CurrentRating=0.35
    DisplayFOV=70.0
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_P38Pickup'
    BobDamping=1.6
    AttachmentClass=class'DH_Weapons.DH_P38Attachment'
    ItemName="Walther P38"
    Mesh=SkeletalMesh'Axis_P38_1st.P-38-Mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.Pistols.p38_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
