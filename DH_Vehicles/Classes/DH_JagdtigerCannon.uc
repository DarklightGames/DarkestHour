//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JagdtigerCannon extends DHVehicleCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Jagdtiger_anm.jagdtiger_turret_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex2.ext_vehicles.JagdTiger_body_ext'

    // Cannon armour (mantlet)
    GunMantletArmorFactor=20.0
    GunMantletSlope=40.0

    // Cannon movement
    bHasTurret=false
    ManualRotationsPerSecond=0.01
    YawBone="Gun"
    bLimitYaw=true
    MaxPositiveYaw=1820
    MaxNegativeYaw=-1820
    YawStartConstraint=-2000.0
    YawEndConstraint=2000.0
    PitchBone="Turret"
    CustomPitchUpLimit=2731
    CustomPitchDownLimit=64171

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_JagdtigerCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_JagdtigerCannonShellHE'

    ProjectileDescriptions(0)="APCBC"
    ProjectileDescriptions(1)="HE"

    nProjectileDescriptions(0)="PzGr.39"
    nProjectileDescriptions(1)="Schw.Spgr.Patr"
    //nProjectileDescriptions(2)="Nbgr.Kw.K"

    InitialPrimaryAmmo=18
    InitialSecondaryAmmo=10
    MaxPrimaryAmmo=20
    MaxSecondaryAmmo=20
    SecondarySpread=0.00129

    // Smoke launcher
    SmokeLauncherClass=class'DH_Vehicles.DH_Nahverteidigungswaffe'
    SmokeLauncherFireOffset(0)=(X=-106.0,Y=-37.0,Z=45.0)

    // Weapon fire
    WeaponFireOffset=10.0

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_GerVehicleSounds.88mm.DH88mm_01'
    CannonFireSound(1)=SoundGroup'DH_GerVehicleSounds.88mm.DH88mm_02'
    CannonFireSound(2)=SoundGroup'DH_GerVehicleSounds.88mm.DH88mm_03'
    ReloadStages(0)=(Sound=Sound'Vehicle_reloads.Reloads.Tiger_reload_01')
    ReloadStages(1)=(Sound=Sound'Vehicle_reloads.Reloads.Tiger_reload_02')
    ReloadStages(2)=(Sound=Sound'Vehicle_reloads.Reloads.Tiger_reload_03')
    ReloadStages(3)=(Sound=Sound'Vehicle_reloads.Reloads.Tiger_reload_04')

    // Cannon range settings
    RangeSettings(1)=100
    RangeSettings(2)=200
    RangeSettings(3)=300
    RangeSettings(4)=400
    RangeSettings(5)=500
    RangeSettings(6)=600
    RangeSettings(7)=700
    RangeSettings(8)=800
    RangeSettings(9)=900
    RangeSettings(10)=1000
    RangeSettings(11)=1100
    RangeSettings(12)=1200
    RangeSettings(13)=1300
    RangeSettings(14)=1400
    RangeSettings(15)=1500
    RangeSettings(16)=1600
    RangeSettings(17)=1700
    RangeSettings(18)=1800
    RangeSettings(19)=1900
    RangeSettings(20)=2000
    RangeSettings(21)=2200
    RangeSettings(22)=2400
    RangeSettings(23)=2600
    RangeSettings(24)=2800
    RangeSettings(25)=3000
}
