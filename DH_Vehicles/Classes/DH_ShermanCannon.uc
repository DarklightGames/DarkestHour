//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ShermanCannon extends DHVehicleCannon;

// Modified to use different WeaponAttachOffset if 75mm turret is used with an M4A3 Sherman hull
// (a little hacky but saves having separate cannon & cannon pawn classes for the M4A3 & variants)
simulated function InitializeVehicleBase()
{
    if (DH_ShermanTank_M4A375W(Base) != none)
    {
        WeaponAttachOffset = vect(11.5, -2.5, 0.0);
    }

    super.InitializeVehicleBase();
}

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_ShermanM4A1_anm.Sherman75mm_turret_ext'
    Skins(0)=Texture'DH_VehiclesUS_tex.Sherman_body_ext'
    Skins(1)=Texture'DH_VehiclesUS_tex.Sherman76w_turret_ext'
    Skins(2)=Texture'DH_VehiclesUS_tex.Sherman_turret_int'
    Skins(3)=Texture'DH_VehiclesUS_tex.Sherman_body_int2'
    WeaponAttachOffset=(X=9.0,Y=-2.5,Z=0.0) // this is for M4A1; X=11.5 works better on M4A3 hull
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc.Sherman_turret_75mm_Coll')

    // Turret armor
    FrontArmorFactor=7.6
    RightArmorFactor=5.1
    LeftArmorFactor=5.1
    RearArmorFactor=5.1
    FrontArmorSlope=30.0
    RightArmorSlope=5.0
    LeftArmorSlope=5.0
    FrontLeftAngle=316.0
    FrontRightAngle=44.0
    RearRightAngle=136.0
    RearLeftAngle=224.0

    // Turret movement
    ManualRotationsPerSecond=0.02
    PoweredRotationsPerSecond=0.0625
    CustomPitchUpLimit=4551
    CustomPitchDownLimit=64079

    // Cannon ammo
    PrimaryProjectileClass=Class'DH_ShermanCannonShell'
    SecondaryProjectileClass=Class'DH_ShermanCannonShellHE'
    TertiaryProjectileClass=Class'DH_ShermanCannonShellSmoke'

    ProjectileDescriptions(0)="APC"
    ProjectileDescriptions(1)="HE"
    ProjectileDescriptions(2)="WP"

    nProjectileDescriptions(0)="M61 APC"
    nProjectileDescriptions(1)="M48 HE-T"
    nProjectileDescriptions(2)="M64 WP"

    InitialPrimaryAmmo=30
    InitialSecondaryAmmo=20
    InitialTertiaryAmmo=4

    MaxPrimaryAmmo=36
    MaxSecondaryAmmo=45
    MaxTertiaryAmmo=9

    SecondarySpread=0.00175
    TertiarySpread=0.0036

    // Coaxial MG ammo
    AltFireProjectileClass=Class'DH_30CalBullet'
    InitialAltAmmo=250
    NumMGMags=8
    AltFireInterval=0.12
    TracerProjectileClass=Class'DH_30CalTracerBullet'
    TracerFrequency=5

    // Smoke launcher
    SmokeLauncherClass=Class'DH_TwoInchBombThrower'
    SmokeLauncherFireOffset(0)=(X=23.0,Y=-36.0,Z=43.5)

    // Weapon fire
    WeaponFireOffset=18.0
    AddedPitch=68
    AltFireOffset=(X=-90.0,Y=-27.5,Z=-1.5)
    AltFireSpawnOffsetX=50.0

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    CannonFireSound(1)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    CannonFireSound(2)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    AltFireSoundClass=SoundGroup'DH_WeaponSounds.30cal_FireLoop01'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.30cal_FireEnd01'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.reload_01s_01')
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.reload_01s_03')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.reload_01s_04')
}
