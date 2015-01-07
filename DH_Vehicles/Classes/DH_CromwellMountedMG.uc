//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_CromwellMountedMG extends DH_ROMountedTankMG;

defaultproperties
{
    ReloadSound=sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
    NumMags=6
    TracerProjectileClass=class'DH_BesaVehicleTracerBullet'
    TracerFrequency=5
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="mg_yaw"
    YawStartConstraint=0.000000
    YawEndConstraint=65535.000000
    PitchBone="mg_yaw"
    PitchUpLimit=15000
    PitchDownLimit=45000
    WeaponFireAttachmentBone="mg_yaw"
    WeaponFireOffset=24.000000
    bInstantFire=false
    Spread=0.002000
    FireInterval=0.092000
    FireSoundClass=SoundGroup'Inf_Weapons.dt.dt_fire_loop'
    FireEndSound=SoundGroup'Inf_Weapons.dt.dt_fire_end'
    ProjectileClass=class'DH_Vehicles.DH_BesaVehicleBullet'
    ShakeRotMag=(X=10.000000,Y=10.000000,Z=10.000000)
    ShakeOffsetMag=(X=0.010000,Y=0.010000,Z=0.010000)
    MaxPositiveYaw=7000
    MaxNegativeYaw=-6000
    bLimitYaw=true
    InitialPrimaryAmmo=225
    Mesh=SkeletalMesh'DH_Cromwell_anm.cromwell_MG'
}
