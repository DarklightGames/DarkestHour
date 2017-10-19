//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_ChurchillMountedMG extends DHVehicleMG;

defaultproperties
{
    // MG mesh
    Mesh=SkeletalMesh'DH_Churchill_anm.Churchill_MG'
    bMatchSkinToVehicle=true
    FireAttachBone="mg_placement"
    FireEffectOffset=(X=-30.0,Y=0.0,Z=15.0) // positions fire on co-driver's hatch

    // Movement
    MaxPositiveYaw=6200 // yaw restricted due to protruding 'horns' at front of tank (gunner can't shoot own tank)
    MaxNegativeYaw=-2300
    CustomPitchUpLimit=4500
    CustomPitchDownLimit=64000

    // Ammo
    ProjectileClass=class'DH_Vehicles.DH_BesaVehicleBullet'
    InitialPrimaryAmmo=225
    NumMGMags=11
    FireInterval=0.092
    TracerProjectileClass=class'DH_BesaVehicleTracerBullet'
    TracerFrequency=5

    // Weapon fire
    bDoOffsetTrace=false // otherwise it adjusts the bullet spawn location to outside the vehicle's collision box, which in this tank is quite a way forward
    WeaponFireOffset=17.0
    FireSoundClass=SoundGroup'DH_WeaponSounds.Besa.Besa_FireLoop'
    FireEndSound=SoundGroup'DH_WeaponSounds.Besa.Besa_FireEnd'
    ShakeRotMag=(X=10.0,Y=10.0,Z=10.0)
    ShakeOffsetMag=(X=0.01,Y=0.01,Z=0.01)
}
