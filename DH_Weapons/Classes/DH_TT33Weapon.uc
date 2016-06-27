//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_TT33Weapon extends DHPistolWeapon;

#exec OBJ LOAD FILE=..\Animations\Allies_Tt33_1st.ukx

defaultproperties
{
    ItemName="TT-30"
    Mesh=mesh'Allies_Tt33_1st.TT-33-Mesh'
    DrawScale=1.0
    DisplayFOV=70
    IronSightDisplayFOV=40
    BobDamping=1.6
    BayonetBoneName=Bayonet
    HighDetailOverlay=Material'Weapons1st_tex.Pistols.TT33_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
    FireModeClass(0)=class'DH_Weapons.DH_TT33Fire'
    FireModeClass(1)=class'DH_Weapons.DH_TT33MeleeFire'
    InitialNumPrimaryMags=5
    MaxNumPrimaryMags=5
    CurrentMagIndex=0
    bPlusOneLoading=true
    bHasBayonet=false
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_TT33Pickup'
    AttachmentClass=class'DH_Weapons.DH_TT33Attachment'
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    IdleEmptyAnim=idle-empty
    SelectAnim=Draw
    PutDownAnim=Put_Away
    SelectEmptyAnim=Draw_Empty
    PutDownEmptyAnim=Put_Away_empty
    MagEmptyReloadAnim=reload_empty
    MagPartialReloadAnim=reload_half
    BayoAttachAnim=Bayonet_on
    BayoDetachAnim=Bayonet_off
    IronBringUp=iron_in
    IronIdleAnim=Iron_idle
    IronIdleEmptyAnim=iron_idle_empty
    IronPutDown=iron_out
    IronBringUpEmpty=iron_in_empty
    IronPutDownEmpty=iron_out_empty
    CrawlForwardAnim=crawlF
    CrawlBackwardAnim=crawlB
    CrawlStartAnim=crawl_in
    CrawlEndAnim=crawl_out
    CrawlForwardEmptyAnim=crawlF_empty
    CrawlBackwardEmptyAnim=crawlB_empty
    CrawlStartEmptyAnim=crawl_in_empty
    CrawlEndEmptyAnim=crawl_out_empty
    SprintStartEmptyAnim=Sprint_Empty_Start
    SprintLoopEmptyAnim=Sprint_Empty_Middle
    SprintEndEmptyAnim=Sprint_Empty_End
    ZoomInTime=0.4
    ZoomOutTime=0.2
    AIRating=+0.35
    CurrentRating=0.35
    bSniping=false
    SelectForce="SwitchToAssaultRifle"
}
