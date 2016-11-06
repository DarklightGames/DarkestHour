//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PantherDCannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_Panther_anm.Panther_turret_ext'
    Skins(0)=texture'axis_vehicles_tex.ext_vehicles.pantherg_ext'
    Skins(1)=texture'axis_vehicles_tex.int_vehicles.pantherg_int'
    CollisionStaticMesh=StaticMesh'DH_German_vehicles_stc.PantherG.Panther_turret_coll'
    HighDetailOverlay=shader'axis_vehicles_tex.int_vehicles.pantherg_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=1

    // Turret armor
    FrontArmorFactor=12.0
    RightArmorFactor=4.5
    LeftArmorFactor=4.5
    RearArmorFactor=4.5
    FrontArmorSlope=13.0
    RightArmorSlope=25.0
    LeftArmorSlope=25.0
    RearArmorSlope=25.0
    FrontLeftAngle=322.0
    FrontRightAngle=38.0
    RearRightAngle=142.0
    RearLeftAngle=218.0

    // Turret movement
    ManualRotationsPerSecond=0.011
    PoweredRotationsPerSecond=0.033
    CustomPitchUpLimit=3276
    CustomPitchDownLimit=64080

    // Cannon ammo
    ProjectileClass=class'DH_Vehicles.DH_PantherCannonShell'
    PrimaryProjectileClass=class'DH_Vehicles.DH_PantherCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_PantherCannonShellAPCR'
    TertiaryProjectileClass=class'DH_Vehicles.DH_PantherCannonShellHE'
    ProjectileDescriptions(1)="APCR"
    ProjectileDescriptions(2)="HE"
    InitialPrimaryAmmo=44
    InitialSecondaryAmmo=5
    InitialTertiaryAmmo=35
    SecondarySpread=0.00165
    TertiarySpread=0.0012

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_MG34Bullet'
    InitialAltAmmo=150
    NumMGMags=9
    AltFireInterval=0.07059
    TracerProjectileClass=class'DH_Weapons.DH_MG34TracerBullet'
    TracerFrequency=7

    // Weapon fire
    WeaponFireOffset=222.0
    AltFireOffset=(X=-32.0,Y=27.0,Z=7.0)

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.Panther.75mm_VL_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.Panther.75mm_VL_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.Panther.75mm_VL_fire03'
    AltFireSoundClass=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    ReloadStages(0)=(Sound=sound'Vehicle_reloads.Reloads.STUG_III_reload_01')
    ReloadStages(1)=(Sound=sound'Vehicle_reloads.Reloads.STUG_III_reload_02')
    ReloadStages(2)=(Sound=sound'Vehicle_reloads.Reloads.STUG_III_reload_03')
    ReloadStages(3)=(Sound=sound'Vehicle_reloads.Reloads.STUG_III_reload_04')

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
}
