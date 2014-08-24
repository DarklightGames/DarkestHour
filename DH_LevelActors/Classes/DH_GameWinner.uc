// class: DH_GameWinner
// Auther: Theel
// Date: 10-25-10
// Purpose:
// Allows leveler to call a "final" event based on who won the most rounds (for series maps)
// Problems/Limitations:
// Can cause roundover loop if not properly used by leveler
// Use the tag EndGame to capture the EndGame event

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

defaultproperties
{
}
