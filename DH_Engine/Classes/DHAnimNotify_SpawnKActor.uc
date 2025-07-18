//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHAnimNotify_SpawnKActor extends AnimNotify_Scripted;

var() StaticMesh    StaticMesh;
var() name          BoneName;
var() float         LifeSpan;
var() Rotator       StartRotation;
var() RangeVector   ImpulseRange;
var() RangeVector   AngularImpulseRange;

var   bool          bDebug;
var   Vector        DebugImpulse, DebugAngularImpulse;

event Notify(Actor Owner)
{
    local Coords BoneCoords;
    local DHKActor Shell;
    local Vector Impulse;
    local Vector AngularImpulse;

    BoneCoords = Owner.GetBoneCoords(BoneName);

    if (default.bDebug)
    {
        Impulse = default.DebugImpulse >> Rotator(BoneCoords.XAxis);
        AngularImpulse = default.DebugAngularImpulse >> Rotator(BoneCoords.XAxis);
    }
    else
    {
        Impulse = Class'UVector'.static.RandomRange(ImpulseRange) >> Rotator(BoneCoords.XAxis);
        AngularImpulse = Class'UVector'.static.RandomRange(AngularImpulseRange) >> Rotator(BoneCoords.XAxis);
    }

    Shell = Owner.Spawn(Class'DHKActor', Owner,, BoneCoords.Origin, Rotator(Vector(StartRotation) >> Rotator(BoneCoords.XAxis)));

    if (Shell != none)
    {
        Shell.SetStaticMesh(StaticMesh);
        Shell.KDisableCollision(Owner);
        Shell.KWake();
        Shell.KAddImpulse(Impulse, Shell.Location);
        Shell.KAddAngularImpulse(AngularImpulse);
        Shell.LifeSpan = LifeSpan;
    }
}

defaultproperties
{
    LifeSpan=15.0
}
