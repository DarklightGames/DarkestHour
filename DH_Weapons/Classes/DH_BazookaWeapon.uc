//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================
// [ ] Calibrate range settings
// [ ] Should not be able to reload while moving
// [ ] New rocket mesh
// [ ] New 3rd person weapon mesh
// [ ] Interface art
//==============================================================================

class DH_BazookaWeapon extends DHRocketWeapon;

defaultproperties
{
    ItemName="M9A1 Bazooka"
    Mesh=SkeletalMesh'DH_Bazooka_1st.Bazooka'
    TeamIndex=1
    FireModeClass(0)=class'DH_Weapons.DH_BazookaFire'
    FireModeClass(1)=class'DH_Weapons.DH_BazookaMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_BazookaAttachment'
    PickupClass=class'DH_Weapons.DH_BazookaPickup'

    FreeAimRotationSpeed=2.0

    FillAmmoMagCount=1
    bDoesNotRetainLoadedMag=true
    bCanHaveAsssistedReload=true

    bHasScope=true
    bForceModelScope=true
    ScopeOverlay=Texture'DH_Bazooka_tex.FPP.BazookaScopeOverlay'    // TODO: not used though??
    ScriptedScopeTexture=Texture'DH_Bazooka_tex.FPP.BazookaScopeOverlay'
    ScopePortalFOV=8.0
    ScopePortalFOVHigh=8.0
    LensMaterialID=4

    FirstSelectAnim="draw_first"
    SelectAnim="Draw"
    PutDownAnim="putaway"
    IronIdleAnim="iron_loop"
    IronIdleEmptyAnim="iron_loop"
    IronSightDisplayFOV=70.0
    IronSightDisplayFOVHigh=70.0

    MagEmptyReloadAnims(0)="reload_empty"
    MagPartialReloadAnims(0)="reload_empty"
    //AssistedMagEmptyReloadAnim="reloadA"
    //AssistedMagPartialReloadAnim="reloadA"

    // TODO: GET THESE WORKING
    RangeSettings(0)=(FirePitch=15,IronIdleAnim="iron_loop_50",FireIronAnim="iron_shoot_loop_50")
    RangeSettings(1)=(FirePitch=850,IronIdleAnim="iron_loop_100",FireIronAnim="iron_shoot_loop_100")
    RangeSettings(2)=(FirePitch=2450,IronIdleAnim="iron_loop_150",FireIronAnim="iron_shoot_loop_150")
}

