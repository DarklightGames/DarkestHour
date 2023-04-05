//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_StuH42MountedMG extends DHVehicleMG;

defaultproperties
{
    // MG mesh
    Mesh=SkeletalMesh'DH_Stug3G_anm.StuH_mg_remote'
    Skins(1)=Texture'DH_VehiclesGE_tex2.int_vehicles.Stug3g_body_int'
    Skins(2)=Texture'Weapons3rd_tex.German.mg34_world'
    bMatchSkinToVehicle=true
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_German_vehicles_stc2.StuH.StuH_remoteMG_coll')
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
    NumMGMags=12
    FireInterval=0.08
    TracerProjectileClass=class'DH_Weapons.DH_MG34TracerBullet'
    TracerFrequency=7

    // Weapon fire
    WeaponFireAttachmentBone="Barrel"
    WeaponFireOffset=3.0
    AmbientEffectEmitterClass=class'ROVehicles.VehicleMGEmitter'
    FireSoundClass=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    ShakeRotMag=(X=25.0,Y=0.0,Z=10.0)
    ShakeRotRate=(X=5000.0,Y=5000.0,Z=5000.0)
    ShakeRotTime=2.0
    ShakeOffsetMag=(X=0.5,Y=0.0,Z=0.2)
    ShakeOffsetRate=(X=500.0,Y=500.0,Z=500.0)
    ShakeOffsetTime=2.0

    // Reload
    ReloadStages(0)=(Sound=Sound'Inf_Weapons_Foley.mg34.mg34_reload01_000',Duration=1.24) // differs from defaults because uses ammo drums & not belts
    ReloadStages(1)=(Sound=Sound'Inf_Weapons_Foley.mg34.mg34_reload02_039',Duration=2.03)
    ReloadStages(2)=(Sound=Sound'Inf_Weapons_Foley.mg34.mg34_reload03_104',Duration=2.07)
    ReloadStages(3)=(Sound=Sound'Inf_Weapons_Foley.mg34.mg34_reload04_170',Duration=1.34)
}
