//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ShermanCannon_M4A3E2 extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_ShermanM4A3_anm.ShermanM4A3E2_turret_ext'
    Skins(0)=texture'DH_VehiclesUS_tex3.ext_vehicles.ShermanM4A3E2_turret'
    Skins(1)=texture'DH_VehiclesUS_tex3.int_vehicles.shermancupolat'
    WeaponAttachOffset=(X=6.0,Y=0.0,Z=0.0)
    BeginningIdleAnim="Periscope_idle"
    CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc3.ShermanM4A3.M4A3E2_turret_coll'
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
    ProjectileClass=class'DH_Vehicles.DH_ShermanCannonShell'
    PrimaryProjectileClass=class'DH_Vehicles.DH_ShermanCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_ShermanCannonShellHE'
    TertiaryProjectileClass=class'DH_Vehicles.DH_ShermanCannonShellSmoke'
    ProjectileDescriptions(2)="Smoke"
    InitialPrimaryAmmo=35
    InitialSecondaryAmmo=50
    InitialTertiaryAmmo=5
    SecondarySpread=0.00175
    TertiarySpread=0.0036

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_30CalBullet'
    InitialAltAmmo=250
    NumMGMags=14
    AltFireInterval=0.12
    TracerProjectileClass=class'DH_Weapons.DH_30CalTracerBullet'
    TracerFrequency=5

    // Weapon fire
    WeaponFireAttachmentBone="Gun" // can't use 'Barrel' bone as it's rolled in the mesh, which screws up offsets
    WeaponFireOffset=106.0
    AddedPitch=68
    AltFireOffset=(X=8.0,Y=-23.5,Z=3.5)
    AltShakeRotMag=(X=0.01,Y=0.01,Z=0.01)
    AltShakeRotRate=(X=1000.0,Y=1000.0,Z=1000.0)

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    CannonFireSound(1)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    CannonFireSound(2)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    AltFireSoundClass=SoundGroup'DH_AlliedVehicleSounds2.3Cal.V30cal_loop01'
    AltFireEndSound=SoundGroup'DH_AlliedVehicleSounds2.3Cal.V30cal_end01'
    ReloadStages(0)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_01')
    ReloadStages(1)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_03')
    ReloadStages(3)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_04')
}
