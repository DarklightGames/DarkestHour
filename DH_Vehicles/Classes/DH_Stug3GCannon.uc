//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Stug3GCannon extends DHVehicleCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Stug3G_anm.Stug3g_turret_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Stug3g_body_ext'
    Skins(1)=Texture'DH_VehiclesGE_tex2.int_vehicles.Stug3g_turret_int'

    // Cannon armour (mantlet)
    GunMantletArmorFactor=5.0
    GunMantletSlope=0.0

    // Cannon movement
    bHasTurret=false
    ManualRotationsPerSecond=0.025
    bLimitYaw=true
    MaxPositiveYaw=1820 // +/- 10 degrees
    MaxNegativeYaw=-1820
    YawStartConstraint=-3000.0
    YawEndConstraint=3000.0
    PitchBone="Turret"
    CustomPitchUpLimit=3641 // +20/-6 degrees
    CustomPitchDownLimit=64444

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_Stug3GCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_Stug3GCannonShellHE'
    TertiaryProjectileClass=class'DH_Vehicles.DH_Stug3GCannonShellSmoke'

    ProjectileDescriptions(2)="Smoke"

    nProjectileDescriptions(0)="PzGr.39"
    nProjectileDescriptions(1)="Sprgr.Patr.34"
    nProjectileDescriptions(2)="Nbgr.Kw.K"

    InitialPrimaryAmmo=25
    InitialSecondaryAmmo=16
    InitialTertiaryAmmo=4
    MaxPrimaryAmmo=27
    MaxSecondaryAmmo=23
    MaxTertiaryAmmo=5
    SecondarySpread=0.00127
    TertiarySpread=0.00357

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_MG34Bullet'
    InitialAltAmmo=150
    NumMGMags=4
    AltFireInterval=0.08
    TracerProjectileClass=class'DH_Weapons.DH_MG34TracerBullet'
    TracerFrequency=7

    // Weapon fire
    WeaponFireOffset=5.5
    AltFireOffset=(X=-167.0,Y=-10.0,Z=14.5)

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire03'
    AltFireSoundClass=sound'Inf_Weapons.mg34_p_fire_loop'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_01')
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_03')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_04')

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
