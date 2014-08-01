// class: DH_DestroyableSM
// Auther: Theel
// Date: 10-04-10
// Purpose:
// Adds the ability to toggle status of the DSM and adds other functionality
// Problems/Limitations:
// none known

class DH_DestroyableSM extends RODestroyableStaticMeshBase;

//Overridden Trigger function to allow toggling
function Trigger(actor Other, pawn EventInstigator)
{
	if (EventInstigator != none)
		MakeNoise(1.0);
	//if destroyed goto state working (basically repairs it)
	if (bDamaged)
		Gotostate('Working');
	else //it's not destroyed, lets destroy it
	{
		Health = 0;
		TriggerEvent(DestroyedEvent, self, EventInstigator);
		BroadcastCriticalMessage(EventInstigator);
		BreakApart(Location);
	}
}

function DestroyDSM()
{
	Health = 0;
	TriggerEvent(DestroyedEvent, self, none);
	BroadcastCriticalMessage(none);
	BreakApart(Location);
}

defaultproperties
{
}
