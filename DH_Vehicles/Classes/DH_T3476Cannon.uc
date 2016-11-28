//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_T3476Cannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_T34_anm.T34-76_turret_ext'
    Skins(0)=texture'allies_vehicles_tex.ext_vehicles.T3476_ext'
    Skins(1)=texture'allies_vehicles_tex.int_vehicles.T3476_int'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=1
    HighDetailOverlay=shader'allies_vehicles_tex.int_vehicles.t3476_int_s'
    CollisionStaticMesh=StaticMesh'DH_Soviet_vehicles_stc.T34-76_turret_col'

    // Turret armor
    FrontArmorFactor=6.0
    LeftArmorFactor=5.2
    RightArmorFactor=5.2
    RearArmorFactor=5.2
    LeftArmorSlope=30.0
    RightArmorSlope=30.0
    RearArmorSlope=30.0
    FrontLeftAngle=341.0
    FrontRightAngle=19.0
    RearRightAngle=162.0
    RearLeftAngle=198.0

    // Turret movement
    ManualRotationsPerSecond=0.029
    PoweredRotationsPerSecond=0.07
    CustomPitchUpLimit=4660
    CustomPitchDownLimit=64535

    // Cannon ammo
    ProjectileClass=class'DH_Vehicles.DH_T3476CannonShell'
    PrimaryProjectileClass=class'DH_Vehicles.DH_T3476CannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_T3476CannonShellHE'
    ProjectileDescriptions(0)="APBC"
    InitialPrimaryAmmo=27
    InitialSecondaryAmmo=50
    SecondarySpread=0.002

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_DP28Bullet'
    InitialAltAmmo=60
    NumMGMags=15
    AltFireInterval=0.1
    TracerProjectileClass=class'DH_Weapons.DH_DP28TracerBullet'
    TracerFrequency=5
    HudAltAmmoIcon=texture'InterfaceArt_tex.HUD.dp27_ammo'

    // Weapon fire
    WeaponFireAttachmentBone="Gun"
    WeaponFireOffset=200.0
    AddedPitch=240
    AltFireOffset=(X=8.0,Y=12.0,Z=2.0) // adjusted from original

    // Sounds
    CannonFireSound(0)=sound'Vehicle_Weapons.T34_76.76mm_fire01'
    CannonFireSound(1)=sound'Vehicle_Weapons.T34_76.76mm_fire02'
    CannonFireSound(2)=sound'Vehicle_Weapons.T34_76.76mm_fire03'
    AltFireSoundClass=sound'DH_WeaponSounds.dt_fire_loop'
    AltFireEndSound=sound'DH_WeaponSounds.dt.dt_fire_end'
    ReloadStages(0)=(Sound=sound'Vehicle_reloads.Reloads.t34_76_reload_01')
    ReloadStages(1)=(Sound=sound'Vehicle_reloads.Reloads.t34_76_reload_02')
    ReloadStages(2)=(Sound=sound'Vehicle_reloads.Reloads.t34_76_reload_03')
    ReloadStages(3)=(Sound=sound'Vehicle_reloads.Reloads.t34_76_reload_04')
    AltReloadStages(0)=(Sound=sound'Inf_Weapons_Foley.dt.DT_reloadempty01_000',Duration=1.76)
    AltReloadStages(1)=(Sound=sound'Inf_Weapons_Foley.dt.DT_reloadempty02_052',Duration=2.29,HUDProportion=0.65)
    AltReloadStages(2)=(Sound=sound'Inf_Weapons_Foley.dt.DT_reloadempty03_121',Duration=2.35)
    AltReloadStages(3)=(Sound=sound'Inf_Weapons_Foley.dt.DT_reloadempty04_191',Duration=3.2,HUDProportion=0.35)

    // View shake
    ShakeRotMag=(X=0.0,Y=0.0,Z=250.0)
    ShakeRotRate=(X=0.0,Y=0.0,Z=2500.0)
    ShakeRotTime=6.0
    ShakeOffsetMag=(X=0.0,Y=0.0,Z=10.0)
    ShakeOffsetRate=(X=0.0,Y=0.0,Z=200.0)
    AltShakeRotMag=(X=50.0,Y=50.0,Z=50.0)
    AltShakeOffsetMag=(X=1.0,Y=1.0,Z=1.0)

    // Cannon range settings
    RangeSettings(0)=0
    RangeSettings(1)=200
    RangeSettings(2)=400
    RangeSettings(3)=600
    RangeSettings(4)=800
    RangeSettings(5)=1000
    RangeSettings(6)=1200
    RangeSettings(7)=1400
    RangeSettings(8)=1600
    RangeSettings(9)=1800
    RangeSettings(10)=2000
    RangeSettings(11)=2200
    RangeSettings(12)=2400
    RangeSettings(13)=2600
    RangeSettings(14)=2800
    RangeSettings(15)=3000
    RangeSettings(16)=3200
    RangeSettings(17)=3400
    RangeSettings(18)=3600
    RangeSettings(19)=3800
    RangeSettings(20)=4000
    RangeSettings(21)=4200
    RangeSettings(22)=4400
    RangeSettings(23)=4600
    RangeSettings(24)=4800
    RangeSettings(25)=5000
}
