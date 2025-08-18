//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MN9130ScopedPEWeapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="Mosin M91/30 (PE)"
    SwayModifyFactor=0.66 // +0.06
    FireModeClass(0)=Class'DH_MN9130ScopedPEFire'
    FireModeClass(1)=Class'DH_MN9130ScopedPEMeleeFire'
    AttachmentClass=Class'DH_MN9130ScopedPEAttachment'
    PickupClass=Class'DH_MN9130ScopedPEPickup'

    Mesh=SkeletalMesh'DH_Nagantscope_1st.mosinscopedPE_mesh'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    bHasScope=true
    bIsSniper=true
    ScopeOverlay=Texture'DH_Weapon_tex.Scopes.Textured_SovScope'
    ScriptedScopeTexture=Texture'DH_Weapon_tex.Scopes.USSR_PU_Scope_Overlay'e

    ScopeOverlaySize=0.366 // size of the scope overlay (1.0 means full screen width, 0.5 means half screen width, etc)
    DisplayFOV=82.0

    IronSightDisplayFOV=34.4
    IronSightDisplayFOVHigh=34.4

    PlayerIronsightFOV=60.0

    PlayerFOVZoom=15.0 // 4.0x // The PlayerFOV the player's FOV will change too when using scoped weapons
    ScopePortalFOV=6.9
    ScopePortalFOVHigh=6.9  //5.5 degrees, the value is higher than that because for some reason 3d scope appears with lower FOV than what is determined here
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
