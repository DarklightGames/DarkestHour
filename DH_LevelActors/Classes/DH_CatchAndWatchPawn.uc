//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_CatchAndWatchPawn extends DH_LevelActors;

var     Pawn        PawnReference; //The pawn to watch
var()   name        EventToTriggerOnDeath;
var     bool        bFired;
//messages

function reset()
{
    PawnReference = none;
    gotostate('WaitToWatch');
}

auto state WaitToWatch
{
    function BeginState()
    {
        bFired = false;
        PawnReference = none; //incase we get set back to watch we should clear our reference
    }
}

state Watch
{
    function BeginState()
    {
        SetTimer(1, true);
    }
    function Timer()
    {
        if (PawnReference.Health <= 0)
            PawnReferenceIsDead();
    }
}

state Done
{
    function BeginState()
    {
        //no point to keep pawn ref
        PawnReference = none;
    }
}

function PassPawnRef(pawn PassedPawn)
{
    if (!Level.Game.IsInState('RoundInPlay') || bFired || PassedPawn.health <= 0)
        return; //Leave as the game was not in Play was already fired or the pawn was alredy dead
    else
    {
        PawnReference = PassedPawn;
        gotostate('Watch');
    }
}

function PawnReferenceIsDead()
{
    if (Level.Game.IsInState('RoundInPlay') && !bFired)
    {
        TriggerEvent(EventToTriggerOnDeath, self, PawnReference);
        bFired = true;
        //Messages
        gotostate('Done');
    }
}

defaultproperties
{
}
