//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// ART
//==============================================================================
// [ ] collision shapes
// [ ] destroyed mesh for all variants (low, mid, high)
///==============================================================================
// ANIMATIONS
//==============================================================================
// [ ] third person pitch/yaw animations
// [ ] first person reload animation
// [ ] first person barrel change animation
// [ ] third person reload animations
//==============================================================================
// QUALITY OF LIFE IMPROVEMENTS
//==============================================================================
// [ ] add click sound when trying to fire while barrel is broken
// [ ] display the number of barrels on the HUD (flash red when a barrel is
//     broken and show button prompt to change it, if applicable)
// [ ] shooting the sight should break it!
// [ ] maybe reloads should be totally manual? [working on it but this probably breaks hetzer reload? investigate.]
//==============================================================================
// BUGS
//==============================================================================
// [ ] smoking barrels stay in place after picking up the gun (probably orphaned actors)
// [ ] some sort of issues with texturing of interior parts of cannons?
//     (refactoring change regression?)
// [ ] picking up the gun and putting it down again resets the barrel conditions.
// [ ] "exit position not found" error if you try to exit in some places
// [ ] destoying a barrel also stops you from being able to rotate the gun with
//      the mouse (this is due to AllowFire being used as a gate for "can the
//      gun move")
// [ ] pressing 1 resets the view; this should be disabled for mounted MGs (or
//      maybe just *all* vehicles where you're changing to the same position?)
// [ ] reload can be initiated in the raised position; what should this do instead?
//      when the user press the reload, we can do two things:
//      1. set a flag saying that a reload is pending.
//      2. set a "desired position index"; the user will automatically transition to it.
//      3. when the user gets to the position where they can reload, it will be automatically triggered by checking the flag.
// [ ] sometimes, when getting on the gun for the first time, the gun will reload
//      immediately for no reason (with no animation)
// [ ] sight is misaligned with barrel at "extreme" yaw angles (add a debug for
//     the camera rotation and barrel rotation angles). some sort of correction
//     may be needed.
//==============================================================================

class DH_MG34LafetteMG extends DHMountedMG;

defaultproperties
{
    Mesh=SkeletalMesh'DH_MG34_anm.MG34_TURRET_EXT'  // TODO: replace with EXT version
    // Skins(0)=Texture'DH_Maxim_tex.MAXIM_TURRET_EXT'

    Begin Object Class=DHWeaponRangeParams Name=RangeParams0
        DistanceUnit=DU_Meters
        Anim="SIGHT_DRIVER"
        AnimFrameCount=15
        Channel=1
        Bone="REAR_SIGHT_POST"
        AnimationInterpDuration=0.5
        RangeTable(0)=(Range=200,AnimationTime=0.04,GunsightPitch=-19)
        RangeTable(1)=(Range=400,AnimationTime=0.065,GunsightPitch=-50)
        RangeTable(2)=(Range=500,AnimationTime=0.09,GunsightPitch=-65)
        RangeTable(3)=(Range=600,AnimationTime=0.105,GunsightPitch=-80)
        RangeTable(4)=(Range=700,AnimationTime=0.125,GunsightPitch=-95)
        RangeTable(5)=(Range=800,AnimationTime=0.15,GunsightPitch=-120)
        RangeTable(6)=(Range=900,AnimationTime=0.175,GunsightPitch=-140)
        RangeTable(7)=(Range=1000,AnimationTime=0.21,GunsightPitch=-165)
    End Object
    RangeParams=RangeParams0

    bLimitYaw=true
    MaxNegativeYaw=-2912    // -16 degrees
    MaxPositiveYaw=2912     // +16 degrees

    CustomPitchUpLimit=1183     // +6.5 degrees
    CustomPitchDownLimit=64353  // -6.5 degrees

    // Ammo
    InitialPrimaryAmmo=50
    NumMGMags=8
    ProjectileClass=Class'DH_MG34Bullet'
    
    FireInterval=0.08 // 862 rpm (value had to be found experimentally due to an engine bug)
    TracerFrequency=7
    // Spread=88.0 (the spread units on the infantry and vehicle weapons are different for some reason!)

    TracerProjectileClass=Class'DH_MG34TracerBullet'

    // Weapon fire
    FireSoundClass=SoundGroup'DH_WeaponSounds.mg34_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.mg34_fire_end'

    PitchBone="PITCH"
    YawBone="YAW"

    ReloadSequence="RELOAD"

    // FiringAnim="FIRING"
    // FiringIdleAnim="IDLE"
    // FiringChannel=2
    // FiringBone="FIRING_ROOT"

    ShellEjectBone="LAFETTE_EJECTOR"
    ShellEjectClass=Class'RO3rdShellEject762x54mm'
    ShellEjectRotationOffset=(Pitch=8192,Yaw=16384,Roll=8192)

    ProjectileRotationMode=PRM_CurrentAim

    WeaponFireOffset=-10

    // Regular MGs do not have collision on because it's assumed that they're a small part
    // mounted on a larger vehicle. In this case, we want to have collision on because it's
    // a standalone weapon.
    bCollideActors=true
    bBlockActors=true
    bProjTarget=true
    bBlockNonZeroExtentTraces=true
    bBlockZeroExtentTraces=true

    //CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Maxim_stc.MAXIM_TURRET_PITCH_COLLISION',AttachBone="MG_PITCH")

    // Pitch rack animation driver
    AnimationDrivers(0)=(BoneName="PITCH_DRIVER_ROOT",AnimationName="PITCH_DRIVER",AnimationFrameCount=11,Channel=3,RotationType=ROTATION_Pitch)

    BarrelCount=2
    BarrelClass=Class'DH_MG34Barrel'
    BarrelChangeSequence="BARREL_CHANGE"
}
