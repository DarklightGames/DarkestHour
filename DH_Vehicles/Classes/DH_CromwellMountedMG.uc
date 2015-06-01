//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_CromwellMountedMG extends DHMountedTankMG;

defaultproperties
{
    ReloadSound=sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
    NumMags=6
    TracerProjectileClass=class'DH_BesaVehicleTracerBullet'
    TracerFrequency=5
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="mg_yaw"
    PitchBone="mg_yaw"
    PitchUpLimit=15000
    PitchDownLimit=45000
    CustomPitchUpLimit=4500
    CustomPitchDownLimit=64000
    WeaponFireAttachmentBone="mg_yaw"
    WeaponFireOffset=24.0
    bInstantFire=false
    Spread=0.002
    FireInterval=0.092
    FireSoundClass=SoundGroup'Inf_Weapons.dt.dt_fire_loop'
    FireEndSound=SoundGroup'Inf_Weapons.dt.dt_fire_end'
    ProjectileClass=class'DH_Vehicles.DH_BesaVehicleBullet'
    ShakeRotMag=(X=10.0,Y=10.0,Z=10.0)
    ShakeOffsetMag=(X=0.01,Y=0.01,Z=0.01)
    MaxPositiveYaw=7000
    MaxNegativeYaw=-6000
    bLimitYaw=true
    InitialPrimaryAmmo=225
    Mesh=SkeletalMesh'DH_Cromwell_anm.cromwell_MG'
}
