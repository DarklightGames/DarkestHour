//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHContextMenu_SquadMembers extends DHContextMenu;

var localized string AdminPrefixText;

protected function DHPlayerReplicationInfo GetSelectedPRI(GUIComponent Component)
{
    local DHGUISquadComponent SquadComponent;

    SquadComponent = DHGUISquadComponent(Component);

    if (SquadComponent != none && SquadComponent.li_Members != none)
    {
        return DHPlayerReplicationInfo(SquadComponent.li_Members.GetObject());
    }
}

protected function AssembleMenu(GUIComponent Component)
{
    local DHSquadReplicationInfo SRI;
    local DHPlayerReplicationInfo PRI, SelectedPRI;
    local DHGUISquadComponent SquadComponent;
    local DHPlayer PC;
    local int SquadMemberIndex, SquadIndex, TeamIndex, InsertSeparatorIndex;
    local bool bParadropMarkerPlaced, bSquadLeaderIsAlive;

    PC = GetComponentController(Component);
    SRI = PC.SquadReplicationInfo;
    SelectedPRI = GetSelectedPRI(Component);
    SquadComponent = DHGUISquadComponent(Component);

    if (PC == none ||
        SRI == none ||
        SelectedPRI == none ||
        SquadComponent == none)
    {
        return;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    if (PRI == none)
    {
        return;
    }

    SquadIndex = SquadComponent.SquadIndex;

    if (PRI != SelectedPRI)
    {
        if (PRI.IsSquadLeader())
        {
            if (PRI.SquadIndex == SquadIndex)
            {
                AddEntry(2);     // Kick player
                AddEntry(3);     // Ban player
                AddEntry(0);     // --------
                AddEntry(4);     // Promote to SL
                AddEntry(0);     // --------

                if (SelectedPRI.bIsSquadAssistant)
                {
                    AddEntry(6); // Rescind assistant
                }
                else
                {
                    AddEntry(5); // Assign assistant
                }
            }
            else if (SelectedPRI.IsSquadLeader())
            {
                AddEntry(8);     // Request merge
            }
            else if (SquadIndex == -1)
            {
                AddEntry(1);     // Invite the unassigned player
            }
        }
        else if (SelectedPRI.IsSquadLeader() &&
                 PRI.SquadIndex == SquadIndex &&
                 !SRI.HasAssistant(PC.GetTeamNum(), PRI.SquadIndex))
        {
            AddEntry(7);         // Volunteer to assist
        }
    }

    if (PRI.IsLoggedInAsAdmin())
    {
        bParadropMarkerPlaced = PC.IsPersonalMarkerPlaced(PC.ParadropMarkerClass);
        bSquadLeaderIsAlive = SquadIndex >= 0 &&
                              SquadIndex < arraycount(PC.SquadLeaderLocations) &&
                              PC.SquadLeaderLocations[SquadIndex] != 0;

        if (SelectedPRI.Team != none)
        {
            TeamIndex = SelectedPRI.Team.TeamIndex;
        }

        InsertSeparatorIndex = GetMenuLength();

        // PARADROP COMMANDS

        if (bParadropMarkerPlaced)
        {
            AddEntry(10);         // ADMIN: Paradrop PLAYER to MARKER
        }

        if (SelectedPRI.SquadIndex >= 0)
        {
            if (!SelectedPRI.IsSquadLeader())
            {
                if (PRI != SelectedPRI && bSquadLeaderIsAlive)
                {
                    AddEntry(9);  // ADMIN: Paradrop PLAYER to SL
                }
            }
            else if (SRI.GetMemberCount(TeamIndex, SelectedPRI.SquadIndex) > 1)
            {
                if (bParadropMarkerPlaced)
                {
                    AddEntry(12); // ADMIN: Paradrop SQUAD to MARKER
                }

                if (bSquadLeaderIsAlive)
                {
                    AddEntry(11); // ADMIN: Paradrop SQUAD to SL
                }
            }
        }
        else if (SRI.GetUnassignedPlayerCount(TeamIndex) > 1 && bParadropMarkerPlaced)
        {
            AddEntry(13);         // ADMIN: Paradrop ALL UNASSIGNED to MARKER
        }

        if (InsertSeparatorIndex > 0 && InsertSeparatorIndex < GetMenuLength())
        {
            InsertEntry(0, InsertSeparatorIndex);
        }

        InsertSeparatorIndex = GetMenuLength();

        // ADMIN COMMANDS

        if (SelectedPRI.SquadIndex >= 0 && (PRI.SquadIndex != SquadIndex || !PRI.IsSquadLeader()))
        {
            if (!SelectedPRI.IsSquadLeader())
            {
                AddEntry(14); // ADMIN: Promote PLAYER to squad leader
            }

            if (PRI != SelectedPRI)
            {
                AddEntry(15); // ADMIN: Kick PLAYER from squad
            }
        }

        if (InsertSeparatorIndex > 0 && InsertSeparatorIndex < GetMenuLength())
        {
            InsertEntry(0, InsertSeparatorIndex);
        }
    }
}

protected function ProcessEntry(int EntryIndex, GUIComponent Component)
{
    local DHGUISquadComponent SquadComponent;
    local DHPlayerReplicationInfo PRI, SelectedPRI;
    local DHPlayer PC;
    local vector ParadropLocation;

    PC = GetComponentController(Component);
    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
    SelectedPRI = GetSelectedPRI(Component);
    SquadComponent = DHGUISquadComponent(Component);

    if (PC == none || PRI == none || SquadComponent == none)
    {
        return;
    }

    switch (EntryIndex)
    {
        case 1:
            PC.ServerSquadInvite(SelectedPRI);
            return;

        case 2:
            PC.ServerSquadKick(SelectedPRI);
            return;

        case 3:
            PC.ServerSquadBan(SelectedPRI);
            return;

        case 4:
            PC.ServerSquadPromote(SelectedPRI);
            return;

        case 5:
            if (!SelectedPRI.IsASL())
            {
                PC.ServerSquadMakeAssistant(SelectedPRI);
            }

            return;

        case 6:
            if (SelectedPRI.IsASL())
            {
                PC.ServerSquadMakeAssistant(none);
            }

            return;

        case 7:
            PC.ServerSquadVolunteerToAssist();
            return;

        case 8:
            PC.ServerSendSquadMergeRequest(SquadComponent.SquadIndex);
            return;
    }

    if (PRI.IsLoggedInAsAdmin())
    {
        switch (EntryIndex)
        {
            case 9: // ADMIN: Paradrop PLAYER to SL
                if (PC.GetSquadLeaderParadropLocation(ParadropLocation, SelectedPRI))
                {
                    PC.ServerParadropPlayer(SelectedPRI, ParadropLocation, PC.ParadropSpreadModifier, false);
                }

                return;

            case 10: // ADMIN: Paradrop PLAYER to MARKER
                if (PC.GetMarkedParadropLocation(ParadropLocation))
                {
                    PC.ServerParadropPlayer(SelectedPRI, ParadropLocation, PC.ParadropSpreadModifier, false);
                }

                return;

            case 11: // ADMIN: Paradrop SQUAD to SL
                if (PC.GetSquadLeaderParadropLocation(ParadropLocation, SelectedPRI) && SelectedPRI.Team != none)
                {
                    PC.ServerParadropSquad(SelectedPRI.Team.TeamIndex, SelectedPRI.SquadIndex, ParadropLocation, PC.ParadropSpreadModifier, false);
                }

                return;

            case 12: // ADMIN: Paradrop SQUAD to MARKER
            case 13: // ADMIN: Paradrop ALL UNASSIGED to MARKER
                if (PC.GetMarkedParadropLocation(ParadropLocation) && SelectedPRI.Team != none)
                {
                    PC.ServerParadropSquad(SelectedPRI.Team.TeamIndex, SelectedPRI.SquadIndex, ParadropLocation, PC.ParadropSpreadModifier, false);
                }

                return;

            case 14:
                PC.ServerSquadPromote(SelectedPRI);
                return;

            case 15:
                PC.ServerSquadKick(SelectedPRI);
                return;
        }
    }
}

protected function string GetEntryString(int EntryIndex, GUIComponent Component)
{
    local string PlayerName;
    local DHPlayerReplicationInfo SelectedPRI;

    if (EntryIndex < 0 || EntryIndex >= default.EntryTexts.Length)
    {
        return super.GetEntryString(EntryIndex, Component);
    }

    SelectedPRI = GetSelectedPRI(Component);

    if (SelectedPRI != none)
    {
        PlayerName = SelectedPRI.PlayerName;
    }

    return Repl(Repl(default.EntryTexts[EntryIndex],
                        "{0}",
                        PlayerName),
                "{1}",
                default.AdminPrefixText);
}

defaultproperties
{
    AdminPrefixText="ADMIN:"
    EntryTexts(0)="-"

    // Squad leader commands
    EntryTexts(1)="Invite {0}"
    EntryTexts(2)="Kick {0}"
    EntryTexts(3)="Ban {0}"
    EntryTexts(4)="Promote {0} to squad leader"
    EntryTexts(5)="Assign {0} as assistant"
    EntryTexts(6)="Unassign {0} as assistant"
    EntryTexts(7)="Volunteer as assistant"
    EntryTexts(8)="Request to merge squads"

    // Admin commands
    EntryTexts(9)="{1} Paradrop {0} to squad leader"
    EntryTexts(10)="{1} Paradrop {0} to marker"
    EntryTexts(11)="{1} Paradrop SQUAD to squad leader"
    EntryTexts(12)="{1} Paradrop SQUAD to marker"
    EntryTexts(13)="{1} Paradrop unassigned players to marker"
    EntryTexts(14)="{1} Promote {0} to squad leader"
    EntryTexts(15)="{1} Kick {0} from squad"
}
