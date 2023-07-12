//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ConditionArrayCheck extends DH_LevelActors;

var()   array<name>                 ConditionsToCheck;  //Array of names to add to the reference array
var     array<TriggeredCondition>   ConditionReferenceArray;
var()   bool                        bTriggerIf; //set this to what will call event for
var()   name                        EventToTrigger; //will call this tag if successful
var()   bool                        UseRandomness;
var()   int                         RandomPercent; // 100 for always succeed, 0 for always fail

// Setup condition references
function PostBeginPlay()
{
    local int                   i;
    local TriggeredCondition    TC;

    super.PostBeginPlay();

    for (i = 0; i < ConditionsToCheck.Length; ++i)
    {
        foreach AllActors(class'TriggeredCondition', TC, ConditionsToCheck[i])
        {
            ConditionReferenceArray.Insert(0, 1); //Adds a new spot at index for the conditionref
            ConditionReferenceArray[0] = TC; //Sets the conditionref in the reference array
            break;
        }
    }
}

event Trigger(Actor Other, Pawn EventInstigator)
{
    local int RandomNum, i;

    for (i = 0; i < ConditionReferenceArray.Length; ++i)
    {
        if (UseRandomness)
        {
            RandomNum = Rand(100);  //Gets a random # between 0 & 99
            if (RandomPercent < RandomNum)
                continue; //continue for loop, but skip this one
        }
        if (ConditionReferenceArray[i].bEnabled == bTriggerIf)
            TriggerEvent(EventToTrigger, self, none);
    }
}
