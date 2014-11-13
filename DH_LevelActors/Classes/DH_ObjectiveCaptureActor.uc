//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ObjectiveCaptureActor extends DH_LevelActors;

var()   int             ObjectiveToModify; //Objective number to modify
var()   ROSideIndex     TeamToCap; //Theel & Basnett

function Trigger(Actor Other, Pawn EventInstigator)
{
    local ROTeamGame ROTeamGame;

    ROTeamGame = ROTeamGame(Level.Game); //Get Game Info

    if (TeamToCap == NEUTRAL)
        ROTeamGame.Objectives[ObjectiveToModify].ObjState = OBJ_Neutral;
    else
        ROTeamGame.Objectives[ObjectiveToModify].ObjectiveCompleted(none, TeamToCap); //Pass the team to capture
}

defaultproperties
{
}
