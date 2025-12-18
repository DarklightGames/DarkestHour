//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// To achieve "fake" inverse kinematics, we can use the engine's animation
// "channel" (i.e. blending) system. This involves baking out animations then
// using a combination of tweening and layering to achieve the desired effect.
//
// For example, on a mounted machine-gun, we want the player model to keep his
// hands on the gun regardless of the pitch or yaw of the gun. In the engine,
// we have 2 "animation spaces" that we can interpolate between: the "sequence
// space" (tweening between frames on a single sequence), and the "blend space"
// (blending 2 animations using channels). Therefore, we can easily map the
// gun's movement spaces onto the animation interpolation spaces.
//
// In the mounted machine-gun example, the gun's yaw can be mapped onto the
// sequence space. This means that a single sequence will be the player moving
// the gun from left-to-right at a specific pitch.
//
// The gun's pitch can then be mapped onto the blend space. This means that
// there will be N number of sequences of the gun being moved left to right,
// but at different pitch values.
//
// The amount of frames-per-sequence and amount of sequences (N) you need will
// depend on the accuracy needed to make any visual issues unnoticable.
//==============================================================================

class DHVehicleWeaponPawnAnimationDriverParameters extends Object;

// TODO: perhaps abstract this out to a delgate function since it only needs to return a float vlaue, then it can work with anything.
enum EDriverInputType
{
    DIT_Pitch,
    DIT_Yaw,
};

struct RangeInt
{
    var int Min;
    var int Max;
};

var() RangeInt DriverPositionIndexRange;    // Range is inclusive
var() EDriverInputType SequenceInputType;
var() int SequenceChannel;                  // Sequence channels should be non-zero.
var() bool bInvertSequenceTheta;
var() EDriverInputType BlendInputType;
var() int BlendChannel;
var() name BoneName;
// The sequences are expected to be on equal segment boundaries. For example, if there are 5 sequences,
// they should be evenly spaced from 0.0 to 1.0 (i.e., [0.0, 0.25, 0.5, 0.75, 1.0]).
var() array<name> Sequences;
var() int FrameCount; // The number of frames in each sequence. This should be same for all sequences.