//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHAnimNotify_SpawnKActor extends AnimNotify_Scripted;

var() StaticMesh    StaticMesh;
var() name          BoneName;
var() float         LifeSpan;
var() rotator       StartRotation;
var() rangevector   ImpulseRange;
var() rangevector   AngularImpulseRange;

var   bool          bDebug;
var   vector        DebugImpulse, DebugAngularImpulse;

event Notify(Actor Owner)
{
    local coords BoneCoords;
    local DHKActor Shell;
    local vector Impulse;
    local vector AngularImpulse;

    BoneCoords = Owner.GetBoneCoords(BoneName);

    if (default.bDebug)
    {
        Impulse = default.DebugImpulse >> rotator(BoneCoords.XAxis);
        AngularImpulse = default.DebugAngularImpulse >> rotator(BoneCoords.XAxis);
    }
    else
    {
        Impulse = class'UVector'.static.RandomRange(ImpulseRange) >> rotator(BoneCoords.XAxis);
        AngularImpulse = class'UVector'.static.RandomRange(AngularImpulseRange) >> rotator(BoneCoords.XAxis);
    }

    Shell = Owner.Spawn(class'DHKActor', Owner,, BoneCoords.Origin, rotator(vector(StartRotation) >> rotator(BoneCoords.XAxis)));

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
