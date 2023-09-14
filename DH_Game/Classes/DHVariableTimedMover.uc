//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVariableTimedMover extends Mover;

var()   bool            bActAsClientMover;
var()   array<float>    KeyMoveTime;
var     array<float>    KeyMoveSpeed;

function PostBeginPlay()
{
    local int i;

    for (i = 0; i < KeyMoveTime.Length; ++i)
    {
        KeyMoveSpeed[i] = KeyMoveTime[i] * MoveTime;
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

// Removed "simulated" as PostBeginPlay isn't simulated & so doesn't run on a net client, so nothing gets set upper_bound
// If this function is simulated it runs on a client & we get "array out of bounds" log errors - looks like this function isn't meant to run clientside
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

// Do nothing on the server
state ServerIdle
{
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
