//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ChurchillMkVIICannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_Churchill_anm.ChurchillMkVII_turret' // TODO: think cupola & hatches are incorrect - believe should have all round vision cupola
    Skins(0)=Texture'DH_Churchill_tex.churchill.ChurchillMkVIIl_turret'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Churchill_stc.ChurchillMkVII_turret_col')
    FireAttachBone="Turret"
    FireEffectOffset=(X=12.0,Y=-25.0,Z=60.0)
    FireEffectScale=0.8

    // Turret armor
    FrontArmorFactor=15.24
    RightArmorFactor=9.53
    LeftArmorFactor=9.53
    RearArmorFactor=9.53
    FrontLeftAngle=328.0
    FrontRightAngle=34.0
    RearRightAngle=147.5
    RearLeftAngle=204.0

    // Turret movement
    ManualRotationsPerSecond=0.029
    PoweredRotationsPerSecond=0.06667
    CustomPitchUpLimit=3641
    CustomPitchDownLimit=65008

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_CromwellCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_CromwellCannonShellHE'
    TertiaryProjectileClass=class'DH_Vehicles.DH_CromwellCannonShellSmoke'


    ProjectileDescriptions(2)="Smoke"

    nProjectileDescriptions(0)="M61 APC"
    nProjectileDescriptions(1)="M48 HE-T"
    nProjectileDescriptions(2)="M89 WP"

    InitialPrimaryAmmo=28
    InitialSecondaryAmmo=15
    InitialTertiaryAmmo=5

    MaxPrimaryAmmo=38
    MaxSecondaryAmmo=38
    MaxTertiaryAmmo=0 //we'll need to find a better solution to limiting WP resupply later

    SecondarySpread=0.00175
    TertiarySpread=0.0036

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Vehicles.DH_BesaVehicleBullet'
    InitialAltAmmo=225
    NumMGMags=11
    AltFireInterval=0.092
    TracerProjectileClass=class'DH_Vehicles.DH_BesaVehicleTracerBullet'
    TracerFrequency=5

    // Smoke launcher
    SmokeLauncherClass=class'DH_Vehicles.DH_TwoInchBombThrower'
    SmokeLauncherFireOffset(0)=(X=32.0,Y=37.5,Z=42.5)

    // Weapon fire
    WeaponFireAttachmentBone="muzzle"
    AltFireAttachmentBone="coax_muzzle"
    AltFireOffset=(X=-8.5,Y=0.0,Z=0.0)

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
