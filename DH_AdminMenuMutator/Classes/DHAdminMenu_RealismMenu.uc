//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

// Displays a list of options intended for use in 'realism match' play, or just for testing or messing around on a test server
// This menu will only be loaded if realism options are allowed by the server
class DHAdminMenu_RealismMenu extends DHAdminMenu_MenuBase;

exec function RealismMenu()
{
    GoToState('MenuVisible');
}

exec function EnableRealismMatch()
{
    if (RealismMutatorIsPresent())
    {
        BuildMutateCommand("EnableRealismMatch", 10);
    }
}

exec function DisableRealismMatch()
{
    if (RealismMutatorIsPresent())
    {
        BuildMutateCommand("DisableRealismMatch", 11);
    }
}

exec function ForceRealismMatchLive()
{
    if (RealismMutatorIsPresent())
    {
        BuildMutateCommand("ForceRealismMatchLive", 12);
    }
}

exec function ParaDropAlliesAtGrid()
{
    BuildMutateCommand("ParaDropAll Allies AtGridRef ", 8);
}

exec function ParaDropAxisAtGrid()
{
    BuildMutateCommand("ParaDropAll Axis AtGridRef ", 8);
}

exec function ParaDropAllAtGrid()
{
    BuildMutateCommand("ParaDropAll Players AtGridRef ", 8);
}

exec function ToggleMinefields()
{
    if (Replicator != none && !Replicator.bMinesDisabled)
    {
        BuildMutateCommand("DisableMinefields", 16); // message "do you want to disable ..."
    }
    else
    {
        BuildMutateCommand("EnableMinefields", 17); // message "do you want to re-enable ..."
    }
}

exec function ToggleCapProgress()
{
    if (Replicator != none && !Replicator.bHideCapProgress)
    {
        BuildMutateCommand("ToggleCapProgress", 18); // message "do you want to disable ..."
    }
    else
    {
        BuildMutateCommand("ToggleCapProgress", 19); // message "do you want to re-enable ..."
    }
}

exec function TogglePlayerIcon()
{
    if (Replicator != none && !Replicator.bHidePlayerIcon)
    {
        BuildMutateCommand("TogglePlayerIcon", 20); // message "do you want to disable ..."
    }
    else
    {
        BuildMutateCommand("TogglePlayerIcon", 21); // message "do you want to re-enable ..."
    }
}

exec function KillAllPlayers()
{
    BuildMutateCommand("KillAllPlayers", 22);
}

exec function SetGameSpeed()
{
    BuildMutateCommand("SetGameSpeed ", 23);
}

exec function SetRoundMinutesRemaining()
{
    BuildMutateCommand("SetRoundMinutesRemaining ", 24);
}

exec function ToggleAdminCanPauseGame()
{
    BuildMutateCommand("ToggleAdminCanPauseGame", 25);
}

exec function DestroyActorInSights()
{
    BuildMutateCommand("DestroyActorInSights", 26);
}

// Checks if our mutator's Replicator actor has flagged that the realism match mutator is present on the server - gives a message & logout if it is not
function bool RealismMutatorIsPresent()
{
    if (Replicator != none && Replicator.bRealismMutPresent)
    {
        return true;
    }

    AdminLogoutIfNecessary();
    ErrorMessageToSelf(3); // mutator isn't present
    bKeepMenuOpen = true;  // tells HandleInput not to close this menu if RM mutator isn't enabled, so allowing another realism menu choice

    return false;
}

defaultproperties
{
    MenuTitle="REALISM MATCH (OR TESTING) MENU"
    PreviousMenu="Menu" // means we return to the player list menu if we press the 'previous menu' key

    MenuText(1)="Enable realism match"
    MenuText(2)="Disable realism match"
    MenuText(3)="Go to realism match LIVE"
    MenuText(4)="ParaDrop all allies at objective"
    MenuText(5)="ParaDrop all axis at objective"
    MenuText(6)="ParaDrop all players at objective"
    MenuText(7)="ParaDrop all allies at grid"
    MenuText(8)="ParaDrop all axis at grid"
    MenuText(9)="ParaDrop all players at grid"

    MenuText(11)="Toggle minefields off/on"
    MenuText(12)="Toggle cap progress bar off/on"
    MenuText(13)="Toggle player location icon off/on"
    MenuText(14)="Kill all players (end realism match)"
    MenuText(15)="Set new game speed"
    MenuText(16)="Set new remaining round time (minutes)"
    MenuText(17)="Toggle whether admin can pause game"
    MenuText(18)="Destroy actor in your sights"

    MenuCommand(1)="*EnableRealismMatch"
    MenuCommand(2)="*DisableRealismMatch"
    MenuCommand(3)="*ForceRealismMatchLive"
    MenuCommand(4)="ObjectivesMenu *ParaDropAlliesAtObjective"
    MenuCommand(5)="ObjectivesMenu *ParaDropAxisAtObjective"
    MenuCommand(6)="ObjectivesMenu *ParaDropAllAtObjective"
    MenuCommand(7)="*ParaDropAlliesAtGrid"
    MenuCommand(8)="*ParaDropAxisAtGrid"
    MenuCommand(9)="*ParaDropAllAtGrid"

    MenuCommand(11)="*ToggleMinefields"
    MenuCommand(12)="*ToggleCapProgress"
    MenuCommand(13)="*TogglePlayerIcon"
    MenuCommand(14)="*KillAllPlayers"
    MenuCommand(15)="*SetGameSpeed"
    MenuCommand(16)="*SetRoundMinutesRemaining"
    MenuCommand(17)="*ToggleAdminCanPauseGame"
    MenuCommand(18)="*DestroyActorInSights"
}
