//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_SpringfieldScopedWeapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="M1903 Springfield Scoped"
    FireModeClass(0)=class'DH_Weapons.DH_SpringfieldScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_SpringfieldScopedMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_SpringfieldScopedAttachment'
    PickupClass=class'DH_Weapons.DH_SpringfieldScopedPickup'

    Mesh=SkeletalMesh'DH_Springfield_1st.Springfield_Scoped'
    Skins(4)=shader'DH_Weapon_tex.Spec_Maps.M1GarandAmmo_s' // TODO: ammo specularity shader isn't used in the anim mesh & should be added there
    HighDetailOverlay=shader'DH_Weapon_tex.Spec_Maps.M1919Springfield_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    bHasScope=true
    ScopeOverlay=Texture'DH_Weapon_tex.Scopes.Springfield_Scope_Overlay'
    ScriptedScopeTexture=Texture'DH_Springfield_tex.Scopes.Scope3D'
    OverlayCorrectionX=-0.5
    DisplayFOV=90.0
    IronSightDisplayFOV=55.0
    IronSightDisplayFOVHigh=55.0
    PlayerFOVZoom=36.0 // 2.5x
    ScopePortalFOV=15.0  // worse zoom than kar98k
    ScopePortalFOVHigh=15.0
    LensMaterialID=5
    bUsesIronsightFOV=false

    MaxNumPrimaryMags=13
    InitialNumPrimaryMags=13

    IronBringUp="Scope_in"
    IronPutDown="Scope_out"
    IronIdleAnim="Scope_Idle"

    PutDownAnim="putaway"
    BoltIronAnim="iron_boltrest"
    BoltHipAnim="bolt_scope"
    PostFireIronIdleAnim=none

    SingleReloadAnim="single_insert"
    SingleReloadHalfAnim="single_insert_half"
    PreReloadAnim="single_open"
    PreReloadHalfAnim="single_open_half"
    PostReloadAnim="single_close"
}
