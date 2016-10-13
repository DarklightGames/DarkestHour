//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_SpringfieldScopedWeapon extends DHBoltSniperWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Springfield_1st.ukx

defaultproperties
{
    PreReloadAnim="Single_Open"
    SingleReloadAnim="Single_Insert"
    PostReloadAnim="Single_Close"
    LensMaterialID=5
    ScopePortalFOVHigh=13.0
    ScopePortalFOV=7.0
    ScopeYaw=25
    ScopePitchHigh=20
    ScopeYawHigh=40
    TexturedScopeTexture=texture'DH_Weapon_tex.Scopes.Springfield_Scope_Overlay'
    IronIdleAnim="Scope_Idle"
    IronBringUp="Scope_In"
    IronPutDown="Scope_Out"
    BayonetBoneName="bayonet"
    BoltHipAnim="bolt_scope"
    BoltIronAnim="iron_boltrest"
    PostFireIronIdleAnim="Iron_idlerest"
    PostFireIdleAnim="Idle"
    MaxNumPrimaryMags=13
    InitialNumPrimaryMags=13
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IronSightDisplayFOV=40.0
    IronSightDisplayFOVHigh=43.0
    ZoomInTime=0.4
    ZoomOutTime=0.4
    PlayerFOVZoom=36.0 // 2.5x magnification
    XoffsetHighDetail=(X=-2.0)
    FireModeClass(0)=class'DH_Weapons.DH_SpringfieldScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_SpringfieldScopedMeleeFire'
    SelectAnim="Draw"
    PutDownAnim="putaway"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.4
    CurrentRating=0.4
    bSniping=true
    DisplayFOV=70.0
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_SpringfieldScopedPickup'
    BobDamping=1.6
    AttachmentClass=class'DH_Weapons.DH_SpringfieldScopedAttachment'
    ItemName="M1903 Springfield Scoped"
    Mesh=SkeletalMesh'DH_Springfield_1st.Springfield_Scoped'
    OverlayCorrectionX=-0.5
}
