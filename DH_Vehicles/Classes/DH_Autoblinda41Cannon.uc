//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Autoblinda41Cannon extends DHVehicleAutoCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_FiatL640_anm.fiatl640_turret_ext'

    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_FiatL640_stc.collision.fiatl640_turret_collision',AttachBone="gun_yaw")
    CollisionStaticMeshes(1)=(CollisionStaticMesh=StaticMesh'DH_FiatL640_stc.collision.fiatl640_turret_hatch_collision',AttachBone="hatch")
    CollisionStaticMeshes(2)=(CollisionStaticMesh=StaticMesh'DH_FiatL640_stc.collision.fiatl640_turret_gun_collision',AttachBone="gun_pitch")

    BeginningIdleAnim="closed"

    GunnerAttachmentBone="gun_yaw"

    FireEffectOffset=(X=0.0,Y=0.0,Z=-10.0)

    // Turret armor
    FrontArmorFactor=4.0
    RightArmorFactor=2.0
    LeftArmorFactor=2.0
    RearArmorFactor=0.6
    
    FrontArmorSlope=10.5
    RightArmorSlope=30.0
    LeftArmorSlope=30.0
    RearArmorSlope=12.2

    FrontLeftAngle=331.0
    FrontRightAngle=29.0
    RearRightAngle=151.0
    RearLeftAngle=209.0

    // Cannon movement
    ManualRotationsPerSecond=0.058  // 21 degrees per second
    CustomPitchUpLimit=3640     // +20 degrees
    CustomPitchDownLimit=63352  // -12 degrees

    // Cannon ammo  // TODO: add correct L6/40 ammo types
    PrimaryProjectileClass=class'DH_Vehicles.DH_Breda2065CannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_Breda2065CannonShellHE'

    nProjectileDescriptions(0)="Granata Perforante da 20"   // AP
    nProjectileDescriptions(1)="Granata da 20"              // HE

    InitialPrimaryAmmo=8
    InitialSecondaryAmmo=8

    MaxPrimaryAmmo=8
    MaxSecondaryAmmo=8
    SecondarySpread=0.0013  // TODO: not needed

    // 35 total magazines (280 rounds) [TODO: figure out the distribution]
    NumPrimaryMags=25
    NumSecondaryMags=10

    WeaponFireAttachmentBone="MUZZLE"
    FireInterval=0.25   // 240 rounds per minute

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_Breda38Bullet'
    InitialAltAmmo=24
    NumMGMags=10
    AltFireInterval=0.109  // 550 rounds per minute
    TracerProjectileClass=class'DH_Weapons.DH_Breda38BulletTracer'
    TracerFrequency=7

    // Weapon fire
    WeaponFireOffset=-2.0
    
    AltFireAttachmentBone="MG_MUZZLE"
    AltFireOffset=(X=-8,Y=0,Z=0)

    // TODO: get new sounds for all these!
    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.Panzeriii.50mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.Panzeriii.50mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.Panzeriii.50mm_fire03'
    AltFireSoundClass=SoundGroup'DH_WeaponSounds.Besa.Besa_FireLoop'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.Besa.Besa_FireEnd'

    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_01')
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_03')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_04')

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

    YawBone="gun_yaw"
    PitchBone="gun_pitch"
    
    ShootAnim="shoot"
    ShootAnimBoneName="barrel"

    GunWheels(0)=(RotationType=ROTATION_Yaw,BoneName="YAW_WHEEL",Scale=16.0,RotationAxis=AXIS_Y)
    GunWheels(1)=(RotationType=ROTATION_Yaw,BoneName="YAW_GEAR_02",Scale=16.0,RotationAxis=AXIS_Y)
    GunWheels(2)=(RotationType=ROTATION_Yaw,BoneName="YAW_GEAR_03",Scale=-16.0,RotationAxis=AXIS_Y)
    GunWheels(3)=(RotationType=ROTATION_Yaw,BoneName="YAW_GEAR_01",Scale=-16.0,RotationAxis=AXIS_Y)
    GunWheels(4)=(RotationType=ROTATION_Pitch,BoneName="PITCH_WHEEL",Scale=-64.0,RotationAxis=AXIS_Y)
}
