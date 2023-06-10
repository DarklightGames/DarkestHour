//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHAnimatedActor extends Actor
    placeable;

var(InitialAnimation)   SkeletalMesh    AnimMesh; // it's possible to set actor's Mesh under 'display' in the editor, but this just makes it more obvious under 'InitialAnimation'
var(InitialAnimation)   name            AnimName;
var(InitialAnimation)   float           AnimRate;

simulated function PostBeginPlay()
{
    if (AnimMesh != none)
    {
        LinkMesh(AnimMesh);
    }

    if (Mesh != none)
    {
        if (HasAnim(AnimName))
        {
            LoopAnim(AnimName, AnimRate);
        }
        else
        {
            Warn("DHAnimatedActor spawned with no valid animation: specified AnimName =" @ AnimName);
        }
    }
    else
    {
        Warn("DHAnimatedActor spawned with no valid skeletal mesh: specified AnimMesh =" @ AnimMesh @ " default Mesh =" @ Mesh);
    }
}

defaultproperties
{
    DrawType=DT_Mesh
    AnimRate=1.0
    bUseDynamicLights=true
    bNoDelete=true
    bShadowCast=true
    CollisionRadius=200.0
    CollisionHeight=200.0
    bCollideActors=true
    bBlockActors=true
    bBlockKarma=true
    bEdShouldSnap=true
}
