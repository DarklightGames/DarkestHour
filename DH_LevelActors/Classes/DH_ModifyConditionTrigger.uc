// class: DH_ModifyConditionTrigger
// Auther: Theel
// Date: 10-04-10
// Purpose:
// Ability to easily change to condition triggers and works will with ConditionArrayCheck
// Problems/Limitations:
// Doesn't support array of names

class DH_ModifyConditionTrigger extends DH_ModifyActors;

var()   name          		ConditionToModifyTrue; //Will set tagged condition to true
var()   name          		ConditionToModifyFalse; //Will set tagged condition to false
var		TriggeredCondition	ConditionTrueRef;
var		TriggeredCondition	ConditionFalseRef;
var()	bool				UseRandomness;
var()	int 				RandomPercent; // 100 for always succeed, 0 for always fail

function PostBeginPlay()
{
	local TriggeredCondition	TD;

	super.PostBeginPlay();

	//Check to make sure name was set
	if(ConditionToModifyTrue != '')
	{	//TriggeredConditions are dynamic so use dynamic actor list
		foreach DynamicActors(class'TriggeredCondition', TD, ConditionToModifyTrue)
		{
			ConditionTrueRef = TD;
			break;
		}
	}
	if(ConditionToModifyFalse != '')
	{
		foreach DynamicActors(class'TriggeredCondition', TD, ConditionToModifyFalse)
		{
			ConditionFalseRef = TD;
			break;
		}
	}
}

event Trigger(Actor Other, Pawn EventInstigator)
{
	local int RandomNum;

	if(UseRandomness)
	{
		RandomNum = Rand(101);  //Gets a random # between 0 & 100
		if(RandomPercent <= RandomNum)
			return; //Leave script as it randomly failed
	}
	if(ConditionTrueRef != None) //Check to make sure the reference exists
		ConditionTrueRef.bEnabled = true; //Change accordingly
	if(ConditionFalseRef != None)
		ConditionFalseRef.bEnabled = false;
}

defaultproperties
{
}
