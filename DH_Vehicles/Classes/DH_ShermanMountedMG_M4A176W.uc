//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ShermanMountedMG_M4A176W extends DH_ROMountedTankMG;

defaultproperties
{
    ReloadSound=sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
    NumMags=6
    FireAttachBone="mg_yaw"
    TracerProjectileClass=class'DH_30CalVehicleTracerBullet'
    TracerFrequency=5
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="mg_yaw"
    PitchBone="mg_yaw"
    PitchUpLimit=15000
    PitchDownLimit=45000
    WeaponFireAttachmentBone="mg_yaw"
    WeaponFireOffset=8.0
    bInstantFire=false
    Spread=0.002
    FireInterval=0.12
    FireSoundClass=SoundGroup'DH_WeaponSounds.30Cal.30Cal_FireLoop01'
    FireEndSound=SoundGroup'DH_WeaponSounds.30Cal.30Cal_FireEnd01'
    ProjectileClass=class'DH_Vehicles.DH_30CalVehicleBullet'
    ShakeRotMag=(X=20.0,Y=20.0,Z=20.0)
    ShakeOffsetMag=(X=0.01,Y=0.01,Z=0.01)
    MaxPositiveYaw=4000
    MaxNegativeYaw=-7000
    bLimitYaw=true
    InitialPrimaryAmmo=200
    Mesh=SkeletalMesh'DH_Sherman_anm.ShermanM4A1_MG_ext'
}
