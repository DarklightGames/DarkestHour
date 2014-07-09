// class: DH_TeamWinRound
// Auther: Theel
// Date: 9-28-10
// Purpose:
// Adds the ability to win a round from event
// Problems/Limitations:
// Will cause roundover loop if not properly used by leveler

class DH_TeamWinRound extends DH_LevelActors;

var() ROSideIndex	TeamToWin;

function Trigger( Actor Other, Pawn EventInstigator )
{
	ROTeamGame(Level.Game).EndRound(TeamToWin);
}

defaultproperties
{
}
