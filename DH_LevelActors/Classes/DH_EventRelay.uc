//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_EventRelay extends DH_LevelActors;

struct EventDelay
{
    var() name EventName;
    var() float Delay;
};

var()   array<EventDelay>   Events;
var     byte                EventIndex;
var()   bool                bFireOnce;

event Trigger(Actor Other, Pawn EventInstigator)
{
    //No recursive calls, please.
    if (EventInstigator == self)
    {
        return;
    }

    GotoState('Activated');
}

state Activated
{
Begin:
    while (EventIndex < Events.Length)
    {
        Sleep(Events[EventIndex].Delay);
        TriggerEvent(Events[EventIndex].EventName, self, none);
        EventIndex++;
    }

    if (bFireOnce)
    {
        Destroy();
    }

    GotoState('');
}
