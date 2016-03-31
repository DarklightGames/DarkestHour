//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WolverineCannon extends DHVehicleCannon;

defaultproperties
{
    InitialTertiaryAmmo=24
    TertiaryProjectileClass=class'DH_Vehicles.DH_WolverineCannonShellHE'
    SecondarySpread=0.001
    TertiarySpread=0.00135
    ManualRotationsPerSecond=0.01
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
    ReloadSoundOne=sound'DH_Vehicle_Reloads.Reloads.reload_01s_01'
    ReloadSoundTwo=sound'DH_Vehicle_Reloads.Reloads.reload_01s_02'
    ReloadSoundThree=sound'DH_Vehicle_Reloads.Reloads.reload_02s_03'
    ReloadSoundFour=sound'DH_Vehicle_Reloads.Reloads.reload_01s_04'
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire03'
    ProjectileDescriptions(1)="HVAP"
    ProjectileDescriptions(2)="HE"
    AddedPitch=52
    WeaponFireOffset=15.0
    ProjectileClass=class'DH_Vehicles.DH_WolverineCannonShell'
    CustomPitchUpLimit=5461
    CustomPitchDownLimit=63715
    InitialPrimaryAmmo=25
    InitialSecondaryAmmo=5
    PrimaryProjectileClass=class'DH_Vehicles.DH_WolverineCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_WolverineCannonShellHVAP'
    FireEffectScale=1.5 // turret fire is larger & positioned in centre of open turret
    FireEffectOffset=(X=0.0,Y=25.0,Z=10.0)
    Mesh=SkeletalMesh'DH_Wolverine_anm.M10_turret_ext'
    Skins(0)=texture'DH_VehiclesUS_tex.ext_vehicles.M10_turret_ext'
    Skins(1)=texture'DH_VehiclesUS_tex.int_vehicles.M10_turret_int'
    Skins(2)=texture'DH_VehiclesUS_tex.int_vehicles.M10_turret_int'
    CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc.M10.M10_turret_coll'
    SoundVolume=80
    SoundRadius=300.0 // TODO: maybe remove so inherits default 200, as not an especially powerful gun & this does not match the Sherman 76? (also, SoundVolume is lower than default 130)
}
