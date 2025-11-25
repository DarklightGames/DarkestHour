//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MaximM191030MGPawn_Standing extends DH_MaximM191030MGPawn;

defaultproperties
{
    Begin Object Class=DHVehicleWeaponPawnAnimationDriverParameters Name=AnimationDriverParameters0
        Sequences(0)="maxim_yaw_stand_pitch_0"
        Sequences(1)="maxim_yaw_stand_pitch_25"
        Sequences(2)="maxim_yaw_stand_pitch_50"
        Sequences(3)="maxim_yaw_stand_pitch_75"
        Sequences(4)="maxim_yaw_stand_pitch_100"
        SequenceChannel=4
        BlendChannel=5
        SequenceInputType=DIT_Yaw
        BlendInputType=DIT_Pitch
        DriverPositionIndexRange=(Min=0,Max=0)
        FrameCount=8
    End Object
    AnimationDrivers(0)=(Parameters=AnimationDriverParameters0)
}
