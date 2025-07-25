//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// [1] https://texashistory.unt.edu/ark:/67531/metapth46561/
//==============================================================================

class DH_Model35MortarCannon extends DHATGunCannon;

// Ignore manual reloading functionality for mortars.
simulated function bool PlayerUsesManualReloading()
{
    return false;
}

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Model35Mortar_anm.model35mortar_tube_ext'
    Skins(0)=Texture'DH_Model35Mortar_tex.Model35Mortar_ext'

    WeaponFireAttachmentBone="MUZZLE"
    GunnerAttachmentBone="YAW"

    // Collision meshes
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Model35Mortar_stc.model35mortar_tube_collision',AttachBone="PITCH")

    // Gun Wheels
    GunWheels(0)=(RotationType=ROTATION_Yaw,BoneName="YAW_WHEEL",Scale=-720,RotationAxis=AXIS_Y)    // [1] 0.5 degrees per turn.
    GunWheels(1)=(RotationType=ROTATION_PITCH,BoneName="PITCH_WHEEL",Scale=533,RotationAxis=AXIS_X) // [1] 12 mils per turn.
    GunWheels(2)=(RotationType=ROTATION_Pitch,BoneName="SIGHT_TOP",Scale=1.0,RotationAxis=AXIS_Y)   // Counter-rotates the sight so it stays level.
    AnimationDrivers(0)=(Channel=1,BoneName="PITCH_ROOT",AnimationName="PITCH_DRIVER",AnimationFrameCount=30,RotationType=ROTATION_Pitch,bIsReversed=true)

    // Turret movement
    ManualRotationsPerSecond=0.0125
    MaxPositiveYaw=782.6    // +/- 4.3 degrees
    MaxNegativeYaw=-782.6
    YawStartConstraint=-782.6
    YawEndConstraint=782.6
    CustomPitchUpLimit=9102
    CustomPitchDownLimit=65535
    RotationsPerSecond=0.0125

    // Cannon ammo
    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="Smoke"
    ProjectileDescriptions(2)="HE-L"

    nProjectileDescriptions(0)="Bomba g. a. da 81"
    nProjectileDescriptions(1)="Bomba Fumogena"
    nProjectileDescriptions(2)="Bomba gr. c. da 81"

    PrimaryProjectileClass=Class'DH_Model35MortarProjectileHE'
    SecondaryProjectileClass=Class'DH_Model35MortarProjectileSmoke'
    TertiaryProjectileClass=Class'DH_Model35MortarProjectileHEBig'
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
    CannonFireSound(0)=SoundGroup'DH_MortarSounds.81mm_mortar_fire_01'
    CannonFireSound(1)=SoundGroup'DH_MortarSounds.81mm_mortar_fire_02'
    CannonFireSound(2)=SoundGroup'DH_MortarSounds.81mm_mortar_fire_03'

    // TODO: figure out what to do with this.
    // ReloadStages(0)=(Sound=Sound'Vehicle_reloads.SU_76_Reload_03',Duration=1.0)

    bIsArtillery=true
    ResupplyInterval=12.0

    // No
    YawBone="YAW"
    PitchBone="PITCH"

    DriverAnimationChannelBone="CAMERA_COM"
    DriverAnimationChannel=2    // 1 is used for the pitching driver

    ProjectileRotationMode=PRM_MuzzleBone

    ShakeOffsetMag=(X=10.0,Y=10.0,Z=10.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=4.0
    ShakeRotMag=(X=100.0,Y=100.0,Z=800.0)
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
    ShakeRotTime=5.0

    EffectEmitterClass=Class'DHMortarFireEffect'
    // TODO: maybe get a dust emitter for this.
    CannonDustEmitterClass=None

    FireBlurScale=0.5
    FireBlurTime=0.4
}
