//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_CatchAndWatchPawn extends DH_LevelActors;

var     Pawn        PawnReference; // the pawn to watch
var()   name        EventToTriggerOnDeath;
var     bool        bFired;

function Reset()
{
    PawnReference = none;
    GotoState('WaitToWatch');
}

auto state WaitToWatch
{
    function BeginState()
    {
        bFired = false;
        PawnReference = none; //in case we get set back to watch we should clear our reference
    }
}

state Watch
{
    function BeginState()
    {
        SetTimer(1.0, true);
    }

    function Timer()
    {
        if (PawnReference.Health <= 0)
        {
            PawnReferenceIsDead();
        }
    }
}

state Done
{
    function BeginState()
    {
        PawnReference = none; // no point to keep pawn ref
    }
}

function PassPawnRef(Pawn PassedPawn)
{
    if (!Level.Game.IsInState('RoundInPlay') || bFired || PassedPawn.Health <= 0)
    {
        return; // leave as the game was not in play, was already fired, or the pawn was already dead
    }

    PawnReference = PassedPawn;
    GotoState('Watch');
}

function PawnReferenceIsDead()
{
    if (Level.Game.IsInState('RoundInPlay') && !bFired)
    {
        TriggerEvent(EventToTriggerOnDeath, self, PawnReference);
        bFired = true;
        GotoState('Done');
    }
}
