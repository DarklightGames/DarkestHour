//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ModifyFactoryRespawn extends DH_ModifyActors;

var()   array<name>             FactoryToModify;
var     array<ROVehicleFactory> FactoryReference;
var()   bool                    UseRandomness;
var()   int                     RandomPercent; // 100 for always succeed, 0 for always fail
var()   NumModifyType           HowToModifyRespawnLimit;
var()   int                     MinModifyNum;
var()   int                     MaxModifyNum;

function PostBeginPlay()
{
    local int               i;
    local ROVehicleFactory  ROVF;

    super.PostBeginPlay();

    //Factories are dynamic so use dynamic actor list
    for (i = 0; i < FactoryToModify.Length; ++i)
    {
        foreach DynamicActors(class'ROVehicleFactory', ROVF, FactoryToModify[i])
        {
            FactoryReference.Insert(0, 1); //Adds a new spot at index for the attached factory
            FactoryReference[0] = ROVF; //Sets the attached factory in the reference array
        }
    }
}

event Trigger(Actor Other, Pawn EventInstigator)
{
    local int i, RandomNum, ModifyActual;

    if (UseRandomness)
    {
        RandomNum = Rand(100);  //Gets a random # between 0 & 99
        if (RandomPercent < RandomNum)
            return; //Leave script as it randomly failed
    }

    //Get num to modify by
    ModifyActual = RandRange(MinModifyNum, MaxModifyNum);

    switch (HowToModifyRespawnLimit)
    {
        case NMT_Add:
            for (i = 0; i < FactoryReference.Length; ++i)
            {
                FactoryReference[i].VehicleRespawnLimit += ModifyActual; //Add the ammount
            }
        break;
        case NMT_Subtract:
            for (i = 0; i < FactoryReference.Length; ++i)
            {
                FactoryReference[i].VehicleRespawnLimit -= ModifyActual; //Subtract the ammount
            }
        break;
        case NMT_Set: //Check factory status and toggle it
            for (i = 0; i < FactoryReference.Length; ++i)
            {
                FactoryReference[i].VehicleRespawnLimit = ModifyActual; //Set the ammount
            }
        break;
        default:
        break;
    }
}
