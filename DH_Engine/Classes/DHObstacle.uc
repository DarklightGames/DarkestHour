//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHObstacle extends Actor;

var()   StaticMesh   DestroyedStaticMesh;

event Touch(Actor Other)
{
    super.Touch(Other);

    //TODO: requires a certain speed?
    if (Other.IsA('SVehicle'))
    {
        GotoState('DestroyedState');
    }
}

event Bump(Actor Other)
{
    super.Bump(Other);

    Level.Game.Broadcast(self, "Bump" @ Other);
}

state DestroyedState
{
    function BeginState()
    {
        Level.Game.Broadcast(self, "Destroyed");

        SetStaticMesh(DestroyedStaticMesh);

        KSetBlockKarma(false);
    }
}

defaultproperties
{
    bBlockPlayers=true
    bBlockActors=true
    bBlockKarma=true
    bBlockProjectiles=true
    bCanBeDamaged=true
    bCollideActors=true
    bCollideWorld=false
    bWorldGeometry=false
    bStatic=false
    bStaticLighting=true
    DrawType=DT_StaticMesh
    Role=ROLE_None
}

