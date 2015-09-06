//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Stug3GMountedMG extends DHVehicleMG;

defaultproperties
{
    bForceSkelUpdate=true // necessary for new player hit detection system, as makes server update the MG mesh skeleton, which it wouldn't otherwise as server doesn't draw mesh
    NumMags=8
    HUDOverlayReloadAnim="Bipod_Reload_s"
    ReloadSounds[0]=(Sound=none,Duration=1.21) // no sounds because HUD overlay reload animation plays them (durations matched to anim notifies)
    ReloadSounds[1]=(Sound=none,Duration=1.94)
    ReloadSounds[2]=(Sound=none,Duration=2.12)
    ReloadSounds[3]=(Sound=none,Duration=1.32)
    FireAttachBone="gunner_int"
    FireEffectOffset=(X=0.0,Y=0.0,Z=5.0)
    TracerProjectileClass=class'DH_Weapons.DH_MG34TracerBullet'
    TracerFrequency=7
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="mg_pitch"
    PitchBone="mg_pitch"
    PitchUpLimit=10000
    PitchDownLimit=50000
    WeaponFireAttachmentBone="tip"
    GunnerAttachmentBone="loader_attachment"
    WeaponFireOffset=0.0 // override inherited from ROMountedTankMG
    RotationsPerSecond=0.05
    bInstantFire=false
    Spread=0.002
    FireInterval=0.07058
    AltFireInterval=0.07058
    AmbientEffectEmitterClass=class'ROVehicles.VehicleMGEmitter'
    FireSoundClass=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
    AmbientSoundScaling=2.0
    FireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    ProjectileClass=class'DH_Weapons.DH_MG34Bullet'
    ShakeRotMag=(X=25.0,Y=0.0,Z=10.0)
    ShakeRotRate=(X=5000.0,Y=5000.0,Z=5000.0)
    ShakeOffsetMag=(X=0.5,Y=0.0,Z=0.2)
    ShakeOffsetRate=(X=500.0,Y=500.0,Z=500.0)
    AIInfo(0)=(bLeadTarget=true,bFireOnRelease=true,aimerror=800.0,RefireRate=0.07058)
    CustomPitchUpLimit=2400 // Matt: reduced from 4500 to stop MG butt poking through hatch
    CustomPitchDownLimit=63500
    MaxPositiveYaw=5500
    MaxNegativeYaw=-5500
    bLimitYaw=true
    BeginningIdleAnim="loader_button_idle"
    InitialPrimaryAmmo=75
    Mesh=SkeletalMesh'DH_Stug3G_anm.Stug_mg34_ext'
    Skins(0)=texture'DH_VehiclesGE_tex2.ext_vehicles.Stug3g_body_ext'
    Skins(1)=texture'DH_VehiclesGE_tex2.int_vehicles.Stug3g_body_int'
    Skins(2)=texture'Weapons3rd_tex.German.mg34_world'
    bMatchSkinToVehicle=true
    bCollideActors=true
    bBlockActors=true
    bProjTarget=true
    bBlockZeroExtentTraces=true
    bBlockNonZeroExtentTraces=true
}
