//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_TeamWinRound extends DH_LevelActors;

var() ROSideIndex   TeamToWin;

function Trigger(Actor Other, Pawn EventInstigator)
{
    ROTeamGame(Level.Game).EndRound(TeamToWin);
}


