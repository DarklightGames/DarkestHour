//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_ChurchillCannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_Churchill_anm.ext_turret'
    Skins(0)=Texture'DH_Churchill_tex.churchill.churchill_turret'
    CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc.Cromwell.Cromwell_turret_Coll'
    FireAttachBone="turret_placement"
//    FireEffectOffset=(X=-3.0,Y=-30.0,Z=50.0)

    WeaponFireAttachmentBone="muzzle"

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
    ProjectileClass=class'DH_Vehicles.DH_CromwellCannonShell'
    PrimaryProjectileClass=class'DH_Vehicles.DH_CromwellCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_CromwellCannonShellHE'
    TertiaryProjectileClass=class'DH_Vehicles.DH_CromwellCannonShellSmoke'
    ProjectileDescriptions(2)="Smoke"
    InitialPrimaryAmmo=33
    InitialSecondaryAmmo=26
    InitialTertiaryAmmo=5
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
    SmokeLauncherFireOffset(0)=(X=32.0,Y=37.5.0,Z=42.5)

    // Weapon fire
    AltFireAttachmentBone="coax_muzzle"

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    CannonFireSound(1)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    CannonFireSound(2)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    AltFireSoundClass=SoundGroup'DH_WeaponSounds.Besa.Besa_FireLoop'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.Besa.Besa_FireEnd'
    ReloadStages(0)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_01')
    ReloadStages(1)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_03')
    ReloadStages(3)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_04')

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
