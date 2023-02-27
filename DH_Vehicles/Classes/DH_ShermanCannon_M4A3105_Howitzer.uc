//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanCannon_M4A3105_Howitzer extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_ShermanM4A3_anm.ShermanM4A3105_turret_ext'
    Skins(0)=Texture'DH_VehiclesUS_tex3.ext_vehicles.Sherman_105_ext'
    WeaponAttachOffset=(X=8.0,Y=0.0,Z=4.5)
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc3.ShermanM4A3.M4A3_105_turret_coll')

    // Turret armor
    FrontArmorFactor=9.0
    RightArmorFactor=5.1
    LeftArmorFactor=5.1
    RearArmorFactor=2.5
    RightArmorSlope=5.0
    LeftArmorSlope=5.0
    FrontLeftAngle=316.0
    FrontRightAngle=44.0
    RearRightAngle=136.0
    RearLeftAngle=224.0

    // Turret movement
    ManualRotationsPerSecond=0.0125
    CustomPitchUpLimit=6372
    CustomPitchDownLimit=64625 // 5 degrees - probably should be 10, but any more & barrel clips hull (a howitzer, so depression isn't really an issue anyway)

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A3105CannonShellHE'
    SecondaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A3105CannonShellSmoke'
    TertiaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A3105CannonShellHEAT'

    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="Smoke"
    ProjectileDescriptions(2)="HEAT"

    nProjectileDescriptions(0)="M1 HE-T"
    nProjectileDescriptions(1)="M60 WP"
    nProjectileDescriptions(2)="M67 HEAT"

    InitialPrimaryAmmo=30
    InitialSecondaryAmmo=4
    InitialTertiaryAmmo=12
    MaxPrimaryAmmo=45
    MaxSecondaryAmmo=0 //we'll need to find a better solution to limiting WP resupply later
    MaxTertiaryAmmo=15
    Spread=0.003
    SecondarySpread=0.0036
    TertiarySpread=0.00225

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_30CalBullet'
    InitialAltAmmo=250
    NumMGMags=5
    AltFireInterval=0.12
    TracerProjectileClass=class'DH_Weapons.DH_30CalTracerBullet'
    TracerFrequency=5

    // Smoke launcher
    SmokeLauncherClass=class'DH_Vehicles.DH_TwoInchBombThrower'
    SmokeLauncherFireOffset(0)=(X=22.0,Y=-39.0,Z=38.0)

    // Weapon fire
    WeaponFireOffset=8.5
    AddedPitch=340
    AltFireOffset=(X=-91.0,Y=-17.0,Z=8.5)
    AltFireSpawnOffsetX=56.0

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire03'
    AltFireSoundClass=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireLoop01'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireEnd01'
    ReloadStages(0)=(Sound=Sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_01')
    ReloadStages(1)=(Sound=Sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_02')
    ReloadStages(2)=(Sound=Sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_03')
    ReloadStages(3)=(Sound=Sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_04')
}
