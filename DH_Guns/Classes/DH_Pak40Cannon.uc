//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Pak40Cannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Pak40_anm.Pak40_turret'
    Skins(0)=Texture'DH_Artillery_Tex.Pak40.Pak40'
    Skins(1)=Texture'DH_VehicleOptics_tex.German.ZF_II_3x8_Pak'
    Skins(2)=Texture'Weapons1st_tex.Bullets.Bullet_Shell_Rifle'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Artillery_stc.Pak40.pak40_turret_coll')
    GunnerAttachmentBone="com_player"

    // Turret movement
    MaxPositiveYaw=5825
    MaxNegativeYaw=-5825
    YawStartConstraint=-6000.0
    YawEndConstraint=6000.0
    CustomPitchUpLimit=3000
    CustomPitchDownLimit=63850

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Guns.DH_Pak40CannonShell'
    SecondaryProjectileClass=class'DH_Guns.DH_Pak40CannonShellHE'
    TertiaryProjectileClass=class'DH_Guns.DH_Pak40CannonShellAPCR'

    nProjectileDescriptions(0)="PzGr.39"
    nProjectileDescriptions(1)="Sprgr.Patr.34"
    nProjectileDescriptions(2)="PzGr.40"

    ProjectileDescriptions(2)="APCR"

    InitialTertiaryAmmo=2
    MaxTertiaryAmmo=2
    InitialPrimaryAmmo=15
    InitialSecondaryAmmo=5
    MaxPrimaryAmmo=20
    MaxSecondaryAmmo=10
    SecondarySpread=0.00127

    // Weapon fire
    WeaponFireOffset=1.0

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.PanzerIV_F2.75mm_L_fire03'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_01') // 3.75 seconds reload
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_3')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_4')

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

    ResupplyInterval=7.5
}
