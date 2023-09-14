//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_BazookaM9Weapon extends DHRocketWeapon;

defaultproperties
{
    ItemName="M9A1 Bazooka"
    Mesh=SkeletalMesh'DH_Bazooka_1st.Bazooka_m9'
    TeamIndex=1
    FireModeClass(0)=class'DH_Weapons.DH_BazookaM9Fire'
    AttachmentClass=class'DH_Weapons.DH_BazookaM9Attachment'
    PickupClass=class'DH_Weapons.DH_BazookaM9Pickup'

    bHasScope=true
    bForceModelScope=true
    ScopeOverlay=Texture'DH_Bazooka_tex.FPP.BazookaScopeOverlay'    // TODO: not used though??
    ScriptedScopeTexture=Texture'DH_Bazooka_tex.FPP.BazookaScopeOverlay'
    ScopePortalFOV=8.0
    ScopePortalFOVHigh=8.0
    LensMaterialID=4
    ScopeScriptedTextureSize=512

    FillAmmoMagCount=1
    bDoesNotRetainLoadedMag=true
    bCanHaveAsssistedReload=true

    SelectAnim="Draw"
    PutDownAnim="putaway"
    IronIdleAnim="iron_loop"
    IronIdleEmptyAnim="iron_loop"
    IronSightDisplayFOV=70.0
    IronSightDisplayFOVHigh=70.0

    MagEmptyReloadAnims(0)="reload_empty"
    MagPartialReloadAnims(0)="reload_empty"

    RangeSettings(0)=(FirePitch=5,IronIdleAnim="iron_loop_50",IronFireAnim="iron_shoot_loop_50",AssistedReloadAnim="iron_reload_50")
    RangeSettings(1)=(FirePitch=200,IronIdleAnim="iron_loop_100",IronFireAnim="iron_shoot_loop_100",AssistedReloadAnim="iron_reload_100")
    RangeSettings(2)=(FirePitch=635,IronIdleAnim="iron_loop_150",IronFireAnim="iron_shoot_loop_150",AssistedReloadAnim="iron_reload_150")
}
