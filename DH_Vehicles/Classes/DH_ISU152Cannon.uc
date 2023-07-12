//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ISU152Cannon extends DHVehicleCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_ISU152_anm.ISU152-turret_ext'
    Skins(0)=Texture'DH_VehiclesSOV_tex.ext_vehicles.isu152_body_ext'
    Skins(1)=Texture'DH_VehiclesSOV_tex.ext_vehicles.isu152_turret_int'
    FireEffectOffset=(X=5.0,Y=0.0,Z=10.0)

    // Cannon armour (mantlet)
    GunMantletArmorFactor=12.0
    GunMantletSlope=0.0

    // Cannon movement
    bHasTurret=false
    ManualRotationsPerSecond=0.012
    YawBone="Gun"
    bLimitYaw=true
    MaxPositiveYaw=1850 // +/- 10 degrees
    MaxNegativeYaw=-1850
    YawStartConstraint=-3000.0
    YawEndConstraint=3000.0
    CustomPitchUpLimit=3641 // +20/-3 degrees
    CustomPitchDownLimit=64990

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_ISU152CannonShellHE'
    SecondaryProjectileClass=class'DH_Vehicles.DH_ISU152CannonShell'

    ProjectileDescriptions(1)="AP"
    ProjectileDescriptions(0)="HE" // HE is primary

    nProjectileDescriptions(1)="BR-540" // earlier AP round without ballistic cap
    nProjectileDescriptions(0)="OF-540"

    InitialPrimaryAmmo=11
    InitialSecondaryAmmo=7
    MaxPrimaryAmmo=13
    MaxSecondaryAmmo=7
    Spread=0.0009
    SecondarySpread=0.0009

    // Weapon fire
    AddedPitch=286
    WeaponFireOffset=120.0

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_AlliedVehicleSounds.152mmSov.152mm_fire01'
    CannonFireSound(1)=SoundGroup'DH_AlliedVehicleSounds.152mmSov.152mm_fire02'
    CannonFireSound(2)=SoundGroup'DH_AlliedVehicleSounds.152mmSov.152mm_fire03'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.ISU152_reload_01')
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.ISU152_reload_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.ISU152_reload_03')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.ISU152_reload_04')

    // View shake
    ShakeRotMag=(X=0.0,Y=0.0,Z=150.0)
    ShakeRotRate=(X=0.0,Y=0.0,Z=2000.0)
    ShakeOffsetMag=(X=0.0,Y=0.0,Z=5.0)

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
    RangeSettings(11)=1200
    RangeSettings(12)=1400
    RangeSettings(13)=1600
    RangeSettings(14)=1800
    RangeSettings(15)=2000
    RangeSettings(16)=2200
    RangeSettings(17)=2400
    RangeSettings(18)=2600
    RangeSettings(19)=2800
    RangeSettings(20)=3000
    RangeSettings(21)=3200
    RangeSettings(22)=3400
    RangeSettings(23)=3600
    RangeSettings(24)=3800
    RangeSettings(25)=4000
    RangeSettings(26)=4200
    RangeSettings(27)=4400
    RangeSettings(28)=4600
    RangeSettings(29)=4800
    RangeSettings(30)=5000
    RangeSettings(31)=5200
    RangeSettings(32)=5400
    RangeSettings(33)=5600
    RangeSettings(34)=5800
}
