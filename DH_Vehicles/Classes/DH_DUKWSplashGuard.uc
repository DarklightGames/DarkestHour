//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_DUKWSplashGuard extends Actor;

var name RaisingAnim;
var name RaisedAnim;
var name LoweringAnim;
var name LoweredAnim;

enum ESplashGuardState
{
    SGS_Lowered,
    SGS_Raised,
    SGS_Transitioning
};

var private ESplashGuardState TargetState;

function ESplashGuardState GetTargetSplashGuardState()
{
    return TargetState;
}

simulated state Idle
{
    simulated function BeginState()
    {
        if (GetSplashGuardState() != TargetState)
        {
            if (TargetState == SGS_Raised)
            {
                GotoState('Raising');
            }
            else if (TargetState == SGS_Lowered)
            {
                GotoState('Lowering');
            }
        }
    }
}

simulated state Raised extends Idle
{
    function BeginState()
    {
        LoopAnim(RaisedAnim);
    }

    simulated function ESplashGuardState GetSplashGuardState()
    {
        return SGS_Raised;
    }
}

simulated state Lowered extends Idle
{
    function BeginState()
    {
        LoopAnim(LoweredAnim);
    }

    simulated function ESplashGuardState GetSplashGuardState()
    {
        return SGS_Lowered;
    }
}

simulated state Transitioning
{
    simulated function ESplashGuardState GetSplashGuardState()
    {
        return SGS_Transitioning;
    }
}

simulated state Lowering extends Transitioning
{
    function BeginState()
    {
        PlayAnim(LoweringAnim);
    }

    function AnimEnd(int Channel)
    {
        GotoState('Lowered');
    }
}

simulated state Raising extends Transitioning
{
    function BeginState()
    {
        PlayAnim(RaisingAnim);
    }

    function AnimEnd(int Channel)
    {
        GotoState('Raised');
    }
}

simulated function ESplashGuardState GetSplashGuardState();

function Raise()
{
    TargetState = SGS_Raised;
}

function Lower()
{
    TargetState = SGS_Lowered;
}

simulated function bool IsRaised() { return GetSplashGuardState() == SGS_Raised; }
simulated function bool IsLowered() { return GetSplashGuardState() == SGS_Lowered; }
simulated function bool IsTransitioning() { return GetSplashGuardState() == SGS_Transitioning; }

function bool Toggle()
{
    if (IsTransitioning())
    {
        // Don't allow toggling while the transition is happening.
        return false;
    }
    else if (IsRaised())
    {
        GotoState('Lowering');
        return true;
    }
    else if (IsLowered())
    {
        GotoState('Raising');
        return true;
    }

    return false;
}

defaultproperties
{
    bReplicateAnimations=true
}
