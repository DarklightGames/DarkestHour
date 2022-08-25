//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_PanzerIVF1Cannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_Panzer4F1_anm.Panzer4F1_turret_ext'
    skins(0)=Texture'axis_vehicles_tex.ext_vehicles.Panzer4F1_ext'
    skins(1)=Texture'axis_vehicles_tex.int_vehicles.Panzer4F2_int'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_German_vehicles_stc.Panzer4H.Panzer4_turret_coll')

    //DestroyedMeshSkins(0)=Combiner'DH_VehiclesGE_tex.Destroyed.PanzerIV_body_dest'

    // Turret armor
    FrontArmorFactor=5.0
    RightArmorFactor=3.0
    LeftArmorFactor=3.0
    RearArmorFactor=3.0

    FrontArmorSlope=11.0
    RightArmorSlope=26.0
    LeftArmorSlope=26.0
    RearArmorSlope=16.0

    FrontLeftAngle=322.0
    FrontRightAngle=38.0
    RearRightAngle=142.0
    RearLeftAngle=218.0

    // Turret movement
    ManualRotationsPerSecond=0.02
    PoweredRotationsPerSecond=0.05 // 20 seconds to rotate 360
    CustomPitchUpLimit=3641
    CustomPitchDownLimit=64080

    // Cannon ammo
    ProjectileClass=class'DH_Vehicles.DH_PanzerIVF1CannonShell'
    PrimaryProjectileClass=class'DH_Vehicles.DH_PanzerIVF1CannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_PanzerIVF1CannonShellHEAT'
    TertiaryProjectileClass=class'DH_Vehicles.DH_PanzerIIINCannonShellHE'

    ProjectileDescriptions(0)="APCBC"
    ProjectileDescriptions(1)="HEAT"
    ProjectileDescriptions(2)="HE"

    nProjectileDescriptions(0)="K.Gr.rot Pz."
    nProjectileDescriptions(1)="Gr.38 Hl/B"
    nProjectileDescriptions(2)="Sprgr.Kw.K."

    InitialPrimaryAmmo=30
    InitialSecondaryAmmo=10
    InitialTertiaryAmmo=20
    MaxPrimaryAmmo=40
    MaxSecondaryAmmo=15
    MaxTertiaryAmmo=25
    Spread=0.00125
    SecondarySpread=0.0039
    TertiarySpread=0.00135

   // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_MG34Bullet'
    InitialAltAmmo=150
    NumMGMags=8
    AltFireInterval=0.08
    TracerProjectileClass=class'DH_Weapons.DH_MG34TracerBullet'
    TracerFrequency=7

    // Weapon fire
    WeaponFireOffset=25.0
    AltFireOffset=(X=-55.0,Y=19.5,Z=0.0)
    AltFireSpawnOffsetX=0.0

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.PanzerIV_F1.75mm_S_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.PanzerIV_F1.75mm_S_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.PanzerIV_F1.75mm_S_fire03'
    AltFireSoundClass=sound'Inf_Weapons.mg34_p_fire_loop'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_01')
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_03')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_04')
    RotateSound=Sound'Vehicle_Weapons.Turret.electric_turret_traverse'

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
