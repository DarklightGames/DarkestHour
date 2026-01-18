//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MG34LafetteMGPawn extends DHMountedMGPawn;

defaultproperties
{
    //HandsMesh=SkeletalMesh'DH_Fiat1435_anm.FIAT1435_HANDS'
    GunClass=Class'DH_MG34LafetteMG'
    DrivePos=(X=0,Y=0,Z=58)
    DriveRot=(Pitch=0,Yaw=0,Roll=0)
    DriveAnim="cv33_gunner_closed"   // TODO: replace with the idle animation.
    InitialPositionIndex=1
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_MG34_anm.MG34_TURRET_INT',bExposed=true,ViewFOV=30.0,bDrawOverlays=true,TransitionUpAnim="OVERLAY_OUT")
    // NOTE: 72.5 FOV is calibrated to not clip into the gun in 4:3 aspect ratio.
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_MG34_anm.MG34_TURRET_INT',bExposed=true,ViewFOV=72.5,TransitionDownAnim="OVERLAY_IN",TransitionUpAnim="RAISE")
    // TODO: let the player move the camera around??
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_MG34_anm.MG34_TURRET_INT',bExposed=true,TransitionDownAnim="LOWER")
    
    //DriverPositionMeshSkins(0)=Texture'DH_Maxim_tex.MAXIM_TURRET_INT'

    IronSightsPositionIndex=1
    IronSightsCameraBone="IRONSIGHT_CAMERA"

    // The reticle is the same as the MGZ sight.
    // View width is 250 meters at 1000 meters.
    GunsightOverlay=Texture'DH_VehicleOptics_tex.RblF16_artillery_sight'
    GunsightSize=0.471

    GunsightCameraBone="GUNSIGHT_CAMERA"
    GunsightPositionIndex=0

    Begin Object Class=DHVehicleWeaponPawnAnimationDriverParameters Name=AnimationDriverParameters0
        // TODO: have exports at 3 different pitches for better blending
        Sequences(0)="MG34_GUNNER_YAW"
        Sequences(1)="MG34_GUNNER_YAW"
        Sequences(2)="MG34_GUNNER_YAW"
        SequenceChannel=4
        BlendChannel=5
        SequenceInputType=DIT_Yaw
        BlendInputType=DIT_Pitch
        DriverPositionIndexRange=(Min=0,Max=2)
        FrameCount=6
    End Object
    AnimationDrivers(0)=(Parameters=AnimationDriverParameters0)
}
