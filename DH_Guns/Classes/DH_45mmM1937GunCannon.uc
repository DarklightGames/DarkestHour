//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_45mmM1937GunCannon extends DHATGunCannon;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Pak36_anm.53K_TURRET_EXT'
    Skins(0)=Texture'DH_Pak36_tex.45mm_ext'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Pak36_stc.pak36_turret_yaw_collision',AttachBone="GUN_YAW")
    CollisionStaticMeshes(1)=(CollisionStaticMesh=StaticMesh'DH_Pak36_stc.45mm_pitch_collision',AttachBone="GUN_PITCH")
    CollisionStaticMeshes(2)=(CollisionStaticMesh=StaticMesh'DH_Pak36_stc.53k_barrel_collision',AttachBone="BARREL")
    GunnerAttachmentBone="GUN_YAW"
    YawBone="GUN_YAW"
    PitchBone="GUN_PITCH"

    BeginningIdleAnim="idle"

    GunWheels(0)=(RotationType=ROTATION_Yaw,BoneName="YAW_WHEEL",Scale=128.0,RotationAxis=AXIS_X)
    GunWheels(1)=(RotationType=ROTATION_Pitch,BoneName="PITCH_WHEEL",Scale=128.0,RotationAxis=AXIS_X)

    AnimationDrivers(0)=(Channel=1,BoneName="PITCH_DRIVER_ROOT",AnimationName="PITCH_DRIVER",AnimationFrameCount=30,RotationType=ROTATION_Pitch)

    DriverAnimationChannel=2
    DriverAnimationChannelBone="CAMERA_COM"

    // Turret movement
    MaxPositiveYaw=5460 // 30 degrees
    MaxNegativeYaw=-5460
    YawStartConstraint=-5460
    YawEndConstraint=5460
    CustomPitchUpLimit=4550     // +25 degrees
    CustomPitchDownLimit=64626  // -5 degrees

    // Cannon ammo
    PrimaryProjectileClass=class'DH_45mmM1937GunCannonShell'
    SecondaryProjectileClass=class'DH_45mmM1937GunCannonShellHE'

    ProjectileDescriptions(0)="APBC"
    ProjectileDescriptions(1)="HE"

    nProjectileDescriptions(0)="BR-240"
    nProjectileDescriptions(1)="O-240"

    InitialPrimaryAmmo=20
    InitialSecondaryAmmo=4
    InitialTertiaryAmmo=2

    MaxPrimaryAmmo=40
    MaxSecondaryAmmo=8
    MaxTertiaryAmmo=4

    SecondarySpread=0.00165
    TertiarySpread=0.0130

    // Weapon fire
    WeaponFireAttachmentBone="MUZZLE_53K"
    WeaponFireOffset=1.0

    //Anims
    ShootLoweredAnim="shoot"
    ShootRaisedAnim="shoot"

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_CC_Vehicle_Weapons.45mm.45mmAT_fire01'
    CannonFireSound(1)=SoundGroup'DH_CC_Vehicle_Weapons.45mm.45mmAT_fire02'
    CannonFireSound(2)=SoundGroup'DH_CC_Vehicle_Weapons.45mm.45mmAT_fire03'

    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_1')
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_2')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_3')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_4')

    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=4.0
    ShakeRotMag=(X=100.0,Y=100.0,Z=800.0)
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
    ShakeRotTime=7.0
}
