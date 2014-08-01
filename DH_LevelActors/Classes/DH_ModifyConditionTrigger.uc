// class: DH_ModifyConditionTrigger
// Auther: Theel
// Date: 10-04-10
// Purpose:
// Ability to easily change to condition triggers and works will with ConditionArrayCheck
// Problems/Limitations:
// Doesn't support array of names

class DH_ModifyConditionTrigger extends DH_ModifyActors;

var()   name          		ConditionToModifytrue; //Will set tagged condition to true
var()   name          		ConditionToModifyfalse; //Will set tagged condition to false
var		TriggeredCondition	ConditiontrueRef;
var		TriggeredCondition	ConditionfalseRef;
var()	bool				UseRandomness;
var()	int 				RandomPercent; // 100 for always succeed, 0 for always fail

function PostBeginPlay()
{
	local TriggeredCondition	TD;

	super.PostBeginPlay();

	//Check to make sure name was set
	if (ConditionToModifytrue != '')
	{	//TriggeredConditions are dynamic so use dynamic actor list
		foreach DynamicActors(class'TriggeredCondition', TD, ConditionToModifytrue)
		{
			ConditiontrueRef = TD;
			break;
		}
	}
	if (ConditionToModifyfalse != '')
	{
		foreach DynamicActors(class'TriggeredCondition', TD, ConditionToModifyfalse)
		{
			ConditionfalseRef = TD;
			break;
		}
	}
}

event Trigger(Actor Other, Pawn EventInstigator)
{
	local int RandomNum;

	if (UseRandomness)
	{
		RandomNum = Rand(101);  //Gets a random # between 0 & 100
		if (RandomPercent <= RandomNum)
			return; //Leave script as it randomly failed
	}
	if (ConditiontrueRef != none) //Check to make sure the reference exists
		ConditiontrueRef.bEnabled = true; //Change accordingly
	if (ConditionfalseRef != none)
		ConditionfalseRef.bEnabled = false;
}

defaultproperties
{
}
