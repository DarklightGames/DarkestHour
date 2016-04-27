//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_JacksonCannon extends DHVehicleCannon;

defaultproperties
{
    InitialTertiaryAmmo=10
    TertiaryProjectileClass=class'DH_Vehicles.DH_JacksonCannonShellHE'
    SecondarySpread=0.0011
    TertiarySpread=0.00125
    ManualRotationsPerSecond=0.01
    PoweredRotationsPerSecond=0.0625
    FrontArmorFactor=6.9
    RightArmorFactor=3.2
    LeftArmorFactor=3.2
    RearArmorFactor=8.0
    FrontArmorSlope=45.0
    RightArmorSlope=5.0
    LeftArmorSlope=5.0
    FrontLeftAngle=325.0
    FrontRightAngle=35.0
    RearRightAngle=145.0
    RearLeftAngle=215.0
    ReloadStages(0)=(Sound=sound'Vehicle_reloads.Reloads.SU_76_Reload_01')
    ReloadStages(1)=(Sound=sound'Vehicle_reloads.Reloads.SU_76_Reload_02')
    ReloadStages(2)=(Sound=sound'Vehicle_reloads.Reloads.SU_76_Reload_03')
    ReloadStages(3)=(Sound=sound'Vehicle_reloads.Reloads.SU_76_Reload_04')
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.IS2.122mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.IS2.122mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.IS2.122mm_fire02'
    ProjectileDescriptions(1)="HVAP"
    ProjectileDescriptions(2)="HE"
    AddedPitch=145
    WeaponFireOffset=26.2
    ProjectileClass=class'DH_Vehicles.DH_JacksonCannonShell'
    CustomPitchUpLimit=3641
    CustomPitchDownLimit=63715
    InitialPrimaryAmmo=32
    InitialSecondaryAmmo=6
    PrimaryProjectileClass=class'DH_Vehicles.DH_JacksonCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_JacksonCannonShellHVAP'
    FireAttachBone="Turret"
    FireEffectScale=1.5 // turret fire is larger & positioned in centre of open turret
    FireEffectOffset=(X=-12.0,Y=0.0,Z=41.0)
    Mesh=SkeletalMesh'DH_Jackson_anm.Jackson_turret_ext'
    Skins(0)=texture'DH_VehiclesUS_tex3.ext_vehicles.M36_turret_ext'
    Skins(1)=texture'DH_VehiclesUS_tex3.int_vehicles.M36_turret_int'
    Skins(2)=texture'DH_VehiclesUS_tex3.int_vehicles.M36_turret_int2'
    CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc2.Jackson.Jackson_turret_col'
    SoundRadius=300.0
}
