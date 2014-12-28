//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_SpringfieldScopedWeapon extends DH_BoltSniperWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Springfield_1st.ukx
#exec OBJ LOAD FILE=..\Textures\DH_Scopeshaders.utx

defaultproperties
{
    PreReloadAnim="Single_Open"
    SingleReloadAnim="Single_Insert"
    PostReloadAnim="Single_Close"
    lenseMaterialID=5
    scopePortalFOVHigh=13.000000
    scopePortalFOV=7.000000
    scopeYaw=25
    scopePitchHigh=20
    scopeYawHigh=40
    TexturedScopeTexture=texture'DH_Weapon_tex.AlliedSmallArms.Springfield_Scope_Overlay'
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
    IronSightDisplayFOV=40.000000
    IronSightDisplayFOVHigh=43.000000
    ZoomInTime=0.400000
    ZoomOutTime=0.400000
    PlayerFOVZoom=32.000000
    XoffsetHighDetail=(X=-2.000000)
    FireModeClass(0)=class'DH_Weapons.DH_SpringfieldScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_SpringfieldScopedMeleeFire'
    SelectAnim="Draw"
    PutDownAnim="putaway"
    SelectAnimRate=1.000000
    PutDownAnimRate=1.000000
    AIRating=0.400000
    CurrentRating=0.400000
    bSniping=true
    DisplayFOV=70.000000
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_SpringfieldScopedPickup'
    BobDamping=1.600000
    AttachmentClass=class'DH_Weapons.DH_SpringfieldScopedAttachment'
    ItemName="M1903 Springfield Scoped"
    Mesh=SkeletalMesh'DH_Springfield_1st.Springfield_Scoped'
}
