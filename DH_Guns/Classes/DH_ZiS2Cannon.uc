//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ZiS2Cannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_ZiS_anm.ZIS2_TURRET_EXT'

    Skins(0)=Texture'DH_ZiS_tex.ZIS_BODY_EXT'
    Skins(1)=Texture'DH_ZiS_tex.ZIS_TURRET_EXT'
    
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_ZiS_stc.ZIS2_TURRET_YAW_COLLISION',AttachBone="GUN_YAW")
    CollisionStaticMeshes(1)=(CollisionStaticMesh=StaticMesh'DH_ZiS_stc.ZIS2_BARREL_COLLISION',AttachBone="BARREL")
    CollisionStaticMeshes(2)=(CollisionStaticMesh=StaticMesh'DH_ZiS_stc.ZIS_PITCH_COLLISION',AttachBone="GUN_PITCH")

    AnimationDrivers(0)=(Channel=2,AnimationName="PITCH_DRIVER",BoneName="PITCH_DRIVER_ROOT",RotationType=ROTATION_Pitch,AnimationFrameCount=34)
    AnimationDrivers(1)=(Channel=3,AnimationName="YAW_DRIVER",BoneName="YAW_BASE_POST",RotationType=ROTATION_Yaw,AnimationFrameCount=26)

    GunWheels(0)=(RotationType=ROTATION_Yaw,BoneName="YAW_WHEEL",Scale=-64.0,RotationAxis=AXIS_Y)
    GunWheels(1)=(RotationType=ROTATION_Pitch,BoneName="PITCH_WHEEL",Scale=64.0,RotationAxis=AXIS_Y)

    ShootAnim="SHOOT"
    ShootAnimBoneName="BARREL"
    GunnerAttachmentBone="GUN_YAW"
    YawBone="GUN_YAW"
    PitchBone="GUN_PITCH"
    WeaponFireAttachmentBone="MUZZLE_ZIS2"

    // Turret movement
    MaxPositiveYaw=4915 // 27 degrees
    MaxNegativeYaw=-4915
    YawStartConstraint=-4915.0
    YawEndConstraint=4915.0
    CustomPitchUpLimit=5460     // +30 degrees
    CustomPitchDownLimit=64626  // -5 degrees

    // Cannon ammo
    PrimaryProjectileClass=Class'DH_ZiS2CannonShell'
    SecondaryProjectileClass=Class'DH_ZiS2CannonShellHE'
    TertiaryProjectileClass=Class'DH_ZiS2CannonShellAPCR'

    ProjectileDescriptions(0)="APBC"
    ProjectileDescriptions(2)="APCR"

    nProjectileDescriptions(0)="BR-271"
    nProjectileDescriptions(1)="O-271"
    nProjectileDescriptions(2)="BR-271P"

    InitialPrimaryAmmo=15
    InitialSecondaryAmmo=5
    InitialTertiaryAmmo=4
    MaxPrimaryAmmo=25
    MaxSecondaryAmmo=15
    MaxTertiaryAmmo=6
    SecondarySpread=0.002

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.75mm_VL_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.75mm_VL_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.75mm_VL_fire03'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.reload_short_1') // 3.5 seconds reload
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.reload_short_2')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.reload_short_3')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.reload_short_4')

    // Cannon range settings
    RangeSettings(1)=200
    RangeSettings(2)=400
    RangeSettings(3)=600
    RangeSettings(4)=800
    RangeSettings(5)=1000
    RangeSettings(6)=1200
    RangeSettings(7)=1400
    RangeSettings(8)=1600
    RangeSettings(9)=1800
    RangeSettings(10)=2000
    RangeSettings(11)=2200
    RangeSettings(12)=2400
    RangeSettings(13)=2600
    RangeSettings(14)=2800
    RangeSettings(15)=3000
    RangeSettings(16)=3200
    RangeSettings(17)=3400
    RangeSettings(18)=3600
    RangeSettings(19)=3800
    RangeSettings(20)=4000

    ResupplyInterval=5.0

    ProjectileRotationMode=PRM_MuzzleBone

    ShakeOffsetMag=(X=12.0,Y=4.0,Z=20.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=6.0
    ShakeRotMag=(X=100.0,Y=100.0,Z=800.0)
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
    ShakeRotTime=5.0
}
