//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_T60Cannon extends DHVehicleAutoCannon;

defaultproperties
{
    Mesh=Mesh'DH_T60_anm.T60_turret_ext'
    Skins(0)=Texture'allies_vehicles_tex.ext_vehicles.T60_ext'
    Skins(1)=Texture'allies_vehicles_tex.int_vehicles.T60_int'
    HighDetailOverlay=Material'allies_vehicles_tex.int_vehicles.T60_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=1
    
    // Turret armor
    FrontArmorFactor=2.5
    RightArmorFactor=2.5
    LeftArmorFactor=2.5
    RearArmorFactor=2.5
    FrontArmorSlope=25.0
    RightArmorSlope=25.0
    LeftArmorSlope=25.0
    RearArmorSlope=24.0
    FrontLeftAngle=306.0
    FrontRightAngle=54.0
    RearRightAngle=130.0
    RearLeftAngle=230.0

    // Turret movement
    ManualRotationsPerSecond=0.025
    CustomPitchUpLimit=4551
    CustomPitchDownLimit=64262

    // Cannon ammo
    bMultipleRoundTypes=false
    ProjectileClass=class'DH_Vehicles.DH_T60CannonShell'
    PrimaryProjectileClass=class'DH_Vehicles.DH_T60CannonShell'
    ProjectileDescriptions(0)="AP-T"

    nProjectileDescriptions(0)="BZT" // armor piercing incendiary with tracer
    //nProjectileDescriptions(1)="OF" // fragmentary round with tracer (incendiary?)

    InitialPrimaryAmmo=58
    NumPrimaryMags=20

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_DP27Bullet'
    InitialAltAmmo=63
    NumMGMags=15
    AltFireInterval=0.105
    TracerProjectileClass=class'DH_Weapons.DH_DP27TracerBullet'
    TracerFrequency=5
    HudAltAmmoIcon=Texture'InterfaceArt_tex.HUD.dp27_ammo'

    // Weapon fire
    FireInterval=0.12 //500-750 rpm
    WeaponFireOffset=65.0
    AltFireOffset=(X=-30.0,Y=-20.0,Z=0.0)

    // Sounds
    CannonFireSound(0)=Sound'Vehicle_Weapons.T60.tnshk20_fire01'
    CannonFireSound(1)=Sound'Vehicle_Weapons.T60.tnshk20_fire02'
    CannonFireSound(2)=Sound'Vehicle_Weapons.T60.tnshk20_fire03'
    AltFireSoundClass=Sound'DH_WeaponSounds.dt_fire_loop'
    AltFireEndSound=Sound'DH_WeaponSounds.dt.dt_fire_end'
    ReloadStages(0)=(Sound=Sound'Vehicle_reloads.Reloads.T60_reload_01')
    ReloadStages(1)=(Sound=Sound'Vehicle_reloads.Reloads.T60_reload_02',HUDProportion=0.6)
    ReloadStages(2)=(Sound=Sound'Vehicle_reloads.Reloads.T60_reload_03')
    ReloadStages(3)=(Sound=Sound'Vehicle_reloads.Reloads.T60_reload_04',HUDProportion=0.4)
    AltReloadStages(0)=(Sound=Sound'Inf_Weapons_Foley.dt.DT_reloadempty01_000',Duration=1.76)
    AltReloadStages(1)=(Sound=Sound'Inf_Weapons_Foley.dt.DT_reloadempty02_052',Duration=2.29,HUDProportion=0.65)
    AltReloadStages(2)=(Sound=Sound'Inf_Weapons_Foley.dt.DT_reloadempty03_121',Duration=2.35)
    AltReloadStages(3)=(Sound=Sound'Inf_Weapons_Foley.dt.DT_reloadempty04_191',Duration=2.2,HUDProportion=0.35)

    // Cannon range settings
    RangeSettings(0)=0
    RangeSettings(1)=500
    RangeSettings(2)=1000
    RangeSettings(3)=1500
    RangeSettings(4)=2000
    RangeSettings(5)=2500
}
