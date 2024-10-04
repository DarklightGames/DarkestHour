//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_DUKWSplashGuard extends Actor
    notplaceable;

var int     SplashGuardAnimationChannel;
var name    SplashGuardBone;
var name    RaisingAnim;
var name    LoweringAnim;

enum ESplashGuardState
{
    SGS_Raised,
    SGS_Lowered,
};

var private ESplashGuardState TargetState;

replication
{
    reliable if (Role == ROLE_Authority)
        TargetState;
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    // Set up the animation channel.
    // TODO: what about out-of-order replication?
    Owner.AnimBlendParams(SplashGuardAnimationChannel, 1.0, 0.0, 0.0, SplashGuardBone);
}

function SetSplashGuardState(ESplashGuardState NewState)
{
    TargetState = NewState;

    CheckState();
}

simulated function PostNetReceive()
{
    super.PostNetReceive();

    CheckState();
}

// Checks the current state vs the target state and transitions if necessary.
simulated function CheckState()
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

auto simulated state Raised
{
    simulated function BeginState()
    {
        // The target state may have changed during the transition, so
        // check the state again.
        CheckState();
    }

    simulated function ESplashGuardState GetSplashGuardState()
    {
        return SGS_Raised;
    }
}

simulated state Lowered
{
    simulated function BeginState()
    {
        // The target state may have changed during the transition, so
        // check the state again.
        CheckState();
    }

    simulated function ESplashGuardState GetSplashGuardState()
    {
        return SGS_Lowered;
    }
}

simulated state Transitioning
{
    simulated function bool IsTransitioning() { return true; }
}

simulated state Lowering extends Transitioning
{
Begin:
    Owner.PlayAnim(LoweringAnim, 1.0, 0.0, SplashGuardAnimationChannel);
    Sleep(Owner.GetAnimDuration(LoweringAnim));
    GotoState('Lowered');
}

simulated state Raising extends Transitioning
{
Begin:
    Owner.PlayAnim(RaisingAnim, 1.0, 0.0, SplashGuardAnimationChannel);
    Sleep(Owner.GetAnimDuration(RaisingAnim));
    GotoState('Raised');
}

simulated function ESplashGuardState GetSplashGuardState();

function Raise()
{
    SetSplashGuardState(SGS_Raised);
}

function Lower()
{
    SetSplashGuardState(SGS_Lowered);
}

simulated function bool IsTransitioning() { return false; }
simulated function bool IsRaised() { return GetSplashGuardState() == SGS_Raised; }
simulated function bool IsLowered() { return GetSplashGuardState() == SGS_Lowered; }

// Returns true if the splash guard was toggled, false otherwise.
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
    bHidden=true
    SplashGuardAnimationChannel=2
    SplashGuardBone="SPLASH_GUARD"
    RaisingAnim="splash_guard_up"
    LoweringAnim="splash_guard_down"
    RemoteRole=ROLE_DumbProxy
    bNetNotify=true
}
