//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHWeaponRangeParams extends Object;

var name                    Anim;
var private float           AnimFrame;
var int                     AnimFrameCount;
var private float           AnimFrameStart;
var private float           AnimFrameTarget;
var private float           AnimTimeSecondsStart;
var private float           AnimTimeSecondsEnd;
var int                     Channel;
var name                    Bone;
var DHUnits.EDistanceUnit   DistanceUnit;
var float                   AnimationInterpDuration;

// Range Table
struct RangeTableItem
{
    var() float Range;          // Range in the specified distance unit.
    var() float AnimationTime;  // Animation driver theta value.
};
var array<RangeTableItem> RangeTable;

simulated function float GetAnimFrame()
{
    return AnimFrame;
}

simulated function float GetAnimFrameTarget()
{
    return AnimFrameTarget;
}

simulated function SetRangeDriverFrameTarget(float TimeSeconds, int RangeIndex, optional bool bNoInterpolation)
{
    local float NewFrameTarget;

    NewFrameTarget = RangeTable[RangeIndex].AnimationTime * (AnimFrameCount - 1);

    AnimFrameStart = AnimFrame;
    AnimFrameTarget = NewFrameTarget;
    AnimTimeSecondsStart = TimeSeconds;
    AnimTimeSecondsEnd = AnimTimeSecondsStart;

    if (!bNoInterpolation)
    {
        AnimTimeSecondsEnd += AnimationInterpDuration;
    }
}

simulated function Tick(float TimeSeconds)
{
    local float T;

    T = Class'UInterp'.static.MapRangeClamped(TimeSeconds, AnimTimeSecondsStart, AnimTimeSecondsEnd, 0.0, 1.0);

    AnimFrame = Class'UInterp'.static.Deceleration(T, AnimFrameStart, AnimFrameTarget);
}

simulated function DumpRangeTable()
{
    local int i;

    for (i = 0; i < RangeTable.Length; ++i)
    {
        Log("RangeTable(" $ i $ ")=(Range=" $ RangeTable[i].Range $ ",AnimationTime=" $ RangeTable[i].AnimationTime $ ")");
    }
}

defaultproperties
{
    DistanceUnit=DU_Meters
    Anim="SIGHT_DRIVER"
    AnimFrameCount=10
    Channel=1
    Bone="REAR_SIGHT"
    AnimationInterpDuration=0.5
}
