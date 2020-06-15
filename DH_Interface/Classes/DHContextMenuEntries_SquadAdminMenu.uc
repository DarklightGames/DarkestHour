//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHContextMenuEntries_SquadAdminMenu extends DHContextMenuEntries
    abstract;

enum EEntryType
{
    ENTRY_Separator,
    ENTRY_KickPlayerFromSquad,
    ENTRY_DemotePlayer,
    ENTRY_PromotePlayerToLeader,
    ENTRY_PromotePlayerToAssistant,
    ENTRY_ParadropPlayerToLeader,
    ENTRY_ParadropPlayerToMarker,
    ENTRY_ParadropSquadToLeader,
    ENTRY_ParadropSquadToMarker,
    ENTRY_DisbandSquad
};

var private array<EEntryType> ContextMenuEntryTypes;
var private array<localized string>     ContextMenuEntryTexts;

var localized string AdminPrefixText;

protected static function array<int> AssembleMenu(DHPlayerReplicationInfo PRI, DHPlayerReplicationInfo SecondPRI)
{
    local array<EEntryType> EntryTypes;
    local array<int> EntryTypeIndices;
    local int i, TeamIndex;
    local DHSquadReplicationInfo SRI;
    local DHPlayer PC;

    // These entries duplicate squad leader's functionality. Hide them!
    if (!PRI.IsSquadLeader() || PRI.SquadIndex != SecondPRI.SquadIndex)
    {
        EntryTypes[EntryTypes.Length] = ENTRY_KickPlayerFromSquad;

        if (SecondPRI.IsSquadLeader())
        {
            EntryTypes[EntryTypes.Length] = ENTRY_DemotePlayer;
        }
        else if (SecondPRI.IsAssistantLeader())
        {
            EntryTypes[EntryTypes.Length] = ENTRY_DemotePlayer;
            EntryTypes[EntryTypes.Length] = ENTRY_PromotePlayerToLeader;
        }
        else
        {
            EntryTypes[EntryTypes.Length] = ENTRY_PromotePlayerToLeader;
            EntryTypes[EntryTypes.Length] = ENTRY_PromotePlayerToAssistant;
        }

        EntryTypes[EntryTypes.Length] = ENTRY_Separator;
    }

    if (!SecondPRI.IsSquadLeader())
    {
        EntryTypes[EntryTypes.Length] = ENTRY_ParadropPlayerToLeader;
    }

    EntryTypes[EntryTypes.Length] = ENTRY_ParadropPlayerToMarker;
    EntryTypes[EntryTypes.Length] = ENTRY_Separator;

    PC = DHPlayer(PRI.Owner);

    if (PC != none && SecondPRI.Team != none)
    {
        SRI = PC.SquadReplicationInfo;
        TeamIndex = SecondPRI.Team.TeamIndex;

        // Hide squad paradrop options when squad leader is the only member.
        if (SRI != none && SRI.GetMemberCount(TeamIndex, SecondPRI.SquadIndex) > 1)
        {
            EntryTypes[EntryTypes.Length] = ENTRY_ParadropSquadToLeader;
            EntryTypes[EntryTypes.Length] = ENTRY_ParadropSquadToMarker;
            EntryTypes[EntryTypes.Length] = ENTRY_Separator;
        }
    }

    EntryTypes[EntryTypes.Length] = ENTRY_DisbandSquad;

    // Convert enums to indices
    for (i = 0; i < EntryTypes.Length; ++i)
    {
        EntryTypeIndices[EntryTypeIndices.Length] = EntryTypes[i];
    }

    return EntryTypeIndices;
}

