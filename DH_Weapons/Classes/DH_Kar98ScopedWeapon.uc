//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_Kar98ScopedWeapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="Karabiner 98k"
    FireModeClass(0)=class'DH_Weapons.DH_Kar98ScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_Kar98ScopedMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_Kar98ScopedAttachment'
    PickupClass=class'DH_Weapons.DH_Kar98ScopedPickup'

    Mesh=SkeletalMesh'DH_Kar98_1st.kar98k-scoped-mesh'
    HighDetailOverlay=shader'Weapons1st_tex.Rifles.k98_sniper_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    bHasScope=true
    ScopeOverlay=Texture'DH_Weapon_tex.Scopes.Ger_sniperscope_overlay'
    IronSightDisplayFOV=45.0
    PlayerFOVZoom=22.5
    ScopePortalFOV=7.0

    MaxNumPrimaryMags=13
    InitialNumPrimaryMags=13

    IronBringUp="Scope_in"
    IronPutDown="Scope_out"
    IronIdleAnim="Scope_Idle"

    BoltIronAnim="scope_bolt"
    BoltHipAnim="bolt_scope"

    MagEmptyReloadAnim="reload_empty"
    MagPartialReloadAnim="reload_half"

    SingleReloadAnim="single_insert"
    SingleReloadHalfAnim="single_insert_half"

    PreReloadAnim="single_open"
    PreReloadHalfAnim="single_open_half"

    PostReloadAnim="single_close"
}
