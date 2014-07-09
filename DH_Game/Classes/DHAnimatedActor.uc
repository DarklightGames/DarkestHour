//	DHAnimatedActor


class DHAnimatedActor extends Actor
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
     AnimName="Higgins-Idle"
     AnimRate=1.000000
     bExactProjectileCollision=True
     DrawType=DT_Mesh
     bUseDynamicLights=True
     bNoDelete=True
     Mesh=SkeletalMesh'DH_HigginsBoat_anm.HigginsBoat'
     bShadowCast=True
     CollisionRadius=200.000000
     CollisionHeight=200.000000
     bCollideActors=True
     bBlockActors=True
     bBlockKarma=True
     bEdShouldSnap=True
}
