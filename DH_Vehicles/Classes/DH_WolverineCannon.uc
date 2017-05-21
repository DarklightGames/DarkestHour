//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_WolverineCannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_Wolverine_anm.M10_turret_ext'
    Skins(0)=texture'DH_VehiclesUS_tex.ext_vehicles.M10_turret_ext'
    Skins(1)=texture'DH_VehiclesUS_tex.int_vehicles.M10_turret_int'
    Skins(2)=texture'DH_VehiclesUS_tex.int_vehicles.M10_turret_int'
    CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc.M10.M10_turret_coll'
    FireEffectScale=1.5 // turret fire is larger & positioned in centre of open turret
    FireEffectOffset=(X=0.0,Y=25.0,Z=10.0)

    // Turret armor
    FrontArmorFactor=5.7
    RightArmorFactor=2.5
    LeftArmorFactor=2.5
    RearArmorFactor=2.5
    FrontArmorSlope=45.0
    RightArmorSlope=25.0
    LeftArmorSlope=25.0
    FrontLeftAngle=332.0
    FrontRightAngle=28.0
    RearRightAngle=152.0
    RearLeftAngle=208.0

    // Turret movement
    ManualRotationsPerSecond=0.01
    CustomPitchUpLimit=5461
    CustomPitchDownLimit=63715

    // Cannon ammo
    ProjectileClass=class'DH_Vehicles.DH_WolverineCannonShell'
    PrimaryProjectileClass=class'DH_Vehicles.DH_WolverineCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_WolverineCannonShellHVAP'
    TertiaryProjectileClass=class'DH_Vehicles.DH_WolverineCannonShellHE'
    ProjectileDescriptions(1)="HVAP"
    ProjectileDescriptions(2)="HE"
    InitialPrimaryAmmo=25
    InitialSecondaryAmmo=5
    InitialTertiaryAmmo=24
    SecondarySpread=0.001
    TertiarySpread=0.00135

    // Weapon fire
    WeaponFireOffset=15.0
    AddedPitch=52

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire03'
    ReloadStages(0)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_01')
    ReloadStages(1)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_02s_03')
    ReloadStages(3)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_04')
}
