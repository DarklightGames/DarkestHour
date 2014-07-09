// class: DH_SwitchLevel
// Auther: Theel
// Date: 9-28-10
// Purpose:
// Adds the ability to change to a certain level based on an event
// Problems/Limitations:
// Does not check if the level is on the server (can disconnect clients if not used properly)

class DH_SwitchLevel extends DH_LevelActors;

var()	string		LevelName;

function Trigger(Actor Other, Pawn EventInstigator)
{
	Level.ServerTravel(LevelName, false);
}

defaultproperties
{
}
