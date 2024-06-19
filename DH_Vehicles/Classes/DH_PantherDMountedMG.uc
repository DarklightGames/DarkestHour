//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PantherDMountedMG extends DHVehicleMG;

defaultproperties
{
    // MG mesh
    Mesh=SkeletalMesh'DH_Panther_anm.panther_d_mg_ext'
    //Skins(0)=Texture'axis_vehicles_tex.ext_vehicles.Panzer4F1_ext'
    FireAttachBone="Mg_placement1"  // TODO: figure this out
    FireEffectOffset=(X=-30.0,Y=10.0,Z=25.0) // positions fire on co-driver's hatch

    // Movement
    MaxPositiveYaw=4500
    MaxNegativeYaw=-4500
    CustomPitchUpLimit=2730
    CustomPitchDownLimit=64000

    // Ammo
    ProjectileClass=class'DH_Weapons.DH_MG34Bullet'
    InitialPrimaryAmmo=150
    NumMGMags=9
    FireInterval=0.08
    TracerProjectileClass=class'DH_Weapons.DH_MG34TracerBullet'
    TracerFrequency=7

    // Weapon fire
    WeaponFireOffset=27.0
    FireSoundClass=sound'Inf_Weapons.mg34_p_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    ShakeRotMag=(X=10.0,Y=10.0,Z=10.0)
    ShakeOffsetMag=(X=0.01,Y=0.01,Z=0.01)
}
