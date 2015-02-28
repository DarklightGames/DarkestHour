//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVariableTimedMover extends Mover;

var() bool          bActAsClientMover;
var() array<float>  KeyMoveTime;
var   array<float>  KeyMoveSpeed;


function PostBeginPlay()
{
    local int n;

    for (n = 0; n < KeyMoveTime.Length; n++)
    {
        KeyMoveSpeed[n] = KeyMoveTime[n] * MoveTime;
    }

    KeyMoveSpeed[KeyMoveTime.Length] = 0.0; // this is to prevent OutOfBounds errors on the array

    super.PostBeginPlay();

    MoveTime = KeyMoveSpeed[KeyNum];

    if (bActAsClientMover && Level.NetMode == NM_DedicatedServer)
    {
        SetTimer(0.0, false);
        SetPhysics(PHYS_None);
        GotoState('ServerIdle');
    }
}

// Matt: removed "simulated" as PostBeginPlay isn't called on net client, so nothing gets set & we get "array out of bounds" log errors - looks like this function isn't meant to run on clients
event KeyFrameReached()
{
    if (KeyNum < KeyMoveSpeed.Length)
    {
        MoveTime = KeyMoveSpeed[KeyNum];
    }

    super.KeyFrameReached();
}

function DoOpen()
{
    MoveTime = KeyMoveSpeed[KeyNum];

    super.DoOpen();
}

function DoClose()
{
    MoveTime = KeyMoveSpeed[KeyNum];

    super.DoClose();
}

state ServerIdle
{
    // Do nothing on the Server
}

state() LoopMove
{
    event KeyFrameReached()
    {
        MoveTime = KeyMoveSpeed[KeyNum];

        super.KeyFrameReached();
    }
}

state() ConstantLoop
{
    event KeyFrameReached()
    {
        MoveTime = KeyMoveSpeed[KeyNum];

        super.KeyFrameReached();
    }
}

state() LeadInOutLooper
{
    event KeyFrameReached()
    {
        MoveTime = KeyMoveSpeed[KeyNum];

        super.KeyFrameReached();
    }
}

state LeadInOutLooping
{
    event KeyFrameReached()
    {
        MoveTime = KeyMoveSpeed[KeyNum];

        super.KeyFrameReached();
    }
}

defaultproperties
{
}
