//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// [ ] *maybe* mid-clip reloading.
// [ ] Sound notifications for reload animation.
// [ ] Maybe make a little "ping" sound when the clip cycles.
// [ ] Have only ONE reload stage, time it to the duration of the animation.
// [ ] Destroyed mesh.
// [ ] Make sure it all works in MP.
// [ ] Make the hands part of the INT mesh. No separate hands mesh needed.
// [ ] Animation bug when the gun is empty and you get onto it (clip does not
//     animate) [half-reloads in general are busted]
// [ ] Fix fucky geo on the hands.
//==============================================================================

class DH_Fiat1435MG extends DHMountedMG
    abstract;

defaultproperties
{
    Begin Object Class=DHWeaponRangeParams Name=RangeParams0
        DistanceUnit=DU_Meters
        Anim="SIGHT_DRIVER"
        AnimFrameCount=10
        Channel=1
        Bone="REAR_SIGHT"
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
        AnimationInterpDuration=0.5
    End Object
    RangeParams=RangeParams0

    bLimitYaw=true
    MaxNegativeYaw=-2184    // -12 degrees
    MaxPositiveYaw=2184     // +12 degrees
    CustomPitchUpLimit=3640     // +20 degrees
    CustomPitchDownLimit=61895  // -20 degrees

    // Ammo
    ProjectileClass=Class'DH_Fiat1435Bullet'
    FireInterval=0.1    // 600rpm
    TracerProjectileClass=Class'DH_Fiat1435TracerBullet'
    TracerFrequency=7

    // Weapon fire
    FireSoundClass=SoundGroup'DH_MN_InfantryWeapons_sound.Breda38FireLoop'
    FireEndSound=SoundGroup'DH_MN_InfantryWeapons_sound.Breda38FireLoopEnd'

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
}
