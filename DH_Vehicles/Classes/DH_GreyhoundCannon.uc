//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_GreyhoundCannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_Greyhound_anm.Greyhound_turret_ext'
    Skins(0)=Texture'DH_VehiclesUS_tex4.ext_vehicles.Greyhound_turret_ext'
    Skins(1)=Texture'DH_VehiclesUS_tex4.int_vehicles.Greyhound_body_int'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc3.M8_Greyhound.Greyhound_turret_coll')
    FireEffectScale=1.25 // turret fire is larger & positioned in centre of open turret
    FireEffectOffset=(X=5.0,Y=20.0,Z=0.0)

    // Turret armor
    FrontArmorFactor=1.9
    RightArmorFactor=1.9
    LeftArmorFactor=1.9
    RearArmorFactor=1.9
    FrontLeftAngle=319.0
    FrontRightAngle=41.0
    RearRightAngle=139.0
    RearLeftAngle=221.0

    // Turret movement
    ManualRotationsPerSecond=0.04
    CustomPitchUpLimit=3641
    CustomPitchDownLimit=63716

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_GreyhoundCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_GreyhoundCannonShellHE'
    TertiaryProjectileClass=class'DH_Engine.DHCannonShellCanister'


    ProjectileDescriptions(2)="Canister"

    nProjectileDescriptions(0)="M51B1 APC"
    nProjectileDescriptions(1)="M63 HE-T"
    nProjectileDescriptions(2)="M2 Canister"

    InitialPrimaryAmmo=20
    InitialSecondaryAmmo=24
    InitialTertiaryAmmo=8
    MaxPrimaryAmmo=24
    MaxSecondaryAmmo=48
    MaxTertiaryAmmo=8
    SecondarySpread=0.00145
    TertiarySpread=0.04

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_30CalBullet'
    InitialAltAmmo=250
    NumMGMags=5
    AltFireInterval=0.12
    TracerProjectileClass=class'DH_Weapons.DH_30CalTracerBullet'
    TracerFrequency=5

    // Weapon fire
    WeaponFireOffset=10.0
    AddedPitch=26
    EffectEmitterClass=class'ROEffects.TankCannonFireEffectTypeC' // smaller muzzle flash effect
    AltFireOffset=(X=-82.0,Y=11.0,Z=0.0)
    ShakeRotRate=(Z=600.0)
    ShakeOffsetMag=(Z=5.0)
    ShakeOffsetTime=6.0

    // Sounds
    CannonFireSound(0)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire01'
    CannonFireSound(1)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire02'
    CannonFireSound(2)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire03'
    AltFireSoundClass=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireLoop01'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireEnd01'
    ReloadStages(0)=(Sound=Sound'DH_AlliedVehicleSounds.Sherman.ShermanReload01')
    ReloadStages(1)=(Sound=Sound'DH_AlliedVehicleSounds.Sherman.ShermanReload02')
    ReloadStages(2)=(Sound=Sound'DH_AlliedVehicleSounds.Sherman.ShermanReload03')
    ReloadStages(3)=(Sound=Sound'DH_AlliedVehicleSounds.Sherman.ShermanReload04')
}
