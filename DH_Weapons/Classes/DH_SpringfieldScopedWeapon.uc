//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_SpringfieldScopedWeapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="M1903 Springfield Scoped"
    FireModeClass(0)=class'DH_Weapons.DH_SpringfieldScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_SpringfieldScopedMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_SpringfieldScopedAttachment'
    PickupClass=class'DH_Weapons.DH_SpringfieldScopedPickup'

    Mesh=SkeletalMesh'DH_Springfield_1st.Springfield_Scoped'
    Skins(0)=Texture'DH_Springfield_tex.Scopes.Springfield_tex'
    Skins(4)=Texture'DH_Weapon_tex.AlliedSmallArms.BARAmmo'
    //HighDetailOverlay=
    bUseHighDetailOverlayIndex=false  //to do
    HighDetailOverlayIndex=0
	sleevenum=1
	handnum=2

    bHasScope=true
    ScopeOverlay=Texture'DH_Weapon_tex.Scopes.Springfield_Scope_Overlay'
    ScriptedScopeTexture=Texture'DH_Springfield_tex.Scopes.Scope3D'
    OverlayCorrectionX=-0.5
    DisplayFOV=70.0
    IronSightDisplayFOV=45.0
    IronSightDisplayFOVHigh=45.0
    PlayerFOVZoom=36.0 // 2.5x
    ScopePortalFOV=15.0  // worse zoom than kar98k
    ScopePortalFOVHigh=15.0
    LensMaterialID=3
    bUsesIronsightFOV=false

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
