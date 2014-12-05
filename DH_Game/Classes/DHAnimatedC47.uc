//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHAnimatedC47 extends Actor
    placeable;

var(InitialAnimation) name AnimName;
var(InitialAnimation) float AnimRate;
var() bool bExactProjectileCollision;       // nonzero extent projectiles should shrink to zero when hitting this actor

simulated function PostBeginPlay()
{
    LoopAnim(AnimName, AnimRate);

    super.PostBeginPlay();
}

defaultproperties
{
    AnimName="c47_in_flight"
    AnimRate=1.000000
    bExactProjectileCollision=true
    DrawType=DT_Mesh
    CullDistance=16000.000000
    bUseDynamicLights=true
    bNoDelete=true
    Mesh=SkeletalMesh'DH_C47_anm.FlyingC47'
    bShadowCast=true
    CollisionRadius=1800.000000
    CollisionHeight=400.000000
    bCollideActors=true
    bBlockActors=true
    bBlockKarma=true
    bEdShouldSnap=true
}
