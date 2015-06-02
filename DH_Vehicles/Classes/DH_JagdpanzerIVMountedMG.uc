//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_JagdpanzerIVMountedMG extends DHVehicleMG;

defaultproperties
{
    ReloadSound=sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
    NumMags=8
    FireAttachBone="mg_yaw"
    TracerProjectileClass=class'DH_MG42VehicleTracerBullet'
    TracerFrequency=7
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="mg_yaw"
    PitchBone="mg_yaw"
    PitchUpLimit=15000
    PitchDownLimit=45000
    CustomPitchUpLimit=2730
    CustomPitchDownLimit=64000
    WeaponFireAttachmentBone="mg_yaw"
    WeaponFireOffset=11.0
    bInstantFire=false
    Spread=0.002
    FireInterval=0.05
    FireSoundClass=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireLoop01'
    AmbientSoundScaling=1.3
    FireEndSound=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireEnd01'
    ProjectileClass=class'DH_Vehicles.DH_MG42VehicleBullet'
    ShakeRotMag=(X=10.0,Y=10.0,Z=10.0)
    ShakeOffsetMag=(X=0.01,Y=0.01,Z=0.01)
    MaxPositiveYaw=4000
    MaxNegativeYaw=-4000
    bLimitYaw=true
    BeginningIdleAnim="Idle"
    InitialPrimaryAmmo=150
    Mesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer_mg_ext'
}
