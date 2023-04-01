//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_DUKWSplashGuard extends Actor;

simulated state Raised
{
    simulated function bool IsRaised()
    {
        return true;
    }
}

simulated state Lowered
{
    simulated function bool IsLowered()
    {
        return true;
    }
}

simulated state Transitioning
{
    simulated function bool IsTransitioning()
    {
        return true;
    }
}

simulated state Lowering extends Transitioning
{
}

simulated state Raising extends Transitioning
{
}

simulated function bool IsRaised();
simulated function bool IsLowered();
simulated function bool IsTransitioning();

function Toggle()
{
    if (IsTransitioning())
    {
        return;
    }

    if (IsRaised())
    {
        GotoState('Lowering');
    }
    else if (IsLowered())
    {
        GotoState('Raising');
    }
}

defaultproperties
{
}