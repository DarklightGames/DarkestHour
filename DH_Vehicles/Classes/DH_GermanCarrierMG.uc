//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_GermanCarrierMG extends DHVehicleMG;

defaultproperties
{
    // MG mesh
    Mesh=SkeletalMesh'DH_Marder3M_anm.marder_M34_ext'
    bForceSkelUpdate=true // necessary for new player hit detection system, as makes server update the MG mesh skeleton, which it wouldn't otherwise as server doesn't draw mesh
    GunnerAttachmentBone="loader_player"

    // Movement
    bLimitYaw = true
    YawBone="mg_yaw"
    PitchBone="mg_yaw"
    RotationsPerSecond=0.5
    MaxPositiveYaw=8500
    MaxNegativeYaw=-8500
    CustomPitchUpLimit=4000
    CustomPitchDownLimit=60000

    // Ammo
    ProjectileClass=class'DH_Weapons.DH_MG34Bullet'
    InitialPrimaryAmmo=50
    NumMGMags=15
    FireInterval=0.08
    TracerProjectileClass=class'DH_Weapons.DH_MG34TracerBullet'
    TracerFrequency=7

    // Weapon fire
    WeaponFireAttachmentBone="tip"
    AmbientEffectEmitterClass=class'VehicleMGEmitter'
    FireSoundClass=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    ShakeOffsetMag=(X=0.5,Y=0.0,Z=0.2)
    ShakeOffsetRate=(X=500.0,Y=500.0,Z=500.0)
    ShakeRotMag=(X=25.0,Y=0.0,Z=10.0)
    ShakeRotRate=(X=5000.0,Y=5000.0,Z=5000.0)

    // Reload
    HUDOverlayReloadAnim="Bipod_Reload_s"
    ReloadStages(0)=(Sound=none,Duration=1.57) // no sounds because HUD overlay reload animation plays them
    ReloadStages(1)=(Sound=none,Duration=1.56)
    ReloadStages(2)=(Sound=none,Duration=1.92)
    ReloadStages(3)=(Sound=none,Duration=1.63)
}
