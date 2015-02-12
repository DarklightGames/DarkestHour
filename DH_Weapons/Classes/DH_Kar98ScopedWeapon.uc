//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Kar98ScopedWeapon extends DH_BoltSniperWeapon;

#exec OBJ LOAD FILE=..\Animations\Axis_Kar98_1st.ukx

defaultproperties
{
    //Correction of textured scope sights
    OverlayCorrectionX=-5.0
    OverlayCorrectionY=10.0

    PreReloadAnim="Single_Open"
    SingleReloadAnim="Single_Insert"
    PostReloadAnim="Single_Close"
    lenseMaterialID=5

    scopePortalFOVHigh=13.000000
    scopePortalFOV=7.000000

    scopePitch=-10
    scopeYaw=40
    scopeYawHigh=35

    TexturedScopeTexture=texture'DH_Weapon_tex.Scopes.Ger_sniperscope_overlay'

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
    IronSightDisplayFOV=45.000000
    IronSightDisplayFOVHigh=43.000000
    ZoomInTime=0.400000
    ZoomOutTime=0.400000
    PlayerFOVZoom=22.500000
    XoffsetHighDetail=(X=-5.000000)
    FireModeClass(0)=class'DH_Weapons.DH_Kar98ScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_Kar98ScopedMeleeFire'
    SelectAnim="Draw"
    PutDownAnim="Put_away"
    SelectAnimRate=1.000000
    PutDownAnimRate=1.000000
    AIRating=0.400000
    CurrentRating=0.400000
    bSniping=true
    DisplayFOV=70.000000
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_Kar98ScopedPickup'
    BobDamping=1.600000
    AttachmentClass=class'DH_Weapons.DH_Kar98ScopedAttachment'
    ItemName="Karabiner 98k"
    Mesh=SkeletalMesh'Axis_Kar98_1st.kar98k-scoped-mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.Rifles.k98_sniper_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
