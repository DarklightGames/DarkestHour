//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_UFOLaserGunBlue extends DHVehicleAutoCannon; 

defaultproperties
{
    // mesh
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
    bMultipleRoundTypes=False
    PrimaryProjectileClass=Class'DH_UFOBubbleBlue'

    InitialPrimaryAmmo=5000
    NumPrimaryMags=200

    Spread=0.01
    AltFireSpread=0.002
    FireInterval=1

    // Weapon fire
    WeaponFireAttachmentBone="tip"
    AltFireAttachmentBone="tip"
    AmbientEffectEmitterClass=none
    CannonFireSound(0)=Sound'DH_UFO_snd.UFO.UfoBigShot'
    CannonFireSound(1)=Sound'DH_UFO_snd.UFO.UfoBigShotD'
    CannonFireSound(2)=Sound'DH_UFO_snd.UFO.UfoBigShotE'

    ShakeOffsetMag=(X=0.5,Y=0.0,Z=0.2)
    ShakeOffsetRate=(X=500.0,Y=500.0,Z=500.0)
    ShakeRotMag=(X=25.0,Y=0.0,Z=10.0)
    ShakeRotRate=(X=5000.0,Y=5000.0,Z=5000.0)

    AltFireSoundClass=Sound'DH_UFO_snd.UFO.UfoFireAlt'
    AltFireEndSound=Sound'DH_UFO_snd.UFO.UfoFireAlt_End'

    // Coaxial MG ammo
    AltFireProjectileClass=Class'DH_UFOLightning'
    InitialAltAmmo=43000
    NumMGMags=150
    AltFireInterval=0.1
    TracerProjectileClass=Class'DH_UFOLaserBulletBlue'
    TracerFrequency=11

    AltFireSoundScaling=0.7

    // Reload (i cant get it to work)
    //HUDOverlayReloadAnim="Bipod_Reload_s"
    ReloadStages(0)=(Sound=Sound'DH_UFO_snd.UFO.UfoCharge',Duration=1.97) // 
    ReloadStages(1)=(Sound=none,Duration=0.06)
    ReloadStages(2)=(Sound=none,Duration=0.02)
    ReloadStages(3)=(Sound=none,Duration=0.03)

    AltReloadStages(0)=(Sound=Sound'DH_UFO_snd.UFO.UfoChargeTwo',Duration=1.97) // 
    AltReloadStages(1)=(Sound=none,Duration=0.06)
    AltReloadStages(2)=(Sound=none,Duration=0.02)
    AltReloadStages(3)=(Sound=none,Duration=0.03)
}
