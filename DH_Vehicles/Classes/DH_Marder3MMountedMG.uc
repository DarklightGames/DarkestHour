//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Marder3MMountedMG extends DHMountedTankMG; // Matt: was ROVehicleWeapon

defaultproperties
{
    NumMags=8
    HUDOverlayReloadAnim="Bipod_Reload_s"
    ReloadDuration=6.59
    TracerProjectileClass=class'DH_MG34VehicleTracerBullet'
    TracerFrequency=7
    VehHitpoints(0)=(PointRadius=9.0,PointScale=1.0,PointBone="loader_player",PointOffset=(X=10.0,Z=-10.0))
    VehHitpoints(1)=(PointRadius=15.0,PointScale=1.0,PointBone="loader_player",PointOffset=(X=10.0,Z=-30.0))
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="mg_yaw"
    PitchBone="mg_pitch"
    PitchUpLimit=10000
    PitchDownLimit=50000
    WeaponFireAttachmentBone="tip"
    GunnerAttachmentBone="loader_player"
    WeaponFireOffset=0.0 // override inherited from ROMountedTankMG
    RotationsPerSecond=0.05
    bInstantFire=false // override inherited from ROMountedTankMG (all MGs have this)
    Spread=0.002
    FireInterval=0.07058
    AltFireInterval=0.07058
    AmbientEffectEmitterClass=class'ROVehicles.VehicleMGEmitter'
    FireSoundClass=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
    AmbientSoundScaling=5.0
    FireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    ProjectileClass=class'DH_Vehicles.DH_MG34VehicleBullet'
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
    InitialPrimaryAmmo=75
    Mesh=SkeletalMesh'DH_Marder3M_anm.marder_M34_ext'
    bCollideActors=true
    bBlockActors=true
    bProjTarget=true
    bBlockZeroExtentTraces=true
    bBlockNonZeroExtentTraces=true
}
