//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_EnfieldNo4ScopedWeapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="Scoped Enfield No.4"
    SwayModifyFactor=0.65 // +0.05
    FireModeClass(0)=class'DH_Weapons.DH_EnfieldNo4ScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_EnfieldNo4ScopedMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_EnfieldNo4ScopedAttachment'
    PickupClass=class'DH_Weapons.DH_EnfieldNo4ScopedPickup'

    Mesh=SkeletalMesh'DH_EnfieldNo4_1st.EnfieldNo4_Scoped'
    HighDetailOverlay=Shader'DH_EnfieldNo4_tex.EnfieldNo4.No4MainSniper_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    bHasScope=true
    bIsSniper=true
    bPlusOneLoading=true

    ScopeOverlay=Texture'DH_Weapon_tex.Scopes.EnfieldNo4_Scope_Overlay'
    ScriptedScopeTexture=Texture'DH_EnfieldNo4_tex.EnfieldNo4.EnfieldNo4_Scope_3D'

    ScopeOverlaySize=0.54 // size of the scope overlay (1.0 means full screen width, 0.5 means half screen width, etc)
    OverlayCorrectionX=-1.5
    //OverlayCorrectionY=6    //pixel value scope overaly correction // removed, because it moved the 0 meters mark above the center (which isnt only wrong, but also inconsistent with the 3d scope)
    DisplayFOV=70.0         // idk
    IronSightDisplayFOV=24.0
    IronSightDisplayFOVHigh=24.0
    PlayerFOVZoom=17.143 // 3.5x // The PlayerFOV the player's FOV will change too when using scoped weapons
    ScopePortalFOV=9.9
    ScopePortalFOVHigh=9.9  //~8.5 degrees, the value is higher than that because for some reason 3d scope appears with lower FOV than what is determined here
    LensMaterialID=3
	
    PlayerIronsightFOV=57.0

    HandNum=1
    SleeveNum=0

    MaxNumPrimaryMags=8
    InitialNumPrimaryMags=8  //reduced from 13 because this rifle used to have x2 as much ammo as other rifles

    bUsesIronsightFOV=false
    FreeAimRotationSpeed=6.0
    BobModifyFactor=0.85

    IronBringUp="Scope_in"
    IronPutDown="Scope_out"
    IronIdleAnim="Scope_Idle"
    BoltIronAnim="scope_bolt"
    BoltHipAnim="bolt_scope"
    PostFireIronIdleAnim=none
    MagEmptyReloadAnim="reload_empty"
    MagPartialReloadAnim="reload_half"

    PreReloadAnim="reload_start"
    PostReloadAnim="reload_end_scope"
    SingleReloadAnim="reload_single"
}
