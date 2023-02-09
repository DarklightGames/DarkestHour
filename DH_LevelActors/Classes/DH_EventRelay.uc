//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_EventRelay extends DH_LevelActors;

struct EventDelay
{
    var name EventName;
    var float Delay;
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
