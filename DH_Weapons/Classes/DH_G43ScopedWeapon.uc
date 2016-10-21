//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_G43ScopedWeapon extends DHSniperWeapon;

#exec OBJ LOAD FILE=..\Animations\Axis_G43_1st.ukx

defaultproperties
{
    LensMaterialID=4
    ScopePortalFOVHigh=13.0
    ScopePortalFOV=7.0
    ScopePitch=-10
    ScopeYaw=40
    ScopeYawHigh=35
    TexturedScopeTexture=texture'DH_Weapon_tex.AxisSmallArms.Ger_sniperscope_overlay'
    MagEmptyReloadAnim="reload_empty"
    MagPartialReloadAnim="reload_half"
    IronIdleAnim="Scope_Idle"
    IronBringUp="Scope_In"
    IronPutDown="Scope_Out"
    MaxNumPrimaryMags=8
    InitialNumPrimaryMags=8
    bPlusOneLoading=true
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IronSightDisplayFOV=45.0
    IronSightDisplayFOVHigh=25.0
    ZoomInTime=0.4
    ZoomOutTime=0.2
    PlayerFOVZoom=22.5
    FireModeClass(0)=class'DH_Weapons.DH_G43ScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_G43MeleeFire'
    SelectAnim="Draw"
    PutDownAnim="Put_away"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.4
    CurrentRating=0.4
    DisplayFOV=70.0
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_G43ScopedPickup'
    BobDamping=1.6
    AttachmentClass=class'DH_Weapons.DH_G43ScopedAttachment'
    ItemName="Gewehr 43"
    Mesh=SkeletalMesh'Axis_G43_1st.g43_scoped_mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.Rifles.g43_sniper_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
