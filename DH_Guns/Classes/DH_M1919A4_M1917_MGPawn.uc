//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M1919A4_M1917_MGPawn extends DHMountedMGPawn;

defaultproperties
{
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_M1919A4_anm.M1919A4_M1917_TURRET_INT',ViewFOV=72.5,bExposed=true)
    GunClass=Class'DH_M1919A4_M1917_MG'
    CameraBone="SIGHT_CAMERA"
    ReloadCameraBone="RELOAD_CAMERA"

    DriveAnim=M1919A4_M1917_GUNNER_YAW
    DrivePos=(Z=25.5)
    DriveRot=(Yaw=16384)

    // TODO: just for testing, reduce number of frames to 10 or 20 depending on how it looks.
    Begin Object Class=DHVehicleWeaponPawnAnimationDriverParameters Name=AnimationDriverParameters0
        // TODO: have exports at 3 different pitches for better blending
        Sequences(0)="M1919A4_M1917_GUNNER_YAW"
        // Sequences(1)="M1919A4_M1917_GUNNER_YAW_1"
        // Sequences(2)="M1919A4_M1917_GUNNER_YAW_0"
        SequenceChannel=4
        BlendChannel=5
        SequenceInputType=DIT_Yaw
        BlendInputType=DIT_Pitch
        DriverPositionIndexRange=(Min=0,Max=2)
        FrameCount=40
    End Object
    AnimationDrivers(0)=(Parameters=AnimationDriverParameters0)
}
