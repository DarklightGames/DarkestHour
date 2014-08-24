class EA_ModifySpawnStatus extends DH_ModifyActors;

var()   array<name>             SpawnsToModify;
var     array<ROSpawnArea>      SpawnReference;
var()   StatusModifyType        HowToModify;

function PostBeginPlay()
{
    local int               i;
    local ROSpawnArea       ROSA;

    super.PostBeginPlay();

    //Spawns are dynamic so use dynamic actor list
    for(i=0; i<SpawnsToModify.Length; i++)
    {
        foreach DynamicActors(class'ROSpawnArea', ROSA, SpawnsToModify[i])
        {
            SpawnReference.Insert(0,1); //Adds a new spot at index for the attached Spawns
            SpawnReference[0] = ROSA; //Sets the attached Spawns in the reference array
        }
    }
}

event Trigger(Actor Other, Pawn EventInstigator)
{
    local int i;

    switch(HowToModify)
    {
        case SMT_Activate:
            for(i=0; i<SpawnReference.Length; i++)
                SpawnReference[i].bEnabled = True; //Activates the Spawn
        break;
        case SMT_Deactivate:
            for(i=0; i<SpawnReference.Length; i++)
                SpawnReference[i].bEnabled = False; //Deactivates the Spawn
        break;
        case SMT_Toggle: //Check spawn area status and toggle it
            for(i=0; i<SpawnReference.Length; i++)
            {
                if(!SpawnReference[i].bEnabled)
                    SpawnReference[i].bEnabled = True; //Activates the Spawn
                else
                    SpawnReference[i].bEnabled = False; //Deactivates the Spawn
            }
        break;
        default:
        break;
    }

    //I think I gotta call a game function to tell it to update
    if (ROTeamGame(Level.Game) != None)
    {
        ROTeamGame(Level.Game).CheckTankCrewSpawnAreas();
        ROTeamGame(Level.Game).CheckSpawnAreas();

        ROTeamGame(Level.Game).CheckVehicleFactories();
    }


}

defaultproperties
{
}
