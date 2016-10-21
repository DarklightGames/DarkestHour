//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_SVT40ScopedWeapon extends DHSniperWeapon;

#exec OBJ LOAD FILE=..\Animations\Allies_Svt40_1st.ukx

defaultproperties
{
    LensMaterialID=4
    ItemName="SVT-40 Scoped"
    Mesh=SkeletalMesh'Allies_Svt40_1st.svt40_scoped_mesh'
    DrawScale=1.0
    DisplayFOV=70.0
    IronSightDisplayFOV=60.0
    BobDamping=1.6
    BayonetBoneName="bayonet"
    HighDetailOverlay=material'Weapons1st_tex.Rifles.SVT40_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
    FireModeClass(0)=class'DH_Weapons.DH_SVT40ScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_SVT40ScopedMeleeFire'
    InitialNumPrimaryMags=6
    MaxNumPrimaryMags=6
    CurrentMagIndex=0
    bPlusOneLoading=true
    bHasBayonet=false
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_SVT40ScopedPickup'
    AttachmentClass=class'DH_Weapons.DH_SVT40ScopedAttachment'
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    SelectAnim="Draw"
    PutDownAnim="Put_Away"
    MagEmptyReloadAnim="reload_empty"
    MagPartialReloadAnim="reload_half"
    IronBringUp="Scope_in"
    IronIdleAnim="Scope_Idle"
    IronPutDown="Scope_out"
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    ZoomInTime=0.4
    ZoomOutTime=0.2
    PlayerFOVZoom=24.0 // the PlayerFOV when using the scope in iron sight mode - 3.5x
    ScopePortalFOV=8.0 // 3.5x
    XoffsetScoped=(X=0.0,Y=0.0,Z=0.0)
    ScopePitch=-10
    ScopeYaw=40
    ScopePortalFOVHigh=15.0 // 3.5x
    IronSightDisplayFOVHigh=32.0
    XoffsetHighDetail=(X=0.0,Y=0.0,Z=0.0)
    ScopePitchHigh=0
    ScopeYawHigh=35
    AIRating=0.4
    CurrentRating=0.4
    bSniping=true
    TexturedScopeTexture=texture'DH_Weapon_tex.Scopes.USSR_PU_Scope_Overlay'
}
