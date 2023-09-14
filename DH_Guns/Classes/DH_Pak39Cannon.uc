//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Pak39Cannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Pak39_anm.pak39_turret'
    Skins(0)=Texture'DH_Pak39_tex.body.pak39_body'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Pak39_stc.Collision.pak39_turret_collision')
    GunnerAttachmentBone="com_player"

    // Turret movement
    bLimitYaw=false
    CustomPitchUpLimit=3000
    CustomPitchDownLimit=63850

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Guns.DH_Pak38CannonShell'
    SecondaryProjectileClass=class'DH_Guns.DH_Pak38CannonShellAPCR'
    TertiaryProjectileClass=class'DH_Guns.DH_Pak38CannonShellHE'

    ProjectileDescriptions(1)="APCR"
    ProjectileDescriptions(2)="HE"

    nProjectileDescriptions(0)="PzGr.39"
    nProjectileDescriptions(1)="PzGr.40"
    nProjectileDescriptions(2)="Sprgr.Patr.38"

    InitialPrimaryAmmo=40
    InitialSecondaryAmmo=6
    InitialTertiaryAmmo=15

    MaxPrimaryAmmo=55
    MaxSecondaryAmmo=10
    MaxTertiaryAmmo=30

    SecondarySpread=0.00165
    TertiarySpread=0.0013

    // Weapon fire
    WeaponFireOffset=1.0

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.Panzeriii.50mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.Panzeriii.50mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.Panzeriii.50mm_fire03'
    ReloadStages(0)=(Sound=none) //~2.8 seconds reload for a lower caliber AT gun
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_2')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_3')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_4')

    GunWheels(0)=(RotationType=ROTATION_Yaw,BoneName="TravWheel",Scale=-64.0,RotationAxis=AXIS_Z)
    GunWheels(1)=(RotationType=ROTATION_Pitch,BoneName="ElevGear",Scale=-32.0,RotationAxis=AXIS_Y)
    GunWheels(2)=(RotationType=ROTATION_Pitch,BoneName="ElevWheel",Scale=-64.0,RotationAxis=AXIS_Y)

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
