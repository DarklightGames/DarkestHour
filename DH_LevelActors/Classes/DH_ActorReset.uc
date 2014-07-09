// class: DH_ActorReset
// Auther: Theel
// Date: 9-28-10
// Purpose:
// Adds the ability to reset an actor by an event
// Problems/Limitations:
// Removed random ability

class DH_ActorReset extends DH_LevelActors;

var()	name				ActorToReset;  //Theel & Basnett
var		actor				ActorReference;

function PostBeginPlay()
{
	local Actor	A;

	super.PostBeginPlay();

	if(ActorToReset == '')
		return; //Actor tag wasn't set no reason to continue

	foreach AllActors(class'Actor', A, ActorToReset)
	{
		ActorReference = A;
		break;
	}
}

function Trigger( Actor Other, Pawn EventInstigator )
{
	ActorReference.reset();
}

defaultproperties
{
}
