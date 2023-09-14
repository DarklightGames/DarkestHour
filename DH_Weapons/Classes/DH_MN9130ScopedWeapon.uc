//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_MN9130ScopedWeapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="Mosin M91/30 (PU)"
    SwayModifyFactor=0.66 // +0.06
    FireModeClass(0)=class'DH_Weapons.DH_MN9130ScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_MN9130ScopedMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_MN9130ScopedAttachment'
    PickupClass=class'DH_Weapons.DH_MN9130ScopedPickup'

    Mesh=SkeletalMesh'DH_Nagantscope_1st.mosinscoped_mesh'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    bHasScope=true
    bIsSniper=true
    ScopeOverlay=Texture'DH_Weapon_tex.Scopes.USSR_PU_Scope_Overlay'
    //ScriptedScopeTexture=Texture'DH_Weapon_tex.Scopes.USSR_PU_Scope_Overlay' //to do: proper 3d scope texture

    ScopeOverlaySize=0.266 // size of the scope overlay (1.0 means full screen width, 0.5 means half screen width, etc)
    DisplayFOV=82.0

    IronSightDisplayFOV=45.5
    IronSightDisplayFOVHigh=45.5

    PlayerIronsightFOV=60.0

    PlayerFOVZoom=17.143 // 3.5x // The PlayerFOV the player's FOV will change too when using scoped weapons
    ScopePortalFOV=5.8
    ScopePortalFOVHigh=5.8  //4.5 degrees, the value is higher than that because for some reason 3d scope appears with lower FOV than what is determined here
    LensMaterialID=5
    bUsesIronsightFOV=true

    InitialNumPrimaryMags=10
    MaxNumPrimaryMags=10

    IronBringUp="Scope_in"
    IronPutDown="Scope_out"
    IronIdleAnim="Scope_Idle"
    BoltIronAnim="scope_bolt"
    BoltHipAnim="bolt_scope"
    PreReloadAnim="single_open"
    SingleReloadAnim="single_insert"
    PostReloadAnim="single_close"
}
