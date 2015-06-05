//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_M3A1HalftrackGun extends DHVehicleMG;

defaultproperties
{
    NumMags=8
    HUDOverlayReloadAnim="Reloads"
    ReloadDuration=6.7
    TracerProjectileClass=class'DH_30CalVehicleTracerBullet'
    TracerFrequency=5
    VehHitpoints(0)=(PointRadius=9.0,PointScale=1.0,PointBone="com_attachment",PointOffset=(X=0.0,Y=-0.5,Z=29.0))
    VehHitpoints(1)=(PointRadius=15.0,PointScale=1.0,PointBone="com_attachment",PointOffset=(X=-3.5,Y=-3.0,Z=8.0))
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="Gun_protection"
    PitchBone="Gun_protection"
    PitchUpLimit=10000
    PitchDownLimit=50000
    WeaponFireAttachmentBone="tip"
    GunnerAttachmentBone="com_attachment"
    WeaponFireOffset=0.0
    RotationsPerSecond=0.5
    bInstantFire=false
    Spread=0.002
    FireInterval=0.12
    AltFireInterval=0.12
    AmbientEffectEmitterClass=class'DH_Vehicles.DH_Vehicle30CalMGEmitter'
    FireSoundClass=SoundGroup'DH_AlliedVehicleSounds2.3Cal.V30cal_loop01'
    AmbientSoundScaling=5.0
    FireEndSound=SoundGroup'DH_AlliedVehicleSounds2.3Cal.V30cal_end01'
    DamageMin=100
    DamageMax=100
    ProjectileClass=class'DH_Vehicles.DH_30CalVehicleBullet'
    ShakeRotMag=(X=25.0,Y=0.0,Z=10.0)
    ShakeRotRate=(X=5000.0,Y=5000.0,Z=5000.0)
    ShakeOffsetMag=(X=0.5,Y=0.0,Z=0.2)
    ShakeOffsetRate=(X=500.0,Y=500.0,Z=500.0)
    AIInfo(0)=(bLeadTarget=true,bFireOnRelease=true,aimerror=800.0,RefireRate=0.07058)
    CustomPitchUpLimit=5000
    CustomPitchDownLimit=63000
    MaxPositiveYaw=12000
    MaxNegativeYaw=-12000
    bLimitYaw=true
    InitialPrimaryAmmo=200
    Mesh=SkeletalMesh'DH_M3A1Halftrack_anm.m3halftrack_gun'
    bCollideActors=true
    bBlockActors=true
    bProjTarget=true
    bBlockZeroExtentTraces=true
    bBlockNonZeroExtentTraces=true
}
