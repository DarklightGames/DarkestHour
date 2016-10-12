//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
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

defaultproperties
{

}
