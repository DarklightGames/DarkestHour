//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_MN9130ScopedWeapon extends DHBoltSniperWeapon;

#exec OBJ LOAD FILE=..\Animations\Allies_Nagantscope_1st.ukx

defaultproperties
{
    LensMaterialID=5
    ItemName="Mosin-Nagant M91/30 PU Sniper"
    Mesh=mesh'Allies_Nagantscope_1st.Mosin-Nagant-9130-Scoped-Mesh'
    DrawScale=1.0
    DisplayFOV=70
    IronSightDisplayFOV=40
    BobDamping=1.6
    BayonetBoneName=Bayonet
    HighDetailOverlay=Material'Weapons1st_tex.Rifles.MN_sniper_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
    FireModeClass(0)=class'DH_Weapons.DH_MN9130ScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_MN9130ScopedMeleeFire'
    InitialNumPrimaryMags=10
    MaxNumPrimaryMags=10
    CurrentMagIndex=0
    bPlusOneLoading=false
    bHasBayonet=false
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_MN9130ScopedPickup'
    AttachmentClass=class'DH_Weapons.DH_MN9130ScopedAttachment'
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    SelectAnim=Draw
    PutDownAnim=Put_Away
    PreReloadAnim=Single_Open
    SingleReloadAnim=Single_insert
    PostReloadAnim=Single_Close
    IronBringUp=Scope_in
    IronIdleAnim=Scope_Idle
    IronPutDown=Scope_out
    CrawlForwardAnim=crawlF
    CrawlBackwardAnim=crawlB
    CrawlStartAnim=crawl_in
    CrawlEndAnim=crawl_out
    PostFireIronIdleAnim=Scope_Idle
    PostFireIdleAnim=Idle
    BoltHipAnim=bolt_scope
    BoltIronAnim=scope_bolt
    ZoomInTime=0.4
    ZoomOutTime=0.4
    PlayerFOVZoom=24
    scopePortalFOV=7.0// 3.5x
    XoffsetScoped=(X=0.0,Y=0.0,Z=0.0)
    scopePitch=0
    scopeYaw=25
    scopePortalFOVHigh=15 // 3.5x
    IronSightDisplayFOVHigh=43//4
    XoffsetHighDetail=(X=-6.0,Y=0.0,Z=0.0)
    scopePitchHigh=20
    scopeYawHigh=40
    AIRating=+0.4
    CurrentRating=0.4
    bSniping=true

    TexturedScopeTexture=Texture'Weapon_overlays.Scopes.Rus_sniperscope_overlay'
}
