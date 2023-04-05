//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M2MortarVehicleWeapon extends DHMortarVehicleWeapon;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_M2MortarProjectileHE'
    PrimaryProjectileClass=class'DH_Weapons.DH_M2MortarProjectileHE'
    SecondaryProjectileClass=class'DH_Weapons.DH_M2MortarProjectileSmoke'
    InitialPrimaryAmmo=24
    InitialSecondaryAmmo=4
    PlayerResupplyAmounts(0)=6
    PlayerResupplyAmounts(1)=1
    FireSoundClass=SoundGroup'DH_WeaponSounds.Mortars.6cmFireSG'
    RotationsPerSecond=0.005
    MaxPositiveYaw=1274
    MaxNegativeYaw=-1274
    Elevation=85.0
    ElevationMaximum=85.0
    ElevationMinimum=40.0
    Mesh=SkeletalMesh'DH_Mortars_3rd.M2Mortar_deployed'
}
