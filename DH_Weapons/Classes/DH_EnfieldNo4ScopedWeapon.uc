//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_EnfieldNo4ScopedWeapon extends DHBoltSniperWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_EnfieldNo4_1st.ukx

defaultproperties
{
    OverlayCorrectionX=-8.0 // correction of textured scope sights
    PreReloadAnim="Single_Open"
    SingleReloadAnim="Single_Insert"
    PostReloadAnim="Single_Close"
    LensMaterialID=5
    ScopePortalFOVHigh=13.0
    ScopePortalFOV=7.0
    ScopeYaw=25
    ScopePitchHigh=20
    ScopeYawHigh=40
    TexturedScopeTexture=texture'DH_Weapon_tex.Scopes.EnfieldNo4_Scope_Overlay'
    IronIdleAnim="Scope_Idle"
    IronBringUp="Scope_In"
    IronPutDown="Scope_Out"
    BayonetBoneName="bayonet"
    BoltHipAnim="bolt_scope"
    BoltIronAnim="iron_boltrest"
    PostFireIronIdleAnim="Iron_idle"
    PostFireIdleAnim="Idle"
    MaxNumPrimaryMags=13
    InitialNumPrimaryMags=13
    bTwoMagsCapacity=true
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IronSightDisplayFOV=40.0
    IronSightDisplayFOVHigh=43.0
    ZoomInTime=0.4
    ZoomOutTime=0.4
    PlayerFOVZoom=25.714285 // 3.5x magnification
    XoffsetHighDetail=(X=-12.0)
    FireModeClass(0)=class'DH_Weapons.DH_EnfieldNo4ScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_EnfieldNo4ScopedMeleeFire'
    SelectAnim="Draw"
    PutDownAnim="putaway"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.4
    CurrentRating=0.4
    DisplayFOV=70.0
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_EnfieldNo4ScopedPickup'
    BobDamping=1.6
    AttachmentClass=class'DH_Weapons.DH_EnfieldNo4ScopedAttachment'
    ItemName="Scoped Enfield No.4"
    Mesh=SkeletalMesh'DH_EnfieldNo4_1st.EnfieldNo4_Scoped'
}
