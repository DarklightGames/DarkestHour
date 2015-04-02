//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHAnimatedC47 extends Actor
    placeable;

var(InitialAnimation) name AnimName;
var(InitialAnimation) float AnimRate;

simulated function PostBeginPlay()
{
    LoopAnim(AnimName, AnimRate);

    super.PostBeginPlay();
}

defaultproperties
{
    AnimName="c47_in_flight"
    AnimRate=1.0
    DrawType=DT_Mesh
    CullDistance=16000.0
    bUseDynamicLights=true
    bNoDelete=true
    Mesh=SkeletalMesh'DH_C47_anm.FlyingC47'
    bShadowCast=true
    CollisionRadius=1800.0
    CollisionHeight=400.0
    bCollideActors=true
    bBlockActors=true
    bBlockKarma=true
    bEdShouldSnap=true
}
