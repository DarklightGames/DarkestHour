//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_IS2Cannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_IS2_anm.IS2-turret_ext'
    Skins(0)=Texture'allies_vehicles_tex.ext_vehicles.IS2_ext'
    Skins(1)=Texture'allies_vehicles_tex.int_vehicles.IS2_int'
    HighDetailOverlay=Shader'allies_vehicles_tex.int_vehicles.IS2_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=1
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Soviet_vehicles_stc.IS2.IS2_turret_coll')

    // Turret armor - JS-2 Model 1943
    FrontArmorFactor=10.0
    LeftArmorFactor=9.0
    RightArmorFactor=9.0
    RearArmorFactor=9.0

    LeftArmorSlope=20.0
    FrontArmorSlope=10.0
    RightArmorSlope=20.0
    RearArmorSlope=30.0

    FrontLeftAngle=340.0
    FrontRightAngle=20.0
    RearRightAngle=143.0
    RearLeftAngle=217.0

    // Turret movement
    ManualRotationsPerSecond=0.011
    PoweredRotationsPerSecond=0.0333 // 12 degrees/sec
    CustomPitchUpLimit=3459 // +19/-2 degrees
    CustomPitchDownLimit=65172

    // Cannon ammo
    ProjectileClass=class'DH_Vehicles.DH_IS2CannonShell'
    PrimaryProjectileClass=class'DH_Vehicles.DH_IS2CannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_IS2CannonShellHE'

    ProjectileDescriptions(0)="AP"

    nProjectileDescriptions(0)="BR-471" // earlier AP round without ballistic cap
    nProjectileDescriptions(1)="OF-471"

    InitialPrimaryAmmo=16
    InitialSecondaryAmmo=8
    MaxPrimaryAmmo=16
    MaxSecondaryAmmo=12
    SecondarySpread=0.002

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_DP27Bullet'
    InitialAltAmmo=63
    NumMGMags=15
    AltFireInterval=0.105
    TracerProjectileClass=class'DH_Weapons.DH_DP27TracerBullet'
    TracerFrequency=5
    HudAltAmmoIcon=Texture'InterfaceArt_tex.HUD.dp27_ammo'

    // Weapon fire
    WeaponFireOffset=232.9
    AltFireOffset=(X=-36.0,Y=13.5,Z=14.5)

    // Sounds
    CannonFireSound(0)=Sound'Vehicle_Weapons.IS2.122mm_fire01'
    CannonFireSound(1)=Sound'Vehicle_Weapons.IS2.122mm_fire02'
    CannonFireSound(2)=Sound'Vehicle_Weapons.IS2.122mm_fire02'
    AltFireSoundClass=Sound'DH_WeaponSounds.dt_fire_loop'
    AltFireEndSound=Sound'DH_WeaponSounds.dt.dt_fire_end'

    ReloadStages(0)=(Sound=Sound'Vehicle_reloads.Reloads.IS2_reload_01') //Early model 2-3 rounds per minute
    ReloadStages(1)=(Sound=Sound'Vehicle_reloads.Reloads.IS2_reload_02')
    ReloadStages(2)=(Sound=Sound'Vehicle_reloads.Reloads.IS2_reload_03')
    ReloadStages(3)=(Sound=Sound'Vehicle_reloads.Reloads.IS2_reload_04')

    AltReloadStages(0)=(Sound=Sound'Inf_Weapons_Foley.dt.DT_reloadempty01_000',Duration=1.76)
    AltReloadStages(1)=(Sound=Sound'Inf_Weapons_Foley.dt.DT_reloadempty02_052',Duration=2.29,HUDProportion=0.65)
    AltReloadStages(2)=(Sound=Sound'Inf_Weapons_Foley.dt.DT_reloadempty03_121',Duration=1.35)
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
    RangeSettings(22)=4000
    RangeSettings(23)=4200
    RangeSettings(24)=4400
    RangeSettings(25)=4600
    RangeSettings(26)=4800
    RangeSettings(27)=5000
    RangeSettings(28)=5200
}
