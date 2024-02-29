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
    PrimaryProjectileClass=class'DH_Vehicles.DH_Sdkfz2341CannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_Sdkfz2341CannonShellHE'

    nProjectileDescriptions(0)="PzGr.39"
    nProjectileDescriptions(1)="Sprgr.Patr.38"

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
    AltFireProjectileClass=class'DH_Weapons.DH_MG42Bullet'  // TODO: 8mm breda
    InitialAltAmmo=150
    NumMGMags=10
    AltFireInterval=0.05
    TracerProjectileClass=class'DH_Weapons.DH_MG42TracerBullet'
    TracerFrequency=7

    // Weapon fire
    WeaponFireOffset=-2.0
    
    AltFireAttachmentBone="MG_MUZZLE"
    AltFireOffset=(X=-8,Y=0,Z=0)

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.Panzeriii.50mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.Panzeriii.50mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.Panzeriii.50mm_fire03'
    AltFireSoundClass=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireLoop01'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireEnd01'
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
}
