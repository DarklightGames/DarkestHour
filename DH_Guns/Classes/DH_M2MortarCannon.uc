//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M2MortarCannon extends DHATGunCannon;

// Ignore manual reloading functionality for mortars.
simulated function bool PlayerUsesManualReloading()
{
    return false;
}

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_M2Mortar_anm.M2MORTAR_GUN_EXT'
    //Skins(0)=Texture'DH_M2Mortar_tex.M2.M2Mortar_ext'

    WeaponFireAttachmentBone="MUZZLE"
    GunnerAttachmentBone="GUN_YAW"

    // Collision meshes
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_M2Mortar_stc.Collision.M2MORTAR_COLLISION_GUN',AttachBone="GUN_PITCH")

    // Gun Wheels
    GunWheels(0)=(RotationType=ROTATION_Yaw,BoneName="YAW_WHEEL",Scale=-720,RotationAxis=AXIS_Y)    // [1] 0.5 degrees per turn.
    GunWheels(1)=(RotationType=ROTATION_Pitch,BoneName="PITCH_WHEEL",Scale=533,RotationAxis=AXIS_Z) // [1] 12 mils per turn.
    GunWheels(2)=(RotationType=ROTATION_Pitch,BoneName="GUNSIGHT",Scale=1.0,RotationAxis=AXIS_Y)   // Counter-rotates the sight so it stays level.

    // Turret movement
    ManualRotationsPerSecond=0.0125
    MaxPositiveYaw=1274.0    // +/- 7 degrees
    MaxNegativeYaw=-1274.0
    YawStartConstraint=-1274.0
    YawEndConstraint=1274.0
    CustomPitchUpLimit=8190     // 40-85 degrees
    CustomPitchDownLimit=65535
    RotationsPerSecond=0.0125

    // Cannon ammo
    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="Smoke"

    // rename obviously
    nProjectileDescriptions(0)="Bomba g. a. da 81"
    nProjectileDescriptions(1)="Bomba Fumogena"

    PrimaryProjectileClass=class'DH_M2MortarProjectileHE'
    SecondaryProjectileClass=class'DH_M2MortarProjectileSmoke'
    InitialPrimaryAmmo=28
    InitialSecondaryAmmo=5
    InitialTertiaryAmmo=2
    MaxPrimaryAmmo=28
    MaxSecondaryAmmo=5
    MaxTertiaryAmmo=0   // HACK: This stops the large HE shells from being resupplied. Replace this later.

    Spread=0.01
    SecondarySpread=0.01
    TertiarySpread=0.01

    // Weapon fire
    WeaponFireOffset=16.0  // TODO: REPLACE
    AddedPitch=0  // TODO: REPLACE

    // Sounds
    // TODO: use 60mm mortar sounds, or just make new ones
    CannonFireSound(0)=SoundGroup'DH_MortarSounds.Fire.81mm_mortar_fire_01'
    CannonFireSound(1)=SoundGroup'DH_MortarSounds.Fire.81mm_mortar_fire_02'
    CannonFireSound(2)=SoundGroup'DH_MortarSounds.Fire.81mm_mortar_fire_03'

    // TODO: figure out what to do with this.
    // ReloadStages(0)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_03',Duration=1.0)

    bIsArtillery=true
    ResupplyInterval=12.0

    YawBone="GUN_YAW"
    PitchBone="GUN_PITCH"

    DriverAnimationChannelBone="CAMERA_COM"
    DriverAnimationChannel=2    // 1 is used for the pitching driver

    ProjectileRotationMode=PRM_MuzzleBone

    ShakeOffsetMag=(X=10.0,Y=10.0,Z=10.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=4.0
    ShakeRotMag=(X=100.0,Y=100.0,Z=800.0)
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
    ShakeRotTime=5.0

    EffectEmitterClass=class'DH_Effects.DHMortarFireEffect'     // TODO: probably okay
    // TODO: maybe get a dust emitter for this.
    CannonDustEmitterClass=None

    FireBlurScale=0.25
    FireBlurTime=0.2
}
