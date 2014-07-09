// class: DH_TriggerArrayActor
// Auther: Theel
// Date: 12-19-10
// Purpose:
// Adds the ability to easily trigger multiple events from one event (dont' do too many!)
// Problems/Limitations:
// Not optimized because lots of events, has no random abilities,

class DH_TriggerArrayActor extends DH_LevelActors;

var()	bool						bFireOnce;
var		bool						bFired;
var()	array<name>					EventsToTrigger;

function Trigger( Actor Other, Pawn EventInstigator )
{
	local int i;

	if(!bFireOnce && !bFired)
	{
  		//Start the loop to trigger all the events we need
		for(i=0;i<EventsToTrigger.Length;i++)
			TriggerEvent(EventsToTrigger[i], self, none); //Triggers the events

		bFired = True;
	}
}

function Reset()
{
	bFired = false; //Because round reset, bFired should be set back to false
}

defaultproperties
{
}
