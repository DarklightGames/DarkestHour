//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Sdkfz251Gun extends Sdkfz251Gun;

defaultproperties
{
     DummyTracerClass=class'DH_Vehicles.DH_MG34VehicleClientTracer'
     mTracerInterval=0.495867
     Spread=0.002000
     FireSoundClass=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
     AmbientSoundScaling=5.000000
     FireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
     ProjectileClass=class'DH_Vehicles.DH_MG34VehicleBullet'
     Mesh=SkeletalMesh'DH_Sdkfz251Halftrack_anm.halftrack_gun'
}