protected static function ProcessEntry(int EntryTypeIndex, DHPlayerReplicationInfo PRI, DHPlayerReplicationInfo SecondPRI)
{
    local DHPlayer PC;
    local EEntryType EntryType;

    if (PRI == none || SecondPRI == none)
    {
        return;
    }

    PC = DHPlayer(PRI.Owner);

    if (PC == none)
    {
        return;
    }

    if (EntryTypeIndex < 0 || EntryTypeIndex >= default.ContextMenuEntryTypes.Length)
    {
        Warn("Entry type index is out of bounds");
        return;
    }

    EntryType = default.ContextMenuEntryTypes[EntryTypeIndex];

    switch (EntryType)
    {
        case ENTRY_KickPlayerFromSquad:
            Log("Kick player from squad");
            break;

        case ENTRY_DemotePlayer:
            Log("Demote player");
            break;

        case ENTRY_PromotePlayerToLeader:
            Log("Promote player to squad leader");
            break;

        case ENTRY_PromotePlayerToAssistant:
            Log("Promote player to assistant");
            break;

        case ENTRY_ParadropPlayerToLeader:
            Log("Paradrop PLAYER to squad leader");
            break;

        case ENTRY_ParadropPlayerToMarker:
            Log("Paradrop PLAYER to marker");
            break;

        case ENTRY_ParadropSquadToLeader:
            Log("Paradrop SQUAD to squad leader");
            break;

        case ENTRY_ParadropSquadToMarker:
            Log("Paradrop SQUAD to marker");
            break;

        case ENTRY_DisbandSquad:
            Log("Disband squad");
            break;
    }
}

protected static function string GetEntryString(int EntryTypeIndex, DHPlayerReplicationInfo PRI, DHPlayerReplicationInfo SecondPRI)
{
    local string S;
    local EEntryType EntryType;

    if (EntryTypeIndex < 0 ||
        EntryTypeIndex >= default.ContextMenuEntryTypes.Length ||
        EntryTypeIndex >= default.ContextMenuEntryTexts.Length ||
        SecondPRI == none)
    {
        return super.GetEntryString(EntryTypeIndex, PRI, SecondPRI);
    }

    EntryType = default.ContextMenuEntryTypes[EntryTypeIndex];

    switch (EntryType)
    {
        case ENTRY_Separator:
            return default.ContextMenuEntryTexts[EntryTypeIndex];
        case ENTRY_KickPlayerFromSquad:
        case ENTRY_DemotePlayer:
        case ENTRY_PromotePlayerToLeader:
        case ENTRY_PromotePlayerToAssistant:
        case ENTRY_ParadropPlayerToLeader:
        case ENTRY_ParadropPlayerToMarker:
            return default.AdminPrefixText @ Repl(default.ContextMenuEntryTexts[EntryTypeIndex], "{0}", SecondPRI.PlayerName);
        default:
            return default.AdminPrefixText @ default.ContextMenuEntryTexts[EntryTypeIndex];
    }

    return S;
}

defaultproperties
{
    ContextMenuEntryTypes(0)=ENTRY_Separator
    ContextMenuEntryTexts(0)="-"

    ContextMenuEntryTypes(1)=ENTRY_KickPlayerFromSquad
    ContextMenuEntryTexts(1)="Kick {0}"

    ContextMenuEntryTypes(2)=ENTRY_DemotePlayer
    ContextMenuEntryTexts(2)="Demote {0}"

    ContextMenuEntryTypes(3)=ENTRY_PromotePlayerToLeader
    ContextMenuEntryTexts(3)="Promote {0} to squad leader"

    ContextMenuEntryTypes(4)=ENTRY_PromotePlayerToAssistant
    ContextMenuEntryTexts(4)="Assign {0} as assistant"

    ContextMenuEntryTypes(5)=ENTRY_ParadropPlayerToLeader
    ContextMenuEntryTexts(5)="Paradrop {0} to squad leader"

    ContextMenuEntryTypes(6)=ENTRY_ParadropPlayerToMarker
    ContextMenuEntryTexts(6)="Paradrop {0} to ruler marker"

    ContextMenuEntryTypes(7)=ENTRY_ParadropSquadToLeader
    ContextMenuEntryTexts(7)="Paradrop SQUAD to SL"

    ContextMenuEntryTypes(8)=ENTRY_ParadropSquadToMarker
    ContextMenuEntryTexts(8)="Paradrop SQUAD to ruler marker"

    ContextMenuEntryTypes(9)=ENTRY_DisbandSquad
    ContextMenuEntryTexts(9)="DISBAND SQUAD!"

    AdminPrefixText="[A]"
}
