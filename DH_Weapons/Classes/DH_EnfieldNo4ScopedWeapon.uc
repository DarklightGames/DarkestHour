//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_EnfieldNo4ScopedWeapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="Scoped Enfield No.4"
    FireModeClass(0)=class'DH_Weapons.DH_EnfieldNo4ScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_EnfieldNo4ScopedMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_EnfieldNo4ScopedAttachment'
    PickupClass=class'DH_Weapons.DH_EnfieldNo4ScopedPickup'

    Mesh=SkeletalMesh'DH_EnfieldNo4_1st.EnfieldNo4_Scoped'
    HighDetailOverlay=Shader'DH_EnfieldNo4_tex.EnfieldNo4.No4MainSniper_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3

    bHasScope=true
    bIsSniper=true
    bPlusOneLoading=true

    ScopeOverlay=Texture'DH_Weapon_tex.Scopes.EnfieldNo4_Scope_Overlay'
    ScriptedScopeTexture=Texture'DH_EnfieldNo4_tex.EnfieldNo4.EnfieldNo4_Scope_3D'

    ScopeOverlaySize=0.7 // size of the scope overlay (1.0 means full screen width, 0.5 means half screen width, etc)
    OverlayCorrectionX=-1.5
    OverlayCorrectionY=6    //pixel value scope overaly correction
    DisplayFOV=70.0         // idk
    IronSightDisplayFOV=40.0
    IronSightDisplayFOVHigh=40.0
    PlayerFOVZoom=25.714285 // 3.5x // The PlayerFOV the player's FOV will change too when using scoped weapons
    ScopePortalFOV=7.0
    ScopePortalFOVHigh=7.0
    LensMaterialID=3

    HandNum=1
    SleeveNum=2

    MaxNumPrimaryMags=13
    InitialNumPrimaryMags=13

    bUsesIronsightFOV=false
    FreeAimRotationSpeed=6.0
    BobModifyFactor=0.85

    IronBringUp="Scope_in"
    IronPutDown="Scope_out"
    IronIdleAnim="Scope_Idle"
    BoltIronAnim="scope_bolt"
    BoltHipAnim="bolt_scope"

    MagEmptyReloadAnim="reload_empty"
    MagPartialReloadAnim="reload_half"

    PreReloadAnim="reload_start"
    PostReloadAnim="reload_end"
    SingleReloadAnim="reload_single"
}

