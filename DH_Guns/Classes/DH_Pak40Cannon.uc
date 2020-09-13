//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_Pak40Cannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Pak40_anm.Pak40_turret'
    Skins(0)=Texture'DH_Artillery_Tex.Pak40.Pak40'
    Skins(1)=Texture'DH_VehicleOptics_tex.German.ZF_II_3x8_Pak'
    Skins(2)=Texture'Weapons1st_tex.Bullets.Bullet_Shell_Rifle'
    CollisionStaticMesh=StaticMesh'DH_Artillery_stc.Pak40.pak40_turret_coll'
    GunnerAttachmentBone="com_player"

    // Turret movement
    MaxPositiveYaw=5825
    MaxNegativeYaw=-5825
    YawStartConstraint=-6000.0
    YawEndConstraint=6000.0
    CustomPitchUpLimit=3000
    CustomPitchDownLimit=63850

    // Cannon ammo
    ProjectileClass=class'DH_Guns.DH_Pak40CannonShell'
    PrimaryProjectileClass=class'DH_Guns.DH_Pak40CannonShell'
    SecondaryProjectileClass=class'DH_Guns.DH_Pak40CannonShellHE'

    nProjectileDescriptions(0)="PzGr.39"
    nProjectileDescriptions(1)="Sprgr.Patr.34"

    InitialPrimaryAmmo=20
    InitialSecondaryAmmo=10
    MaxPrimaryAmmo=50
    MaxSecondaryAmmo=42
    SecondarySpread=0.00127

    // Weapon fire
    WeaponFireOffset=1.0

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire03'
    ReloadStages(0)=(Sound=none) //faster 3 sec reload for an AT gun
    ReloadStages(1)=(Sound=none)
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
}
