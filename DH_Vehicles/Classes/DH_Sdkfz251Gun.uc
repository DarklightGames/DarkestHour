//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Sdkfz251Gun extends DHVehicleMG;

defaultproperties
{
    bForceSkelUpdate=true // added as part of player hit detection TEST
    NumMags=15
    HUDOverlayReloadAnim="Bipod_Reload_s"
    ReloadDuration=6.59
    TracerProjectileClass=class'DH_MG34VehicleTracerBullet'
    TracerFrequency=7
    bHasGunShield=true
    MaxPlayerHitX=-18.0
    VehHitpoints(0)=(PointRadius=9.0,PointHeight=0.0,PointScale=1.0,PointBone=com_attachment,PointOffset=(X=0.0,Y=0.0,Z=15.0))
    VehHitpoints(1)=(PointRadius=15.0,PointHeight=0.0,PointScale=1.0,PointBone=com_attachment,PointOffset=(X=0.0,Y=0.0,Z=-5.0))
    hudAltAmmoIcon=Texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="Gun_protection"
    PitchBone="Gun"
    PitchUpLimit=10000
    PitchDownLimit=50000
    WeaponFireAttachmentBone="Gun"
    GunnerAttachmentBone="com_attachment"
    WeaponFireOffset=40.0
    bInstantFire=false
    Spread=0.002
    FireInterval=0.07058
    AltFireInterval=0.07058
    AmbientEffectEmitterClass=class'VehicleMGEmitter'
    FireSoundClass=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
    AmbientSoundScaling=2.5
    FireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    ProjectileClass=class'DH_Vehicles.DH_MG34VehicleBullet'
    ShakeOffsetMag=(X=0.5,Y=0.0,Z=0.2)
    ShakeOffsetRate=(X=500.0,Y=500.0,Z=500.0)
    ShakeRotMag=(X=25.0,Y=0.0,Z=10.0)
    ShakeRotRate=(X=5000.0,Y=5000.0,Z=5000.0)
    AIInfo[0]=(bLeadTarget=true,bFireOnRelease=true,AimError=800.0,RefireRate=0.07058)
    CustomPitchUpLimit=2000
    CustomPitchDownLimit=63000
    MaxPositiveYaw=10000
    MaxNegativeYaw=-10000
    bLimitYaw=true
    InitialPrimaryAmmo=50
    Mesh=SkeletalMesh'DH_Sdkfz251Halftrack_anm.halftrack_gun_ext'
    bCollideActors=true
    bProjTarget=true
    bBlockActors=true
    bBlockNonZeroExtentTraces=true
    bBlockZeroExtentTraces=true
}
