//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ModifyObjectiveStatus extends DH_ModifyActors;

enum ETypeOfRandom
{
    TR_NoRandom,
    TR_Percentage,
    TR_MaxToModify
};

var()   ETypeOfRandom       HowToRandom; //Decides how to randomize the modification of each objective on the list
var()   array<int>          ObjectivesNumsToModify;  //List of objective numbers to potentionally modify
var()   int                 RandomPercent; //100 for always succeed, 0 for always fail
var()   int                 MaxNumToModify; //In the random loop, it will stop once this number is hit
var()   StatusModifyType    HowToModify; //How to modify the objectives that are selected

event Trigger(Actor Other, Pawn EventInstigator)
{
    local int RandomNum, i;
    local bool  NewStatus;
    local DarkestHourGame DHGame;
    local array<int> TempObjNumsModify;

    DHGame = DarkestHourGame(Level.Game); //Get Game Info

    switch (HowToRandom)
    {
        case TR_NoRandom:
            for (i = 0; i < ObjectivesNumsToModify.Length; ++i)
            {
                switch (HowToModify)
                {
                    case SMT_Activate:
                        DHGame.DHObjectives[ObjectivesNumsToModify[i]].SetActive(true);
                    break;
                    case SMT_Deactivate:
                        DHGame.DHObjectives[ObjectivesNumsToModify[i]].SetActive(false);
                    break;
                    case SMT_Toggle:
                        NewStatus = !DHGame.DHObjectives[ObjectivesNumsToModify[i]].bActive;
                        DHGame.DHObjectives[ObjectivesNumsToModify[i]].SetActive(NewStatus);
                    break;
                }
            }
        break;
        case TR_Percentage:
            for (i = 0; i < ObjectivesNumsToModify.Length; ++i)
            {
                RandomNum = Rand(100);  //Gets a random # between 0 & 99
                if (RandomPercent > RandomNum)
                {
                    switch (HowToModify)
                    {
                        case SMT_Activate:
                            DHGame.DHObjectives[ObjectivesNumsToModify[i]].SetActive(true);
                        break;
                        case SMT_Deactivate:
                            DHGame.DHObjectives[ObjectivesNumsToModify[i]].SetActive(false);
                        break;
                        case SMT_Toggle:
                            NewStatus = !DHGame.DHObjectives[ObjectivesNumsToModify[i]].bActive;
                            DHGame.DHObjectives[ObjectivesNumsToModify[i]].SetActive(NewStatus);
                        break;
                    }
                }
                else {}
                    //do nothing for it randomly failed
            }
        break;
        case TR_MaxToModify:
            TempObjNumsModify = ObjectivesNumsToModify; //Setup a temp array = to ObjectiveNumsToModify
            for (i = 0; i < MaxNumToModify; ++i)
            {
                if (TempObjNumsModify.Length <= 0) //Check to make sure we don't do more times than needed
                    break; //break out of the for loop because we won't be changing anymore

                RandomNum = Rand(TempObjNumsModify.Length); //Select an element in the array to modify
                switch (HowToModify)
                {
                    case SMT_Activate:
                        DHGame.DHObjectives[TempObjNumsModify[RandomNum]].SetActive(true);
                    break;
                    case SMT_Deactivate:
                        DHGame.DHObjectives[TempObjNumsModify[RandomNum]].SetActive(false);
                    break;
                    case SMT_Toggle:
                        NewStatus = !DHGame.DHObjectives[TempObjNumsModify[RandomNum]].bActive;
                        DHGame.DHObjectives[TempObjNumsModify[RandomNum]].SetActive(NewStatus);
                    break;
                }
                //Remove the element in the array so we don't select it again
                TempObjNumsModify.Remove(RandomNum, 1);
            }
        break;
    }
}
