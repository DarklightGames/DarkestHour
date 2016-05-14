//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

// Matt: originally extended RODestroyableStaticMeshBase, but lots of classes look for a RODestroyableStaticMesh, which is a subclass of RODSMBase & so won't be found
// Makes no difference in function, as RODSM is just an empty class that extends RODSMBase, so does exactly the same thing
class DH_DestroyableSM extends RODestroyableStaticMesh;

// Overridden Trigger function to allow toggling
function Trigger(Actor Other, Pawn EventInstigator)
{
    if (EventInstigator != none)
    {
        MakeNoise(1.0);
    }

    // If destroyed, go to state working (basically repairs it)
    if (bDamaged)
    {
        GotoState('Working');
    }
    // It's not destroyed - let's destroy it
    else
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
