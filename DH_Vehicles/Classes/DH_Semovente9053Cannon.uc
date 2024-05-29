//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Semovente9053Cannon extends DHVehicleCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Semovente9053_anm.semovente9053_turret_ext'
    Skins(0)=Texture'DH_Semovente9053_tex.semovente9053_turret_ext'

    // Turret armor
    FrontArmorFactor=3.0
    RightArmorFactor=1.5
    LeftArmorFactor=1.5
    RearArmorFactor=0.0
    FrontArmorSlope=29.0
    RightArmorSlope=0.0
    LeftArmorSlope=0.0
    RearArmorSlope=0.0

    FrontLeftAngle=270.0
    FrontRightAngle=90.0
    RearRightAngle=132.0
    RearLeftAngle=228.0

    BeginningIdleAnim="com_closed"

    // Cannon movement
    bHasTurret=true
    ManualRotationsPerSecond=0.033
    bLimitYaw=true
    MaxPositiveYaw=7281
    MaxNegativeYaw=-7281
    YawStartConstraint=-7281  // -40 degrees
    YawEndConstraint=7281  // +40 degrees
    CustomPitchUpLimit=3458  // +19 degrees
    CustomPitchDownLimit=64626  // -5 degrees

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_Semovente9053CannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_Semovente9053CannonShellHE'
    TertiaryProjectileClass=none

    nProjectileDescriptions(0)="Granata Perforante da 90"
    nProjectileDescriptions(1)="Granata da 90"

    InitialPrimaryAmmo=7
    InitialSecondaryAmmo=2

    MaxPrimaryAmmo=7
    MaxSecondaryAmmo=2
    
    SecondarySpread=0.00127

    // Weapon fire
    WeaponFireOffset=0.0
    
    // Fire Effects
    FireEffectScale=1.75
    FireEffectOffset=(X=-15.0,Y=15.0,Z=0.0)

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire03'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_1') //~3.9 seconds reload
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

    YawBone="GUN_YAW"
    PitchBone="GUN_PITCH"
    WeaponFireAttachmentBone="MUZZLE"

    ShootAnim="shoot"
    ShootAnimBoneName="BARREL"

    GunWheels(0)=(RotationType=ROTATION_Pitch,BoneName="GUNSIGHT",Scale=-1.0,RotationAxis=AXIS_Y)
    GunWheels(1)=(RotationType=ROTATION_Yaw,BoneName="YAW_WHEEL_L",Scale=64.0,RotationAxis=AXIS_Y)
    GunWheels(2)=(RotationType=ROTATION_Yaw,BoneName="YAW_WHEEL_R",Scale=64.0,RotationAxis=AXIS_Y)
    GunWheels(3)=(RotationType=ROTATION_Pitch,BoneName="PITCH_WHEEL_L",Scale=64.0,RotationAxis=AXIS_Y)
    GunWheels(4)=(RotationType=ROTATION_Pitch,BoneName="PITCH_WHEEL_R",Scale=64.0,RotationAxis=AXIS_Y)

    ShakeOffsetMag=(X=6.0,Y=2.0,Z=10.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=4.0
    ShakeRotMag=(X=100.0,Y=100.0,Z=800.0)
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
    ShakeRotTime=7.0

    VehicleAttachments(0)=(StaticMesh=StaticMesh'DH_Military_Italy.rf1ca_radio',RelativeLocation=(X=-42.1971,Y=-54.814,Z=37.2554),RelativeRotation=(Yaw=-16384))
    VehicleAttachments(1)=(AttachClass=class'DH_Engine.DHRadio',RelativeLocation=(X=-42.1971,Y=-54.814,Z=37.2554),RadioCollisionRadius=16.0,RadioCollisionHeight=10.0,bServerOnly=true)

    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Semovente9053_stc.semovente9053_turret_collision')
    CollisionStaticMeshes(1)=(CollisionStaticMesh=StaticMesh'DH_Semovente9053_stc.semovente9053_gun_collision',AttachBone="GUN_PITCH")
}
