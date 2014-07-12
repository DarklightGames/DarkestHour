class DHBarbedWire extends Actor
    placeable;

var bool bIsDestroyed;

var() sound DestroySound;

defaultproperties
{
    DrawType=DT_StaticMesh

    bStatic=false
    bNoDelete=true
    bUseCylinderCollision=false
    bCollideActors=true
    bCollideWorld=false
    bBlockActors=false
    bBlockProjectiles=false
    bBlockKarma=true
    bUseCollisionStaticMesh=true
    bFixedRotationDir=true
}

