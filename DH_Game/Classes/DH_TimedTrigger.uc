//=============================================================================
// class TimedTrigger
// A trigger that triggers after a given delay.
//=============================================================================

class DH_TimedTrigger extends Trigger;

var( ) 	float 	DelayTime;

var( )	bool	bIsStateOne;

simulated function PostBeginPlay( )
{
   	// Set up the timer, then tell our parent:
   	SetTimer(DelayTime, false);

   	Super.PostBeginPlay();
}

// The timer will go off every 'DelayTime' seconds:
simulated function Timer( )
{
   	// Trigger:
	if(bIsStateOne)
	{
   		TriggerEvent(Event, self, none);
   		Log("TRIGGERED EVENT!");
		bIsStateOne=false;
	}
}

// Reset actor to initial state - used when restarting level without reloading.
function Reset()
{
	Super.Reset();

	// collision, bInitiallyactive
	bInitiallyActive = bSavedInitialActive;
	SetCollision(bSavedInitialCollision, bBlockActors );

	//re-trigger event to revert back to initial state then reset timer:
	if( !bIsStateOne )
	{
   		TriggerEvent(Event, self, none);
   		Log("TRIGGERED EVENT TO RESET!");
		bIsStateOne=true;
	}

	SetTimer(DelayTime, false);
}

defaultproperties
{
     DelayTime=60.000000
     bIsStateOne=True
}
