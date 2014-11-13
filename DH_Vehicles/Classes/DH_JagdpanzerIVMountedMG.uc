//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_JagdpanzerIVMountedMG extends DH_ROMountedTankMG;

defaultproperties
{
     ReloadSound=Sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
     NumMags=8
     DummyTracerClass=class'DH_Vehicles.DH_MG42VehicleClientTracer'
     mTracerInterval=0.350000
     hudAltAmmoIcon=Texture'InterfaceArt_tex.HUD.mg42_ammo'
     YawBone="mg_yaw"
     YawStartConstraint=0.000000
     YawEndConstraint=65535.000000
     PitchBone="mg_yaw"
     PitchUpLimit=15000
     PitchDownLimit=45000
     WeaponFireAttachmentBone="mg_yaw"
     WeaponFireOffset=11.000000
     bInstantFire=false
     Spread=0.002000
     FireInterval=0.050000
     FireSoundClass=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireLoop01'
     AmbientSoundScaling=1.300000
     FireEndSound=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireEnd01'
     ProjectileClass=class'DH_Vehicles.DH_MG42VehicleBullet'
     ShakeRotMag=(X=10.000000,Y=10.000000,Z=10.000000)
     ShakeOffsetMag=(X=0.010000,Y=0.010000,Z=0.010000)
     MaxPositiveYaw=4000
     MaxNegativeYaw=-4000
     bLimitYaw=true
     BeginningIdleAnim="Idle"
     InitialPrimaryAmmo=150
     Mesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer_mg_ext'
}
