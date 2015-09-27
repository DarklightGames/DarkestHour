//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHObjectiveManager extends MasterObjectiveManager;

function PostBeginPlay()
{
    if (DarkestHourGame(Level.Game) != None)
    {
        DarkestHourGame(Level.Game).ObjectiveManager = self;
    }
}

// Override to fix issue with RO vs DH objective arrays in DarkestHourGame
function ObjectiveStateChanged()
{
    local int i,j,k;
    local DarkestHourGame DHGame;
    local bool bReadyToModify;

    DHGame = DarkestHourGame(Level.Game);

    for (i = 0; i < ObjectiveManagers.Length; i++)
    {
        for (k = 0; k < ArrayCount(DHGame.DHObjectives); k++)
        {
            bReadyToModify = true;

            for (j = 0; j < ObjectiveManagers[i].AxisRequiredObjectives.Length; j++)
            {
                if (DHGame.DHObjectives[ObjectiveManagers[i].AxisRequiredObjectives[j]].ObjState != OBJ_Axis)
                {
                    bReadyToModify = false;
                    break;
                }
            }

            for (j = 0; j < ObjectiveManagers[i].AlliesRequiredObjectives.Length; j++)
            {
                if (DHGame.DHObjectives[ObjectiveManagers[i].AlliesRequiredObjectives[j]].ObjState != OBJ_Allies)
                {
                    bReadyToModify = false;
                    break;
                }
            }

            if (bReadyToModify)
            {
                for (j = 0; j < ObjectiveManagers[i].AxisObjectivesToModify.Length; j++)
                {
                    if (ObjectiveManagers[i].ActivationStyle == AS_Activate)
                    {
                        DHGame.DHObjectives[ObjectiveManagers[i].AxisObjectivesToModify[j]].bActive = true;
                    }
                    else
                    {
                        DHGame.DHObjectives[ObjectiveManagers[i].AxisObjectivesToModify[j]].bActive = false;
                    }

                    DHGame.FindNewObjectives(DHGame.DHObjectives[ObjectiveManagers[i].AxisObjectivesToModify[j]]);
                    DHGame.DHObjectives[ObjectiveManagers[i].AxisObjectivesToModify[j]].NotifyStateChanged();
                }

                for (j = 0; j < ObjectiveManagers[i].AlliesObjectivesToModify.Length; j++)
                {
                    if (ObjectiveManagers[i].ActivationStyle == AS_Activate)
                    {
                        DHGame.DHObjectives[ObjectiveManagers[i].AlliesObjectivesToModify[j]].bActive = true;
                    }
                    else
                    {
                        DHGame.DHObjectives[ObjectiveManagers[i].AlliesObjectivesToModify[j]].bActive = false;
                    }

                    DHGame.FindNewObjectives(DHGame.DHObjectives[ObjectiveManagers[i].AlliesObjectivesToModify[j]]);
                    DHGame.DHObjectives[ObjectiveManagers[i].AlliesObjectivesToModify[j]].NotifyStateChanged();
                }
            }
        }
    }
}

defaultproperties
{
}
