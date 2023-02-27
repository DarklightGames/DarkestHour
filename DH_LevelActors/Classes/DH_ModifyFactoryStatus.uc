//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ModifyFactoryStatus extends DH_ModifyActors;

var()   array<name>             FactoryToModify;
var()   bool                    bChangeUseSpawnArea;
var()   bool                    bUseSpawnArea;
var     array<ROVehicleFactory> FactoryReference;
var()   bool                    bInstantDestroyEmpty; //Will instantly destroy vehicle if empty
var()   bool                    UseRandomness;
var()   int                     RandomPercent; // 100 for always succeed, 0 for always fail
var()   StatusModifyType        HowToModify;

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
    local int i, RandomNum;

    if (UseRandomness)
    {
        RandomNum = Rand(100);  //Gets a random # between 0 & 99
        if (RandomPercent < RandomNum)
            return; //Leave script as it randomly failed
    }
    switch (HowToModify)
    {
        case SMT_Activate:
            for (i = 0; i < FactoryReference.Length; ++i)
            {
                FactoryReference[i].Activate(FactoryReference[i].TeamNum); //Activates the factory
                if (bChangeUseSpawnArea)
                    FactoryReference[i].bUsesSpawnAreas = bUseSpawnArea;
            }
        break;
        case SMT_Deactivate:
            for (i = 0; i < FactoryReference.Length; ++i)
            {
                FactoryReference[i].Deactivate(); //Deactivates the factory

                if (bChangeUseSpawnArea)
                    FactoryReference[i].bUsesSpawnAreas = bUseSpawnArea;

                //Check to see if leveler set bInstantDestroyEmpty and if the vehicle is empty
                if (FactoryReference[i].LastSpawnedVehicle != none && bInstantDestroyEmpty && ROVehicle(FactoryReference[i].LastSpawnedVehicle).IsVehicleEmpty())
                    ROVehicle(FactoryReference[i].LastSpawnedVehicle).Destroy(); //Destroy the vehicle
            }
        break;
        case SMT_Toggle: //Check factory status and toggle it
            for (i = 0; i < FactoryReference.Length; ++i)
            {
                if (!FactoryReference[i].bFactoryActive)
                {
                    FactoryReference[i].Activate(FactoryReference[i].TeamNum);
                    if (bChangeUseSpawnArea)
                        FactoryReference[i].bUsesSpawnAreas = bUseSpawnArea;
                }
                else
                {
                    FactoryReference[i].Deactivate();

                    if (bChangeUseSpawnArea)
                        FactoryReference[i].bUsesSpawnAreas = bUseSpawnArea;

                    if (FactoryReference[i].LastSpawnedVehicle != none && bInstantDestroyEmpty && ROVehicle(FactoryReference[i].LastSpawnedVehicle).IsVehicleEmpty())
                        ROVehicle(FactoryReference[i].LastSpawnedVehicle).Destroy();
                }
            }
        break;
        default:
        break;
    }
}
