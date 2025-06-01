//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ModifyReinfInterval extends DH_ModifyActors;

var()   ROSideIndex         TeamToModify;
var()   int                 NewIntervalTime;

event Trigger(Actor Other, Pawn EventInstigator)
{
    local DarkestHourGame G;

    G = DarkestHourGame(Level.Game);

    if (G != none)
    {
        G.SetReinforcementInterval(TeamToModify, NewIntervalTime);
    }
}


