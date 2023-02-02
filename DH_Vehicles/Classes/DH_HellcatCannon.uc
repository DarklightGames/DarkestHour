//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_HellcatCannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_Hellcat_anm.hellcat_turret_ext'
    Skins(0)=Texture'DH_VehiclesUS_tex5.ext_vehicles.hellcat_turret_ext'
    Skins(1)=Texture'DH_VehiclesUS_tex5.int_vehicles.hellcat_turret_int'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc3.Hellcat.Hellcat_turret_coll')
    FireAttachBone="Turret"
    FireEffectScale=1.5 // turret fire is larger & positioned in centre of open turret
    FireEffectOffset=(X=15.0,Y=30.0,Z=0.0)

    // Turret armor
    FrontArmorFactor=1.9
    RightArmorFactor=1.3
    LeftArmorFactor=1.3
    RearArmorFactor=1.3
    RightArmorSlope=20.0
    LeftArmorSlope=20.0
    RearArmorSlope=13.0
    FrontLeftAngle=324.0
    FrontRightAngle=36.0
    RearRightAngle=144.0
    RearLeftAngle=216.0

    // Turret movement
    ManualRotationsPerSecond=0.033
    PoweredRotationsPerSecond=0.067
    CustomPitchUpLimit=3641
    CustomPitchDownLimit=63715

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_HellcatCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_HellcatCannonShellHVAP'
    TertiaryProjectileClass=class'DH_Vehicles.DH_HellcatCannonShellHE'

    ProjectileDescriptions(1)="HVAP"
    ProjectileDescriptions(2)="HE"

    nProjectileDescriptions(0)="M62 APC"
    nProjectileDescriptions(1)="M93 HVAP"
    nProjectileDescriptions(2)="M42A1 HE-T"

    InitialPrimaryAmmo=30
    InitialSecondaryAmmo=4
    InitialTertiaryAmmo=5
    MaxPrimaryAmmo=30
    MaxSecondaryAmmo=5
    MaxTertiaryAmmo=10
    SecondarySpread=0.001
    TertiarySpread=0.00135

    // Weapon fire
    WeaponFireOffset=-4.0
    AddedPitch=52

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire03'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_01')
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_03')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_04')
}
