//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
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

    foreach AllActors(Class'Actor', ActorReference, ActorToReset)
    {
        break;
    }
}

function Trigger(Actor Other, Pawn EventInstigator)
{
    ActorReference.Reset();
}
