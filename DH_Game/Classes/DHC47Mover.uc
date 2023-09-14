//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHC47Mover extends DHVariableTimedMover;

var(InitialAnimation)   name    AnimName;
var(InitialAnimation)   float   AnimRate;

simulated function BeginPlay()
{
    LoopAnim(AnimName, AnimRate);

    super.BeginPlay();
}

defaultproperties
{
    DrawType=DT_Mesh
    Mesh=SkeletalMesh'DH_C47_anm.FlyingC47'
    AnimName="c47_in_flight"
    AnimRate=1.0
    CollisionRadius=1800.0
    CollisionHeight=400.0
    bBlockKarma=true
    CullDistance=16000.0
}
