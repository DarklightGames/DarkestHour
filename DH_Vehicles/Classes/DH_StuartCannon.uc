//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_StuartCannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_Stuart_anm.Stuart_turret_ext'
    Skins(0)=Texture'DH_VehiclesUS_tex.ext_vehicles.M5_body_ext'
    Skins(1)=Texture'DH_VehiclesUS_tex.int_vehicles.M5_turret_int'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc.M5_Stuart.Stuart_turret_col')

    // Turret armor
    FrontArmorFactor=5.1
    RightArmorFactor=3.2
    LeftArmorFactor=3.2
    RearArmorFactor=3.2
    FrontArmorSlope=10.0
    FrontLeftAngle=323.0
    FrontRightAngle=37.0
    RearRightAngle=143.0
    RearLeftAngle=217.0

    // Turret movement
    ManualRotationsPerSecond=0.04
    PoweredRotationsPerSecond=0.083
    CustomPitchUpLimit=3641
    CustomPitchDownLimit=63352

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_StuartCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_StuartCannonShellHE'
    TertiaryProjectileClass=class'DH_Engine.DHCannonShellCanister'

    ProjectileDescriptions(2)="Canister"

    nProjectileDescriptions(0)="M51B1 APC"
    nProjectileDescriptions(1)="M63 HE-T"
    nProjectileDescriptions(2)="M2 Canister"

    InitialPrimaryAmmo=60
    InitialSecondaryAmmo=30
    InitialTertiaryAmmo=15
    MaxPrimaryAmmo=64
    MaxSecondaryAmmo=44
    MaxTertiaryAmmo=20
    SecondarySpread=0.00145
    TertiarySpread=0.04

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_30CalBullet'
    InitialAltAmmo=250
    NumMGMags=7
    AltFireInterval=0.12
    TracerProjectileClass=class'DH_Weapons.DH_30CalTracerBullet'
    TracerFrequency=5

    // Weapon fire
    WeaponFireOffset=12.5
    AddedPitch=18
    EffectEmitterClass=class'ROEffects.TankCannonFireEffectTypeC' // smaller muzzle flash effect
    AltFireOffset=(X=-59.0,Y=7.0,Z=0.5)
    ShakeRotRate=(Z=600.0)
    ShakeOffsetMag=(Z=5.0)
    ShakeOffsetTime=6.0

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_CC_Vehicle_Weapons.37mm.37mmAT_fire_02'
    CannonFireSound(1)=SoundGroup'DH_CC_Vehicle_Weapons.37mm.37mmAT_fire_02'
    CannonFireSound(2)=SoundGroup'DH_CC_Vehicle_Weapons.37mm.37mmAT_fire_02'
    AltFireSoundClass=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireLoop01'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireEnd01'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_01')
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_03')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_04')
}
