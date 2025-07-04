//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PanzerschreckWeapon extends DHRocketWeapon;

defaultproperties
{
    ItemName="RPzB 54 'Panzerschrek'"
    NativeItemName="Raketenpanzerbüchse 54 'Panzerschrek'"
    TeamIndex=0
    FireModeClass(0)=Class'DH_PanzerschreckFire'
    AttachmentClass=Class'DH_PanzerschreckAttachment'
    PickupClass=Class'DH_PanzerschreckPickup'

    Mesh=SkeletalMesh'DH_Panzerschreck_anm.Panzerschreck_1st'

    FillAmmoMagCount=1
    bDoesNotRetainLoadedMag=true
    bCanHaveAsssistedReload=true

    SwayModifyFactor=1.0
    BobModifyFactor=0.8

    DisplayFOV=90.0
    IronSightDisplayFOV=60.0
    IronSightDisplayFOVHigh=6.0

    RangeDistanceUnit=DU_Meters
    RangeSettings(0)=(Range=50,FirePitch=0,IronIdleAnim="Iron_idle",IronFireAnim="iron_shoot",AssistedReloadAnim="iron_reload")
    RangeSettings(1)=(Range=150,FirePitch=350,IronIdleAnim="iron_idle_150",IronFireAnim="iron_shoot_150",AssistedReloadAnim="iron_reload_150")
    RangeSettings(2)=(Range=200,FirePitch=675,IronIdleAnim="iron_idle_200",IronFireAnim="iron_shoot_200",AssistedReloadAnim="iron_reload_200")

    MagEmptyReloadAnims(0)="Reload"
    MagPartialReloadAnims(0)="Reload"
}
