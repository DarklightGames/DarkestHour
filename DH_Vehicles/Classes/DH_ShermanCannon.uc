//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
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
    Skins(0)=texture'DH_VehiclesUS_tex.ext_vehicles.Sherman_body_ext'
    Skins(1)=texture'DH_VehiclesUS_tex.ext_vehicles.Sherman76w_turret_ext'
    Skins(2)=texture'DH_VehiclesUS_tex.int_vehicles.Sherman_turret_int'
    Skins(3)=texture'DH_VehiclesUS_tex.int_vehicles.Sherman_body_int2'
    WeaponAttachOffset=(X=9.0,Y=-2.5,Z=0.0) // this is for M4A1; X=11.5 works better on M4A3 hull
    CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc.Sherman.Sherman_turret_75mm_Coll'

    // Turret armor
    FrontArmorFactor=7.6
    RightArmorFactor=5.1
    LeftArmorFactor=5.1
    RearArmorFactor=5.1
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
    ProjectileClass=class'DH_Vehicles.DH_ShermanCannonShell'
    PrimaryProjectileClass=class'DH_Vehicles.DH_ShermanCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_ShermanCannonShellHE'
    TertiaryProjectileClass=class'DH_Vehicles.DH_ShermanCannonShellSmoke'
    ProjectileDescriptions(2)="Smoke"
    InitialPrimaryAmmo=45
    InitialSecondaryAmmo=40
    InitialTertiaryAmmo=5
    SecondarySpread=0.00175
    TertiarySpread=0.0036

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_30CalBullet'
    InitialAltAmmo=250
    NumMGMags=8
    AltFireInterval=0.12
    TracerProjectileClass=class'DH_Weapons.DH_30CalTracerBullet'
    TracerFrequency=5

    // Weapon fire
    WeaponFireOffset=18.0
    AddedPitch=68
    AltFireOffset=(X=-90.0,Y=-27.5,Z=-1.5)
    AltFireSpawnOffsetX=50.0
    AltShakeRotMag=(X=0.01,Y=0.01,Z=0.01)
    AltShakeRotRate=(X=1000.0,Y=1000.0,Z=1000.0)

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    CannonFireSound(1)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    CannonFireSound(2)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    AltFireSoundClass=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireLoop01'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireEnd01'
    ReloadStages(0)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_01')
    ReloadStages(1)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_03')
    ReloadStages(3)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_04')
}
