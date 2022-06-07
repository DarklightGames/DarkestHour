//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_SpringfieldScopedWeapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="M1903A4 Springfield (M73 Weaver)"
    FireModeClass(0)=class'DH_Weapons.DH_SpringfieldScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_SpringfieldScopedMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_SpringfieldScopedAttachment'
    PickupClass=class'DH_Weapons.DH_SpringfieldScopedPickup'

    Mesh=SkeletalMesh'DH_Springfield_1st.Springfield_Scoped'
    Skins(0)=Texture'DH_Springfield_tex.Rifle.Springfield_tex'
    Skins(3)=Texture'DH_Weapon_tex.AlliedSmallArms.BARAmmo'
    HighDetailOverlay=Shader'DH_Springfield_tex.Rifle.Springfield_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=0
	sleevenum=1
	handnum=2

    bHasScope=true
    ScopeOverlay=Texture'DH_Weapon_tex.Scopes.Springfield_Scope_Overlay'
    ScriptedScopeTexture=Texture'DH_Springfield_tex.Scopes.Scope3D'
    OverlayCorrectionX=-0.5
    ScopeOverlaySize=0.222

    DisplayFOV=80.0
    IronSightDisplayFOV=46.8
    IronSightDisplayFOVHigh=46.8
    PlayerFOVZoom=24.0 // 2.5x
    ScopePortalFOV=6.77  // "24.1  ft @ 100 yards" for M73 scope, which is about 4.5 degrees
    ScopePortalFOVHigh=6.77  //however, the value is higher than that because for some reason 3d scope appears with lower FOV than what is determined here
    LensMaterialID=4

    PlayerIronsightFOV=60.0
    bUsesIronsightFOV=true

    MaxNumPrimaryMags=13
    InitialNumPrimaryMags=13

    IronBringUp="Scope_in"
    IronPutDown="Scope_out"
    IronIdleAnim="Scope_Idle"
    BoltIronAnim="scope_bolt"
    BoltHipAnim="bolt_scope"
    PostFireIronIdleAnim=none
    SingleReloadAnim="single_insert"
    SingleReloadHalfAnim="single_insert"  //you dont really see inside the mag
    PreReloadAnim="single_open"
    PreReloadHalfAnim="single_open_half"
    PostReloadAnim="single_close"
}
