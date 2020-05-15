//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_BA64MG extends DHVehicleMG;

defaultproperties
{
    // MG mesh
    Mesh=SkeletalMesh'DH_BA64_anm.BA64_turret_ext'
    bForceSkelUpdate=true // necessary for new player hit detection system, as makes server update the MG mesh skeleton, which it wouldn't otherwise as server doesn't draw mesh
    GunnerAttachmentBone=com_attachment
    BeginningIdleAnim=com_idle_close

    // Movement
    bLimitYaw=false
    YawBone=turret
    YawStartConstraint=0
    YawEndConstraint=65535
    PitchUpLimit=10000
    PitchDownLimit=50000
    PitchBone=mg_base

    RotationsPerSecond=0.25
    CustomPitchUpLimit=3500
    CustomPitchDownLimit=63500

    // Ammo
    ProjectileClass=class'DH_Weapons.DH_DP28Bullet'
    InitialPrimaryAmmo=63
    NumMGMags=15
    FireInterval=0.1
    TracerProjectileClass=class'DH_Weapons.DH_DP28TracerBullet'
    TracerFrequency=5
    HudAltAmmoIcon=Texture'InterfaceArt_tex.HUD.dp27_ammo'

    // Weapon fire
    WeaponFireAttachmentBone="Tip"
    WeaponFireOffset=-8.0 // originally zero but flash was too far out in front of the muzzle
    AmbientEffectEmitterClass=class'VehicleMGEmitterBA'
    FireSoundClass=Sound'DH_WeaponSounds.dt_fire_loop'
    FireEndSound=Sound'DH_WeaponSounds.dt.dt_fire_end'
    ShakeRotMag=(X=25.0,Y=0.0,Z=10.0)
    ShakeRotRate=(X=5000.0,Y=5000.0,Z=5000.0)
    ShakeOffsetMag=(X=0.5,Y=0.0,Z=0.2)
    ShakeOffsetRate=(X=500.0,Y=500.0,Z=500.0)

    // Reload
    HUDOverlayReloadAnim="Reload"
    ReloadStages(0)=(Duration=1.73) // no sounds because HUD overlay reload animation plays them
    ReloadStages(1)=(Duration=2.23,HUDProportion=0.65)
    ReloadStages(2)=(Duration=2.37)
    ReloadStages(3)=(Duration=2.27,HUDProportion=0.35)
}
