//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_M3A1HalftrackMG extends DHVehicleMG;

defaultproperties
{
    bForceSkelUpdate=true // necessary for new player hit detection system, as makes server update the MG mesh skeleton, which it wouldn't otherwise as server doesn't draw mesh
    NumMags=8
    HUDOverlayReloadAnim="Reloads"
    ReloadSounds[0]=(Sound=none,Duration=1.44) // no sounds because HUD overlay reload animation plays them (durations matched to anim notifies)
    ReloadSounds[1]=(Sound=none,Duration=1.52)
    ReloadSounds[2]=(Sound=none,Duration=2.40)
    ReloadSounds[3]=(Sound=none,Duration=1.34)
    TracerProjectileClass=class'DH_Weapons.DH_30CalTracerBullet'
    TracerFrequency=5
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
    FireSoundClass=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireLoop01'
    AmbientSoundScaling=5.0
    FireEndSound=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireEnd01'
    DamageMin=100
    DamageMax=100
    ProjectileClass=class'DH_Weapons.DH_30CalBullet'
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
}
