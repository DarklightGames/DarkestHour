//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

// Displays a list of options intended for use in 'realism match' play, or just for testing or messing around on a test server
// This menu will only be loaded if realism options are allowed by the server
class DHAdminMenu_RealismMenu extends DHAdminMenu_MenuBase;

exec function RealismMenu()
{
    GotoState('MenuVisible');
}

exec function EnableRealismMatch()
{
    if (RealismMutatorIsPresent())
    {
        BuildMutateCommand("EnableRealismMatch", 11);
    }
}

exec function DisableRealismMatch()
{
    if (RealismMutatorIsPresent())
    {
        BuildMutateCommand("DisableRealismMatch", 12);
    }
}

exec function ForceRealismMatchLive()
{
    if (RealismMutatorIsPresent())
    {
        BuildMutateCommand("ForceRealismMatchLive", 13);
    }
}

exec function ParaDropAlliesAtGrid()
{
    BuildMutateCommand("ParaDropAll Allies AtGridRef ", 9);
}

exec function ParaDropAxisAtGrid()
{
    BuildMutateCommand("ParaDropAll Axis AtGridRef ", 9);
}

exec function ParaDropAllAtGrid()
{
    BuildMutateCommand("ParaDropAll Players AtGridRef ", 9);
}

exec function ToggleMinefields()
{
    if (Replicator != none && !Replicator.bMinesDisabled)
    {
        BuildMutateCommand("DisableMinefields", 17); // message "do you want to disable ..."
    }
    else
    {
        BuildMutateCommand("EnableMinefields", 18); // message "do you want to re-enable ..."
    }
}

exec function ToggleCapProgress()
{
    if (Replicator != none && !Replicator.bHideCapProgress)
    {
        BuildMutateCommand("ToggleCapProgress", 19); // message "do you want to disable ..."
    }
    else
    {
        BuildMutateCommand("ToggleCapProgress", 20); // message "do you want to re-enable ..."
    }
}

exec function TogglePlayerIcon()
{
    if (Replicator != none && !Replicator.bHidePlayerIcon)
    {
        BuildMutateCommand("TogglePlayerIcon", 21); // message "do you want to disable ..."
    }
    else
    {
        BuildMutateCommand("TogglePlayerIcon", 22); // message "do you want to re-enable ..."
    }
}

exec function KillAllPlayers()
{
    BuildMutateCommand("KillAllPlayers", 23);
}

exec function SetGameSpeed()
{
    BuildMutateCommand("SetGameSpeed ", 24);
}

exec function SetRoundMinutesRemaining()
{
    BuildMutateCommand("SetRoundMinutesRemaining ", 25);
}

exec function ToggleAdminCanPauseGame()
{
    BuildMutateCommand("ToggleAdminCanPauseGame", 26);
}

exec function DestroyActorInSights()
{
    BuildMutateCommand("DestroyActorInSights", 27);
}

exec function ChangeAlliesSquadSize()
{
    BuildMutateCommand("ChangeAlliesSquadSize", 28);
}

exec function ChangeAxisSquadSize()
{
    BuildMutateCommand("ChangeAxisSquadSize", 29);
}

exec function ToggleRallyPoints()
{
    local DHSquadReplicationInfo SRI;

    if (PC == none)
    {
        return;
    }

    SRI = DHPlayer(PC).SquadReplicationInfo;

    if (SRI == none || !AreRallyPointsAllowed())
    {
        return;
    }

    if (SRI.bAreRallyPointsEnabled)
    {
        BuildMutateCommand("DisableRallyPoints", 33); // disable
    }
    else
    {
        BuildMutateCommand("EnableRallyPoints", 34); // enable
    }
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

function bool AreRallyPointsAllowed()
{
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

    if (GRI != none && GRI.GameType != none && GRI.GameType.default.bAreRallyPointsEnabled)
    {
        return true;
    }

    AdminLogoutIfNecessary();
    ErrorMessageToSelf(25); // "The game mode does not allow rally points..."
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

    MenuText(19)="Change allies squad size"
    MenuText(20)="Change axis squad size"

    MenuText(21)="Toggle rally point placement on/off"

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

    MenuCommand(19)="*ChangeAlliesSquadSize"
    MenuCommand(20)="*ChangeAxisSquadSize"
    MenuCommand(21)="*ToggleRallyPoints"
}
