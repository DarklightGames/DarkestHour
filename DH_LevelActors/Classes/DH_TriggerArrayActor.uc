//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_TriggerArrayActor extends DH_LevelActors;

var()   bool                        bFireOnce;
var     bool                        bFired;
var()   array<name>                 EventsToTrigger;

function Trigger(Actor Other, Pawn EventInstigator)
{
    local int i;

    if (!bFireOnce && !bFired)
    {
        //Start the loop to trigger all the events we need
        for (i = 0; i < EventsToTrigger.Length; ++i)
            TriggerEvent(EventsToTrigger[i], self, none); //Triggers the events

        bFired = true;
    }
}

function Reset()
{
    bFired = false; //Because round reset, bFired should be set back to false
}


