//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_StuH42MountedMG extends DHVehicleMG;

defaultproperties
{
    bForceSkelUpdate=true // necessary for new player hit detection system, as makes server update the MG mesh skeleton, which it wouldn't otherwise as server doesn't draw mesh
    NumMags=12
    ReloadSounds[0]=(Sound=sound'Inf_Weapons_Foley.mg34.mg34_reload01_000',Duration=1.24) // differs from defaults because uses ammo drums & not belts
    ReloadSounds[1]=(Sound=sound'Inf_Weapons_Foley.mg34.mg34_reload02_039',Duration=2.03)
    ReloadSounds[2]=(Sound=sound'Inf_Weapons_Foley.mg34.mg34_reload03_104',Duration=2.07)
    ReloadSounds[3]=(Sound=sound'Inf_Weapons_Foley.mg34.mg34_reload04_170',Duration=1.34)
    FireAttachBone="gunner_int"
    FireEffectOffset=(X=0.0,Y=0.0,Z=5.0)
    TracerProjectileClass=class'DH_Weapons.DH_MG34TracerBullet'
    TracerFrequency=7
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="Turret"
    PitchBone="Gun"
    PitchUpLimit=10000
    PitchDownLimit=50000
    WeaponFireAttachmentBone="Barrel"
    GunnerAttachmentBone="loader_attachment"
    WeaponFireOffset=3.0
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
    ShakeRotTime=2.0
    ShakeOffsetMag=(X=0.5,Y=0.0,Z=0.2)
    ShakeOffsetRate=(X=500.0,Y=500.0,Z=500.0)
    ShakeOffsetTime=2.0
    AIInfo(0)=(bLeadTarget=true,bFireOnRelease=true,aimerror=800.0,RefireRate=0.07058)
    CustomPitchUpLimit=4500
    CustomPitchDownLimit=63500
    MaxPositiveYaw=5500
    MaxNegativeYaw=-5500
    BeginningIdleAnim="com_idle_close"
    InitialPrimaryAmmo=50
    Mesh=SkeletalMesh'DH_Stug3G_anm.StuH_mg_remote'
    Skins(0)=texture'DH_VehiclesGE_tex2.ext_vehicles.Stug3g_body_ext'
    Skins(1)=texture'DH_VehiclesGE_tex2.int_vehicles.Stug3g_body_int'
    Skins(2)=texture'Weapons3rd_tex.German.mg34_world'
    bMatchSkinToVehicle=true
    CollisionStaticMesh=StaticMesh'DH_German_vehicles_stc2.StuH.StuH_remoteMG_coll'
    bCollideActors=true
    bBlockActors=true
    bProjTarget=true
    bBlockZeroExtentTraces=true
    bBlockNonZeroExtentTraces=true
}
