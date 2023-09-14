//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanMountedMG extends DHVehicleMG;

defaultproperties
{
    // MG mesh
    Mesh=SkeletalMesh'DH_ShermanM4A1_anm.Sherman_MG'
    Skins(0)=Texture'DH_VehiclesUS_tex.ext_vehicles.Sherman_body_ext'
    FireAttachBone="mg_placement"
    FireEffectOffset=(X=-40.0,Y=0.0,Z=30.0) // positions fire on co-driver's hatch

    WeaponAttachOffset=(X=1.5,Y=1.0,Z=1.5) // this is for M4A1 (as the MG mesh is off-kilter when not adjusted

    // Movement
    MaxPositiveYaw=4000
    MaxNegativeYaw=-4500
    PitchBone="mg_yaw"
    CustomPitchUpLimit=3000
    CustomPitchDownLimit=63000

    // Ammo
    ProjectileClass=class'DH_Weapons.DH_30CalBullet'
    InitialPrimaryAmmo=250
    NumMGMags=9
    FireInterval=0.12
    TracerProjectileClass=class'DH_Weapons.DH_30CalTracerBullet'
    TracerFrequency=5

    // Weapon fire
    WeaponFireOffset=5.0
    FireSoundClass=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireLoop01'
    FireEndSound=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireEnd01'
    ShakeRotMag=(X=20.0,Y=20.0,Z=20.0)
    ShakeOffsetMag=(X=0.01,Y=0.01,Z=0.01)

    //HUDOverlayReloadAnim="Reloads"
}
