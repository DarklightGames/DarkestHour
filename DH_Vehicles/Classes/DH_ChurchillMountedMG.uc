//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ChurchillMountedMG extends DHVehicleMG;

defaultproperties
{
    // MG mesh
    Mesh=SkeletalMesh'DH_Churchill_anm.Churchill_MG'
    bMatchSkinToVehicle=true
    Skins(1)=Texture'DH_Churchill_tex.churchill.ChurchillMkVIIl_turret'
    Skins(2)=Texture'DH_VehiclesUK_tex.int_vehicles.Cromwell_body_int'
    bForceSkelUpdate=true // necessary for new player hit detection system, as makes server update the MG mesh skeleton, which it wouldn't otherwise as server doesn't draw mesh
    BeginningIdleAnim="MG_idle"
    GunnerAttachmentBone="gunner_attachment"
    FireAttachBone="MG_placement"
    FireEffectOffset=(X=-30.0,Y=0.0,Z=15.0) // positions fire on co-driver's hatch

    // Movement
    YawBone="MG_pivot"
    MaxPositiveYaw=6200 // yaw restricted due to protruding 'horns' at front of tank (gunner can't shoot own tank)
    MaxNegativeYaw=-2300
    PitchBone="MG_pivot"
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
    WeaponFireAttachmentBone="MG_pivot"
    WeaponFireOffset=17.0
    FireSoundClass=SoundGroup'DH_WeaponSounds.Besa.Besa_FireLoop'
    FireEndSound=SoundGroup'DH_WeaponSounds.Besa.Besa_FireEnd'
    ShakeRotMag=(X=10.0,Y=10.0,Z=10.0)
    ShakeOffsetMag=(X=0.01,Y=0.01,Z=0.01)
}
