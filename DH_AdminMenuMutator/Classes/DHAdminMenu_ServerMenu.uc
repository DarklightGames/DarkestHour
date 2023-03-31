//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHAdminMenu_ServerMenu extends DHAdminMenu_MenuBase;

exec function ServerMenu()
{
    GotoState('MenuVisible');
}

exec function SetGamePassword()
{
    BuildMutateCommand("SetGamePassword ", 30);
}

exec function ToggleLockWeapons()
{
    BuildMutateCommand("ToggleLockWeapons ", 31);
}

defaultproperties
{
    MenuTitle="SERVER MENU (FOR VARIOUS SETTINGS)"
    PreviousMenu="Menu" // means we return to the player list menu if we press the 'previous menu' key

    MenuText(1)="Set Game Password (leave blank to remove password)"
    MenuCommand(1)="*SetGamePassword"

    MenuText(2)="Toggle Lock Weapons"
    MenuCommand(2)="*ToggleLockWeapons"
}
