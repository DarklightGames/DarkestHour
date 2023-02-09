//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_T3485Cannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_T34_anm.T34-85_turret_ext'
    Skins(0)=Texture'allies_vehicles_tex.ext_vehicles.T3485_ext'
    Skins(1)=Texture'allies_vehicles_tex.int_vehicles.T3485_int'
    HighDetailOverlay=Shader'allies_vehicles_tex.int_vehicles.T3485_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=1
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Soviet_vehicles_stc.T34-85_turret_col')

    // Turret armor
    FrontArmorFactor=8.4 //9.0 cm reduced by cast armor modifier 93%
    LeftArmorFactor=7.5
    RightArmorFactor=7.5
    RearArmorFactor=5.2
    FrontArmorSlope=5.0  // to do: spherical shape that has different slope depending on elevation
    LeftArmorSlope=18.0
    RightArmorSlope=18.0
    RearArmorSlope=10.0

    FrontLeftAngle=342.0
    FrontRightAngle=18.0
    RearRightAngle=162.0
    RearLeftAngle=198.0

    // Turret movement
    ManualRotationsPerSecond=0.02
    PoweredRotationsPerSecond=0.0555 // 20 degrees/sec
    CustomPitchUpLimit=4005 // +22/-5 degrees
    CustomPitchDownLimit=64626

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_T3485CannonShell_Early'
    SecondaryProjectileClass=class'DH_Vehicles.DH_T3485CannonShellAPCR'
    TertiaryProjectileClass=class'DH_Vehicles.DH_T3485CannonShellHE'

    ProjectileDescriptions(0)="APBC"
    ProjectileDescriptions(1)="APCR"
    ProjectileDescriptions(2)="HE"

    nProjectileDescriptions(0)="BR-365"
    nProjectileDescriptions(1)="BR-365P"
    nProjectileDescriptions(2)="O-365"

    InitialPrimaryAmmo=28
    InitialSecondaryAmmo=4
    InitialTertiaryAmmo=16
    MaxPrimaryAmmo=30
    MaxSecondaryAmmo=6
    MaxTertiaryAmmo=25
    SecondarySpread=0.001
    TertiarySpread=0.002

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_DP27Bullet'
    InitialAltAmmo=63
    NumMGMags=15
    AltFireInterval=0.105
    TracerProjectileClass=class'DH_Weapons.DH_DP27TracerBullet'
    TracerFrequency=5
    HudAltAmmoIcon=Texture'InterfaceArt_tex.HUD.dp27_ammo'

    // Weapon fire
    WeaponFireOffset=150.9
    AltFireOffset=(X=-41.0,Y=17.5,Z=0.0)

    // Sounds
    CannonFireSound(0)=Sound'Vehicle_Weapons.T34_85.85mm_fire01'
    CannonFireSound(1)=Sound'Vehicle_Weapons.T34_85.85mm_fire02'
    CannonFireSound(2)=Sound'Vehicle_Weapons.T34_85.85mm_fire03'
    AltFireSoundClass=Sound'DH_WeaponSounds.dt_fire_loop'
    AltFireEndSound=Sound'DH_WeaponSounds.dt.dt_fire_end'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_01')
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_03')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_04')
    AltReloadStages(0)=(Sound=Sound'Inf_Weapons_Foley.dt.DT_reloadempty01_000',Duration=1.76)
    AltReloadStages(1)=(Sound=Sound'Inf_Weapons_Foley.dt.DT_reloadempty02_052',Duration=2.29,HUDProportion=0.65)
    AltReloadStages(2)=(Sound=Sound'Inf_Weapons_Foley.dt.DT_reloadempty03_121',Duration=2.35)
    AltReloadStages(3)=(Sound=Sound'Inf_Weapons_Foley.dt.DT_reloadempty04_191',Duration=1.2,HUDProportion=0.35)

    // Cannon range settings
    RangeSettings(0)=0
    RangeSettings(1)=400
    RangeSettings(2)=500
    RangeSettings(3)=600
    RangeSettings(4)=700
    RangeSettings(5)=800
    RangeSettings(6)=900
    RangeSettings(7)=1000
    RangeSettings(8)=1200
    RangeSettings(9)=1400
    RangeSettings(10)=1600
    RangeSettings(11)=1800
    RangeSettings(12)=2000
    RangeSettings(13)=2200
    RangeSettings(14)=2400
    RangeSettings(15)=2600
    RangeSettings(16)=2800
    RangeSettings(17)=3000
    RangeSettings(18)=3200
    RangeSettings(19)=3400
    RangeSettings(20)=3600
    RangeSettings(21)=3800
}
