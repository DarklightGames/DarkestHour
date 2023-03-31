//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHAccurateVolumeTimer extends VolumeTimer;

// Keeps accurate timing over a period, with Timer being called exactly every TimerFrequency seconds, without losing time
// In a normal VolumeTimer a small amount of time passes in between fixed duration timers, so over a period timing drifts & becomes slightly off

var     float   NextTimerCallTime; // the time when the next Timer should be called, so we can keep accurate timing over a period

// Modified to set the initial NextTimerCallTime
// Also uses TimerFrequency value for the 1st timer duration, instead of assuming default 1 second, & makes sure we have an owning Actor
function PostBeginPlay()
{
    if (Owner != none)
    {
        A = Owner;
        NextTimerCallTime = Level.TimeSeconds + TimerFrequency;
        SetTimer(NextTimerCallTime - Level.TimeSeconds, false);
    }
    else
    {
        Log("WARNING:" @ Name @ "somehow spawned with no associated owning Volume & is now self-destructing !");
        Destroy();
    }
}

// Modified to set a more accurate timer based on exact time until NextTimerCallTime
function Timer()
{
    A.TimerPop(self);
    NextTimerCallTime += TimerFrequency;
    SetTimer(NextTimerCallTime - Level.TimeSeconds, false);
}
