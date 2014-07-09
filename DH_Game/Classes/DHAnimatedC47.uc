//	DHAnimatedActor


class DHAnimatedC47 extends Actor
    placeable;

var(InitialAnimation) name AnimName;
var(InitialAnimation) float AnimRate;
var() bool bExactProjectileCollision;		// nonzero extent projectiles should shrink to zero when hitting this actor

simulated function PostBeginPlay()
{
	LoopAnim( AnimName, AnimRate );
     	Super.PostBeginPlay();
}

defaultproperties
{
     AnimName="c47_in_flight"
     AnimRate=1.000000
     bExactProjectileCollision=True
     DrawType=DT_Mesh
     CullDistance=16000.000000
     bUseDynamicLights=True
     bNoDelete=True
     Mesh=SkeletalMesh'DH_C47_anm.FlyingC47'
     bShadowCast=True
     CollisionRadius=1800.000000
     CollisionHeight=400.000000
     bCollideActors=True
     bBlockActors=True
     bBlockKarma=True
     bEdShouldSnap=True
}
