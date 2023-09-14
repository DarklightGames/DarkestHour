//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

// Displays a list of actions for a chosen player (paradrop options will only display if they are allowed by the server)
class DHAdminMenu_PlayerActionsMenu extends DHAdminMenu_MenuBase;

exec function PlayerActionsMenu(string PlayerName)
{
    if (!bInitialVariablesSet)
    {
        bInitialVariablesSet = true;

        if (Replicator == none || !Replicator.bParaDropPlayerAllowed) // if paradrops are not enabled on the server then remove those menu options
        {
            MenuText.Length = MenuText.Length - 3;
            MenuCommand.Length = MenuCommand.Length - 3;
        }
    }

    if (PlayerName != "")
    {
        MenuTitle = default.MenuTitle @ PlayerName; // adds player name to menu title
        SelectionSuffix = PlayerName;
        GotoState('MenuVisible');
    }
}

exec function RenamePlayer(string OldPlayerName, string NewPlayerName)
{
    BuildMutateCommand("RenamePlayer" @ OldPlayerName @ NewPlayerName, 1);
}

exec function PrivateMessageToPlayer(string PlayerName)
{
    BuildMutateCommand("PrivateMessageToPlayer" @ PlayerName $ " ", 2);
}

exec function WarningMessageToPlayer(string PlayerName)
{
    BuildMutateCommand("WarningMessageToPlayer" @ PlayerName $ " ", 3);
}

exec function KickPlayerWithReason(string PlayerName)
{
    BuildMutateCommand("KickPlayerWithReason" @ PlayerName $ " ", 4);
}

exec function KillPlayer(string PlayerName)
{
    BuildMutateCommand("KillPlayer" @ PlayerName, 5);
}

exec function GagPlayer(string PlayerName)
{
    BuildMutateCommand("GagPlayer" @ PlayerName, 32);
}

exec function ParaDropPlayerAtGrid(string PlayerName)
{
    BuildMutateCommand("ParaDropPlayer" @ PlayerName @ "AtGridRef ", 9);
}

exec function ParaDropPlayerAtCurrentLocation(string PlayerName)
{
    BuildMutateCommand("ParaDropPlayer" @ PlayerName @ "AtCurrentLocation", 10);
}

defaultproperties
{
    MenuTitle="PLAYER ACTIONS:"
    PreviousMenu="Menu" // means we return to the player list menu if we press the 'previous menu' key

    MenuText(0)="Rename player"
    MenuText(1)="Send private message"
    MenuText(2)="Send warning message (with sound)"
    MenuText(3)="Kick with message"
    MenuText(4)="Kill this player"
    MenuText(5)="Gag this player"
    MenuText(6)="Switch player to allies role"
    MenuText(7)="Switch player to axis role"
    MenuText(8)="Paradrop player at objective"
    MenuText(9)="Paradrop player at grid"
    MenuText(10)="Paradrop player at current location"

    MenuCommand(0)="*RenamePlayer"
    MenuCommand(1)="*PrivateMessageToPlayer"
    MenuCommand(2)="*WarningMessageToPlayer"
    MenuCommand(3)="*KickPlayerWithReason"
    MenuCommand(4)="*KillPlayer"
    MenuCommand(5)="*GagPlayer"
    MenuCommand(6)="RolesMenu Allies *SwitchPlayerToAlliesRole"
    MenuCommand(7)="RolesMenu Axis *SwitchPlayerToAxisRole"
    MenuCommand(8)="ObjectivesMenu *ParaDropPlayerAtObjective"
    MenuCommand(9)="*ParaDropPlayerAtGrid"
    MenuCommand(10)="*ParaDropPlayerAtCurrentLocation"
}
