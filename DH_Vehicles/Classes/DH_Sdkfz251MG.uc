//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Sdkfz251MG extends DHVehicleMG;

defaultproperties
{
    bForceSkelUpdate=true // necessary for new player hit detection system, as makes server update the MG mesh skeleton, which it wouldn't otherwise as server doesn't draw mesh
    NumMags=15
    HUDOverlayReloadAnim="Bipod_Reload_s"
    ReloadSounds[0]=(Sound=none,Duration=1.21) // no sounds because HUD overlay reload animation plays them (durations matched to anim notifies)
    ReloadSounds[1]=(Sound=none,Duration=1.94)
    ReloadSounds[2]=(Sound=none,Duration=2.12)
    ReloadSounds[3]=(Sound=none,Duration=1.32)
    TracerProjectileClass=class'DH_Weapons.DH_MG34TracerBullet'
    TracerFrequency=7
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
    ProjectileClass=class'DH_Weapons.DH_MG34Bullet'
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
    Skins(0)=texture'axis_vehicles_tex.ext_vehicles.halftrack_ext'
    Skins(1)=texture'Weapons3rd_tex.German.mg34_world'
    bMatchSkinToVehicle=true
    CollisionStaticMesh=StaticMesh'DH_German_vehicles_stc.Halftrack.Halftrack_MG_coll'
    bCollideActors=true
    bProjTarget=true
    bBlockActors=true
    bBlockNonZeroExtentTraces=true
    bBlockZeroExtentTraces=true
}
