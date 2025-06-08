//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Pak40Cannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Pak40_anm.Pak40_turret_ext'
    Skins(0)=Texture'DH_Pak40_tex.Pak40.pak40_ext_gray'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Pak40_stc.Collision.PAK40_TURRET_COLLISION_BARREL',AttachBone="BARREL")
    CollisionStaticMeshes(1)=(CollisionStaticMesh=StaticMesh'DH_Pak40_stc.Collision.PAK40_TURRET_COLLISION_PITCH',AttachBone="GUN_PITCH")
    CollisionStaticMeshes(2)=(CollisionStaticMesh=StaticMesh'DH_Pak40_stc.Collision.PAK40_TURRET_COLLISION_YAW',AttachBone="GUN_YAW")
    GunnerAttachmentBone="GUN_YAW"
    PitchBone="GUN_PITCH"
    YawBone="GUN_YAW"
    ShootAnim="SHOOT"
    ShootAnimBoneName="BARREL"
    WeaponFireAttachmentBone="MUZZLE"
    GunWheels(0)=(RotationType=ROTATION_Yaw,BoneName="YAW_WHEEL",Scale=128,RotationAxis=AXIS_X)
    GunWheels(1)=(RotationType=ROTATION_Pitch,BoneName="PITCH_WHEEL",Scale=128,RotationAxis=AXIS_Y)
    AnimationDrivers(0)=(Channel=2,BoneName="PITCH_DRIVER_ROOT",AnimationName="PITCH_DRIVER",AnimationFrameCount=22,RotationType=ROTATION_Pitch)

    // Turret movement
    MaxPositiveYaw=5642
    MaxNegativeYaw=-5642
    YawStartConstraint=-5642    // -31 degrees
    YawEndConstraint=5642       // +31 degrees

    CustomPitchUpLimit=3094     // +17 degrees
    CustomPitchDownLimit=64444  // -6 degrees

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Guns.DH_Pak40CannonShell'
    SecondaryProjectileClass=class'DH_Guns.DH_Pak40CannonShellHE'
    TertiaryProjectileClass=class'DH_Guns.DH_Pak40CannonShellHEAT'

    nProjectileDescriptions(0)="PzGr.39"
    nProjectileDescriptions(1)="Sprgr.Patr.34"
    nProjectileDescriptions(2)="Gr.38 Hl/B"

    ProjectileDescriptions(2)="HEAT"

    // Ammo apparently came in cases of 3, so we keep the rounds as multiples of 3
    InitialPrimaryAmmo=9
    InitialSecondaryAmmo=6
    InitialTertiaryAmmo=6
    MaxPrimaryAmmo=12
    MaxSecondaryAmmo=9
    MaxTertiaryAmmo=12
    SecondarySpread=0.00127

    // Weapon fire
    WeaponFireOffset=1.0

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire03'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_01') // 3.75 seconds reload
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_3')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_4')

    // Cannon range settings
    RangeSettings(1)=100
    RangeSettings(2)=200
    RangeSettings(3)=300
    RangeSettings(4)=400
    RangeSettings(5)=500
    RangeSettings(6)=600
    RangeSettings(7)=700
    RangeSettings(8)=800
    RangeSettings(9)=900
    RangeSettings(10)=1000
    RangeSettings(11)=1100
    RangeSettings(12)=1200
    RangeSettings(13)=1300
    RangeSettings(14)=1400
    RangeSettings(15)=1500
    RangeSettings(16)=1600
    RangeSettings(17)=1700
    RangeSettings(18)=1800
    RangeSettings(19)=1900
    RangeSettings(20)=2000

    ResupplyInterval=7.5

    ShakeOffsetMag=(X=12.0,Y=4.0,Z=20.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=8.0
    ShakeRotMag=(X=100.0,Y=100.0,Z=800.0)
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
    ShakeRotTime=7.0
}
