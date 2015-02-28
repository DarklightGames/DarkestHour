//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHAnimatedActor extends Actor
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
    AnimName="Higgins-Idle"
    AnimRate=1.0
    bExactProjectileCollision=true
    DrawType=DT_Mesh
    bUseDynamicLights=true
    bNoDelete=true
    Mesh=SkeletalMesh'DH_HigginsBoat_anm.HigginsBoat'
    bShadowCast=true
    CollisionRadius=200.0
    CollisionHeight=200.0
    bCollideActors=true
    bBlockActors=true
    bBlockKarma=true
    bEdShouldSnap=true
}
