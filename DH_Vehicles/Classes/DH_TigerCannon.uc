//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_TigerCannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_Tiger_anm.Tiger_turret_ext'
    Skins(0)=Texture'axis_vehicles_tex.ext_vehicles.Tiger1_ext'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_German_vehicles_stc.Tiger1.Tiger1_turret_Coll')
    HighDetailOverlay=Shader'axis_vehicles_tex.int_vehicles.tiger1_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=1

    // Turret armor
    FrontArmorFactor=13.0
    RightArmorFactor=8.7
    LeftArmorFactor=8.7
    RearArmorFactor=8.7
    FrontArmorSlope=8.0
    FrontLeftAngle=320.0
    FrontRightAngle=40.0
    RearRightAngle=140.0
    RearLeftAngle=220.0

    // Turret movement
    ManualRotationsPerSecond=0.0077
    PoweredRotationsPerSecond=0.025
    CustomPitchUpLimit=3095
    CustomPitchDownLimit=64353

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_TigerCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_TigerCannonShellHE'

    nProjectileDescriptions(0)="PzGr.39"
    nProjectileDescriptions(1)="Schw.Sprgr.Patr."

    InitialPrimaryAmmo=40
    InitialSecondaryAmmo=22
    MaxPrimaryAmmo=48
    MaxSecondaryAmmo=44
    SecondarySpread=0.00125

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_MG34Bullet'
    InitialAltAmmo=150
    NumMGMags=8
    AltFireInterval=0.08
    TracerProjectileClass=class'DH_Weapons.DH_MG34TracerBullet'
    TracerFrequency=7

    // Weapon fire
    WeaponFireOffset=184.0
    AltFireOffset=(X=-71.0,Y=31.0,Z=2.0)

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire03'
    AltFireSoundClass=sound'Inf_Weapons.mg34_p_fire_loop'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_01')
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_03')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_04')

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
    RangeSettings(21)=2200
    RangeSettings(22)=2400
    RangeSettings(23)=2600
    RangeSettings(24)=2800
    RangeSettings(25)=3000
    RangeSettings(26)=3200
    RangeSettings(27)=3400
    RangeSettings(28)=3600
    RangeSettings(29)=3800
    RangeSettings(30)=4000
}
