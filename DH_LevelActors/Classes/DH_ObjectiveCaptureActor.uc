//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ObjectiveCaptureActor extends DH_LevelActors;

var()   int             ObjectiveToModify;
var()   ROSideIndex     TeamToCap;

function Trigger(Actor Other, Pawn EventInstigator)
{
    local DarkestHourGame DHTeamGame;

    DHTeamGame = DarkestHourGame(Level.Game);

    if (TeamToCap == NEUTRAL)
        DHTeamGame.DHObjectives[ObjectiveToModify].ObjState = OBJ_Neutral;
    else
        DHTeamGame.DHObjectives[ObjectiveToModify].ObjectiveCompleted(none, TeamToCap); //Pass the team to capture
}


