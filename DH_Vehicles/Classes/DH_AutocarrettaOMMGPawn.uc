//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_AutocarrettaOMMGPawn extends DHVehicleMGPawn;

defaultproperties
{
    GunClass=Class'DH_AutocarrettaOMMG'
    PositionInArray=0
    bMustBeTankCrew=false
    bKeepDriverAuxCollision=true
    bMultiPosition=true
    // Because of the way that explosives work, we must say that the driver is not exposed so that
    // he is not killed by explosives while buttoned up.
    DriverPositions(0)=(/*PositionMesh=SkeletalMesh'DH_CV33_anm.cv33_turret_int',*/bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(/*PositionMesh=SkeletalMesh'DH_CV33_anm.cv33_turret_int',*/TransitionUpAnim="cv33_turret_open",DriverTransitionAnim="cv33_gunner_close",ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=16384,ViewNegativeYawLimit=-16384,bExposed=true)
    UnbuttonedPositionIndex=0
    BinocPositionIndex=1
    bDrawDriverInTP=true
    DrivePos=(X=0,Y=0,Z=58)
    DriveRot=(Pitch=0,Yaw=16384,Roll=0)
    BinocsDriveRot=(Pitch=0,Yaw=16384,Roll=0)
    DriveAnim="cv33_gunner_closed"
    
    // TODO: figure out what this is
    FirstPersonGunRefBone="1stperson_wep"
    FirstPersonGunShakeScale=2.5
    FirstPersonOffsetZScale=3.0
    bHideMuzzleFlashAboveSights=true

    GunsightCameraBone="GUNNER_CAMERA"
    CameraBone="GUNNER_CAMERA"

    AnimationDrivers(0)=(Sequence="fiat1435_gunner_yaw_driver",Type=ADT_Yaw,DriverPositionIndexRange=(Min=0,Max=1),FrameCount=32)   // todo: fill in
}
