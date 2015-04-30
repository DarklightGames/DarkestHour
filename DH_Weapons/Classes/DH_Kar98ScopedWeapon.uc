//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Kar98ScopedWeapon extends DHBoltSniperWeapon;

#exec OBJ LOAD FILE=..\Animations\Axis_Kar98_1st.ukx

defaultproperties
{
    PreReloadAnim="Single_Open"
    SingleReloadAnim="Single_Insert"
    PostReloadAnim="Single_Close"
    LensMaterialID=5
    ScopePortalFOVHigh=13.0
    ScopePortalFOV=7.0
    ScopePitch=-10
    ScopeYaw=40
    ScopeYawHigh=35
    TexturedScopeTexture=texture'DH_Weapon_tex.Scopes.Ger_sniperscope_overlay'
    OverlayCorrectionX=-3.0
    OverlayCorrectionY=3.0
    IronIdleAnim="Scope_Idle"
    IronBringUp="Scope_In"
    IronPutDown="Scope_Out"
    BayonetBoneName="bayonet"
    BoltHipAnim="bolt_scope"
    BoltIronAnim="scope_bolt"
    PostFireIronIdleAnim="Scope_Idle"
    PostFireIdleAnim="Idle"
    MaxNumPrimaryMags=13
    InitialNumPrimaryMags=13
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IronSightDisplayFOV=45.0
    IronSightDisplayFOVHigh=43.0
    ZoomInTime=0.4
    ZoomOutTime=0.4
    PlayerFOVZoom=22.5
    XoffsetHighDetail=(X=-5.0)
    FireModeClass(0)=class'DH_Weapons.DH_Kar98ScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_Kar98ScopedMeleeFire'
    SelectAnim="Draw"
    PutDownAnim="Put_away"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.4
    CurrentRating=0.4
    DisplayFOV=70.0
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_Kar98ScopedPickup'
    BobDamping=1.6
    AttachmentClass=class'DH_Weapons.DH_Kar98ScopedAttachment'
    ItemName="Karabiner 98k"
    Mesh=SkeletalMesh'Axis_Kar98_1st.kar98k-scoped-mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.Rifles.k98_sniper_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
