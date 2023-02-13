//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// Spawn this class at a location to test if a DHPawn is able to be teleported
// to a location. Used to test if spawn locations are going to be valid and are
// not blocked by static geometry.
//==============================================================================

class DHPawnCollisionTest extends Actor
    notplaceable;

defaultproperties
{
    RemoteRole=ROLE_None
    DrawType=DT_None
    bCollideActors=true
    bBlockKarma=false
    bIgnoreEncroachers=true
    bBlockActors=false
    bProjTarget=true
    bBlockHitPointTraces=false
    bUseCylinderCollision=true
    CollisionRadius=23
    CollisionHeight=52
    bCollideWorld=true
}

