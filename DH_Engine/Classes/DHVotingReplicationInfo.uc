//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVotingReplicationInfo extends VotingReplicationInfo
    DependsOn(DHVotingHandler);

var config bool bEnableSinglePlayerVoting; // for debugging purposes

// Grab data from VotingHandler on server side
// Overriden to allow single-player debugging
simulated function GetServerData()
{
    if (Level.NetMode == NM_Client &&
        (Level.NetMode != NM_Standalone || !bEnableSinglePlayerVoting))
    {
        return;
    }

    bKickVote = VH.bKickVote;
    bMapVote = VH.bMapVote;
    bMatchSetup = VH.bMatchSetup;
    MapCount = VH.MapCount;
    GameConfigCount = VH.GameConfig.Length;

    if (bMapVote)
    {
        Mode = byte(VH.bEliminationMode);
        Mode += byte(VH.bScoreMode) * 2;
        Mode += byte(VH.bAccumulationMode) * 4;

        CurrentGameConfig = VH.CurrentGameConfig;

        AddToTickedReplicationQueue(REPDATATYPE_GameConfig, GameConfigCount-1);
        AddToTickedReplicationQueue(REPDATATYPE_MapList, MapCount-1);

        if (VH.MapVoteCount.Length > 0)
        {
            AddToTickedReplicationQueue(REPDATATYPE_MapVoteCount, VH.MapVoteCount.Length-1);
        }
    }

    if (bKickVote && VH.KickVoteCount.Length > 0)
    {
        AddToTickedReplicationQueue(REPDATATYPE_KickVoteCount, VH.KickVoteCount.Length-1);
    }
}

simulated function Tick(float DeltaTime)
{
    local int i;
    local bool bDedicated, bListening;

    if (TickedReplicationQueue.Length == 0 || bWaitingForReply)
    {
        return;
    }

    bDedicated = Level.NetMode == NM_DedicatedServer ||
                (Level.NetMode == NM_ListenServer && PlayerOwner != none &&
                 PlayerOwner.Player.Console == none );

    bListening = Level.NetMode == NM_ListenServer && PlayerOwner != none &&
                 PlayerOwner.Player.Console != none;

    if (!bDedicated &&
        !bListening &&
        (Level.NetMode != NM_Standalone || !bEnableSinglePlayerVoting))
    {
        return;
    }

    i = TickedReplicationQueue.Length - 1;

    switch (TickedReplicationQueue[i].DataType)
    {
        case REPDATATYPE_GameConfig:
            TickedReplication_GameConfig(TickedReplicationQueue[i].Index, bDedicated);
            break;
        case REPDATATYPE_MapList:
            TickedReplication_MapList(TickedReplicationQueue[i].Index, bDedicated);
            break;
        case REPDATATYPE_MapVoteCount:
            TickedReplication_MapVoteCount(TickedReplicationQueue[i].Index, bDedicated);
            break;
        case REPDATATYPE_KickVoteCount:
            TickedReplication_KickVoteCount(TickedReplicationQueue[i].Index, bDedicated);
            break;
        case REPDATATYPE_MatchConfig:
            TickedReplication_MatchConfig(TickedReplicationQueue[i].Index, bDedicated);
            break;
        case REPDATATYPE_Maps:
            TickedReplication_Maps(TickedReplicationQueue[i].Index, bDedicated);
            break;
        case REPDATATYPE_Mutators:
            TickedReplication_Mutators(TickedReplicationQueue[i].Index, bDedicated);
            break;
    }

    TickedReplicationQueue[i].Index++;

    if (TickedReplicationQueue[i].Index > TickedReplicationQueue[i].Last)
    {
        TickedReplicationQueue.Remove(i,1);
    }
}
