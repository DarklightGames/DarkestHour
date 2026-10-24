//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_GapCannon extends DHVehicleAutoCannon;


defaultproperties
{
     AmbientGlow=224
     bUseDynamicLights=true
     bUseLightingFromBase=true
     //LightType=LT_SubtlePulse
    // LightEffect=LE_TorchWaver
     LightRadius=555
     LightBrightness=200
     LightPeriod=2
     bLightingVisibility=True
    // mesh
    Mesh=SkeletalMesh'DH_UFO_anm.GapTurret'
    bForceSkelUpdate=true // necessary for new player hit detection system, as makes server update the MG mesh skeleton, which it wouldn't otherwise as server doesn't draw mesh

    // Movement
    YawBone="Turret"
    YawStartConstraint=-8000.000000
    YawEndConstraint=8000.000000
    PitchBone="Turret_placement1"
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
    PrimaryProjectileClass=Class'DH_GapTrainBullet'

    InitialPrimaryAmmo=5000
    NumPrimaryMags=20000

    Spread=0.01
    AltFireSpread=0.01
    FireInterval=5
    AltFireInterval=1

    // Weapon fire
    WeaponFireAttachmentBone="tip2"
    AltFireAttachmentBone="tip2"
    AmbientEffectEmitterClass=Class'DH_GapAltEmitter'
    CannonFireSound(0)=Sound'DH_UFO_snd.UFO.PortalBig'
    CannonFireSound(1)=Sound'DH_UFO_snd.UFO.PortalA'
    CannonFireSound(2)=Sound'DH_UFO_snd.UFO.PortalB'

    ShakeOffsetMag=(X=0.5,Y=0.0,Z=0.2)
    ShakeOffsetRate=(X=500.0,Y=500.0,Z=500.0)
    ShakeRotMag=(X=25.0,Y=0.0,Z=10.0)
    ShakeRotRate=(X=5000.0,Y=5000.0,Z=5000.0)

    AltFireSoundClass=Sound'DH_UFO_snd.UFO.portalloop'
    AltFireEndSound=Sound'DH_UFO_snd.UFO.UfoBigShot'

    ShootLoweredAnim="fire"
    ShootRaisedAnim="fire"

    // Coaxial MG ammo
    AltFireProjectileClass=Class'DH_GapStopSignBullet'
    InitialAltAmmo=43000
    NumMGMags=150

    TracerProjectileClass=Class'DH_GapTrainSignBullet'
    TracerFrequency=1

    AltFireSoundScaling=1

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
