//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanFireFlyCannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_ShermanFirefly_anm.ShermanFirefly_turret_ext'
    Skins(0)=Texture'DH_VehiclesUK_tex.ext_vehicles.FireFly_body_ext'
    Skins(1)=Texture'DH_VehiclesUK_tex.ext_vehicles.FireFly_armor_ext'
    Skins(2)=Texture'DH_VehiclesUS_tex.int_vehicles.Sherman_turret_int'
    WeaponAttachOffset=(X=0.0,Y=1.78,Z=4.77)
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc.Sherman.Firefly_turret_Col')

    // Turret armor
    FrontArmorFactor=7.6
    RightArmorFactor=5.1
    LeftArmorFactor=5.1
    RearArmorFactor=6.4
    RightArmorSlope=5.0
    LeftArmorSlope=5.0
    FrontLeftAngle=316.0
    FrontRightAngle=44.0
    RearRightAngle=136.0
    RearLeftAngle=224.0

    // Turret movement
    ManualRotationsPerSecond=0.02
    PoweredRotationsPerSecond=0.056
    CustomPitchUpLimit=4551
    CustomPitchDownLimit=64625

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_ShermanFireFlyCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_ShermanFireFlyCannonShellAPDS'
    TertiaryProjectileClass=class'DH_Vehicles.DH_ShermanFireFlyCannonShellHE'

    ProjectileDescriptions(1)="APDS"
    ProjectileDescriptions(2)="HE"

    nProjectileDescriptions(0)="Mk.IV APC"
    nProjectileDescriptions(1)="Mk.I APDS"
    nProjectileDescriptions(2)="Mk.I HE-T"

    InitialPrimaryAmmo=40
    InitialSecondaryAmmo=4
    InitialTertiaryAmmo=12
    MaxPrimaryAmmo=48
    MaxSecondaryAmmo=5
    MaxTertiaryAmmo=24
    SecondarySpread=0.002 // was originally 0.006 but was found to be too much, APDS should have a half chance of hitting a frontal panther turret at 400 yards, it now does.
    TertiarySpread=0.00156

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_30CalBullet'
    InitialAltAmmo=250
    NumMGMags=8
    AltFireInterval=0.12
    TracerProjectileClass=class'DH_Weapons.DH_30CalTracerBullet'
    TracerFrequency=5

    // Weapon fire
    WeaponFireOffset=6.0
    AltFireOffset=(X=-181.0,Y=-23.0,Z=0.0)
    AltFireSpawnOffsetX=48.0

    // Smoke launcher
    SmokeLauncherClass=class'DH_Vehicles.DH_TwoInchBombThrower'
    SmokeLauncherFireOffset(0)=(X=24.0,Y=-42.0,Z=41.0)

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_AlliedVehicleSounds.17pounder.DH17pounder'
    CannonFireSound(1)=SoundGroup'DH_AlliedVehicleSounds.17pounder.DH17pounder'
    CannonFireSound(2)=SoundGroup'DH_AlliedVehicleSounds.17pounder.DH17pounder'
    AltFireSoundClass=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireLoop01'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireEnd01'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_01')
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_03')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_04')

    // Cannon range settings
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
    RangeSettings(11)=2400
    RangeSettings(12)=2800
    RangeSettings(13)=3200
    RangeSettings(14)=3600
    RangeSettings(15)=4000
}
