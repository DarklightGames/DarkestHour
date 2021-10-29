//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_ModifyReinfInterval extends DH_ModifyActors;

var()   EROSideIndex        TeamToModify;
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

