//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_CromwellMountedMG extends DHVehicleMG;

defaultproperties
{
    // MG mesh
    Mesh=SkeletalMesh'DH_Cromwell_anm.cromwell_MG'
    bMatchSkinToVehicle=true
    FireAttachBone="Mg_placement1"
    FireEffectOffset=(X=-30.0,Y=0.0,Z=15.0) // positions fire on co-driver's hatch

    // Movement
    MaxPositiveYaw=7000
    MaxNegativeYaw=-6000
    PitchBone="mg_yaw"
    CustomPitchUpLimit=4500
    CustomPitchDownLimit=64000

    // Ammo
    ProjectileClass=class'DH_Vehicles.DH_BesaVehicleBullet'
    InitialPrimaryAmmo=225
    NumMGMags=6
    FireInterval=0.092
    TracerProjectileClass=class'DH_BesaVehicleTracerBullet'
    TracerFrequency=5

    // Weapon fire
    WeaponFireOffset=25.0
    FireSoundClass=SoundGroup'Inf_Weapons.dt.dt_fire_loop'
    FireEndSound=SoundGroup'Inf_Weapons.dt.dt_fire_end'
    ShakeRotMag=(X=10.0,Y=10.0,Z=10.0)
    ShakeOffsetMag=(X=0.01,Y=0.01,Z=0.01)
}
