//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_CV33MG extends DHVehicleMG;

defaultproperties
{
    // MG mesh
    Mesh=SkeletalMesh'DH_CV33_anm.cv33_turret_ext'

    FireAttachBone="GUN"
    FireEffectOffset=(X=-30.0,Y=10.0,Z=25.0) // TODO: replace, put it on the hatch

    // Movement
    MaxPositiveYaw=2366         // 13 degrees
    MaxNegativeYaw=-2366        // 13 degrees
    CustomPitchUpLimit=2730     // 15 degrees
    CustomPitchDownLimit=63352  // 12 degrees

    // Ammo
    ProjectileClass=class'DH_Weapons.DH_MG34Bullet' // replace: fiat 35 bullet & properties
    InitialPrimaryAmmo=150
    NumMGMags=5
    FireInterval=0.1    // 600rpm
    TracerProjectileClass=class'DH_Weapons.DH_Breda30TracerBullet'
    TracerFrequency=7

    // Weapon fire
    FireSoundClass=sound'Inf_Weapons.mg34_p_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    ShakeRotMag=(X=10.0,Y=10.0,Z=10.0)
    ShakeOffsetMag=(X=0.01,Y=0.01,Z=0.01)
    WeaponFireAttachmentBone="MUZZLE_L"
    WeaponFireOffset=0

    bHasMultipleBarrels=true
    Barrels(0)=(MuzzleBone="MUZZLE_L",EffectEmitterClass=class'DH_Vehicles.DH_VehicleBrenMGEmitter')    // TODO: replace emitter with a correctly timed one
    Barrels(1)=(MuzzleBone="MUZZLE_R",EffectEmitterClass=class'DH_Vehicles.DH_VehicleBrenMGEmitter')
    AmbientEffectEmitterClass=class'DH_Vehicles.DH_VehicleMGMultiBarrelEmitterController'
}
