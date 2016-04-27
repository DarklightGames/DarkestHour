//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ShermanCannonA_76mm extends DHVehicleCannon;

// Modified to use different WeaponAttachOffset if 76mm turret is used with an M4A3 Sherman hull
// (a little hacky but saves having separate cannon & cannon pawn classes for the M4A3 & variants)
simulated function InitializeVehicleBase()
{
    if (DH_ShermanTank_M4A376W(Base) != none)
    {
        WeaponAttachOffset = vect(1.0, -1.0, 0.0);
    }

    super.InitializeVehicleBase();
}

defaultproperties
{
    InitialTertiaryAmmo=26
    TertiaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A176WCannonShellHE'
    SecondarySpread=0.001
    TertiarySpread=0.00135
    ManualRotationsPerSecond=0.02
    PoweredRotationsPerSecond=0.0625
    FrontArmorFactor=8.9
    RightArmorFactor=6.4
    LeftArmorFactor=6.4
    RearArmorFactor=6.4
    FrontArmorSlope=1.01
    RightArmorSlope=1.01
    LeftArmorSlope=1.01
    RearArmorSlope=1.0
    FrontLeftAngle=322.0
    FrontRightAngle=38.0
    RearRightAngle=142.0
    RearLeftAngle=218.0
    ReloadStages(0)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_01')
    ReloadStages(1)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_02s_03')
    ReloadStages(3)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_04')
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire03'
    ProjectileDescriptions(1)="HVAP"
    ProjectileDescriptions(2)="HE"
    AddedPitch=52
    NumMGMags=6
    TracerProjectileClass=class'DH_Weapons.DH_30CalTracerBullet'
    TracerFrequency=5
    WeaponFireAttachmentBone="barrelA"
    WeaponFireOffset=1.5
    AltFireOffset=(X=-178.0,Y=-21.0,Z=2.0)
    AltFireSpawnOffsetX=17.0
    AltFireInterval=0.12
    AltFireSoundClass=SoundGroup'DH_AlliedVehicleSounds2.3Cal.V30cal_loop01'
    AltFireEndSound=SoundGroup'DH_AlliedVehicleSounds2.3Cal.V30cal_end01'
    ProjectileClass=class'DH_Vehicles.DH_ShermanM4A176WCannonShell'
    AltFireProjectileClass=class'DH_Weapons.DH_30CalBullet'
    AltShakeRotMag=(X=0.01,Y=0.01,Z=0.01)
    AltShakeRotRate=(X=1000.0,Y=1000.0,Z=1000.0)
    CustomPitchUpLimit=5461
    CustomPitchDownLimit=63715
    InitialPrimaryAmmo=43
    InitialSecondaryAmmo=2
    InitialAltAmmo=200
    PrimaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A176WCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A176WCannonShellHVAP'
    FireEffectOffset=(X=0.0,Y=0.0,Z=-10.0)
    WeaponAttachOffset=(X=-1.0,Y=-1.0,Z=0.0) // this is for M4A1; X=1 works better on M4A3 hull
    Mesh=SkeletalMesh'DH_ShermanM4A1_anm.Sherman76mm_turret_extA'
    Skins(0)=texture'DH_VehiclesUS_tex.ext_vehicles.Sherman76w_turret_ext'
    Skins(1)=texture'DH_VehiclesUS_tex.ext_vehicles.Sherman_body_ext'
    CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc.Sherman.Sherman_turret_76mm_Coll'
}
