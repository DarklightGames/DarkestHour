//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MG34LafetteMG extends DHMountedMG;

defaultproperties
{
    Mesh=SkeletalMesh'DH_MG34_anm.MG34_TURRET_INT'  // TODO: replace with EXT version
    // Skins(0)=Texture'DH_Maxim_tex.MAXIM_TURRET_EXT'

    Begin Object Class=DHWeaponRangeParams Name=RangeParams0
        DistanceUnit=DU_Meters
        Anim="SIGHT_DRIVER"
        AnimFrameCount=15
        Channel=1
        Bone="SIGHT_PITCH"
        AnimationInterpDuration=0.5
        RangeTable(0)=(Range=200,AnimationTime=0.0375)
        RangeTable(1)=(Range=400,AnimationTime=0.045)
        RangeTable(2)=(Range=500,AnimationTime=0.06)
        RangeTable(3)=(Range=600,AnimationTime=0.0725)
        RangeTable(4)=(Range=700,AnimationTime=0.085)
        RangeTable(5)=(Range=800,AnimationTime=0.12)
        RangeTable(6)=(Range=900,AnimationTime=0.16)
        RangeTable(7)=(Range=1000,AnimationTime=0.16)
    End Object
    RangeParams=RangeParams0

    bLimitYaw=true
    MaxNegativeYaw=-3276    // -18 degrees
    MaxPositiveYaw=3276     // +18 degrees

    // TODO: figure this out
    CustomPitchUpLimit=2002     // +12 degrees
    CustomPitchDownLimit=63534  // -12 degrees

    // Ammo
    InitialPrimaryAmmo=250
    NumMGMags=3
    ProjectileClass=Class'DH_MG34Bullet'
    
    FireInterval=0.08 // 862 rpm (value had to be found experimentally due to an engine bug)
    TracerFrequency=7
    // Spread=88.0 (the spread units on the infantry and vehicle weapons are different for some reason!)

    TracerProjectileClass=Class'DH_MG34TracerBullet'

    // Weapon fire
    FireSoundClass=SoundGroup'DH_WeaponSounds.mg34_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.mg34_fire_end'

    // TODO: replace
    PitchBone="MG"
    YawBone="MG"

    FiringAnim="BOLT_FIRING"
    FiringIdleAnim="BOLT_IDLE"
    FiringChannel=2
    FiringBone="FIRING_ROOT"

    ShellEjectBone="EJECTOR"
    ShellEjectClass=Class'RO3rdShellEject762x54mm'
    ShellEjectRotationOffset=(Pitch=0,Yaw=32768)

    WeaponFireOffset=-10

    // Regular MGs do not have collision on because it's assumed that they're a small part
    // mounted on a larger vehicle. In this case, we want to have collision on because it's
    // a standalone weapon.
    bCollideActors=true
    bBlockActors=true
    bProjTarget=true
    bBlockNonZeroExtentTraces=true
    bBlockZeroExtentTraces=true

    NumRoundsInStaticMesh=1

    //CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Maxim_stc.MAXIM_TURRET_PITCH_COLLISION',AttachBone="MG_PITCH")

    BarrelCount=2
    BarrelClass=Class'DH_MG34Barrel'
}
