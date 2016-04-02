//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_StuH42MountedMG extends DHVehicleMG;

defaultproperties
{
    // MG mesh
    Mesh=SkeletalMesh'DH_Stug3G_anm.StuH_mg_remote'
    Skins(1)=texture'DH_VehiclesGE_tex2.int_vehicles.Stug3g_body_int'
    Skins(2)=texture'Weapons3rd_tex.German.mg34_world'
    bMatchSkinToVehicle=true
    CollisionStaticMesh=StaticMesh'DH_German_vehicles_stc2.StuH.StuH_remoteMG_coll'
    bForceSkelUpdate=true // necessary for new player hit detection system, as makes server update the MG mesh skeleton, which it wouldn't otherwise as server doesn't draw mesh
    BeginningIdleAnim="com_idle_close"
    GunnerAttachmentBone="loader_attachment"
    FireAttachBone="gunner_int"
    FireEffectOffset=(X=0.0,Y=0.0,Z=50.0)

    // Collision (as has gun shield)
    bCollideActors=true
    bBlockActors=true
    bProjTarget=true
    bBlockZeroExtentTraces=true
    bBlockNonZeroExtentTraces=true

    // Movement
    YawBone="Turret"
    bLimitYaw=false
    PitchBone="Gun"
    CustomPitchUpLimit=1500 // reduced from 4500 so that MG stock doesn't sink into roof
    CustomPitchDownLimit=63500

    // Ammo
    ProjectileClass=class'DH_Weapons.DH_MG34Bullet'
    InitialPrimaryAmmo=50
    NumMags=12
    FireInterval=0.07059
    AIInfo(0)=(RefireRate=0.07059)
    TracerProjectileClass=class'DH_Weapons.DH_MG34TracerBullet'
    TracerFrequency=7

    // Weapon fire
    WeaponFireAttachmentBone="Barrel"
    WeaponFireOffset=3.0
    AmbientEffectEmitterClass=class'ROVehicles.VehicleMGEmitter'
    FireSoundClass=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    AmbientSoundScaling=2.0
    ShakeRotMag=(X=25.0,Y=0.0,Z=10.0)
    ShakeRotRate=(X=5000.0,Y=5000.0,Z=5000.0)
    ShakeRotTime=2.0
    ShakeOffsetMag=(X=0.5,Y=0.0,Z=0.2)
    ShakeOffsetRate=(X=500.0,Y=500.0,Z=500.0)
    ShakeOffsetTime=2.0

    // Reload
    ReloadSounds[0]=(Sound=sound'Inf_Weapons_Foley.mg34.mg34_reload01_000',Duration=1.24) // differs from defaults because uses ammo drums & not belts
    ReloadSounds[1]=(Sound=sound'Inf_Weapons_Foley.mg34.mg34_reload02_039',Duration=2.03)
    ReloadSounds[2]=(Sound=sound'Inf_Weapons_Foley.mg34.mg34_reload03_104',Duration=2.07)
    ReloadSounds[3]=(Sound=sound'Inf_Weapons_Foley.mg34.mg34_reload04_170',Duration=1.34)
}
