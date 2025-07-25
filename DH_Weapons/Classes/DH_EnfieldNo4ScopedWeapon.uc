//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_EnfieldNo4ScopedWeapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="Enfield No.4 Mk.I (T) (No.32)"
    SwayModifyFactor=0.65 // +0.05
    FireModeClass(0)=class'DH_EnfieldNo4ScopedFire'
    FireModeClass(1)=class'DH_EnfieldNo4ScopedMeleeFire'
    AttachmentClass=class'DH_EnfieldNo4ScopedAttachment'
    PickupClass=class'DH_EnfieldNo4ScopedPickup'

    Mesh=SkeletalMesh'DH_EnfieldNo4_anm.EnfieldNo4_Scoped_1st'

    bHasScope=true
    bIsSniper=true
    bPlusOneLoading=true

    ScopeOverlay=Texture'DH_Weapon_tex.Scopes.Textured_BritScope'
    ScriptedScopeTexture=Texture'DH_Weapon_tex.Scopes.EnfieldNo4_Scope_overlay'

    ScopeOverlaySize=0.54 // size of the scope overlay (1.0 means full screen width, 0.5 means half screen width, etc)
    OverlayCorrectionX=-1.5
    //OverlayCorrectionY=6    //pixel value scope overaly correction // removed, because it moved the 0 meters mark above the center (which isnt only wrong, but also inconsistent with the 3d scope)
    DisplayFOV=85.0
    IronSightDisplayFOV=33.5
    IronSightDisplayFOVHigh=33.5
    PlayerFOVZoom=17.143 // 3.5x // The PlayerFOV the player's FOV will change too when using scoped weapons
    ScopePortalFOV=9.4   //~8.5 degrees, the value is higher than that because for some reason 3d scope appears with lower FOV than what is determined here
    ScopePortalFOVHigh=9.4  //also it is reduced so that 3d scope takes slightly less space on the screen
    LensMaterialID=3

    PlayerIronsightFOV=60.0
    bUsesIronsightFOV=true

    MaxNumPrimaryMags=8
    InitialNumPrimaryMags=8  //reduced from 13 because this rifle used to have x2 as much ammo as other rifles

    FreeAimRotationSpeed=6.0
    BobModifyFactor=0.85

    IronBringUp="Scope_in"
    IronPutDown="Scope_out"
    IronIdleAnim="Scope_Idle"
    BoltIronAnim="scope_bolt"
    BoltHipAnim="bolt_scope"
    PostFireIronIdleAnim=none
    MagEmptyReloadAnims(0)="reload_empty"
    MagPartialReloadAnims(0)="reload_half"

    PreReloadCockedAnim="reload_start_cocked"
    PreReloadAnim="reload_start"
    PostReloadAnim="reload_end_scope"
    SingleReloadAnim="reload_single"

    WeaponComponentAnimations(0)=(DriverType=DRIVER_Bolt,Channel=2,BoneName="cocker",Animation="cocker")
}
