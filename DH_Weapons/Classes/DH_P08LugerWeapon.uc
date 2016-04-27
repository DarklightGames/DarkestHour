//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_P08LugerWeapon extends DHPistolWeapon;

#exec OBJ LOAD FILE=..\Animations\Axis_Luger_1st.ukx

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
    IronSightDisplayFOV=55.0
    ZoomInTime=0.4
    ZoomOutTime=0.3
    FireModeClass(0)=class'DH_Weapons.DH_P08LugerFire'
    FireModeClass(1)=class'DH_Weapons.DH_P08LugerMeleeFire'
    SelectAnim="Draw"
    PutDownAnim="Put_away"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.35
    CurrentRating=0.35
    DisplayFOV=70.0
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_P08LugerPickup'
    BobDamping=1.6
    AttachmentClass=class'DH_Weapons.DH_P08LugerAttachment'
    ItemName="Luger P08"
    Mesh=SkeletalMesh'Axis_Luger_1st.P08Luger'
    HighDetailOverlay=Shader'Weapons1st_tex.Pistols.luger_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
