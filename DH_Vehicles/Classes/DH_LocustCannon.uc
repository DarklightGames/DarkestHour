//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_LocustCannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_Locust_anm.Locust_turret'
    Skins(0)=Texture'DH_Locust_tex.Locust_turret_ext'
    Skins(1)=Texture'DH_Locust_tex.Locust_int'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc2.Locust.Locust_turret_collision')
    FireAttachBone="turret"
    FireEffectOffset=(X=-21.0,Y=16.0,Z=35.0)

    // Turret armor
    FrontArmorFactor=2.54
    RightArmorFactor=2.54
    LeftArmorFactor=2.54
    RearArmorFactor=2.54
    FrontArmorSlope=30.0
    RightArmorSlope=5.0
    LeftArmorSlope=5.0
    FrontLeftAngle=320.0
    FrontRightAngle=40.0
    RearRightAngle=161.0
    RearLeftAngle=199.0

    // Turret movement
    ManualRotationsPerSecond=0.04
    CustomPitchUpLimit=5461    // 30 degrees elevation
    CustomPitchDownLimit=63716 // 10 degrees depression

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_LocustCannonShell' // same as Stuart AP but modified to use tracer static mesh, as usual corona effect can't be seen through gunsight overlay
    SecondaryProjectileClass=class'DH_Vehicles.DH_StuartCannonShellHE'
    TertiaryProjectileClass=class'DH_Engine.DHCannonShellCanister'

    ProjectileDescriptions(2)="Canister"

    nProjectileDescriptions(0)="M51B1 APC"
    nProjectileDescriptions(1)="M63 HE-T"
    nProjectileDescriptions(2)="M2 Canister"

    InitialPrimaryAmmo=20
    InitialSecondaryAmmo=8
    InitialTertiaryAmmo=10
    MaxPrimaryAmmo=24
    MaxSecondaryAmmo=16
    MaxTertiaryAmmo=10
    SecondarySpread=0.00145
    TertiarySpread=0.04

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_30CalBullet'
    InitialAltAmmo=250
    NumMGMags=9
    AltFireInterval=0.12
    TracerProjectileClass=class'DH_Weapons.DH_30CalTracerBullet'
    TracerFrequency=5

    // Weapon fire
    WeaponFireOffset=10.0
    AddedPitch=18
    EffectEmitterClass=class'ROEffects.TankCannonFireEffectTypeC' // smaller muzzle flash effect
    AltFireOffset=(X=-66.5,Y=8.3,Z=0.0)
    ShakeRotRate=(Z=600.0)
    ShakeOffsetMag=(Z=5.0)
    ShakeOffsetTime=6.0

    // Sounds
    CannonFireSound(0)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire01'
    CannonFireSound(1)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire02'
    CannonFireSound(2)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire03'
    AltFireSoundClass=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireLoop01'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireEnd01'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_01')
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_03')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_04')
}
