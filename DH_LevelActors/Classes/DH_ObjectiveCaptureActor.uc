// class: DH_ObjectiveCaptureActor
// Auther: Theel
// Date: 9-28-10
// Purpose:
// Adds the ability to capture an objective from event
// Problems/Limitations:
// Can cause roundover loop if not properly used by leveler (careful)

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
