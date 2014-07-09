// class: DH_ModifyDefendingSide
// Auther: Theel
// Date: 10-04-10
// Purpose:
// Ability to change the defending team from event.  Helps with getting counter attack setups
// Problems/Limitations:
// None

class DH_ModifyDefendingSide extends DH_ModifyActors;

var()	ROSideIndex		NewDefendingSide;

event Trigger(Actor Other, Pawn EventInstigator)
{
	switch(NewDefendingSide)
	{
		//Change Defending Side To None
		case NEUTRAL:
				ROTeamGame(Level.Game).LevelInfo.DefendingSide = SIDE_None;
			break;
		//Change Defending Side To Axis
		case AXIS:
				ROTeamGame(Level.Game).LevelInfo.DefendingSide = SIDE_Axis;
			break;
		//Change Defending Side To Allies
		case ALLIES:
				ROTeamGame(Level.Game).LevelInfo.DefendingSide = SIDE_Allies;
			break;
		default:
			break;
	}
}

defaultproperties
{
}
