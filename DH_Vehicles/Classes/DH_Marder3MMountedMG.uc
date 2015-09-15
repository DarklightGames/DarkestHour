//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Marder3MMountedMG extends DHVehicleMG;

defaultproperties
{
    bForceSkelUpdate=true // necessary for new player hit detection system, as makes server update the MG mesh skeleton, which it wouldn't otherwise as server doesn't draw mesh
    NumMags=24
    HUDOverlayReloadAnim="Bipod_Reload_s"
    ReloadSounds[0]=(Sound=none,Duration=1.21) // no sounds because HUD overlay reload animation plays them (durations matched to anim notifies)
    ReloadSounds[1]=(Sound=none,Duration=1.94)
    ReloadSounds[2]=(Sound=none,Duration=2.12)
    ReloadSounds[3]=(Sound=none,Duration=1.32)
    TracerProjectileClass=class'DH_Weapons.DH_MG34TracerBullet'
    TracerFrequency=7
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="mg_yaw"
    PitchBone="mg_pitch"
    PitchUpLimit=10000
    PitchDownLimit=50000
    WeaponFireAttachmentBone="tip"
    GunnerAttachmentBone="loader_player"
    WeaponFireOffset=0.0
    RotationsPerSecond=0.5
    bInstantFire=false
    Spread=0.002
    FireInterval=0.07058
    AltFireInterval=0.07058
    AmbientEffectEmitterClass=class'ROVehicles.VehicleMGEmitter'
    FireSoundClass=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
    AmbientSoundScaling=2.5
    FireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    ProjectileClass=class'DH_Weapons.DH_MG34Bullet'
    ShakeRotMag=(X=25.0,Y=0.0,Z=10.0)
    ShakeRotRate=(X=5000.0,Y=5000.0,Z=5000.0)
    ShakeOffsetMag=(X=0.5,Y=0.0,Z=0.2)
    ShakeOffsetRate=(X=500.0,Y=500.0,Z=500.0)
    AIInfo(0)=(bLeadTarget=true,bFireOnRelease=true,aimerror=800.0,RefireRate=0.07058)
    CustomPitchUpLimit=4500
    CustomPitchDownLimit=63500
    MaxPositiveYaw=5500
    MaxNegativeYaw=-5500
    bLimitYaw=true
    BeginningIdleAnim="loader_close_idle"
    InitialPrimaryAmmo=50
    Mesh=SkeletalMesh'DH_Marder3M_anm.marder_M34_ext'
}
