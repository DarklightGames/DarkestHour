//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_T34MountedMG extends DHVehicleMG;

defaultproperties
{
    // MG mesh
    Mesh=mesh'allies_t3485_anm.T3485_MG_ext'
    bMatchSkinToVehicle=true
    FireAttachBone="mg_yaw"

    // Movement
    MaxPositiveYaw=4500
    MaxNegativeYaw=-8000
    CustomPitchUpLimit=5000
    CustomPitchDownLimit=63500

    // Ammo
    ProjectileClass=class'DH_Weapons.DH_DP28Bullet'
    InitialPrimaryAmmo=60
    NumMGMags=15
    FireInterval=0.1
    TracerProjectileClass=class'DH_Weapons.DH_30CalTracerBullet'
    TracerFrequency=5

    // Weapon fire
    WeaponFireOffset=11.0
    FireSoundClass=sound'Inf_Weapons.dt_fire_loop'
    FireEndSound=sound'Inf_Weapons.dt.dt_fire_end'
    ShakeRotMag=(X=20.000000,Y=20.000000,Z=20.000000)
    ShakeOffsetMag=(X=0.010000,Y=0.010000,Z=0.010000)
}
