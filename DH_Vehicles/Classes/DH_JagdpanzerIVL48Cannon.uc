//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JagdpanzerIVL48Cannon extends DHVehicleCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L48_turret_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_body_camo1'
    Skins(1)=Texture'DH_VehiclesGE_tex4.int_vehicles.jagdpanzeriv_body_int'
    Skins(2)=Texture'DH_VehiclesGE_tex4.int_vehicles.jagdpanzeriv_body_int'
    GunnerAttachmentBone="Commander_attachment"
    FireEffectOffset=(X=10.0,Y=0.0,Z=0.0)

    // Cannon armour (mantlet)
    GunMantletArmorFactor=8.0
    GunMantletSlope=40.0

    // Cannon movement
    bHasTurret=false
    ManualRotationsPerSecond=0.033
    bLimitYaw=true
    MaxPositiveYaw=1820
    MaxNegativeYaw=-1820
    YawStartConstraint=-3000.0
    YawEndConstraint=3000.0
    PitchBone="Turret"
    CustomPitchUpLimit=2731
    CustomPitchDownLimit=64653

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_JagdpanzerIVL48CannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_JagdpanzerIVL48CannonShellHE'
    TertiaryProjectileClass=class'DH_Vehicles.DH_JagdpanzerIVL48CannonShellSmoke'
    ProjectileDescriptions(2)="Smoke"

    nProjectileDescriptions(0)="PzGr.39"
    nProjectileDescriptions(1)="Sprgr.Patr.34"
    nProjectileDescriptions(2)="Nbgr.Kw.K"

    InitialPrimaryAmmo=44
    InitialSecondaryAmmo=8
    InitialTertiaryAmmo=4

    MaxPrimaryAmmo=54
    MaxSecondaryAmmo=20
    MaxTertiaryAmmo=5
    SecondarySpread=0.00127
    TertiarySpread=0.00357

    // Smoke launcher
    SmokeLauncherClass=class'DH_Vehicles.DH_Nahverteidigungswaffe'
    SmokeLauncherFireOffset(0)=(X=-157.0,Y=-6.0,Z=22.0)

    // Weapon fire
    WeaponFireAttachmentBone="barrel001"
    WeaponFireOffset=9.0

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire03'
    ReloadStages(0)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_01')
    ReloadStages(1)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_02')
    ReloadStages(2)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_03')
    ReloadStages(3)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_04')

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
