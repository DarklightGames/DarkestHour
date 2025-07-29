//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Kz8cmGrW42VehicleWeapon extends DHMortarVehicleWeapon;

defaultproperties
{
    ProjectileClass=Class'DH_Kz8cmGrW42ProjectileHE'
    PrimaryProjectileClass=Class'DH_Kz8cmGrW42ProjectileHE'
    SecondaryProjectileClass=Class'DH_Kz8cmGrW42ProjectileSmoke'
    InitialPrimaryAmmo=16
    InitialSecondaryAmmo=4
    PlayerResupplyAmounts(0)=4
    PlayerResupplyAmounts(1)=1
    FireSoundClass=SoundGroup'DH_WeaponSounds.8cmFireSG'
    RotationsPerSecond=0.005
    MaxPositiveYaw=1850
    MaxNegativeYaw=-1850
    Elevation=80.0
    ElevationMaximum=88.0
    Mesh=SkeletalMesh'DH_Mortars_3rd.Kz8cmGrW42_deployed'
    PrimaryShellBone="Shell"
}
