//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ZiS3Cannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_ZiS_anm.ZIS3_TURRET_EXT'
    //Skins(0)=Texture'DH_Artillery_tex.ZiS3Gun'
    //Skins(1)=Shader'MilitaryAlliesSMT.76mmShellCase2_Shine'
    //CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Artillery_stc.ZiS3_gun_collision')

    AnimationDrivers(0)=(Channel=1,AnimationName="PITCH_DRIVER",BoneName="PITCH_DRIVER_ROOT",RotationType=ROTATION_Pitch,AnimationFrameCount=34)
    AnimationDrivers(1)=(Channel=2,AnimationName="YAW_DRIVER",BoneName="YAW_BASE_POST",RotationType=ROTATION_Yaw,AnimationFrameCount=26)

    GunWheels(0)=(RotationType=ROTATION_Yaw,BoneName="YAW_WHEEL",Scale=-64.0,RotationAxis=AXIS_Y)
    GunWheels(1)=(RotationType=ROTATION_Pitch,BoneName="PITCH_WHEEL",Scale=64.0,RotationAxis=AXIS_Y)

    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_ZiS_stc.ZIS3_TURRET_YAW_COLLISION',AttachBone="GUN_YAW")
    CollisionStaticMeshes(1)=(CollisionStaticMesh=StaticMesh'DH_ZiS_stc.ZIS3_BARREL_COLLISION',AttachBone="BARREL")
    CollisionStaticMeshes(2)=(CollisionStaticMesh=StaticMesh'DH_ZiS_stc.ZIS_PITCH_COLLISION',AttachBone="GUN_PITCH")

    ShootAnim="SHOOT"
    ShootAnimBoneName="BARREL"
    YawBone="GUN_YAW"
    PitchBone="GUN_PITCH"
    WeaponFireAttachmentBone="MUZZLE_ZIS3"
    GunnerAttachmentBone="GUN_YAW"

    // Turret movement
    MaxPositiveYaw=4915 // 27 degrees
    MaxNegativeYaw=-4915
    YawStartConstraint=-5500.0
    YawEndConstraint=5500.0
    CustomPitchUpLimit=5097 // +28/-5 degrees (could actually elevate to 37 degrees, but reduced to stop breech sinking into ground)
    CustomPitchDownLimit=64100

    // Cannon ammo
    PrimaryProjectileClass=Class'DH_ZiS3CannonShell'
    SecondaryProjectileClass=Class'DH_ZiS3CannonShellHE'
    //TertiaryProjectileClass=Class'DH_ZiS3CannonShellAPCR'


    ProjectileDescriptions(0)="APBC"
    //ProjectileDescriptions(2)="APCR"

    nProjectileDescriptions(0)="BR-350B" // standard mid-late war APBC shell
    nProjectileDescriptions(1)="OF-350"
    //nProjectileDescriptions(2)="BR-350P"

    InitialPrimaryAmmo=10
    InitialSecondaryAmmo=15
    //InitialTertiaryAmmo=0
    MaxPrimaryAmmo=20
    MaxSecondaryAmmo=25
    //MaxTertiaryAmmo=0  //no APCR for zis3 because the gun is available since 1942, but APCR was only adopted in 1943.
    //Ideally it should be available on `43-`45 maps but i dont know a proper way to do this, so zis2 kinda "replaces" 76mm APCR shells in terms of gameplay for now
    SecondarySpread=0.002

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.76mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.76mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.76mm_fire03'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.reload_01s_01') // 3.75 seconds reload
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.reload_01s_02')
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

    ResupplyInterval=7.5
}
