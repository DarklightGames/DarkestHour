//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHWeaponRangeParams extends Object;

var name                    Anim;
var int                     AnimFrameCount;
var int                     Channel;
var name                    Bone;
var DHUnits.EDistanceUnit   DistanceUnit;
var float                   AnimationInterpDuration;

// Range Table
struct RangeTableItem
{
    var() float Range;              // Range in the specified distance unit.
    var() float AnimationTime;      // Animation driver theta value.
    var() float GunsightPitch;      // Added pitch for the gunsight at this range.
    var() float GunsightCorrectX;   // Added X correction for the gunsight at this range.
};
var() array<RangeTableItem> RangeTable;

var private float           InterpSecondsStart;
var private float           InterpSecondsEnd;

var private float           AnimFrame;
var private float           AnimFrameStart;
var private float           AnimFrameTarget;

var private float           GunsightPitchOffset;
var private float           GunsightPitchOffsetStart;
var private float           GunsightPitchOffsetTarget;

var private float           GunsightCorrectXOffset;
var private float           GunsightCorrectXOffsetStart;
var private float           GunsightCorrectXOffsetTarget;

simulated function float GetAnimFrame()
{
    return AnimFrame;
}

simulated function float GetGunsightPitchOffset()
{
    return GunsightPitchOffset;
}

simulated function float GetGunsightCorrectXOffset()
{
    return GunsightCorrectXOffset;
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
    GunsightPitchOffsetStart = GunsightPitchOffset;
    GunsightPitchOffsetTarget = RangeTable[RangeIndex].GunsightPitch;
    GunsightCorrectXOffsetStart = GunsightCorrectXOffset;
    GunsightCorrectXOffsetTarget = RangeTable[RangeIndex].GunsightCorrectX;
    InterpSecondsStart = TimeSeconds;
    InterpSecondsEnd = InterpSecondsStart;

    if (!bNoInterpolation)
    {
        InterpSecondsEnd += AnimationInterpDuration;
    }
}

simulated function Tick(float TimeSeconds)
{
    local float T;

    if (TimeSeconds >= InterpSecondsEnd)
    {
        AnimFrame = AnimFrameTarget;
        GunsightPitchOffset = GunsightPitchOffsetTarget;
        GunsightCorrectXOffset = GunsightCorrectXOffsetTarget;
        return;
    }

    T = Class'UInterp'.static.MapRangeClamped(TimeSeconds, InterpSecondsStart, InterpSecondsEnd, 0.0, 1.0);
    AnimFrame = Class'UInterp'.static.Deceleration(T, AnimFrameStart, AnimFrameTarget);
    GunsightPitchOffset = Class'UInterp'.static.Deceleration(T, GunsightPitchOffsetStart, GunsightPitchOffsetTarget);
    GunsightCorrectXOffset = Class'UInterp'.static.Deceleration(T, GunsightCorrectXOffsetStart, GunsightCorrectXOffsetTarget);
}

simulated function DumpRangeTable()
{
    local int i;

    for (i = 0; i < RangeTable.Length; ++i)
    {
        Log("RangeTable(" $ i $ ")=(Range=" $ RangeTable[i].Range $ ",AnimationTime=" $ RangeTable[i].AnimationTime $ ",GunsightPitch=" $ RangeTable[i].GunsightPitch $ ",GunsightCorrectX=" $ RangeTable[i].GunsightCorrectX $ ")");
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
