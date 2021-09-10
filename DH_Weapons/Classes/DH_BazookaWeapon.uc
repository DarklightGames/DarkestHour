//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
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

    FillAmmoMagCount=1
    bDoesNotRetainLoadedMag=true
    bCanHaveAsssistedReload=true

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
    RangeSettings(0)=(FirePitch=15,IronIdleAnim="iron_loop",FireIronAnim="iron_shoot_loop")
    RangeSettings(1)=(FirePitch=850,IronIdleAnim="iron_loop",FireIronAnim="iron_shoot_loop")
    RangeSettings(2)=(FirePitch=2450,IronIdleAnim="iron_loop",FireIronAnim="iron_shoot_loop")
}

