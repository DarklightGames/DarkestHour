//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_DestroyableSM extends RODestroyableStaticMeshBase;

//Overridden Trigger function to allow toggling
function Trigger(actor Other, pawn EventInstigator)
{
    if (EventInstigator != none)
        MakeNoise(1.0);
    //if destroyed goto state working (basically repairs it)
    if (bDamaged)
        Gotostate('Working');
    else //it's not destroyed, lets destroy it
    {
        Health = 0;
        TriggerEvent(DestroyedEvent, self, EventInstigator);
        BroadcastCriticalMessage(EventInstigator);
        BreakApart(Location);
    }
}

function DestroyDSM()
{
    Health = 0;
    TriggerEvent(DestroyedEvent, self, none);
    BroadcastCriticalMessage(none);
    BreakApart(Location);
}

defaultproperties
{
}
