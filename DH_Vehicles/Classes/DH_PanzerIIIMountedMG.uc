//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerIIIMountedMG extends DH_ROMountedTankMG;

defaultproperties
{
    ReloadSound=sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
    NumMags=8
    DummyTracerClass=class'DH_Vehicles.DH_MG34VehicleClientTracer'
    mTracerInterval=0.495867
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="mg_yaw"
    YawStartConstraint=0.000000
    YawEndConstraint=65535.000000
    PitchBone="mg_pitch"
    PitchUpLimit=15000
    PitchDownLimit=45000
    WeaponFireAttachmentBone="mg_yaw"
    WeaponFireOffset=12.000000
    bInstantFire=false
    Spread=0.002000
    FireInterval=0.070580
    FireSoundClass=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
    AmbientSoundScaling=5.000000
    FireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    ProjectileClass=class'DH_Vehicles.DH_MG34VehicleBullet'
    ShakeRotMag=(X=10.000000,Y=10.000000,Z=10.000000)
    ShakeOffsetMag=(X=0.010000,Y=0.010000,Z=0.010000)
    MaxPositiveYaw=2730
    MaxNegativeYaw=-2730
    bLimitYaw=true
    InitialPrimaryAmmo=150
    Mesh=SkeletalMesh'axis_panzer3_anm.Panzer3_mg_ext'
}
