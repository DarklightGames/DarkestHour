//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JagdpantherCannon extends DHVehicleCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_turret_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Jagdpanther_body_goodwood'
    Skins(1)=Texture'DH_VehiclesGE_tex2.int_vehicles.Jagdpanther_walls_int'
    Skins(2)=Texture'DH_VehiclesGE_tex2.int_vehicles.Jagdpanther_turret_int'
    FireEffectOffset=(X=0.0,Y=0.0,Z=-10.0)

    // Cannon armour (mantlet)
    GunMantletArmorFactor=15.0
    GunMantletSlope=35.0

    // Cannon movement
    bHasTurret=false
    ManualRotationsPerSecond=0.02
    YawBone="Gun"
    bLimitYaw=true
    MaxPositiveYaw=2367
    MaxNegativeYaw=-2367
    YawStartConstraint=-3000.0
    YawEndConstraint=3000.0
    PitchBone="gun_pitch"
    CustomPitchUpLimit=2548
    CustomPitchDownLimit=64079

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_JagdpantherCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_JagdpantherCannonShellHE'

    nProjectileDescriptions(0)="PzGr.39/43"
    nProjectileDescriptions(1)="Sprgr.Patr."

    InitialPrimaryAmmo=30
    InitialSecondaryAmmo=7
    MaxPrimaryAmmo=42
    MaxSecondaryAmmo=15
    SecondarySpread=0.00135

    // Smoke launcher
    SmokeLauncherClass=class'DH_Vehicles.DH_Nahverteidigungswaffe'
    SmokeLauncherFireOffset(0)=(X=-64.0,Y=-39.0,Z=35.0)

    // Weapon fire
    WeaponFireOffset=8.5
    AddedPitch=-56.0

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_GerVehicleSounds.88mm.DH88mm_01'
    CannonFireSound(1)=SoundGroup'DH_GerVehicleSounds.88mm.DH88mm_02'
    CannonFireSound(2)=SoundGroup'DH_GerVehicleSounds.88mm.DH88mm_03'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_01')
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_03')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_04')

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
    RangeSettings(26)=3200
    RangeSettings(27)=3400
    RangeSettings(28)=3600
    RangeSettings(29)=3800
    RangeSettings(30)=4000
}
