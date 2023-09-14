//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Sdkfz2342Cannon extends DHVehicleCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Puma_turret_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex6.ext_vehicles.Puma_turret_dunk'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_German_vehicles_stc3.Puma.Puma_turret_coll')
    FireEffectOffset=(X=0.0,Y=0.0,Z=-10.0)

    // Turret armor
    FrontArmorFactor=3.0
    RightArmorFactor=1.0
    LeftArmorFactor=1.0
    RearArmorFactor=1.0
    FrontArmorSlope=40.0
    RightArmorSlope=25.0
    LeftArmorSlope=25.0
    RearArmorSlope=25.0
    FrontLeftAngle=331.0
    FrontRightAngle=29.0
    RearRightAngle=151.0
    RearLeftAngle=209.0

    // Cannon movement
    ManualRotationsPerSecond=0.04
    CustomPitchUpLimit=3640
    CustomPitchDownLimit=63715

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_Sdkfz2342CannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_Sdkfz2342CannonShellHE'

    nProjectileDescriptions(0)="PzGr.39"
    nProjectileDescriptions(1)="Sprgr.Patr.38"

    InitialPrimaryAmmo=35
    InitialSecondaryAmmo=20


    MaxPrimaryAmmo=35
    MaxSecondaryAmmo=20
    SecondarySpread=0.0013

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_MG42Bullet'
    InitialAltAmmo=150
    NumMGMags=10
    AltFireInterval=0.05
    TracerProjectileClass=class'DH_Weapons.DH_MG42TracerBullet'
    TracerFrequency=7

    // Smoke launcher
    SmokeLauncherClass=class'DH_Vehicles.DH_ExternalSmokeCandleDischarger'
    SmokeLauncherFireOffset(0)=(X=38.0,Y=-39.0,Z=35.0)
    SmokeLauncherFireOffset(1)=(X=38.0,Y=37.0,Z=35.0)
    SmokeLauncherFireOffset(2)=(X=37.0,Y=-45.0,Z=29.0)
    SmokeLauncherFireOffset(3)=(X=37.0,Y=43.0,Z=29.0)
    SmokeLauncherFireOffset(4)=(X=40.0,Y=-46.0,Z=23.0)
    SmokeLauncherFireOffset(5)=(X=40.0,Y=44.0,Z=23.0)

    // Weapon fire
    WeaponFireOffset=-2.0
    AltFireOffset=(X=-155.0,Y=17.0,Z=2.0)

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
}
