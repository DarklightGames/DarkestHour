//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ActorReset extends DH_LevelActors;

var()   name                ActorToReset;
var     Actor               ActorReference;

function PostBeginPlay()
{
    super.PostBeginPlay();

    if (ActorToReset == '')
    {
        return; //Actor tag wasn't set no reason to continue
    }

    foreach AllActors(class'Actor', ActorReference, ActorToReset)
    {
        break;
    }
}

function Trigger(Actor Other, Pawn EventInstigator)
{
    ActorReference.Reset();
}
