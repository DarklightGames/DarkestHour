//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_17PounderGunCannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_17PounderGun_anm.17Pounder_turret'
    Skins(0)=Texture'DH_Artillery_Tex.17pounder.17Pounder'
    Skins(1)=Texture'Weapons1st_tex.Bullets.Bullet_Shell_Rifle_MN'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Artillery_stc.17pounder.17pdr_turret_coll')
    GunnerAttachmentBone="com_player"

    // Turret movement
    RotationsPerSecond=0.02
    MaxPositiveYaw=5460
    MaxNegativeYaw=-5460
    YawStartConstraint=-6000.0
    YawEndConstraint=6000.0
    PitchBone="gun01"
    CustomPitchUpLimit=3004
    CustomPitchDownLimit=64444

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Guns.DH_17PounderCannonShell'
    SecondaryProjectileClass=class'DH_Guns.DH_17PounderCannonShellHE'

    nProjectileDescriptions(0)="Mk.IV APC"
    nProjectileDescriptions(1)="Mk.I HE-T"

    InitialPrimaryAmmo=15
    InitialSecondaryAmmo=5
    MaxPrimaryAmmo=20
    MaxSecondaryAmmo=10
    SecondarySpread=0.00156

    // Weapon fire
    WeaponFireOffset=-5.0

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_AlliedVehicleSounds.17pounder.DH17pounder'
    CannonFireSound(1)=SoundGroup'DH_AlliedVehicleSounds.17pounder.DH17pounder'
    CannonFireSound(2)=SoundGroup'DH_AlliedVehicleSounds.17pounder.DH17pounder'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_1') //~3.9 seconds reload
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
