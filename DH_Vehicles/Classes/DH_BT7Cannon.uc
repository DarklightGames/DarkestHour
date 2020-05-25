//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_BT7Cannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=Mesh'DH_BT7_anm.BT7_turret_ext'
    skins(0)=Texture'allies_ahz_vehicles_tex.ext_vehicles.BT7_ext'
    skins(1)=Texture'allies_ahz_vehicles_tex.int_vehicles.BT7_int'
    bUseHighDetailOverlayIndex=false
    //CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc.M10.M10_turret_coll'

    // Turret armor
    FrontArmorFactor=1.5
    LeftArmorFactor=1.5
    RightArmorFactor=1.5
    RearArmorFactor=1.3
    FrontArmorSlope=12.0
    LeftArmorSlope=12.0
    RightArmorSlope=12.0
    RearArmorSlope=15.0

    FrontLeftAngle=341.0
    FrontRightAngle=19.0
    RearRightAngle=162.0
    RearLeftAngle=198.0

    // Turret movement
    ManualRotationsPerSecond=0.04
    CustomPitchUpLimit=4551 // +25/-8 degrees
    CustomPitchDownLimit=64079

    // Cannon ammo
    ProjectileClass=class'DH_Vehicles.DH_BT7CannonShell'
    PrimaryProjectileClass=class'DH_Vehicles.DH_BT7CannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_BT7CannonShellHE'

    ProjectileDescriptions(0)="APHE-T"
    ProjectileDescriptions(1)="HE"

    nProjectileDescriptions(0)="BR-240"
    nProjectileDescriptions(1)="O-240"

    InitialPrimaryAmmo=30
    InitialSecondaryAmmo=30

    MaxPrimaryAmmo=60
    MaxSecondaryAmmo=60

    SecondarySpread=0.002

    // Weapon fire
    WeaponFireOffset=8.0
    EffectEmitterClass=class'ROEffects.TankCannonFireEffectTypeC' // smaller muzzle flash effect
    AltFireOffset=(X=-75.0,Y=7.75,Z=0.0)

    // Cannon range settings
    RangeSettings(0)=0
    RangeSettings(1)=500
    RangeSettings(2)=1000
    RangeSettings(3)=1500
    RangeSettings(4)=2000
    RangeSettings(5)=2500

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_DP28Bullet'
    InitialAltAmmo=60
    NumMGMags=15
    AltFireInterval=0.1
    TracerProjectileClass=class'DH_Weapons.DH_DP28TracerBullet'
    TracerFrequency=5
    HudAltAmmoIcon=Texture'InterfaceArt_tex.HUD.dp27_ammo'

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_ArtillerySounds.AT_Guns.47mm_fire01'
    CannonFireSound(1)=SoundGroup'DH_ArtillerySounds.AT_Guns.47mm_fire02'
    CannonFireSound(2)=SoundGroup'DH_ArtillerySounds.AT_Guns.47mm_fire03'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_01')
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_03')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_04')
    AltFireSoundClass=Sound'DH_WeaponSounds.dt_fire_loop'
    AltFireEndSound=Sound'DH_WeaponSounds.dt.dt_fire_end'

    AltReloadStages(0)=(Sound=Sound'Inf_Weapons_Foley.dt.DT_reloadempty01_000',Duration=1.76)
    AltReloadStages(1)=(Sound=Sound'Inf_Weapons_Foley.dt.DT_reloadempty02_052',Duration=2.29,HUDProportion=0.65)
    AltReloadStages(2)=(Sound=Sound'Inf_Weapons_Foley.dt.DT_reloadempty03_121',Duration=1.35)
    AltReloadStages(3)=(Sound=Sound'Inf_Weapons_Foley.dt.DT_reloadempty04_191',Duration=2.2,HUDProportion=0.35)
}
