//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M5GunCannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_M5Gun_anm.m5_turret'
    Skins(0)=texture'DH_M5Gun_tex.m5.m5'
    CollisionStaticMesh=StaticMesh'DH_Artillery_stc.17pounder.17pdr_turret_coll'
    BeginningIdleAnim="com_idle_close"
    GunnerAttachmentBone="com_player"

    // Turret movement
    RotationsPerSecond=0.02
    MaxPositiveYaw=4096
    MaxNegativeYaw=-4096
    YawStartConstraint=-4096
    YawEndConstraint=4096
    CustomPitchUpLimit=5460
    CustomPitchDownLimit=64625

    // Cannon ammo
    ProjectileClass=class'DH_Guns.DH_M5CannonShell'          // TODO: make special shells for the m5
    PrimaryProjectileClass=class'DH_Guns.DH_M5CannonShell'
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
    ReloadStages(0)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_01')
    ReloadStages(1)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_02s_03')
    ReloadStages(3)=(Sound=sound'DH_Vehicle_Reloads.Reloads.reload_01s_04')

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
