//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ModifyConditionTrigger extends DH_ModifyActors;

var()   name                ConditionToModifytrue; //Will set tagged condition to true
var()   name                ConditionToModifyfalse; //Will set tagged condition to false
var     TriggeredCondition  ConditiontrueRef;
var     TriggeredCondition  ConditionfalseRef;
var()   bool                UseRandomness;
var()   int                 RandomPercent; // 100 for always succeed, 0 for always fail

function PostBeginPlay()
{
    super.PostBeginPlay();

    //Check to make sure name was set
    if (ConditionToModifytrue != '')
    {   //TriggeredConditions are dynamic so use dynamic actor list
        foreach DynamicActors(class'TriggeredCondition', ConditiontrueRef, ConditionToModifytrue)
        {
            break;
        }
    }
    if (ConditionToModifyfalse != '')
    {
        foreach DynamicActors(class'TriggeredCondition', ConditionfalseRef, ConditionToModifyfalse)
        {
            break;
        }
    }
}

event Trigger(Actor Other, Pawn EventInstigator)
{
    local int RandomNum;

    if (UseRandomness)
    {
        RandomNum = Rand(100);  //Gets a random # between 0 & 99
        if (RandomPercent < RandomNum)
            return; //Leave script as it randomly failed
    }
    if (ConditiontrueRef != none) //Check to make sure the reference exists
        ConditiontrueRef.bEnabled = true; //Change accordingly
    if (ConditionfalseRef != none)
        ConditionfalseRef.bEnabled = false;
}
