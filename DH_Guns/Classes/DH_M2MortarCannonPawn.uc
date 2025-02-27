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

    DrivePos=(X=28.60893,Y=0.68,Z=53.0)   // setdrivepos 28.60893 0.68 53.0
    DriveRot=(Yaw=16384)
    DriveAnim="M2mortar_idle"

    OverlayCorrectionX=0
    OverlayCorrectionY=0

    // AmmoShellTextures(0)=Texture'DH_M2Mortar_tex.interface.IT_HE_M110_3360_ICON'
    // AmmoShellTextures(1)=Texture'DH_M2Mortar_tex.interface.IT_SMOKE_M110_3360_ICON'
    // AmmoShellTextures(2)=Texture'DH_M2Mortar_tex.interface.IT_SMOKE_M110_B_ICON'

    // AmmoShellReloadTextures(0)=Texture'DH_M2Mortar_tex.interface.IT_HE_M110_3360_ICON_RELOAD'
    // AmmoShellReloadTextures(1)=Texture'DH_M2Mortar_tex.interface.IT_SMOKE_M110_3360_ICON_RELOAD'
    // AmmoShellReloadTextures(2)=Texture'DH_M2Mortar_tex.interface.IT_SMOKE_M110_B_ICON'

    ArtillerySpottingScopeClass=class'DH_Weapons.DHArtillerySpottingScope_AlliedMortar'   // TODO: rename class

    GunPitchOffset=7280 // +40 degrees

    FiringCameraInTime=0.65
    FiringCameraOutTime=1.0
    HandsFiringCameraBone="CAMERA"
    HandsFiringAnimName="FIRE_HANDS"

    HandsMesh=SkeletalMesh'DH_Model35Mortar_anm.MORTAR_FIRST_PERSON_HANDS'  // TODO; swap out
    HandsAttachBone="MUZZLE"
    HandsProjectileBone="PROJECTILE"

    FireDelaySeconds=2.35

    // Player firing animations.
    PlayerFireAnims(0)=(Angle=40,AnimName="M2mortar_fire_40")
    PlayerFireAnims(1)=(Angle=45,AnimName="M2mortar_fire_45")
    PlayerFireAnims(2)=(Angle=50,AnimName="M2mortar_fire_50")
    PlayerFireAnims(3)=(Angle=55,AnimName="M2mortar_fire_55")
    PlayerFireAnims(4)=(Angle=60,AnimName="M2mortar_fire_60")
    PlayerFireAnims(5)=(Angle=65,AnimName="M2mortar_fire_65")
    PlayerFireAnims(6)=(Angle=70,AnimName="M2mortar_fire_70")
    PlayerFireAnims(7)=(Angle=75,AnimName="M2mortar_fire_75")
    PlayerFireAnims(8)=(Angle=80,AnimName="M2mortar_fire_80")
    PlayerFireAnims(9)=(Angle=85,AnimName="M2mortar_fire_85")
    PlayerFireAnims(10)=(Angle=90,AnimName="M2mortar_fire_90")

    // Timed to coincide with the round disappearing into the tube.
    // Because of the wonky fake IK setup we have, the round can sometimes not align perfectly with the tube
    // so it's best to just hide it once it enters the tube.
    ProjectileLifeSpan=2.05

    bNetNotify=true

    TPCamLookat=(X=0,Y=0,Z=-70)
    FiringDriverPositionIndex=1
}
