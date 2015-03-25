//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ObjectiveCaptureActor extends DH_LevelActors;

var()   int             ObjectiveToModify;
var()   ROSideIndex     TeamToCap;

function Trigger(Actor Other, Pawn EventInstigator)
{
    local ROTeamGame ROTeamGame;

    ROTeamGame = ROTeamGame(Level.Game);

    if (TeamToCap == NEUTRAL)
        ROTeamGame.Objectives[ObjectiveToModify].ObjState = OBJ_Neutral;
    else
        ROTeamGame.Objectives[ObjectiveToModify].ObjectiveCompleted(none, TeamToCap); //Pass the team to capture
}

defaultproperties
{
}
