//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_17PounderGunCannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_17PounderGun_anm.17Pounder_turret'
    Skins(0)=texture'DH_Artillery_Tex.17pounder.17Pounder'
    Skins(1)=texture'Weapons1st_tex.Bullets.Bullet_Shell_Rifle_MN'
//  CollisionStaticMesh=StaticMesh'DH_Artillery_stc.17pounder.17pdr_turret_coll' // TODO - make 'turret' col mesh
    BeginningIdleAnim="com_idle_close"
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
    ProjectileClass=class'DH_Guns.DH_17PounderCannonShell'
    PrimaryProjectileClass=class'DH_Guns.DH_17PounderCannonShell'
    SecondaryProjectileClass=class'DH_Guns.DH_17PounderCannonShellHE'
    InitialPrimaryAmmo=60
    InitialSecondaryAmmo=30
    SecondarySpread=0.00156

    // Weapon fire
    WeaponFireOffset=-5.0

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_AlliedVehicleSounds.17pounder.DH17pounder'
    CannonFireSound(1)=SoundGroup'DH_AlliedVehicleSounds.17pounder.DH17pounder'
    CannonFireSound(2)=SoundGroup'DH_AlliedVehicleSounds.17pounder.DH17pounder'
    ReloadSoundOne=sound'DH_Vehicle_Reloads.Reloads.reload_01s_01'
    ReloadSoundTwo=sound'DH_Vehicle_Reloads.Reloads.reload_01s_02'
    ReloadSoundThree=sound'DH_Vehicle_Reloads.Reloads.reload_02s_03'
    ReloadSoundFour=sound'DH_Vehicle_Reloads.Reloads.reload_01s_04'

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
