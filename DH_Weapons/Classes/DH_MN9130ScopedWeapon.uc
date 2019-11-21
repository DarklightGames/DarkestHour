//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_MN9130ScopedWeapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="Mosin-Nagant M91/30 PU Sniper"
	SwayModifyFactor=0.68 // +0.08 
    FireModeClass(0)=class'DH_Weapons.DH_MN9130ScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_MN9130ScopedMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_MN9130ScopedAttachment'
    PickupClass=class'DH_Weapons.DH_MN9130ScopedPickup'

    Mesh=SkeletalMesh'Allies_Nagantscope_1st.Mosin-Nagant-9130-Scoped-Mesh'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    bHasScope=true
    bIsSniper=true
    ScopeOverlay=Texture'DH_Weapon_tex.Scopes.USSR_PU_Scope_Overlay'

    ScopeOverlaySize=0.7 // size of the scope overlay (1.0 means full screen width, 0.5 means half screen width, etc)
    DisplayFOV=70.0         // idk

    IronSightDisplayFOV=40.0
    IronSightDisplayFOVHigh=40.0

    PlayerFOVZoom=24.0 // 3.5x // The PlayerFOV the player's FOV will change too when using scoped weapons
    ScopePortalFOV=7.0
    ScopePortalFOVHigh=7.0
    LensMaterialID=5

    InitialNumPrimaryMags=10
    MaxNumPrimaryMags=10

    bUsesIronsightFOV=false

    IronBringUp="Scope_in"
    IronPutDown="Scope_out"
    IronIdleAnim="Scope_Idle"
    BoltIronAnim="scope_bolt"
    BoltHipAnim="bolt_scope"
    PreReloadAnim="single_open"
    SingleReloadAnim="single_insert"
    PostReloadAnim="single_close"
}
