//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PanzerIVGLateCannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_PanzerIV_anm.Panzer4Glate_turret_ext'
    Skins(0)=Texture'axis_vehicles_tex.ext_vehicles.Panzer4F2_ext'
    Skins(1)=Texture'axis_vehicles_tex2.ext_vehicles.Panzer4H_Armor'
    Skins(2)=Texture'axis_vehicles_tex.int_vehicles.Panzer4F2_int'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_German_vehicles_stc.Panzer4H.Panzer4_turret_coll')
    HighDetailOverlay=Shader'axis_vehicles_tex.int_vehicles.Panzer4f2_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    // Turret armor
    bHasAddedSideArmor=true
    FrontArmorFactor=5.0
    RightArmorFactor=3.1
    LeftArmorFactor=3.1
    RearArmorFactor=3.1
    FrontArmorSlope=12.0
    RightArmorSlope=26.0
    LeftArmorSlope=26.0
    RearArmorSlope=10.0
    FrontLeftAngle=322.0
    FrontRightAngle=38.0
    RearRightAngle=142.0
    RearLeftAngle=218.0

    // Turret movement
    ManualRotationsPerSecond=0.02
    PoweredRotationsPerSecond=0.04
    CustomPitchUpLimit=3641
    CustomPitchDownLimit=64080

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_PanzerIVCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_PanzerIVCannonShellHE'
    TertiaryProjectileClass=class'DH_Vehicles.DH_PanzerIVCannonShellHEAT'

    ProjectileDescriptions(2)="HEAT"

    nProjectileDescriptions(0)="PzGr.39"
    nProjectileDescriptions(1)="Sprgr.Patr.34"
    nProjectileDescriptions(2)="Gr.38 Hl/C"

    InitialPrimaryAmmo=40
    InitialSecondaryAmmo=16
    InitialTertiaryAmmo=7

    MaxPrimaryAmmo=44
    MaxSecondaryAmmo=35
    MaxTertiaryAmmo=8
    SecondarySpread=0.00127
    TertiarySpread=0.00357

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_MG34Bullet'
    InitialAltAmmo=150
    NumMGMags=5
    AltFireInterval=0.08
    TracerProjectileClass=class'DH_Weapons.DH_MG34TracerBullet'
    TracerFrequency=7

    // Weapon fire
    WeaponFireOffset=138.5
    AltFireOffset=(X=-60.0,Y=19.0,Z=0.0)
    AltFireSpawnOffsetX=26.0

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire03'
    AltFireSoundClass=sound'Inf_Weapons.mg34_p_fire_loop'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
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
