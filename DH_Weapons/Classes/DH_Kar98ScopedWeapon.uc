//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Kar98ScopedWeapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="Kar 98k (ZF39)"
    NativeItemName="Karabiner 98k (ZF39)"
    FireModeClass(0)=Class'DH_Kar98ScopedFire'
    FireModeClass(1)=Class'DH_Kar98ScopedMeleeFire'
    AttachmentClass=Class'DH_Kar98ScopedAttachment'
    PickupClass=Class'DH_Kar98ScopedPickup'

    Mesh=SkeletalMesh'DH_Kar98_1st.DH_kar98k_scoped_mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.k98_sniper_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    bHasScope=true
    bIsSniper=true
    ScopeOverlay=Texture'DH_Weapon_tex.Scopes.Textured_GerScope'
	ScriptedScopeTexture=Texture'DH_Weapon_tex.Scopes.Ger_sniperscope_overlay'
    IronSightDisplayFOV=45.0
    IronSightDisplayFOVHigh=45.0
    PlayerFOVZoom=15.0
    ScopePortalFOV=7.1     //very hard to find information on ZF39's field of view, + it wasnt a single scope but rather a variety of similar scopes
    ScopePortalFOVHigh=7.1 //i managed to find that it was approximately ~6.5 degrees (varied between manufacturers)
    LensMaterialID=5

    PlayerIronsightFOV=60.0
    bUsesIronsightFOV=true

    ScopeOverlaySize=0.43

    MaxNumPrimaryMags=13
    InitialNumPrimaryMags=13

    IronBringUp="Scope_in"
    IronPutDown="Scope_out"
    IronIdleAnim="Scope_Idle"
    BoltIronAnim="scope_bolt"
    BoltHipAnim="bolt_scope"
    PostFireIronIdleAnim=none
    SingleReloadAnim="single_insert"
    SingleReloadHalfAnim="single_insert_half"
    PreReloadAnim="single_open"
    PreReloadHalfAnim="single_open_half"
    PostReloadAnim="single_close"
}
