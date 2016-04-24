//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ShermanCannon_M4A3105 extends DHVehicleCannon;

defaultproperties
{
    InitialTertiaryAmmo=15
    TertiaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A3105CannonShellHEAT'
    SecondarySpread=0.0036
    TertiarySpread=0.00225
    ManualRotationsPerSecond=0.0125
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
    ReloadStages(0)=(Sound=sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_01')
    ReloadStages(1)=(Sound=sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_02')
    ReloadStages(2)=(Sound=sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_03')
    ReloadStages(3)=(Sound=sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_04')
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire03'
    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="Smoke"
    ProjectileDescriptions(2)="HEAT"
    AddedPitch=340
    NumMGMags=5
    TracerProjectileClass=class'DH_Weapons.DH_30CalTracerBullet'
    TracerFrequency=5
    WeaponFireOffset=8.5
    AltFireOffset=(X=-91.0,Y=-17.0,Z=8.5)
    AltFireSpawnOffsetX=56.0
    Spread=0.003
    AltFireInterval=0.12
    AltFireSoundClass=SoundGroup'DH_AlliedVehicleSounds2.3Cal.V30cal_loop01'
    AltFireEndSound=SoundGroup'DH_AlliedVehicleSounds2.3Cal.V30cal_end01'
    ProjectileClass=class'DH_Vehicles.DH_ShermanM4A3105CannonShellHE'
    AltFireProjectileClass=class'DH_Weapons.DH_30CalBullet'
    AltShakeRotMag=(X=0.01,Y=0.01,Z=0.01)
    AltShakeRotRate=(X=1000.0,Y=1000.0,Z=1000.0)
    CustomPitchUpLimit=6372
    CustomPitchDownLimit=64625 // 5 degrees - probably should be 10, but any more & barrel clips hull (a howitzer, so depression isn't really an issue anyway)
    InitialPrimaryAmmo=45
    InitialSecondaryAmmo=6
    InitialAltAmmo=200
    PrimaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A3105CannonShellHE'
    SecondaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A3105CannonShellSmoke'
    WeaponAttachOffset=(X=8.0,Y=0.0,Z=4.5)
    Mesh=SkeletalMesh'DH_ShermanM4A3_anm.ShermanM4A3105_turret_ext'
    Skins(0)=texture'DH_VehiclesUS_tex3.ext_vehicles.Sherman_105_ext'
    CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc3.ShermanM4A3.M4A3_105_turret_coll'
    SoundVolume=200
    SoundRadius=50.0 // TODO: maybe increase as is far lower than default 200, but it's a powerful gun?
}
