//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ModifySpawnArea extends DH_ModifyActors;

var()   array<name>         SpawnsToModify;
var     array<ROSpawnArea>  SpawnReference;
var()   StatusModifyType    HowToModify;

function PostBeginPlay()
{
    local int i;
    local ROSpawnArea ROSA;

    super.PostBeginPlay();

    //Spawn areas are dynamic so use dynamic actor list
    for (i = 0; i < SpawnsToModify.Length; ++i)
    {
        foreach DynamicActors(class'ROSpawnArea', ROSA, SpawnsToModify[i])
        {
            SpawnReference.Insert(0, 1); //Adds a new spot at index for the attached Spawns
            SpawnReference[0] = ROSA; //Sets the attached Spawns in the reference array
        }
    }
}

event Trigger(Actor Other, Pawn EventInstigator)
{
    local int i;

    switch (HowToModify)
    {
        case SMT_Activate:
            for (i = 0; i < SpawnReference.Length; ++i)
            {
                SpawnReference[i].bEnabled = true; //Activates the Spawn
            }
            break;
        case SMT_Deactivate:
            for (i = 0; i < SpawnReference.Length; ++i)
            {
                SpawnReference[i].bEnabled = false; //Deactivates the Spawn
            }
            break;
        case SMT_Toggle: //Check spawn area status and toggle it
            for (i = 0; i < SpawnReference.Length; ++i)
            {
                SpawnReference[i].bEnabled = !SpawnReference[i].bEnabled;
            }
            break;
        default:
            break;
    }

    //Call game functions to update the spawns, very important or else it doesn't act as desired
    if (ROTeamGame(Level.Game) != none)
    {
        ROTeamGame(Level.Game).CheckTankCrewSpawnAreas();
        ROTeamGame(Level.Game).CheckSpawnAreas();
        ROTeamGame(Level.Game).CheckVehicleFactories();
    }
}
