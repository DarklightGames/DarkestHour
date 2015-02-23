//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Tiger2BMountedMG extends DH_ROMountedTankMG;

defaultproperties
{
    ReloadSound=sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
    NumMags=10
    TracerProjectileClass=class'DH_MG34VehicleTracerBullet'
    TracerFrequency=7
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="mg_yaw"
    YawStartConstraint=0.0
    YawEndConstraint=65535.0
    PitchBone="mg_pitch"
    PitchUpLimit=15000
    PitchDownLimit=45000
    WeaponFireAttachmentBone="mg_yaw"
    WeaponFireOffset=20.0
    RotationsPerSecond=1.0
    bInstantFire=false
    Spread=0.002
    FireInterval=0.07058
    FireSoundClass=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
    AmbientSoundScaling=5.0
    FireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    ProjectileClass=class'DH_Vehicles.DH_MG34VehicleBullet'
    ShakeRotMag=(X=10.0,Y=10.0,Z=10.0)
    ShakeRotRate=(X=400.0,Y=400.0,Z=400.0)
    ShakeOffsetMag=(X=0.4,Y=0.4,Z=0.4)
    ShakeOffsetRate=(X=100.0,Y=100.0,Z=100.0)
    AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.5)
    AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.015)
    MaxPositiveYaw=7000
    MaxNegativeYaw=-7000
    bLimitYaw=true
    InitialPrimaryAmmo=150
    Mesh=SkeletalMesh'axis_panzer4F1_anm.Panzer4F1_mg_ext'
}
