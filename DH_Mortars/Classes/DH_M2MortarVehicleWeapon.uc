//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M2MortarVehicleWeapon extends DHMortarVehicleWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Mortars_3rd.ukx

defaultproperties
{
    ProjectileClass=class'DH_Mortars.DH_M2MortarProjectileHE'
    PrimaryProjectileClass=class'DH_Mortars.DH_M2MortarProjectileHE'
    SecondaryProjectileClass=class'DH_Mortars.DH_M2MortarProjectileSmoke'
    InitialPrimaryAmmo=24
    InitialSecondaryAmmo=4
    PlayerResupplyAmounts(0)=6
    PlayerResupplyAmounts(1)=1
    FireSoundClass=SoundGroup'DH_WeaponSounds.Mortars.6cmFireSG'
    RotationsPerSecond=0.015625
    MaxPositiveYaw=1274
    MaxNegativeYaw=-1274
    ElevationMaximum=85.0
    ElevationMinimum=40.0
    Mesh=SkeletalMesh'DH_Mortars_3rd.M2Mortar_deployed'
}
