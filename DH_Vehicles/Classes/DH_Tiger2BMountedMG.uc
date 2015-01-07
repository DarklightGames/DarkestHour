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
    YawStartConstraint=0.000000
    YawEndConstraint=65535.000000
    PitchBone="mg_pitch"
    PitchUpLimit=15000
    PitchDownLimit=45000
    WeaponFireAttachmentBone="mg_yaw"
    WeaponFireOffset=20.000000
    RotationsPerSecond=1.000000
    bInstantFire=false
    Spread=0.002000
    FireInterval=0.070580
    FireSoundClass=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
    AmbientSoundScaling=5.000000
    FireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    ProjectileClass=class'DH_Vehicles.DH_MG34VehicleBullet'
    ShakeRotMag=(X=10.000000,Y=10.000000,Z=10.000000)
    ShakeRotRate=(X=400.000000,Y=400.000000,Z=400.000000)
    ShakeOffsetMag=(X=0.400000,Y=0.400000,Z=0.400000)
    ShakeOffsetRate=(X=100.000000,Y=100.000000,Z=100.000000)
    AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.500000)
    AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.015000)
    MaxPositiveYaw=7000
    MaxNegativeYaw=-7000
    bLimitYaw=true
    InitialPrimaryAmmo=150
    Mesh=SkeletalMesh'axis_panzer4F1_anm.Panzer4F1_mg_ext'
}
