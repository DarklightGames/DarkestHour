//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_SwitchLevel extends DH_LevelActors;

var()   string      LevelName;

function Trigger(Actor Other, Pawn EventInstigator)
{
    Level.ServerTravel(LevelName, false);
}


