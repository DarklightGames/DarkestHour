//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ObjectiveArrayCheck extends DH_LevelActors;

// Defines an objective state
enum EObjectiveState
{
    OBJ_Axis,
    OBJ_Allies,
    OBJ_Neutral,
};

var()   bool                        bFireOnce;
var()   array<int>                  ObjectivesToCheck;  //Array of names to add to the reference array
var()   array<int>                  ObjectivesToModify;
var()   name                        EventToTrigger; //will call this tag if successful
var()   name                        EventToTriggerForFail; //will call this event if fail
var()   EObjectiveState             StateToCheckFor;
var()   bool                        bStatusToModifyTo;
var()   bool                        UseRandomness;
var()   int                         RandomPercent; // 100 for always succeed, 0 for always fail
var()   bool                        bAutoStartCheck;

event Trigger(Actor Other, Pawn EventInstigator)
{
    local int RandomNum, i;
    local DarkestHourGame DHGame;

    if (bFireOnce && IsInState('Done'))
        return; //stop function because it's already done and should only fire once

    if (UseRandomness)
    {
        RandomNum = Rand(100);  //Gets a random # between 0 & 99

        if (RandomPercent < RandomNum)
            return; //stop function because it randomly failed
    }

    DHGame = DarkestHourGame(Level.Game); //Get Game Info

    //Check the array for the state to check for
    for (i = 0; i < ObjectivesToCheck.Length; ++i)
    {
        if (DHGame.DHObjectives[ObjectivesToCheck[i]].ObjState != StateToCheckFor)
        {
            if (EventToTriggerForFail != '')
                TriggerEvent(EventToTriggerForFail, self, none); //Triggers the event EventToTriggerForFail

            return; //No reason to continue as not all the objectives were in the state to check for
        }
    }

    //Because we are here everything checked out so lets goto done
    GotoState('Done');

    //if EventToTrigger is set lets trigger the event
    if (EventToTrigger != '')
        TriggerEvent(EventToTrigger, self, none); //Triggers the event

    //Go ahead and status change the objectives you want to change
    for (i = 0; i < ObjectivesToModify.Length; ++i)
    {
        DHGame.DHObjectives[ObjectivesToModify[i]].SetActive(bStatusToModifyTo);
    }
}

function Reset()
{
    GotoState('Initialize'); // cancels the Timing Timer (allowing for ResetGame)
}

auto state Initialize
{
    function BeginState()
    {
        if (bAutoStartCheck)
            GotoState('Timing');
    }
}

state Timing
{
    function BeginState()
    {
        SetTimer(1.0, true);
    }

    function Timer()
    {
        Trigger(self, none); // calls its own Trigger function
    }
}

state Done
{
    // Do nothing
}


