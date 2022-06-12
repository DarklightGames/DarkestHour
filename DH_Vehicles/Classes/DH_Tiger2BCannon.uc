//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_Tiger2BCannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_Tiger2B_anm.tiger2B_turret_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex2.ext_vehicles.tiger2B_body_normandy'
    Skins(1)=Texture'DH_VehiclesGE_tex2.int_vehicles.tiger2B_turret_int'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_German_vehicles_stc2.Tiger2B.Tiger2B_turret_col')
    FireEffectOffset=(X=0.0,Y=0.0,Z=-10.0)

    // Turret armor
    FrontArmorFactor=18.0
    RightArmorFactor=8.0
    LeftArmorFactor=8.0
    RearArmorFactor=8.0
    FrontArmorSlope=10.0
    RightArmorSlope=21.0
    LeftArmorSlope=21.0
    RearArmorSlope=21.0
    FrontLeftAngle=326.0
    FrontRightAngle=34.0
    RearRightAngle=146.0
    RearLeftAngle=214.0

    // Turret movement
    ManualRotationsPerSecond=0.0056
    PoweredRotationsPerSecond=0.04
    CustomPitchUpLimit=2731
    CustomPitchDownLimit=64189

    // Cannon ammo
    ProjectileClass=class'DH_Vehicles.DH_Tiger2BCannonShell'
    PrimaryProjectileClass=class'DH_Vehicles.DH_Tiger2BCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_Tiger2BCannonShellHE'

    nProjectileDescriptions(0)="PzGr.39/43"
    nProjectileDescriptions(1)="Sprgr.Patr."

    InitialPrimaryAmmo=40
    InitialSecondaryAmmo=20
    MaxPrimaryAmmo=45
    MaxSecondaryAmmo=35
    SecondarySpread=0.00152

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_MG34Bullet'
    InitialAltAmmo=150
    NumMGMags=10
    AltFireInterval=0.08
    TracerProjectileClass=class'DH_Weapons.DH_MG34TracerBullet'
    TracerFrequency=7

    // Smoke launcher
    SmokeLauncherClass=class'DH_Vehicles.DH_Nahverteidigungswaffe'
    SmokeLauncherFireOffset(0)=(X=16.0,Y=43.0,Z=66.0)

    // Weapon fire
    AddedPitch=15
    WeaponFireOffset=0.0
    AltFireOffset=(X=-325.0,Y=19.5,Z=4.5)

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_GerVehicleSounds.88mm.DH88mm_01'
    CannonFireSound(1)=SoundGroup'DH_GerVehicleSounds.88mm.DH88mm_02'
    CannonFireSound(2)=SoundGroup'DH_GerVehicleSounds.88mm.DH88mm_03'
    AltFireSoundClass=sound'Inf_Weapons.mg34_p_fire_loop'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    ReloadStages(0)=(Sound=Sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_01')
    ReloadStages(1)=(Sound=Sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_02')
    ReloadStages(2)=(Sound=Sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_03')
    ReloadStages(3)=(Sound=Sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_04')

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
