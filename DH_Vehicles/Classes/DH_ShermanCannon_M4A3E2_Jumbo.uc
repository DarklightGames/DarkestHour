//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanCannon_M4A3E2_Jumbo extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_ShermanM4A3_anm.ShermanM4A3E2_turret_ext'
    Skins(0)=Texture'DH_VehiclesUS_tex3.ext_vehicles.ShermanM4A3E2_turret'
    Skins(1)=Texture'DH_VehiclesUS_tex3.int_vehicles.shermancupolat'
    WeaponAttachOffset=(X=6.0,Y=0.0,Z=0.0)
    BeginningIdleAnim="Periscope_idle"
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc3.ShermanM4A3.M4A3E2_turret_coll')
    FireEffectOffset=(X=0.0,Y=0.0,Z=-10.0)

    // Turret armor
    FrontArmorFactor=16.6
    RightArmorFactor=15.2
    LeftArmorFactor=15.2
    RearArmorFactor=15.2
    FrontLeftAngle=320.0
    FrontRightAngle=40.0
    RearRightAngle=140.0
    RearLeftAngle=220.0

    // Turret movement
    ManualRotationsPerSecond=0.0167
    PoweredRotationsPerSecond=0.04
    CustomPitchUpLimit=4551
    CustomPitchDownLimit=63715

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_ShermanCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_ShermanCannonShellHE'
    TertiaryProjectileClass=class'DH_Vehicles.DH_ShermanCannonShellSmoke'

    ProjectileDescriptions(2)="Smoke"

    nProjectileDescriptions(0)="M61 APC"
    nProjectileDescriptions(1)="M48 HE-T"
    nProjectileDescriptions(2)="M64 WP"

    InitialPrimaryAmmo=32
    InitialSecondaryAmmo=25
    InitialTertiaryAmmo=4
    MaxPrimaryAmmo=35
    MaxSecondaryAmmo=50
    MaxTertiaryAmmo=0 //we'll need to find a better solution to limiting WP resupply later

    SecondarySpread=0.00175
    TertiarySpread=0.0036

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_30CalBullet'
    InitialAltAmmo=250
    NumMGMags=14
    AltFireInterval=0.12
    TracerProjectileClass=class'DH_Weapons.DH_30CalTracerBullet'
    TracerFrequency=5

    // Smoke launcher
    SmokeLauncherClass=class'DH_Vehicles.DH_TwoInchBombThrower'
    SmokeLauncherFireOffset(0)=(X=44.0,Y=-37.0,Z=51.5)

    // Weapon fire
    WeaponFireAttachmentBone="Gun" // can't use 'Barrel' bone as it's rolled in the mesh, which screws up offsets
    WeaponFireOffset=106.0
    AddedPitch=68
    AltFireOffset=(X=8.0,Y=-23.5,Z=3.5)

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    CannonFireSound(1)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    CannonFireSound(2)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    AltFireSoundClass=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireLoop01'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireEnd01'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_01')
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_03')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_04')
}
