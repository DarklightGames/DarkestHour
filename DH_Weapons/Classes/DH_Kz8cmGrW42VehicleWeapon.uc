//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Kz8cmGrW42VehicleWeapon extends DHMortarVehicleWeapon;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_Kz8cmGrW42ProjectileHE'
    PrimaryProjectileClass=class'DH_Weapons.DH_Kz8cmGrW42ProjectileHE'
    SecondaryProjectileClass=class'DH_Weapons.DH_Kz8cmGrW42ProjectileSmoke'
    InitialPrimaryAmmo=16
    InitialSecondaryAmmo=4
    PlayerResupplyAmounts(0)=4
    PlayerResupplyAmounts(1)=1
    FireSoundClass=SoundGroup'DH_WeaponSounds.Mortars.8cmFireSG'
    RotationsPerSecond=0.005
    MaxPositiveYaw=1850
    MaxNegativeYaw=-1850
    Elevation=80.0
    ElevationMaximum=88.0
    Mesh=SkeletalMesh'DH_Mortars_3rd.Kz8cmGrW42_deployed'
}
