//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SU76Cannon extends DHVehicleCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=Mesh'DH_SU76_anm.SU76_turret_ext'
    skins(0)=Texture'allies_vehicles_tex.ext_vehicles.SU76_ext'
    skins(1)=Texture'allies_vehicles_tex.int_vehicles.SU76_int'
    HighDetailOverlay=Material'allies_vehicles_tex.int_vehicles.SU76_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=1

    // Cannon armour (mantlet)
    GunMantletArmorFactor=6.0 //gun breech should stop the shells, i think. In case of su-76 its rather a strong point rather than a weak point, as the rest of superstructure armor is very thin and not sloped
    GunMantletSlope=0.0

    // Cannon movement
    bHasTurret=false
    ManualRotationsPerSecond=0.04
    YawBone="turret"
    bLimitYaw=true
    MaxPositiveYaw=2780 // +/- 15 degrees
    MaxNegativeYaw=-2780
    YawStartConstraint=-4000.0
    YawEndConstraint=4000.0
    CustomPitchUpLimit=4633 // +25/-5 degrees
    CustomPitchDownLimit=64620

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_SU76CannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_SU76CannonShellHE'
    ProjectileDescriptions(0)="APBC"

    nProjectileDescriptions(0)="BR-350B" // standard mid-late war APBC shell
    nProjectileDescriptions(1)="OF-350"

    InitialPrimaryAmmo=25
    InitialSecondaryAmmo=25
    MaxPrimaryAmmo=27
    MaxSecondaryAmmo=27
    SecondarySpread=0.002

    TertiaryProjectileClass=class'DH_Vehicles.DH_SU76CannonShellAPCR'
    InitialTertiaryAmmo=2
    MaxTertiaryAmmo=6
    nProjectileDescriptions(2)="BR-350P"
    ProjectileDescriptions(2)="APCR"

    // Weapon fire

    WeaponFireOffset=200.0


    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.SU_76.76mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.SU_76.76mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.SU_76.76mm_fire03'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_1') //3.5 seconds reload, according to books it could be even faster. Comfortable opened loader space allows that.
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_2')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_3')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_4')

    // View shake


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
    RangeSettings(17)=3400
    RangeSettings(18)=3600
    RangeSettings(19)=3800
    RangeSettings(20)=4000
}
