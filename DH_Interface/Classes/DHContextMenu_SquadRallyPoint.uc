//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHContextMenu_SquadRallyPoint extends DHContextMenu;

const DESTROY_RALLY_ENTRY_INDEX = 0;
const SEPARATOR_ENTRY_INDEX = 1;
const SET_AS_SECONDARY_ENTRY_INDEX = 2;

protected function AssembleMenu(GUIComponent Component)
{
    local DHPlayer PC;
    local DHGameReplicationInfo GRI;
    local DHSpawnPoint_SquadRallyPoint SRP;
    local DHPlayerReplicationInfo PRI;
    
    PC = GetComponentController(Component);
    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
    SRP = DHSpawnPoint_SquadRallyPoint(GRI.SpawnPoints[Component.Tag]);

    if (SRP == none || SRP.GetTeamIndex() != PC.GetTeamNum() || SRP.SquadIndex != PRI.SquadIndex || !SRP.IsActive())
    {
        return;
    }

    AddEntry(DESTROY_RALLY_ENTRY_INDEX);

    if (PC.SquadReplicationInfo.GetActiveSquadRallyPointCount(SRP.GetTeamIndex(), SRP.SquadIndex) > 1)
    {
        AddEntry(SEPARATOR_ENTRY_INDEX);
        AddEntry(SET_AS_SECONDARY_ENTRY_INDEX);
    }
}

protected function ProcessEntry(int EntryIndex, GUIComponent Component)
{
    local DHPlayer PC;
    local DHGameReplicationInfo GRI;
    local DHSpawnPoint_SquadRallyPoint SRP;

    PC = GetComponentController(Component);
    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    SRP = DHSpawnPoint_SquadRallyPoint(GRI.SpawnPoints[Component.Tag]);

    switch (EntryIndex)
    {
        case DESTROY_RALLY_ENTRY_INDEX:
            PC.ServerSquadDestroyRallyPoint(SRP);
            break;
        case SET_AS_SECONDARY_ENTRY_INDEX:
            PC.ServerSquadSwapRallyPoints();
            break;
    }
}

defaultproperties
{
    EntryTexts(0)="Destroy Rally"
    EntryTexts(1)="-"
    EntryTexts(2)="Set as Secondary"
}
