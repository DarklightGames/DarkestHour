//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_TimedTrigger extends Trigger;

var()   float   DelayTime;

var()   bool    bIsStateOne;

// Modified to set a timer for specified DelayTime, then tell our parent
simulated function PostBeginPlay()
{
    SetTimer(DelayTime, false);

    super.PostBeginPlay();
}

// Modified to trigger the event after the specified delay & flag that we are no longer in the original state
simulated function Timer()
{
    if (bIsStateOne)
    {
        TriggerEvent(Event, self, none);
        bIsStateOne = false;
    }
}
/*
function Timer() // THE SUPER
{
    bKeepTiming = false;

    foreach TouchingActors(class'Actor', A)
    {
        if (IsRelevant(A))
        {
            bKeepTiming = true;
            Touch(A);
        }
    }

    if (bKeepTiming)
    {
        SetTimer(RepeatTriggerTime, false);
    }
}
*/

// Modified to reset actor to initial state - used when restarting level without reloading
// Re-trigger event to revert back to initial state then reset timer
function Reset()
{
    super.Reset();

    if (!bIsStateOne)
    {
        TriggerEvent(Event, self, none);
        bIsStateOne = true;
    }

    SetTimer(DelayTime, false);
}

defaultproperties
{
    DelayTime=60.0
    bIsStateOne=true
}
