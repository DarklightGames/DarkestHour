//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ML3InchCannonPawn extends DHMortarCannonPawn;

defaultproperties
{
    GunClass=class'DH_Guns.DH_ML3InchCannon'

    // Spotting Scope
    DriverPositions(0)=(TransitionUpAnim="overlay_out",ViewFOV=40.0,ViewPitchUpLimit=2731,ViewPitchDownLimit=64626,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,bDrawOverlays=true,bExposed=true)
    // Kneeling
    DriverPositions(1)=(DriverTransitionAnim="model35mortar_sit",TransitionUpAnim="raise",TransitionDownAnim="overlay_in",ViewPitchUpLimit=8192,ViewPitchDownLimit=55000,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    // Standing
    DriverPositions(2)=(DriverTransitionAnim="model35mortar_stand",TransitionDownAnim="lower",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    // Binoculars
    DriverPositions(3)=(DriverTransitionAnim="model35mortar_binocs",ViewFOV=12.0,ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)

    PlayerCameraBone="CAMERA_COM"
    CameraBone="GUNSIGHT_CAMERA"

    GunsightPositions=0
    UnbuttonedPositionIndex=0
    SpottingScopePositionIndex=0
    IntermediatePositionIndex=1 // the open sights position (used to play a special 'intermediate' firing anim in that position)
    RaisedPositionIndex=2
    BinocPositionIndex=3

    bLockCameraDuringTransition=false

    DrivePos=(X=28.60893,Y=0.68,Z=53.0)
    DriveRot=(Yaw=16384)
    DriveAnim="model35mortar_idle"

    OverlayCorrectionX=0
    OverlayCorrectionY=0

    AmmoShellTextures(0)=Texture'DH_ML3InchMortar_tex.interface.ML3INCH_HE_ICON'
    AmmoShellTextures(1)=Texture'DH_ML3InchMortar_tex.interface.ML3INCH_SMOKE_ICON'

    AmmoShellReloadTextures(0)=Texture'DH_ML3InchMortar_tex.interface.ML3INCH_HE_ICON_RELOAD'
    AmmoShellReloadTextures(1)=Texture'DH_ML3InchMortar_tex.interface.ML3INCH_SMOKE_ICON_RELOAD'

    ArtillerySpottingScopeClass=class'DH_Guns.DH_Model35MortarArtillerySpottingScope'

    GunPitchOffset=8192 // +45 degrees  // TODO: this should be on the cannon class

    FiringCameraInTime=0.65
    FiringCameraOutTime=1.0

    HandsMesh=SkeletalMesh'DH_Model35Mortar_anm.MORTAR_FIRST_PERSON_HANDS'
    HandsAttachBone="MUZZLE"
    HandsProjectileBone="PROJECTILE"
    HandsFiringCameraBone="CAMERA"
    HandsFiringAnimName="FIRE_HANDS"
    HandsRelativeLocation=(X=5) // The fins on the projectiles are a bit longer than the others.

    FireDelaySeconds=2.35

    // Player firing animations.
    PlayerFireAnims(0)=(Angle=45,AnimName="model35mortar_fire_45")
    PlayerFireAnims(1)=(Angle=50,AnimName="model35mortar_fire_50")
    PlayerFireAnims(2)=(Angle=55,AnimName="model35mortar_fire_55")
    PlayerFireAnims(3)=(Angle=60,AnimName="model35mortar_fire_60")
    PlayerFireAnims(4)=(Angle=65,AnimName="model35mortar_fire_65")
    PlayerFireAnims(5)=(Angle=70,AnimName="model35mortar_fire_70")
    PlayerFireAnims(6)=(Angle=75,AnimName="model35mortar_fire_75")
    PlayerFireAnims(7)=(Angle=80,AnimName="model35mortar_fire_80")

    // Timed to coincide with the round disappearing into the tube.
    // Because of the wonky fake IK setup we have, the round can sometimes not align perfectly with the tube
    // so it's best to just hide it once it enters the tube.
    ProjectileLifeSpan=2.05

    bNetNotify=true

    TPCamLookat=(X=0,Y=0,Z=-70)
    FiringDriverPositionIndex=1
}
