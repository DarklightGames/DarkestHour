//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M2MortarVehicleWeapon extends DHMortarVehicleWeapon;

// HACK: Mortar has 2 shells modeled, but only one of them is utiziled in
// animations, so we keep the other one hidden. Remove this when animations for
// both shells are implemented.
simulated event ShowShell()
{
    if (PrimaryShellBone != '')
    {
        SetBoneScale(0, 1.0, PrimaryShellBone);
    }
}

defaultproperties
{
    ProjectileClass=Class'DH_M2MortarProjectileHE'
    PrimaryProjectileClass=Class'DH_M2MortarProjectileHE'
    SecondaryProjectileClass=Class'DH_M2MortarProjectileSmoke'
    InitialPrimaryAmmo=24
    InitialSecondaryAmmo=4
    PlayerResupplyAmounts(0)=6
    PlayerResupplyAmounts(1)=1
    FireSoundClass=SoundGroup'DH_WeaponSounds.6cmFireSG'
    RotationsPerSecond=0.005
    MaxPositiveYaw=1274
    MaxNegativeYaw=-1274
    Elevation=85.0
    ElevationMaximum=85.0
    ElevationMinimum=40.0
    Mesh=SkeletalMesh'DH_Mortars_3rd.M2Mortar_deployed'
    PrimaryShellBone="shell2"
    SecondaryShellBone="Shell"
}
