//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_PanzerschreckWeapon extends DHRocketWeapon;

defaultproperties
{
    ItemName="Raketenpanzerbüchse 54"
    TeamIndex=0
    FireModeClass(0)=class'DH_Weapons.DH_PanzerschreckFire'
    AttachmentClass=class'DH_Weapons.DH_PanzerschreckAttachment'
    PickupClass=class'DH_Weapons.DH_PanzerschreckPickup'

    Mesh=SkeletalMesh'DH_Panzerschreck_anm.Panzerschreck_1st'

    FillAmmoMagCount=1
    bDoesNotRetainLoadedMag=true
    bCanHaveAsssistedReload=true

    SwayModifyFactor=1.0
    BobModifyFactor=0.8

    DisplayFOV=90.0
    IronSightDisplayFOV=60.0
    IronSightDisplayFOVHigh=6.0

    RangeSettings(0)=(FirePitch=0,IronIdleAnim="Iron_idle",IronFireAnim="iron_shoot",AssistedReloadAnim="iron_reload")
    RangeSettings(1)=(FirePitch=350,IronIdleAnim="iron_idle_150",IronFireAnim="iron_shoot_150",AssistedReloadAnim="iron_reload_150")
    RangeSettings(2)=(FirePitch=675,IronIdleAnim="iron_idle_200",IronFireAnim="iron_shoot_200",AssistedReloadAnim="iron_reload_200")

    MagEmptyReloadAnims(0)="Reload"
    MagPartialReloadAnims(0)="Reload"
}
