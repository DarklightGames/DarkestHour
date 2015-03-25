//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ActorReset extends DH_LevelActors;

var()   name                ActorToReset;
var     actor               ActorReference;

function PostBeginPlay()
{
    local Actor A;

    super.PostBeginPlay();

    if (ActorToReset == '')
        return; //Actor tag wasn't set no reason to continue

    foreach AllActors(class'Actor', A, ActorToReset)
    {
        ActorReference = A;
        break;
    }
}

function Trigger(Actor Other, Pawn EventInstigator)
{
    ActorReference.reset();
}

defaultproperties
{
}
