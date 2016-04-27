//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ShermanMountedMG extends DHVehicleMG;

defaultproperties
{
    // MG mesh
    Mesh=SkeletalMesh'DH_ShermanM4A1_anm.Sherman_MG'
    Skins(0)=texture'DH_VehiclesUS_tex.ext_vehicles.Sherman_body_ext'
    FireAttachBone="mg_placement"
    FireEffectOffset=(X=-40.0,Y=0.0,Z=30.0) // positions fire on co-driver's hatch

    // Movement
    MaxPositiveYaw=4000
    MaxNegativeYaw=-8000
    PitchBone="mg_yaw"
    CustomPitchUpLimit=3000
    CustomPitchDownLimit=63000

    // Ammo
    ProjectileClass=class'DH_Weapons.DH_30CalBullet'
    InitialPrimaryAmmo=200
    NumMGMags=6
    FireInterval=0.12
    TracerProjectileClass=class'DH_Weapons.DH_30CalTracerBullet'
    TracerFrequency=5

    // Weapon fire
    WeaponFireOffset=5.0
    FireSoundClass=SoundGroup'DH_AlliedVehicleSounds2.3Cal.V30cal_loop01'
    FireEndSound=SoundGroup'DH_AlliedVehicleSounds2.3Cal.V30cal_end01'
    ShakeRotMag=(X=20.0,Y=20.0,Z=20.0)
    ShakeOffsetMag=(X=0.01,Y=0.01,Z=0.01)
}
