//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ModifySpawnPoint extends DH_ModifyActors;

var()   array<name>         SpawnPointsToModify; // leveller specifies the tag(s) of spawn point(s) to be modified
var()   StatusModifyType    HowToModify;         // leveller specifies whether the spawn point(s) is to be enabled, disabled or have its status toggled

function PostBeginPlay()
{
    super.PostBeginPlay();

    if (SpawnPointsToModify.Length == 0)
    {
        Log("WARNING:" @ Name @ "has no specified SpawnPointsToModify & is now self-destructing!");
        Destroy();
    }
}

event Trigger(Actor Other, Pawn EventInstigator)
{
    local DHSpawnManager SM;
    local int            i;

    if (DarkestHourGame(Level.Game) != none)
    {
        SM = DarkestHourGame(Level.Game).SpawnManager;

        if (SM != none)
        {
            for (i = 0; i < SpawnPointsToModify.Length; ++i)
            {
                switch (HowToModify)
                {
                    case SMT_Activate:
                        SM.SetSpawnPointIsActiveByTag(SpawnPointsToModify[i], true);
                        break;
                    case SMT_Deactivate:
                        SM.SetSpawnPointIsActiveByTag(SpawnPointsToModify[i], false);
                        break;
                    case SMT_Toggle:
                        SM.ToggleSpawnPointIsActiveByTag(SpawnPointsToModify[i]);
                        break;
                    default:
                        break;
                }
            }
        }
    }
}


