//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHContextMenu_CommandPost extends DHContextMenu;

const ABANDON_ENTRY_INDEX = 0;

protected function AssembleMenu(GUIComponent Component)
{
    local DHPlayer PC;
    local DHGameReplicationInfo GRI;
    local DHSpawnPoint_PlatoonHQ SP;
    local DHPlayerReplicationInfo PRI;
    
    PC = GetComponentController(Component);
    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
    SP = DHSpawnPoint_PlatoonHQ(GRI.SpawnPoints[Component.Tag]);

    if (SP == none || SP.GetTeamIndex() != PC.GetTeamNum() || !SP.IsActive())
    {
        return;
    }

    AddEntry(ABANDON_ENTRY_INDEX);
}

protected function ProcessEntry(int EntryIndex, GUIComponent Component)
{
    local DHPlayer PC;
    local DHGameReplicationInfo GRI;
    local DHSpawnPoint_PlatoonHQ SP;

    PC = GetComponentController(Component);
    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    SP = DHSpawnPoint_PlatoonHQ(GRI.SpawnPoints[Component.Tag]);

    switch (EntryIndex)
    {
        case ABANDON_ENTRY_INDEX:
            //SP.Construction.TearDown();
            // TODO: tear down the HQ, flag it as being abandoned so it says the right thing.
            //PC.ServerSquadDestroyRallyPoint(SRP);
            break;
        default:
            break;
    }
}

defaultproperties
{
    EntryTexts(0)="Abandon"
}
