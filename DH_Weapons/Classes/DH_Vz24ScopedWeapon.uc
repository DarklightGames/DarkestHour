//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Vz24ScopedWeapon extends DHBoltActionWeapon;

simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    // Hiding bayonet
    SetBoneScale(0, 0.0, 'bayonet');
}

defaultproperties
{
    ItemName="Vz.24 Rifle (IOR)"
    NativeItemName="ZB vz.24 Puska (IOR)"
    FireModeClass(0)=class'DH_Weapons.DH_Vz24ScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_Vz24ScopedMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_Vz24ScopedAttachment'
    PickupClass=class'DH_Weapons.DH_Vz24ScopedPickup'

    Mesh=SkeletalMesh'DH_Kar98_1st.Vz24scoped_mesh'

    bHasScope=true
    bIsSniper=true
    ScopeOverlay=Texture'DH_Weapon_tex.Scopes.Textured_GerScope'
	ScriptedScopeTexture=Texture'DH_Weapon_tex.Scopes.Ger_sniperscope_overlay'
    DisplayFOV=88.0
    IronSightDisplayFOV=38.0
    IronSightDisplayFOVHigh=38.0
    PlayerFOVZoom=14.11
    ScopePortalFOV=7.1     
    ScopePortalFOVHigh=7.1 // "4,25x28" which appears to be 6.6 degrees? 
    LensMaterialID=5

    PlayerIronsightFOV=60.0
    bUsesIronsightFOV=true

    ScopeOverlaySize=0.454

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
