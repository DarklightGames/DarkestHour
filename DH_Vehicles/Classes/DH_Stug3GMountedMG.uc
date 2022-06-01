//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_Stug3GMountedMG extends DHVehicleMG;

defaultproperties
{
    // MG mesh
    Mesh=SkeletalMesh'DH_Stug3G_anm.Stug_mg34_ext'
    Skins(1)=Texture'DH_VehiclesGE_tex2.int_vehicles.Stug3g_body_int'
    Skins(2)=Texture'Weapons3rd_tex.German.mg34_world'
    bMatchSkinToVehicle=true
    bForceSkelUpdate=true // necessary for new player hit detection system, as makes server update the MG mesh skeleton, which it wouldn't otherwise as server doesn't draw mesh
    BeginningIdleAnim="loader_button_idle"
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
    RotationsPerSecond=0.5
    YawBone="mg_pitch"
    MaxPositiveYaw=5500
    MaxNegativeYaw=-5500
    CustomPitchUpLimit=2400 // reduced from 4500 to stop MG butt poking through hatch
    CustomPitchDownLimit=63500

    // Ammo
    ProjectileClass=class'DH_Weapons.DH_MG34Bullet'
    InitialPrimaryAmmo=50
    NumMGMags=12
    FireInterval=0.08
    TracerProjectileClass=class'DH_Weapons.DH_MG34TracerBullet'
    TracerFrequency=7

    // Weapon fire
    WeaponFireAttachmentBone="tip"
    AmbientEffectEmitterClass=class'ROVehicles.VehicleMGEmitter'
    FireSoundClass=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    ShakeRotMag=(X=25.0,Y=0.0,Z=10.0)
    ShakeRotRate=(X=5000.0,Y=5000.0,Z=5000.0)
    ShakeOffsetMag=(X=0.5,Y=0.0,Z=0.2)
    ShakeOffsetRate=(X=500.0,Y=500.0,Z=500.0)

    // Reload
    HUDOverlayReloadAnim="Bipod_Reload_s"
    ReloadStages(0)=(Sound=none,Duration=1.57) // no sounds because HUD overlay reload animation plays them
    ReloadStages(1)=(Sound=none,Duration=1.56)
    ReloadStages(2)=(Sound=none,Duration=1.92)
    ReloadStages(3)=(Sound=none,Duration=1.63)
}
