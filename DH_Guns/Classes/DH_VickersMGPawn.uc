//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_VickersMGPawn extends DHMountedMGPawn;

defaultproperties
{
    DrivePos=(X=-15.5622,Y=0,Z=29.7831)
    DriveRot=(Pitch=0,Yaw=0,Roll=0)
    DriveAnim="FIAT1435_GUNNER_IDLE"
    IronSightsPositionIndex=0

    Begin Object Class=DHVehicleWeaponPawnAnimationDriverParameters Name=AnimationDriverParameters0
        Sequences(0)="FIAT1435_GUNNER_YAW_POS_20"
        Sequences(1)="FIAT1435_GUNNER_YAW_POS_10"
        Sequences(2)="FIAT1435_GUNNER_YAW_0"
        Sequences(3)="FIAT1435_GUNNER_YAW_NEG_10"
        Sequences(4)="FIAT1435_GUNNER_YAW_NEG_20"
        SequenceInputType=DIT_Yaw
        DriverPositionIndexRange=(Min=0,Max=0)
        SequenceChannel=4
        BlendChannel=5
        FrameCount=5
    End Object
    AnimationDrivers(0)=(Parameters=AnimationDriverParameters0)

    GunClass=Class'DH_VickersMG'
    HandsReloadSequence="RELOAD_AC"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Fiat1435_anm.FIAT1435_GUN_AC_1ST',bExposed=true,ViewFOV=72.5)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Fiat1435_anm.FIAT1435_GUN_AC_1ST',bExposed=true,ViewFOV=72.5)
    DriverPositionsExtra(0)=(CameraBone="GUNSIGHT_CAMERA_AC")
    DriverPositionsExtra(1)=(CameraBone="GUNSIGHT_CAMERA_AC")
    GunsightCameraBone="GUNSIGHT_CAMERA_AC"
}
