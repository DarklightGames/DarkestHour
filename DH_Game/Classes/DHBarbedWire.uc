//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

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

