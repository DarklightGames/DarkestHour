//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_BazookaWeapon extends DHRocketWeapon;

defaultproperties
{
    ItemName="M1A1 Bazooka"
    Mesh=SkeletalMesh'DH_Bazooka_1st.Bazooka_m1a1'
    TeamIndex=1
    FireModeClass(0)=class'DH_Weapons.DH_BazookaFire'
    AttachmentClass=class'DH_Weapons.DH_BazookaAttachment'
    PickupClass=class'DH_Weapons.DH_BazookaPickup'

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

    RangeSettings(0)=(FirePitch=165,IronIdleAnim="iron_loop_50",IronFireAnim="iron_shoot_loop_50",AssistedReloadAnim="iron_reload_50")
    RangeSettings(1)=(FirePitch=1200,IronIdleAnim="iron_loop_100",IronFireAnim="iron_shoot_loop_100",AssistedReloadAnim="iron_reload_100")
    RangeSettings(2)=(FirePitch=3000,IronIdleAnim="iron_loop_150",IronFireAnim="iron_shoot_loop_150",AssistedReloadAnim="iron_reload_150")
}

