//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_TimedTrigger extends Trigger;

var()   float   DelayTime;

var()   bool    bIsStateOne;

simulated function PostBeginPlay()
{
    // Set up the timer, then tell our parent:
    SetTimer(DelayTime, false);

    super.PostBeginPlay();
}

// The timer will go off every 'DelayTime' seconds:
simulated function Timer()
{
    // Trigger:
    if (bIsStateOne)
    {
        TriggerEvent(Event, self, none);
        Log("TRIGGERED EVENT!");
        bIsStateOne = false;
    }
}

// Reset actor to initial state - used when restarting level without reloading.
function Reset()
{
    super.Reset();

    // collision, bInitiallyactive
    bInitiallyActive = bSavedInitialActive;
    SetCollision(bSavedInitialCollision, bBlockActors);

    //re-trigger event to revert back to initial state then reset timer:
    if (!bIsStateOne)
    {
        TriggerEvent(Event, self, none);
        Log("TRIGGERED EVENT TO RESET!");
        bIsStateOne = true;
    }

    SetTimer(DelayTime, false);
}

defaultproperties
{
    DelayTime=60.0
    bIsStateOne=true
}
