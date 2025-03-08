//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Granatwerfer34Cannon extends DHATGunCannon;

// Ignore manual reloading functionality for mortars.
simulated function bool PlayerUsesManualReloading()
{
    return false;
}

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Granatwerfer34_anm.grw34_gun_ext'
    Skins(0)=Texture'DH_Granatwerfer34_tex.grw34_ext_yellow'

    WeaponFireAttachmentBone="MUZZLE"
    GunnerAttachmentBone="GUN_YAW"

    // Collision meshes
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Model35Mortar_stc.Collision.GRW34_GUN_COLLISION',AttachBone="GUN_PITCH")

    // Gun Wheels
    GunWheels(0)=(RotationType=ROTATION_Pitch,BoneName="GUNSIGHT",Scale=1.0,RotationAxis=AXIS_Y)   // Counter-rotates the sight so it stays level.
    GunWheels(1)=(RotationType=ROTATION_Yaw,BoneName="YAW_WHEEL",Scale=-320,RotationAxis=AXIS_Y)
    GunWheels(2)=(RotationType=ROTATION_Pitch,BoneName="PITCH_WHEEL",Scale=533,RotationAxis=AXIS_Z)
    AnimationDrivers(0)=(Channel=1,BoneName="PITCH_ROOT",AnimationName="PITCH_DRIVER",AnimationFrameCount=44,RotationType=ROTATION_Pitch,bIsReversed=true)

    // Turret movement
    ManualRotationsPerSecond=0.0125
    MaxPositiveYaw=910    // +/- 5 degrees
    MaxNegativeYaw=-910
    YawStartConstraint=-910
    YawEndConstraint=910
    CustomPitchUpLimit=8192
    CustomPitchDownLimit=65535
    RotationsPerSecond=0.0125

    // Cannon ammo
    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="Smoke"

    nProjectileDescriptions(0)="Wgr. 38"
    nProjectileDescriptions(1)="Wgr. 38 Nb."

    PrimaryProjectileClass=class'DH_Guns.DH_Granatwerfer34ProjectileHE'
    SecondaryProjectileClass=class'DH_Guns.DH_Granatwerfer34ProjectileSmoke'
    InitialPrimaryAmmo=28
    InitialSecondaryAmmo=5
    MaxPrimaryAmmo=28
    MaxSecondaryAmmo=5

    Spread=0.01
    SecondarySpread=0.01
    TertiarySpread=0.01

    // Weapon fire
    WeaponFireOffset=16.0
    AddedPitch=0

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_MortarSounds.Fire.81mm_mortar_fire_01'
    CannonFireSound(1)=SoundGroup'DH_MortarSounds.Fire.81mm_mortar_fire_02'
    CannonFireSound(2)=SoundGroup'DH_MortarSounds.Fire.81mm_mortar_fire_03'

    // TODO: figure out what to do with this.
    // ReloadStages(0)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_03',Duration=1.0)

    bIsArtillery=true
    ResupplyInterval=12.0

    // No 
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

    EffectEmitterClass=class'DH_Effects.DHMortarFireEffect'
    CannonDustEmitterClass=None
}
