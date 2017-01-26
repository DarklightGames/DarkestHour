//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHDestroyableSM extends RODestroyableStaticMesh
    abstract placeable;

// This class exists because we need it in DH_Engine as classes in DH_Engine access these class variables
// It is abstract because we have DH_DestroyableSM (notice the _) which is in DH_LevelActors and already used by maps
// We can't just move DH_DestroyableSM to DH_Engine, as it would break levels that use it, hence why we have DHDestroyableSM

var()   bool            bDestroyableByAxis, bDestroyableByAllies;  // Used in DHThrowableExplosiveProjectile HurtRadius()

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
    bDestroyableByAxis=true
    bDestroyableByAllies=true
}
