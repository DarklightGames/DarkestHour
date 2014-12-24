//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ShermanMountedMG_M4A176W extends DH_ROMountedTankMG;

defaultproperties
{
    ReloadSound=sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
    NumMags=6
    FireAttachBone="mg_yaw"
//  DummyTracerClass=class'DH_Vehicles.DH_30CalVehicleClientTracer' // deprecated
    TracerProjectileClass=class'DH_30CalVehicleTracerBullet'
    TracerFrequency=5
//  mTracerInterval=0.600000 // deprecated
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
    FireSoundClass=SoundGroup'DH_WeaponSounds.30Cal.30Cal_FireLoop01'
    FireEndSound=SoundGroup'DH_WeaponSounds.30Cal.30Cal_FireEnd01'
    ProjectileClass=class'DH_Vehicles.DH_30CalVehicleBullet'
    ShakeRotMag=(X=20.000000,Y=20.000000,Z=20.000000)
    ShakeOffsetMag=(X=0.010000,Y=0.010000,Z=0.010000)
    MaxPositiveYaw=4000
    MaxNegativeYaw=-7000
    bLimitYaw=true
    InitialPrimaryAmmo=200
    Mesh=SkeletalMesh'DH_Sherman_anm.ShermanM4A1_MG_ext'
}
