//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHAnimNotify_SpawnKActor extends AnimNotify_Scripted;

var() StaticMesh    StaticMesh;
var() name          BoneName;
var() float         LifeSpan;
var() rotator       StartRotation;
var() rangevector   ImpulseRange;
var() rangevector   AngularImpulseRange;

event Notify(Actor Owner)
{
    local coords BoneCoords;
    local DHKActor Shell;
    local vector Impulse;
    local vector AngularImpulse;

    BoneCoords = Owner.GetBoneCoords(BoneName);
    Impulse = class'UVector'.static.RandomRange(ImpulseRange) >> rotator(BoneCoords.XAxis);
    AngularImpulse = class'UVector'.static.RandomRange(AngularImpulseRange) >> rotator(BoneCoords.XAxis);

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
    LifeSpan=15
}
