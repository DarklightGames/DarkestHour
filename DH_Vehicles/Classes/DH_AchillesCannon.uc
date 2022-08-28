//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_AchillesCannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_Wolverine_anm.Achilles_turret_ext'
    Skins(0)=Texture'DH_VehiclesUK_tex.ext_vehicles.Achilles_turret_ext'
    Skins(1)=Texture'DH_VehiclesUK_tex.int_vehicles.Achilles_turret_int'
    Skins(2)=Texture'DH_VehiclesUK_tex.int_vehicles.Achilles_turret_int'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc.M10.M10_turret_coll')
    FireEffectScale=1.5 // turret fire is larger & positioned in centre of open turret
    FireEffectOffset=(X=0.0,Y=20.0,Z=10.0)

    // Turret armor
    FrontArmorFactor=5.0
    RightArmorFactor=2.5
    LeftArmorFactor=2.5
    RearArmorFactor=2.5
    FrontArmorSlope=45.0
    RightArmorSlope=15.0
    LeftArmorSlope=15.0
    FrontLeftAngle=332.0
    FrontRightAngle=28.0
    RearRightAngle=152.0
    RearLeftAngle=208.0

    // Turret movement
    ManualRotationsPerSecond=0.011111
    CustomPitchUpLimit=3641
    CustomPitchDownLimit=64653

    // Cannon ammo
    ProjectileClass=class'DH_Vehicles.DH_AchillesCannonShell'
    PrimaryProjectileClass=class'DH_Vehicles.DH_AchillesCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_AchillesCannonShellAPDS'
    TertiaryProjectileClass=class'DH_Vehicles.DH_AchillesCannonShellHE'

    ProjectileDescriptions(1)="APDS"
    ProjectileDescriptions(2)="HE"

    nProjectileDescriptions(0)="Mk.IV APC"
    nProjectileDescriptions(1)="Mk.I APDS"
    nProjectileDescriptions(2)="Mk.I HE-T"

    InitialPrimaryAmmo=20
    InitialSecondaryAmmo=2
    InitialTertiaryAmmo=8
    MaxPrimaryAmmo=32
    MaxSecondaryAmmo=4
    MaxTertiaryAmmo=15
    SecondarySpread=0.002 // was originally 0.006 but was found to be too much, APDS should have a half chance of hitting a frontal panther turret at 400 yards, it now does.
    TertiarySpread=0.00156

    // Weapon fire
    WeaponFireOffset=5.5

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_AlliedVehicleSounds.17pounder.DH17pounder'
    CannonFireSound(1)=SoundGroup'DH_AlliedVehicleSounds.17pounder.DH17pounder'
    CannonFireSound(2)=SoundGroup'DH_AlliedVehicleSounds.17pounder.DH17pounder'
    ReloadStages(0)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_01')
    ReloadStages(1)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_02')
    ReloadStages(2)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_03')
    ReloadStages(3)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_04')

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
