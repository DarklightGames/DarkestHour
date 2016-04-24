//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ShermanCannon_M4A3E2 extends DHVehicleCannon;

defaultproperties
{
    InitialTertiaryAmmo=5
    TertiaryProjectileClass=class'DH_Vehicles.DH_ShermanCannonShellSmoke'
    SecondarySpread=0.00175
    TertiarySpread=0.0036
    ManualRotationsPerSecond=0.0167
    PoweredRotationsPerSecond=0.04
    FrontArmorFactor=16.6
    RightArmorFactor=15.2
    LeftArmorFactor=15.2
    RearArmorFactor=15.2
    FrontLeftAngle=320.0
    FrontRightAngle=40.0
    RearRightAngle=140.0
    RearLeftAngle=220.0
    ReloadStages(0)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_01')
    ReloadStages(1)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_03')
    ReloadStages(3)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_04')
    CannonFireSound(0)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    CannonFireSound(1)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    CannonFireSound(2)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    ProjectileDescriptions(2)="Smoke"
    AddedPitch=68
    NumMGMags=5
    TracerProjectileClass=class'DH_Weapons.DH_30CalTracerBullet'
    TracerFrequency=5
    WeaponFireAttachmentBone="Gun" // can't use 'Barrel' bone as it's rolled in the mesh, which screws up offsets
    WeaponFireOffset=106.0
    AltFireOffset=(X=8.0,Y=-23.5,Z=3.5)
    AltFireInterval=0.12
    AltFireSoundClass=SoundGroup'DH_AlliedVehicleSounds2.3Cal.V30cal_loop01'
    AltFireEndSound=SoundGroup'DH_AlliedVehicleSounds2.3Cal.V30cal_end01'
    ProjectileClass=class'DH_Vehicles.DH_ShermanCannonShell'
    AltFireProjectileClass=class'DH_Weapons.DH_30CalBullet'
    AltShakeRotMag=(X=0.01,Y=0.01,Z=0.01)
    AltShakeRotRate=(X=1000.0,Y=1000.0,Z=1000.0)
    CustomPitchUpLimit=4551
    CustomPitchDownLimit=63715
    BeginningIdleAnim="Periscope_idle"
    InitialPrimaryAmmo=35
    InitialSecondaryAmmo=50
    InitialAltAmmo=200
    PrimaryProjectileClass=class'DH_Vehicles.DH_ShermanCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_ShermanCannonShellHE'
    FireEffectOffset=(X=0.0,Y=0.0,Z=-10.0)
    WeaponAttachOffset=(X=6.0,Y=0.0,Z=0.0)
    Mesh=SkeletalMesh'DH_ShermanM4A3_anm.ShermanM4A3E2_turret_ext'
    Skins(0)=texture'DH_VehiclesUS_tex3.ext_vehicles.ShermanM4A3E2_turret'
    Skins(1)=texture'DH_VehiclesUS_tex3.int_vehicles.shermancupolat'
    CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc3.ShermanM4A3.M4A3E2_turret_coll'
}
