//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_BT7Cannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'allies_ahz_bt7_anm.BT7_turret_ext'
    Skins(0)=texture'allies_ahz_vehicles_tex.ext_vehicles.BT7_ext'
    Skins(1)=texture'allies_ahz_vehicles_tex.int_vehicles.BT7_int'
//  CollisionStaticMesh=StaticMesh // TODO: make one
    FireEffectOffset=(X=0.0,Y=0.0,Z=0.0) // TODO: set

    // Turret armor
    FrontArmorFactor=1.5
    RightArmorFactor=1.5
    LeftArmorFactor=1.5
    RearArmorFactor=1.5
    FrontArmorSlope=15.0
    RightArmorSlope=12.0
    LeftArmorSlope=12.0
    RearArmorSlope=0.0
    FrontLeftAngle=324.0
    FrontRightAngle=36.0
    RearRightAngle=144.0
    RearLeftAngle=216.0

    // Turret movement
    ManualRotationsPerSecond=0.05 // TODO: was 0.04, but that was inconsistent with comment (17 secs to fully rotate = 0.0588)
    CustomPitchUpLimit=6000
    CustomPitchDownLimit=64450 // TODO: check, was 63500

    // Cannon ammo // TODO: HE & 2nd AP type have been added?
    ProjectileClass=class'DH_Vehicles.DH_BT7CannonShellAP'
    PrimaryProjectileClass=class'DH_Vehicles.DH_BT7CannonShellAP'
    SecondaryProjectileClass=class'DH_Vehicles.DH_BT7CannonShell'
    TertiaryProjectileClass=class'DH_Vehicles.DH_BT7CannonShellHE'
    ProjectileDescriptions(0)="AP"
    ProjectileDescriptions(1)="APBC"
    ProjectileDescriptions(2)="HE"
    InitialPrimaryAmmo=50
    InitialSecondaryAmmo=20
    InitialTertiaryAmmo=70
    Spread=0.0
    SecondarySpread=0.0025
    TertiarySpread=0.002

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_DP28Bullet'
    InitialAltAmmo=60
    NumMGMags=20
    AltFireInterval=0.1
    TracerProjectileClass=class'DH_Weapons.DH_DP28TracerBullet'
    TracerFrequency=5

    // Weapon fire  (shake reduced due to light calibre)
    AltFireOffset=(X=-67.0,Y=7.5,Z=0.0)
    ShakeRotMag=(Z=1.0)
    ShakeRotRate=(Z=10.0)
    ShakeRotTime=2.0
    ShakeOffsetMag=(Z=0.5)
    ShakeOffsetRate=(Z=10.0)
    ShakeOffsetTime=2.0
    AltShakeOffsetMag=(X=0.5,Y=0.5,Z=0.5)
    AltShakeOffsetRate=(X=500.0,Y=500.0,Z=500.0)
    AltShakeOffsetTime=1.0
    AltShakeRotMag=(X=50.0,Y=50.0,Z=50.0)

    // Sounds
    CannonFireSound(0)=sound'Vehicle_Weapons.PanzerIII.50mm_fire01'
    CannonFireSound(1)=sound'Vehicle_Weapons.PanzerIII.50mm_fire02'
    CannonFireSound(2)=sound'Vehicle_Weapons.PanzerIII.50mm_fire03'
    AltFireSoundScaling=3.0 // TODO - use DH default 2.75 as other tank MGs?
    AltFireSoundClass=sound'Inf_Weapons.dt_fire_loop'
    AltFireEndSound=sound'Inf_Weapons.dt.dt_fire_end'
    ReloadStages(0)=(Sound=sound'Vehicle_reloads.Reloads.Panzer_III_reload_01')
    ReloadStages(1)=(Sound=sound'Vehicle_reloads.Reloads.Panzer_III_reload_02')
    ReloadStages(2)=(Sound=sound'Vehicle_reloads.Reloads.Panzer_III_reload_03')
    ReloadStages(3)=(Sound=sound'Vehicle_reloads.Reloads.Panzer_III_reload_04')
    AltReloadSound=sound'Vehicle_reloads.DT_ReloadHidden'

    // Cannon range settings
    RangeSettings(1)=250
    RangeSettings(2)=500
    RangeSettings(3)=1000
    RangeSettings(4)=1500
    RangeSettings(5)=2000
    RangeSettings(6)=2500
}
