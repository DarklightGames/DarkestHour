//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M1919A4MG extends DH_Fiat1435MG
    // abstract
    ;

defaultproperties
{
    WeaponFireAttachmentBone="MUZZLE_A4"

    InitialPrimaryAmmo=250
    NumMGMags=2
    
    Mesh=SkeletalMesh'DH_M1919_anm.M1919A4_M2_GUN_EXT'

    ReloadCameraTweenTime=0.5

    RangeDistanceUnit=DU_Meters
    RangeDriverAnim="SIGHT_DRIVER"
    RangeDriverAnimFrameCount=10
    RangeDriverChannel=1
    RangeDriverBone="REAR_SIGHT"
    
    RangeTable(0)=(Range=100.0,AnimationTime=0.120)
    RangeTable(1)=(Range=200.0,AnimationTime=0.135)
    RangeTable(2)=(Range=300.0,AnimationTime=0.150)
    RangeTable(3)=(Range=400.0,AnimationTime=0.165)
    RangeTable(4)=(Range=500.0,AnimationTime=0.190)
    RangeTable(5)=(Range=600.0,AnimationTime=0.230)
    RangeTable(6)=(Range=700.0,AnimationTime=0.27)
    RangeTable(7)=(Range=800.0,AnimationTime=0.31)
    RangeTable(8)=(Range=900.0,AnimationTime=0.36)
    RangeTable(9)=(Range=1000.0,AnimationTime=0.41)

    YawBone="GUN_YAW"
    PitchBone="GUN_PITCH"

    bLimitYaw=true
    MaxNegativeYaw=-2184    // -12 degrees
    MaxPositiveYaw=2184     // +12 degrees
    CustomPitchUpLimit=3640     // +20 degrees
    CustomPitchDownLimit=61895  // -20 degrees

    // Ammo
    ProjectileClass=class'DH_30CalBullet'
    FireInterval=0.135
    TracerProjectileClass=class'DH_30CalTracerBullet'
    TracerFrequency=5

    // Weapon fire
    FireSoundClass=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireLoop01'
    FireEndSound=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireEnd01'
    ShakeRotMag=(X=30.0,Y=30.0,Z=30.0)
    ShakeOffsetMag=(X=0.02,Y=0.02,Z=0.02)

    RangeDriverAnimationInterpDuration=0.5

    FiringAnim="BOLT_FIRING"
    FiringIdleAnim="BOLT_IDLE"
    FiringChannel=2
    FiringBone="FIRING_ROOT"

    ShellEjectBone="EJECTOR"
    ShellEjectClass=class'RO3rdShellEject762x54mm'
    ShellEjectRotationOffset=(Pitch=-16384,Yaw=16384)

    ProjectileRotationMode=PRM_MuzzleBone

    // Regular MGs do not have collision on because it's assumed that they're a small part
    // mounted on a larger vehicle. In this case, we want to have collision on because it's
    // a standalone weapon.
    bCollideActors=true
    bBlockActors=true
    bProjTarget=true
    bBlockNonZeroExtentTraces=true
    bBlockZeroExtentTraces=true

    RoundsInStaticMesh=1
}
