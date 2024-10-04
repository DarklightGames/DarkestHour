//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// This actor can be attached to any vehicle to provide a toggleable animated
// element on any vehicle.
//==============================================================================

class DHVehicleComponentController extends Actor
    notplaceable;

var int     Channel;
var name    BoneName;
var name    RaisingAnim;
var name    LoweringAnim;

enum EControllerState
{
    STATE_Raised,
    STATE_Lowered,
};

var private EControllerState TargetState;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        Channel, BoneName, RaisingAnim, LoweringAnim;
    reliable if (bNetDirty && Role == ROLE_Authority)
        TargetState;
}

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if (Role < ROLE_Authority)
    {
        SetAnimBlendParams();
    }
}

simulated function SetAnimBlendParams()
{
    Owner.AnimBlendParams(Channel, 1.0, 0.0, 0.0, BoneName);
}

function SetControllerState(EControllerState NewState)
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
    if (GetControllerState() != TargetState)
    {
        if (TargetState == STATE_Raised)
        {
            GotoState('Raising');
        }
        else if (TargetState == STATE_Lowered)
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

    simulated function EControllerState GetControllerState()
    {
        return STATE_Raised;
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

    simulated function EControllerState GetControllerState()
    {
        return STATE_Lowered;
    }
}

simulated state Transitioning
{
    simulated function bool IsTransitioning() { return true; }
}

simulated state Lowering extends Transitioning
{
Begin:
    Owner.PlayAnim(LoweringAnim, 1.0, 0.0, Channel);
    Sleep(Owner.GetAnimDuration(LoweringAnim));
    GotoState('Lowered');
}

simulated state Raising extends Transitioning
{
Begin:
    Owner.PlayAnim(RaisingAnim, 1.0, 0.0, Channel);
    Sleep(Owner.GetAnimDuration(RaisingAnim));
    GotoState('Raised');
}

simulated function EControllerState GetControllerState();

function Raise()
{
    SetControllerState(STATE_Raised);
}

function Lower()
{
    SetControllerState(STATE_Lowered);
}

simulated function bool IsTransitioning() { return false; }
simulated function bool IsRaised() { return GetControllerState() == STATE_Raised; }
simulated function bool IsLowered() { return GetControllerState() == STATE_Lowered; }

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
    RemoteRole=ROLE_DumbProxy
    bNetNotify=true
}
