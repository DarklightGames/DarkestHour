//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M1919A4MG extends DHMountedMG
    abstract;

defaultproperties
{
    WeaponFireAttachmentBone="MUZZLE"

    InitialPrimaryAmmo=250
    NumMGMags=2
    
    Mesh=SkeletalMesh'DH_M1919A4_anm.M1919A4_M2_GUN_EXT'

    Begin Object Class=DHWeaponRangeParams Name=RangeParams0
        DistanceUnit=DU_Meters
        Anim="SIGHT_DRIVER"
        AnimFrameCount=10
        Channel=1
        Bone="SIGHT_ROOT"
        RangeTable(0)=(Range=0,AnimationTime=0.00)
        RangeTable(1)=(Range=200,AnimationTime=0.16)
        RangeTable(2)=(Range=400,AnimationTime=0.20)
        RangeTable(3)=(Range=600,AnimationTime=0.23)
        RangeTable(4)=(Range=800,AnimationTime=0.29)
        RangeTable(5)=(Range=1000,AnimationTime=0.36)
        AnimationInterpDuration=0.5
    End Object
    RangeParams=RangeParams0

    YawBone="GUN_YAW"
    PitchBone="GUN_PITCH"

    bLimitYaw=true
    MaxNegativeYaw=-2184    // -12 degrees
    MaxPositiveYaw=2184     // +12 degrees
    CustomPitchUpLimit=3640     // +20 degrees
    CustomPitchDownLimit=61895  // -20 degrees

    // Ammo
    ProjectileClass=Class'DH_30CalBullet'
    FireInterval=0.135
    TracerProjectileClass=Class'DH_30CalTracerBullet'
    TracerFrequency=5

    // Weapon fire
    FireSoundClass=SoundGroup'DH_WeaponSounds.30cal_FireLoop01'
    FireEndSound=SoundGroup'DH_WeaponSounds.30cal_FireEnd01'
    ShakeRotMag=(X=30.0,Y=30.0,Z=30.0)
    ShakeOffsetMag=(X=0.02,Y=0.02,Z=0.02)

    FiringAnim="BOLT_FIRING"
    FiringIdleAnim="BOLT_IDLE"
    FiringChannel=2
    FiringBone="FIRING_ROOT"

    ShellEjectBone="EJECTOR"
    ShellEjectClass=Class'RO3rdShellEject762x54mm'
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

    NumRoundsInStaticMesh=1

    BarrelCount=1
    BarrelClass=Class'DH_30CalBarrel'
}
