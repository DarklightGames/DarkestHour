//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_UFOLaserGun extends DHVehicleMG;

defaultproperties
{
    // MG mesh
    Mesh=SkeletalMesh'DH_UFO_anm.UFO_turret_ext'
    bForceSkelUpdate=true // necessary for new player hit detection system, as makes server update the MG mesh skeleton, which it wouldn't otherwise as server doesn't draw mesh

    // Movement
    YawBone="Turret"
    YawStartConstraint=-8000.000000
    YawEndConstraint=8000.000000
    PitchBone="Turret_placement2"
    PitchUpLimit=10000
    PitchDownLimit=35000
    GunnerAttachmentBone="com_attachment"
    bLimitYaw = true
    RotationsPerSecond=1
    MaxPositiveYaw=8500
    MaxNegativeYaw=-8500
    CustomPitchUpLimit=10000
    CustomPitchDownLimit=35000

    // Ammo
    ProjectileClass=Class'DH_UFOLaserBulletYellow'
    InitialPrimaryAmmo=5000
    NumMGMags=15
    FireInterval=0.05
    TracerProjectileClass=Class'DH_UFOLaserBulletRed' //this one is anti-armor
    TracerFrequency=3

    // Weapon fire
    WeaponFireAttachmentBone="Barrel"
    AmbientEffectEmitterClass=Class'VehicleMGEmitter'
    FireSoundClass=Sound'DH_UFO_snd.UFO.UfoLaser'
    FireEndSound=none
    ShakeOffsetMag=(X=0.5,Y=0.0,Z=0.2)
    ShakeOffsetRate=(X=500.0,Y=500.0,Z=500.0)
    ShakeRotMag=(X=25.0,Y=0.0,Z=10.0)
    ShakeRotRate=(X=5000.0,Y=5000.0,Z=5000.0)


    // Reload
    HUDOverlayReloadAnim="Bipod_Reload_s"
    ReloadStages(0)=(Sound=none,Duration=1.57) // no sounds because HUD overlay reload animation plays them
    ReloadStages(1)=(Sound=none,Duration=1.56)
    ReloadStages(2)=(Sound=none,Duration=1.92)
    ReloadStages(3)=(Sound=none,Duration=1.63)
}
