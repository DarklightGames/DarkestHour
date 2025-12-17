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
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_MG34_anm.MG34_TURRET_INT',bExposed=true)
    //DriverPositionMeshSkins(0)=Texture'DH_Maxim_tex.MAXIM_TURRET_INT'

    Begin Object Class=DHVehicleWeaponPawnAnimationDriverParameters Name=AnimationDriverParameters0
        Sequences(0)="maxim_yaw_pitch_0"
        Sequences(1)="maxim_yaw_pitch_25"
        Sequences(2)="maxim_yaw_pitch_50"
        Sequences(3)="maxim_yaw_pitch_75"
        Sequences(4)="maxim_yaw_pitch_100"
        SequenceChannel=4
        BlendChannel=5
        SequenceInputType=DIT_Yaw
        BlendInputType=DIT_Pitch
        DriverPositionIndexRange=(Min=0,Max=0)
        FrameCount=8
    End Object
    AnimationDrivers(0)=(Parameters=AnimationDriverParameters0)
}
