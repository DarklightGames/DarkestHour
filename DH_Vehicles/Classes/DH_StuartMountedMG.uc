//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_StuartMountedMG extends DH_ROMountedTankMG;

defaultproperties
{
    ReloadSound=sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
    NumMags=6
    FireAttachBone="mg_yaw"
    FireEffectOffset=(X=5.000000)
    DummyTracerClass=class'DH_Vehicles.DH_30CalVehicleClientTracer'
    mTracerInterval=0.600000
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="mg_yaw"
    YawStartConstraint=0.000000
    YawEndConstraint=65535.000000
    PitchBone="mg_yaw"
    PitchUpLimit=15000
    PitchDownLimit=45000
    WeaponFireAttachmentBone="mg_yaw"
    WeaponFireOffset=8.000000
    bInstantFire=false
    Spread=0.002000
    FireInterval=0.120000
    FireSoundClass=SoundGroup'DH_AlliedVehicleSounds2.30Cal.V30cal_loop01'
    FireEndSound=SoundGroup'DH_AlliedVehicleSounds2.30Cal.V30cal_end01'
    ProjectileClass=class'DH_Vehicles.DH_30CalVehicleBullet'
    ShakeRotMag=(X=20.000000,Y=20.000000,Z=20.000000)
    ShakeOffsetMag=(X=0.010000,Y=0.010000,Z=0.010000)
    MaxPositiveYaw=3500
    MaxNegativeYaw=-8000
    bLimitYaw=true
    InitialPrimaryAmmo=200
    Mesh=SkeletalMesh'DH_Sherman_anm.ShermanM4A1_MG_ext'
    SoundVolume=150
}
