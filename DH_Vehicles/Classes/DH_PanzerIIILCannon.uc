//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_PanzerIIILCannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_Panzer3_anm.Panzer3L_turret_ext'
    Skins(0)=texture'DH_VehiclesGE_tex2.ext_vehicles.panzer3_body_camo1'
    Skins(1)=texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha'
    Skins(2)=texture'axis_vehicles_tex.int_vehicles.panzer3_int'
    CollisionStaticMesh=StaticMesh'DH_German_vehicles_stc2.Panzer3.Panzer3L_turret_coll'
    HighDetailOverlay=shader'axis_vehicles_tex.int_vehicles.panzer3_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    // Turret armor
    FrontArmorFactor=5.7
    RightArmorFactor=3.0
    LeftArmorFactor=3.0
    RearArmorFactor=3.0
    FrontArmorSlope=25.0
    RightArmorSlope=25.0
    LeftArmorSlope=25.0
    RearArmorSlope=12.0
    FrontLeftAngle=325.0
    FrontRightAngle=35.0
    RearRightAngle=145.0
    RearLeftAngle=215.0

    // Turret movement
    ManualRotationsPerSecond=0.04
    CustomPitchUpLimit=3641
    CustomPitchDownLimit=63715

    // Cannon ammo
    ProjectileClass=class'DH_Vehicles.DH_PanzerIIILCannonShell'
    PrimaryProjectileClass=class'DH_Vehicles.DH_PanzerIIILCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_PanzerIIILCannonShellAPCR'
    TertiaryProjectileClass=class'DH_Vehicles.DH_PanzerIIILCannonShellHE'
    ProjectileDescriptions(1)="APCR"
    ProjectileDescriptions(2)="HE"
    InitialPrimaryAmmo=55
    InitialSecondaryAmmo=10
    InitialTertiaryAmmo=30
    SecondarySpread=0.00165
    TertiarySpread=0.0013

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_MG34Bullet'
    InitialAltAmmo=150
    NumMGMags=8
    AltFireInterval=0.07059
    TracerProjectileClass=class'DH_Weapons.DH_MG34TracerBullet'
    TracerFrequency=7

    // Weapon fire
    WeaponFireOffset=9.0
    AltFireOffset=(X=-137.0,Y=21.5,Z=4.5)
    AltFireSpawnOffsetX=61.0
    AltShakeOffsetMag=(X=0.1,Y=0.1,Z=0.1)

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.Panzeriii.50mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.Panzeriii.50mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.Panzeriii.50mm_fire03'
    AltFireSoundClass=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    ReloadStages(0)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_01')
    ReloadStages(1)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_03')
    ReloadStages(3)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_04')

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
