//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Fiat1435MGPawn extends DHMountedMGPawn
    abstract;

defaultproperties
{
    HandsMesh=SkeletalMesh'DH_Fiat1435_anm.FIAT1435_HANDS'
    DrivePos=(X=-15.5622,Y=0,Z=29.7831)
    DriveRot=(Pitch=0,Yaw=0,Roll=0)
    DriveAnim="cv33_gunner_closed"  // TODO: replace

    IronSightsPositionIndex=0

    // DriverPositionsExtra(0)=(CameraBone="GUNSIGHT_CAMERA")
    // DriverPositionsExtra(1)=(CameraBone="IRONSIGHT_CAMERA")
    // DriverPositionsExtra(2)=(CameraBone="")

    Begin Object Class=DHVehicleWeaponPawnAnimationDriverParameters Name=AnimationDriverParameters0
        Sequences(0)="fiat1435_gunner_yaw_driver"
        SequenceInputType=DIT_Yaw
        DriverPositionIndexRange=(Min=0,Max=0)
    End Object
    AnimationDrivers(0)=(Parameters=AnimationDriverParameters0)
}
