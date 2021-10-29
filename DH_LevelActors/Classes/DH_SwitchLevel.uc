//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_SwitchLevel extends DH_LevelActors;

var()   string      LevelName;

function Trigger(Actor Other, Pawn EventInstigator)
{
    Level.ServerTravel(LevelName, false);
}

