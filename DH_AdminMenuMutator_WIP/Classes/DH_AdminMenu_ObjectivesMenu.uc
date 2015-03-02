//========================================================================================
// DH_AdminMenu_ObjectivesMenu - by Matt UK
//========================================================================================
//
// Displays a list of map objectives for paradropping a player, team or all players
// This menu will only be loaded if paradrop or realism options are allowed by the server
//
//========================================================================================
class DH_AdminMenu_ObjectivesMenu extends DH_AdminMenu_MenuBase;

exec function ObjectivesMenu(string Action, optional string PlayerName)
{
    if (!bInitialVariablesSet)
    {
        bInitialVariablesSet = true;
        GetAllObjectiveNames();
    }

    if (Action != "")
    {
        if (PlayerName != "") // if have player name we must have got here from actions menu for that player, so we'll return there if we press 'previous menu' key
        {
            PreviousMenu = "PlayerActionsMenu" @ PlayerName;
        }
        else // otherwise we must have got here from the realism menu so we'll return there if we press 'previous menu'
        {
            PreviousMenu = "RealismMenu";
        }

        SelectionPrefix = Action @ PlayerName; // sets variables to be used in the generic HandleInput function, which avoids having to redefine it here        
        GoToState('MenuVisible');
    }
}

function GetAllObjectiveNames()
{
    local  ROGameReplicationInfo  GRI;
    local  int  i;

    MenuText.Length = 0;
    GRI = ROGameReplicationInfo(PC.GameReplicationInfo);

    for (i = 0; i < arraycount(GRI.Objectives); ++i)
    {
        if (GRI.Objectives[i] != none)
        {
            MenuText[i] = GRI.Objectives[i].ObjName;
        }
    }
}

exec function ParaDropPlayerAtObjective(string PlayerName, string ObjectiveName, string ObjectiveIndex)
{
    BuildMutateCommand("ParaDropPlayer" @ PlayerName @ "AtObjective" @ ObjectiveName @ ObjectiveIndex, 7);
}

exec function ParaDropAlliesAtObjective(string ObjectiveName, string ObjectiveIndex)
{
    BuildMutateCommand("ParaDropAll Allies AtObjective" @ ObjectiveName @ ObjectiveIndex, 13);
}

exec function ParaDropAxisAtObjective(string ObjectiveName, string ObjectiveIndex)
{ 
    BuildMutateCommand("ParaDropAll Axis AtObjective" @ ObjectiveName @ ObjectiveIndex, 14);
}

exec function ParaDropAllAtObjective(string ObjectiveName, string ObjectiveIndex)
{ 
    BuildMutateCommand("ParaDropAll Players AtObjective" @ ObjectiveName @ ObjectiveIndex, 15);
}

defaultproperties
{
    MenuTitle="OBJECTIVE SELECTION MENU"
    bUseMenuTextAsMenuCommand=true
    bTreatSelectionAsOneWord=true
    bUseSelectionIndexAsSuffix=true
}
