//================================================== ===========================
// VariableTimedMover
// Allows custom MoveTimes per key (modified from a version by Fataloverdose)
// by SuperApe -- Sept 2005
// Modified again by PsYcH0_Ch!cKeN -- July 2008
//================================================== ===========================
class DHVariableTimedMover extends Mover;

var() bool bActAsClientMover;
var() array<float> KeyMoveTime;
var array<float> KeyMoveSpeed;

function PostBeginPlay()
{
	local int n;

	for ( n = 0; n < KeyMoveTime.length; n++ )
	{
		KeyMoveSpeed[n] = KeyMoveTime[n] * MoveTime;
	}

    KeyMoveSpeed[KeyMoveTime.length] = 0; // This is to prevent OutofBounds errors on the array

	Super.PostBeginPlay();

	MoveTime = KeyMoveSpeed[ KeyNum ];

	if ( bActAsClientMover && Level.NetMode == NM_DedicatedServer )
	{
		SetTimer( 0, false );
		SetPhysics( PHYS_None );
		GotoState('ServerIdle');
	}
}

simulated event KeyFrameReached()
{
MoveTime = KeyMoveSpeed[ KeyNum ];
Super.KeyFrameReached();
}

function DoOpen()
{
MoveTime = KeyMoveSpeed[ KeyNum ];
Super.DoOpen();
}

function DoClose()
{
MoveTime = KeyMoveSpeed[ KeyNum ];
Super.DoClose();
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
Super.KeyFrameReached();
}
}

state() ConstantLoop
{
event KeyFrameReached()
{
MoveTime = KeyMoveSpeed[ KeyNum ];
Super.KeyFrameReached();
}
}

state() LeadInOutLooper
{
event KeyFrameReached()
{
MoveTime = KeyMoveSpeed[ KeyNum ];
Super.KeyFrameReached();
}
}

state LeadInOutLooping
{
event KeyFrameReached()
{
MoveTime = KeyMoveSpeed[ KeyNum ];
Super.KeyFrameReached();
}
}

defaultproperties
{
}
