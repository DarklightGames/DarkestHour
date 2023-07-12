//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_GameWinner extends DH_LevelActors;

var()   name    AxisWonEvent;
var()   name    AlliesWonEvent;

event Trigger(Actor Other, Pawn EventInstigator)
{
    local ROTeamGame ROTeamGame;

    ROTeamGame = ROTeamGame(Level.Game); //Get Game Info

    if (ROTeamGame.Teams[AXIS_TEAM_INDEX].Score > ROTeamGame.Teams[ALLIES_TEAM_INDEX].Score)
        TriggerEvent(AxisWonEvent, Other, EventInstigator);
    else if (ROTeamGame.Teams[AXIS_TEAM_INDEX].Score < ROTeamGame.Teams[ALLIES_TEAM_INDEX].Score)
        TriggerEvent(AlliesWonEvent, Other, EventInstigator);
    else
        Level.Game.Broadcast(self, "The Game Was Tie!");
}
