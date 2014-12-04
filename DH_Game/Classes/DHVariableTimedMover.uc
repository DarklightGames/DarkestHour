//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHVariableTimedMover extends Mover;

var() bool bActAsClientMover;
var() array<float> KeyMoveTime;
var array<float> KeyMoveSpeed;

function PostBeginPlay()
{
    local int n;

    for (n = 0; n < KeyMoveTime.length; n++)
    {
        KeyMoveSpeed[n] = KeyMoveTime[n] * MoveTime;
    }

    KeyMoveSpeed[KeyMoveTime.length] = 0; // This is to prevent OutofBounds errors on the array

    super.PostBeginPlay();

    MoveTime = KeyMoveSpeed[ KeyNum ];

    if (bActAsClientMover && Level.NetMode == NM_DedicatedServer)
    {
        SetTimer(0, false);
        SetPhysics(PHYS_None);
        GotoState('ServerIdle');
    }
}

simulated event KeyFrameReached()
{
MoveTime = KeyMoveSpeed[ KeyNum ];
super.KeyFrameReached();
}

function DoOpen()
{
MoveTime = KeyMoveSpeed[ KeyNum ];
super.DoOpen();
}

function DoClose()
{
MoveTime = KeyMoveSpeed[ KeyNum ];
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
MoveTime = KeyMoveSpeed[ KeyNum ];
super.KeyFrameReached();
}
}

state() ConstantLoop
{
event KeyFrameReached()
{
MoveTime = KeyMoveSpeed[ KeyNum ];
super.KeyFrameReached();
}
}

state() LeadInOutLooper
{
event KeyFrameReached()
{
MoveTime = KeyMoveSpeed[ KeyNum ];
super.KeyFrameReached();
}
}

state LeadInOutLooping
{
event KeyFrameReached()
{
MoveTime = KeyMoveSpeed[ KeyNum ];
super.KeyFrameReached();
}
}

defaultproperties
{
}
