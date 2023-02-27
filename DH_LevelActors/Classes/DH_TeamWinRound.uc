//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_TeamWinRound extends DH_LevelActors;

var() ROSideIndex   TeamToWin;

function Trigger(Actor Other, Pawn EventInstigator)
{
    ROTeamGame(Level.Game).EndRound(TeamToWin);
}


