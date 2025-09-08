//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Maxim Gun firing: https://www.youtube.com/watch?v=vYx1KnXVvs4
//==============================================================================

class DH_MaximM191030MG extends DHMountedMG;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Maxim_anm.MAXIM_TURRET_EXT'

    ReloadCameraTweenTime=0.5

    RangeDistanceUnit=DU_Meters
    RangeDriverAnim="SIGHT_DRIVER"
    RangeDriverAnimFrameCount=10
    RangeDriverChannel=1
    RangeDriverBone="REAR_SIGHT"
    
    // RangeTable(0)=(Range=100.0,AnimationTime=0.120)
    // RangeTable(1)=(Range=200.0,AnimationTime=0.135)
    // RangeTable(2)=(Range=300.0,AnimationTime=0.150)
    // RangeTable(3)=(Range=400.0,AnimationTime=0.165)
    // RangeTable(4)=(Range=500.0,AnimationTime=0.190)
    // RangeTable(5)=(Range=600.0,AnimationTime=0.230)
    // RangeTable(6)=(Range=700.0,AnimationTime=0.27)
    // RangeTable(7)=(Range=800.0,AnimationTime=0.31)
    // RangeTable(8)=(Range=900.0,AnimationTime=0.36)
    // RangeTable(9)=(Range=1000.0,AnimationTime=0.41)

    bLimitYaw=true
    MaxNegativeYaw=-8192    // -45 degrees
    MaxPositiveYaw=8192     // +45 degrees
    CustomPitchUpLimit=2002     // +12 degrees
    CustomPitchDownLimit=63534  // -12 degrees

    // Ammo
    InitialPrimaryAmmo=250
    NumMGMags=3
    ProjectileClass=Class'DH_Fiat1435Bullet'                    // TODO: replace with maxim bullet (same as mosin?)
    FireInterval=0.1    // 600rpm
    TracerProjectileClass=Class'DH_Fiat1435TracerBullet'        // TODO: replace
    TracerFrequency=7

    // Weapon fire
    FireSoundClass=SoundGroup'DH_MN_InfantryWeapons_sound.Breda38FireLoop'
    FireEndSound=SoundGroup'DH_MN_InfantryWeapons_sound.Breda38FireLoopEnd'

    RangeDriverAnimationInterpDuration=0.5

    FiringAnim="BOLT_FIRING"
    FiringIdleAnim="BOLT_IDLE"
    FiringChannel=2
    FiringBone="FIRING_ROOT"

    ShellEjectBone="EJECTOR"
    ShellEjectClass=Class'RO3rdShellEject762x54mm'
    ShellEjectRotationOffset=(Pitch=-16384,Yaw=16384)

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
