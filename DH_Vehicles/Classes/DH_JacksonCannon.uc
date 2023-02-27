//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JacksonCannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_Jackson_anm.Jackson_turret_ext'
    Skins(0)=Texture'DH_VehiclesUS_tex3.ext_vehicles.M36_turret_ext'
    Skins(1)=Texture'DH_VehiclesUS_tex3.int_vehicles.M36_turret_int'
    Skins(2)=Texture'DH_VehiclesUS_tex3.int_vehicles.M36_turret_int2'
    Skins(3)=Texture'DH_VehiclesUS_tex3.ext_vehicles.M36_turret_ext' // shows the muzzle brake
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc2.Jackson.Jackson_turret_col')
    FireAttachBone="Turret"
    FireEffectScale=1.5 // turret fire is larger & positioned in centre of open turret
    FireEffectOffset=(X=-12.0,Y=0.0,Z=41.0)

    // Turret armor
    FrontArmorFactor=6.9
    RightArmorFactor=3.2
    LeftArmorFactor=3.2
    RearArmorFactor=8.0
    FrontArmorSlope=45.0
    RightArmorSlope=5.0
    LeftArmorSlope=5.0
    FrontLeftAngle=325.0
    FrontRightAngle=35.0
    RearRightAngle=145.0
    RearLeftAngle=215.0

    // Turret movement
    ManualRotationsPerSecond=0.01
    PoweredRotationsPerSecond=0.0625
    CustomPitchUpLimit=3641
    CustomPitchDownLimit=63715

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_JacksonCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_JacksonCannonShellHVAP'
    TertiaryProjectileClass=class'DH_Vehicles.DH_JacksonCannonShellHE'

    ProjectileDescriptions(1)="HVAP"
    ProjectileDescriptions(2)="HE"

    nProjectileDescriptions(0)="M82 APC"
    nProjectileDescriptions(1)="M304 HVAP"
    nProjectileDescriptions(2)="M71 HE-T"

    InitialPrimaryAmmo=30
    InitialSecondaryAmmo=4
    InitialTertiaryAmmo=5
    MaxPrimaryAmmo=32
    MaxSecondaryAmmo=6
    MaxTertiaryAmmo=10
    SecondarySpread=0.0011
    TertiarySpread=0.00125

    // Weapon fire
    WeaponFireOffset=33.0
    AddedPitch=190

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.IS2.122mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.IS2.122mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.IS2.122mm_fire02'
    ReloadStages(0)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_01')
    ReloadStages(1)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_02')
    ReloadStages(2)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_03')
    ReloadStages(3)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_04')
}
