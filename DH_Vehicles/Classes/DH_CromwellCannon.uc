//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_CromwellCannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_Cromwell_anm.Cromwell_turret_ext'
    Skins(0)=Texture'DH_VehiclesUK_tex.ext_vehicles.Cromwell_body_ext'
    Skins(1)=Texture'DH_VehiclesUK_tex.int_vehicles.Cromwell_body_int2'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc.Cromwell.Cromwell_turret_Coll')
    FireAttachBone="Turret"
    FireEffectOffset=(X=-3.0,Y=-30.0,Z=50.0)

    // Turret armor
    FrontArmorFactor=7.6
    RightArmorFactor=6.3
    LeftArmorFactor=6.3
    RearArmorFactor=5.7
    FrontLeftAngle=318.0
    FrontRightAngle=42.0
    RearRightAngle=138.0
    RearLeftAngle=222.0

    // Turret movement
    ManualRotationsPerSecond=0.029
    PoweredRotationsPerSecond=0.0625
    CustomPitchUpLimit=3641
    CustomPitchDownLimit=64500

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_CromwellCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_CromwellCannonShellHE'
    TertiaryProjectileClass=class'DH_Vehicles.DH_CromwellCannonShellSmoke'

    ProjectileDescriptions(2)="Smoke"

    nProjectileDescriptions(0)="M61 APC"
    nProjectileDescriptions(1)="M48 HE-T"
    nProjectileDescriptions(2)="M64 WP"

    InitialPrimaryAmmo=25
    InitialSecondaryAmmo=13
    InitialTertiaryAmmo=4
    MaxPrimaryAmmo=33
    MaxSecondaryAmmo=26
    MaxTertiaryAmmo=0 //we'll need to find a better solution to limiting WP resupply later

    SecondarySpread=0.00175
    TertiarySpread=0.0036

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Vehicles.DH_BesaVehicleBullet'
    InitialAltAmmo=225
    NumMGMags=10
    AltFireInterval=0.092
    TracerProjectileClass=class'DH_Vehicles.DH_BesaVehicleTracerBullet'
    TracerFrequency=5

    // Smoke launcher
    SmokeLauncherClass=class'DH_Vehicles.DH_TwoInchBombThrower'
    SmokeLauncherFireOffset(0)=(X=37.0,Y=40.0,Z=42.0)

    // Weapon fire
    AltFireOffset=(X=-109.5,Y=-11.5,Z=1.0)
    AltFireSpawnOffsetX=23.0

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    CannonFireSound(1)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    CannonFireSound(2)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    AltFireSoundClass=SoundGroup'DH_WeaponSounds.Besa.Besa_FireLoop'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.Besa.Besa_FireEnd'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_01')
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_03')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_04')

    // Cannon range settings
    RangeSettings(1)=200
    RangeSettings(2)=400
    RangeSettings(3)=600
    RangeSettings(4)=800
    RangeSettings(5)=1000
    RangeSettings(6)=1200
    RangeSettings(7)=1400
    RangeSettings(8)=1600
    RangeSettings(9)=1800
    RangeSettings(10)=2000
    RangeSettings(11)=2200
    RangeSettings(12)=2400
    RangeSettings(13)=2600
    RangeSettings(14)=2800
    RangeSettings(15)=3000
    RangeSettings(16)=3200
}
