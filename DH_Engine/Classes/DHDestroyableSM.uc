//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHDestroyableSM extends RODestroyableStaticMesh
    abstract placeable;

// This class exists because we need it in DH_Engine as classes in DH_Engine access these class variables
// It is abstract because we have DH_DestroyableSM (notice the _) which is in DH_LevelActors and already used by maps
// We can't just move DH_DestroyableSM to DH_Engine, as it would break levels that use it, hence why we have DHDestroyableSM

var()   bool    bDestroyableByAxis, bDestroyableByAllies; // used in DHThrowableExplosiveProjectile's HurtRadius() function so explosion only damages DSM based on team
var     Controller  DelayedDamageInstigatorController; // projectiles set this when they explode so we have reference to player responsible for damage, even if his pawn dies

// Modified to allow allow toggling between destroyed & normal states
function Trigger(Actor Other, Pawn EventInstigator)
{
    if (EventInstigator != none)
    {
        MakeNoise(1.0);
    }

    if (bDamaged)
    {
        GotoState('Working');
    }
    else
    {
        DestroyDSM(EventInstigator);
    }
}

// New function used by DH_ModifyDSMStatus actor to
function DestroyDSM(Pawn EventInstigator)
{
    Health = 0;
    TriggerEvent(DestroyedEvent, self, EventInstigator);
    BroadcastCriticalMessage(EventInstigator);
    BreakApart(Location);
}

defaultproperties
{
    bDestroyableByAxis=true
    bDestroyableByAllies=true
}
