//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_StuH42MountedMG extends DHMountedTankMG;

defaultproperties
{
    ReloadSound=sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
    NumMags=8
    FireAttachBone="gunner_int"
    FireEffectOffset=(X=0.0,Y=0.0,Z=5.0)
    TracerProjectileClass=class'DH_MG34VehicleTracerBullet'
    TracerFrequency=7
    bHasGunShield=true
    MaxPlayerHitX=-20.5
    VehHitpoints(0)=(PointRadius=15.0,PointScale=1.0,PointBone="loader_player",PointOffset=(Z=-16.0))
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
    ProjectileClass=class'DH_Vehicles.DH_MG34VehicleBullet'
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
    InitialPrimaryAmmo=75
    Mesh=SkeletalMesh'DH_Stug3G_anm.StuH_mg_remote'
    Skins(0)=texture'DH_VehiclesGE_tex2.ext_vehicles.Stug3g_body_ext'
    Skins(2)=texture'Weapons3rd_tex.German.mg34_world'
    bCollideActors=true
    bBlockActors=true
    bProjTarget=true
    bBlockZeroExtentTraces=true
    bBlockNonZeroExtentTraces=true
}
