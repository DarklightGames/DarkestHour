//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M2MortarCannonPawn extends DHMortarCannonPawn;

defaultproperties
{
    PitchAnimationDriver=(Channel=1,BoneName="PITCH_ROOT",SequenceName="PITCH_DRIVER",SequenceFrameCount=45)

    GunClass=class'DH_Guns.DH_M2MortarCannon'

    // Spotting Scope
    DriverPositions(0)=(TransitionUpAnim="overlay_out",ViewFOV=40.0,ViewPitchUpLimit=2731,ViewPitchDownLimit=64626,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,bDrawOverlays=true,bExposed=true)
    // Kneeling
    DriverPositions(1)=(DriverTransitionAnim="M2mortar_sit",TransitionUpAnim="raise",TransitionDownAnim="overlay_in",ViewPitchUpLimit=8192,ViewPitchDownLimit=55000,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    // Standing
    DriverPositions(2)=(DriverTransitionAnim="M2mortar_stand",TransitionDownAnim="lower",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    // Binoculars
    DriverPositions(3)=(DriverTransitionAnim="M2mortar_binocs",ViewFOV=12.0,ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)

    PlayerCameraBone="CAMERA_COM"
    CameraBone="GUNSIGHT_CAMERA"

    GunsightPositions=0
    UnbuttonedPositionIndex=0
    SpottingScopePositionIndex=0
    IntermediatePositionIndex=1 // the open sights position (used to play a special 'intermediate' firing anim in that position)
    RaisedPositionIndex=2
    BinocPositionIndex=3

    bLockCameraDuringTransition=false

    DrivePos=(X=0.7,Y=0,Z=57.5)
    DriveRot=(Yaw=0)
    DriveAnim="m2mortar_gunner_idle"

    OverlayCorrectionX=0
    OverlayCorrectionY=0

    AmmoShellTextures(0)=Texture'DH_M2Mortar_tex.M2MORTAR_AMMO_HE_ICON'
    AmmoShellTextures(1)=Texture'DH_M2Mortar_tex.M2MORTAR_AMMO_WP_ICON'

    AmmoShellReloadTextures(0)=Texture'DH_M2Mortar_tex.M2MORTAR_AMMO_HE_ICON_RELOAD'
    AmmoShellReloadTextures(1)=Texture'DH_M2Mortar_tex.M2MORTAR_AMMO_WP_ICON_RELOAD'

    ArtillerySpottingScopeClass=class'DH_M2MortarArtillerySpottingScope'

    GunPitchOffset=7280 // +40 degrees

    FiringCameraInTime=0.65
    FiringCameraOutTime=1.0
    HandsFiringCameraBone="CAMERA"
    HandsFiringAnimName="FIRE_HANDS_60MM"

    HandsMesh=SkeletalMesh'DH_Model35Mortar_anm.MORTAR_FIRST_PERSON_HANDS'
    HandsAttachBone="MUZZLE"
    HandsProjectileBone="PROJECTILE"

    FireDelaySeconds=1.75

    // Player firing animations.
    PlayerFireAnims(0)=(Angle=40,AnimName="m2mortar_gunner_fire_40")
    PlayerFireAnims(1)=(Angle=45,AnimName="m2mortar_gunner_fire_45")
    PlayerFireAnims(2)=(Angle=50,AnimName="m2mortar_gunner_fire_50")
    PlayerFireAnims(3)=(Angle=55,AnimName="m2mortar_gunner_fire_55")
    PlayerFireAnims(4)=(Angle=60,AnimName="m2mortar_gunner_fire_60")
    PlayerFireAnims(5)=(Angle=65,AnimName="m2mortar_gunner_fire_65")
    PlayerFireAnims(6)=(Angle=70,AnimName="m2mortar_gunner_fire_70")
    PlayerFireAnims(7)=(Angle=75,AnimName="m2mortar_gunner_fire_75")
    PlayerFireAnims(8)=(Angle=80,AnimName="m2mortar_gunner_fire_80")
    PlayerFireAnims(9)=(Angle=85,AnimName="m2mortar_gunner_fire_85")

    // Timed to coincide with the round disappearing into the tube.
    // Because of the wonky fake IK setup we have, the round can sometimes not align perfectly with the tube
    // so it's best to just hide it once it enters the tube.
    ProjectileLifeSpan=1.525

    bNetNotify=true

    TPCamLookat=(X=0,Y=0,Z=-70)
    FiringDriverPositionIndex=1
}
