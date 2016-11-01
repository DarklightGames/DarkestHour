//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_IS2Cannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_IS2_anm.IS2-turret_ext'
    Skins(0)=texture'allies_vehicles_tex.ext_vehicles.IS2_ext'
    Skins(1)=texture'allies_vehicles_tex.int_vehicles.IS2_int'
    HighDetailOverlay=shader'allies_vehicles_tex.int_vehicles.IS2_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=1
    CollisionStaticMesh=StaticMesh'DH_Soviet_vehicles_stc.IS2.IS2_turret_coll'

    // Turret armor
    FrontArmorFactor=10.0
    LeftArmorFactor=9.0
    RightArmorFactor=9.0
    RearArmorFactor=9.0
    LeftArmorSlope=20.0
    RightArmorSlope=20.0
    RearArmorSlope=30.0
    FrontLeftAngle=340.0
    FrontRightAngle=20.0
    RearRightAngle=143.0
    RearLeftAngle=217.0

    // Turret movement
    ManualRotationsPerSecond=0.029
    PoweredRotationsPerSecond=0.07
    CustomPitchUpLimit=6000
    CustomPitchDownLimit=64500

    // Cannon ammo
    ProjectileClass=class'DH_Vehicles.DH_IS2CannonShell'
    PrimaryProjectileClass=class'DH_Vehicles.DH_IS2CannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_IS2CannonShellHE'
    ProjectileDescriptions(0)="AP"
    InitialPrimaryAmmo=18
    InitialSecondaryAmmo=10
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
    AltFireOffset=(X=8.0,Y=14.0,Z=13.0) // repositioned as was way off in original

    // Sounds
    CannonFireSound(0)=sound'Vehicle_Weapons.IS2.122mm_fire01'
    CannonFireSound(1)=sound'Vehicle_Weapons.IS2.122mm_fire02'
    CannonFireSound(2)=sound'Vehicle_Weapons.IS2.122mm_fire02'
    AltFireSoundClass=sound'Inf_Weapons.dt_fire_loop'
    AltFireEndSound=sound'Inf_Weapons.dt.dt_fire_end'
    ReloadStages(0)=(Sound=sound'Vehicle_reloads.Reloads.IS2_reload_01')
    ReloadStages(1)=(Sound=sound'Vehicle_reloads.Reloads.IS2_reload_02')
    ReloadStages(2)=(Sound=sound'Vehicle_reloads.Reloads.IS2_reload_03')
    ReloadStages(3)=(Sound=sound'Vehicle_reloads.Reloads.IS2_reload_04')
    AltReloadSound=sound'Vehicle_reloads.Reloads.DT_ReloadHidden'

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
