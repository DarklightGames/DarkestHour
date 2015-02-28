//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVotingHandler extends xVotingHandler;

var localized string lmsgMapVotedTooRecently;

var config float MapVoteIntervalDuration;

// NOTE: overridden to fix vote 'duplication' bug
function PlayerExit(Controller Exiting)
{
    local int i, x, ExitingPlayerIndex;

    // Disable voting in single player mode
    if (Level.NetMode == NM_StandAlone)
    {
        return;
    }

    ExitingPlayerIndex = -1;

    if (bMapVote || bKickVote || bMatchSetup)
    {
        // Find the MVRI belonging to the exiting player
        for (i = 0; i < MVRI.Length; i++)
        {
            // Remove players vote from vote count
            if (MVRI[i] != none && (MVRI[i].PlayerOwner == none || MVRI[i].PlayerOwner == Exiting))
            {
                Log("exiting player MVRI found" @ i,'MapVoteDebug');

                ExitingPlayerIndex = i;

                if (bMapVote && MVRI[ExitingPlayerIndex].MapVote > -1 && MVRI[ExitingPlayerIndex].GameVote > -1)
                {
                    for (x = 0; x < MapVoteCount.Length; x++)
                    {
                        if (MVRI[ExitingPlayerIndex].MapVote == MapVoteCount[x].MapIndex && MVRI[ExitingPlayerIndex].GameVote == MapVoteCount[x].GameConfigIndex)
                        {
                            UpdateVoteCount(MapVoteCount[x].MapIndex, MapVoteCount[x].GameConfigIndex, -MVRI[ExitingPlayerIndex].VoteCount);
                            break;
                        }
                    }
                }

                if (bKickVote)
                {
                    // Clear votes for exiting player
                    UpdateKickVoteCount(MVRI[ExitingPlayerIndex].PlayerID, 0);

                    // Decrease votecount for player that the exiting player voted against
                    if (MVRI[ExitingPlayerIndex].KickVote > -1 && MVRI[MVRI[ExitingPlayerIndex].KickVote] != none)
                    {
                        UpdateKickVoteCount(MVRI[MVRI[ExitingPlayerIndex].KickVote].PlayerID, -1);
                    }
                }
            }

            if (bKickVote && ExitingPlayerIndex > -1 && MVRI[i] != none && MVRI[i].KickVote == ExitingPlayerIndex)
            {
                MVRI[i].KickVote = -1;
            }

            if (MVRI[i] != none && (MVRI[i].PlayerOwner == none || MVRI[i].PlayerOwner == Exiting))
            {
                Log("___Destroying VRI...", 'MapVoteDebug');

                MVRI[i].Destroy();
                MVRI[i] = none;

                if (bKickVote)
                {
                    TallyKickVotes();
                }

                if (bMapVote)
                {
                    TallyVotes(false);
                }
            }
        }
    }
}

// overidden to stop rapid-fire voting
function SubmitMapVote(int MapIndex, int GameIndex, Actor Voter)
{
    local int Index, VoteCount, PrevMapVote, PrevGameVote;
    local MapHistoryInfo MapInfo;
    local DHPlayer P;

    P = DHPlayer(Voter);

    if (P != none && P.MapVoteTime != 0.0 && Level.TimeSeconds < (P.MapVoteTime + MapVoteIntervalDuration))
    {
        TextMessage = lmsgMapVotedTooRecently;
        Repl(TextMessage, "%seconds%", int(Ceil(P.MapVoteTime + MapVoteIntervalDuration) - Level.TimeSeconds));

        P.ClientMessage(TextMessage);

        return;
    }

    if (bLevelSwitchPending)
    {
        return;
    }

    Index = GetMVRIIndex(PlayerController(Voter));

    // check for invalid vote from unpatch players
    if (!IsValidVote(MapIndex, GameIndex))
    {
        return;
    }

    if (PlayerController(Voter).PlayerReplicationInfo.bAdmin || PlayerController(Voter).PlayerReplicationInfo.bSilentAdmin)  // Administrator Vote
    {
        TextMessage = lmsgAdminMapChange;
        TextMessage = Repl(TextMessage, "%mapname%", MapList[MapIndex].MapName $ "(" $ GameConfig[GameIndex].Acronym $ ")");

        Level.Game.Broadcast(self, TextMessage);

        log("Admin has forced map switch to " $ MapList[MapIndex].MapName $ "(" $ GameConfig[GameIndex].Acronym $ ")",'MapVote');

        CloseAllVoteWindows();

        bLevelSwitchPending = true;

        MapInfo = History.PlayMap(MapList[MapIndex].MapName);

        ServerTravelString = SetupGameMap(MapList[MapIndex], GameIndex, MapInfo);

        log("ServerTravelString = " $ ServerTravelString ,'MapVoteDebug');

        Level.ServerTravel(ServerTravelString, false);    // change the map

        SetTimer(1, true);

        return;
    }

    if (PlayerController(Voter).PlayerReplicationInfo.bOnlySpectator)
    {
        // Spectators cant vote
        PlayerController(Voter).ClientMessage(lmsgSpectatorsCantVote);

        return;
    }

    // check for invalid map, invalid gametype, player isnt revoting same as previous vote, and map choosen isnt disabled
    if (MapIndex < 0 ||
        MapIndex >= MapCount ||
        GameIndex >= GameConfig.Length ||
        (MVRI[Index].GameVote == GameIndex && MVRI[Index].MapVote == MapIndex) ||
        !MapList[MapIndex].bEnabled)
    {
        return;
    }

    log("___" $ Index $ " - " $ PlayerController(Voter).PlayerReplicationInfo.PlayerName $ " voted for " $ MapList[MapIndex].MapName $ "(" $ GameConfig[GameIndex].Acronym $ ")",'MapVote');

    PrevMapVote = MVRI[Index].MapVote;
    PrevGameVote = MVRI[Index].GameVote;
    MVRI[Index].MapVote = MapIndex;
    MVRI[Index].GameVote = GameIndex;

    if (bAccumulationMode)
    {
        if (bScoreMode)
        {
            VoteCount = GetAccVote(PlayerController(Voter)) + int(GetPlayerScore(PlayerController(Voter)));
            TextMessage = lmsgMapVotedForWithCount;
        }
        else
        {
            VoteCount = GetAccVote(PlayerController(Voter)) + 1;
            TextMessage = lmsgMapVotedForWithCount;
        }
    }
    else
    {
        if (bScoreMode)
        {
            VoteCount = int(GetPlayerScore(PlayerController(Voter)));
            TextMessage = lmsgMapVotedForWithCount;
        }
        else
        {
            VoteCount =  1;
            TextMessage = lmsgMapVotedFor;
        }
    }

    if (P != none)
    {
        P.MapVoteTime = Level.TimeSeconds;
    }

    TextMessage = Repl(TextMessage, "%votecount%", string(VoteCount));
    TextMessage = Repl(TextMessage, "%playername%", PlayerController(Voter).PlayerReplicationInfo.PlayerName);
    TextMessage = Repl(TextMessage, "%mapname%", MapList[MapIndex].MapName $ "(" $ GameConfig[GameIndex].Acronym $ ")");
    Level.Game.Broadcast(self,TextMessage);

    UpdateVoteCount(MapIndex, GameIndex, VoteCount);

    if (PrevMapVote > -1 && PrevGameVote > -1)
    {
        UpdateVoteCount(PrevMapVote, PrevGameVote, -MVRI[Index].VoteCount); // undo previous vote
    }

    MVRI[Index].VoteCount = VoteCount;

    TallyVotes(false);
}

defaultproperties
{
    MapVoteIntervalDuration=5.0
    lmsgMapVotedTooRecently="Please wait %seconds% seconds before voting for another map!"
}
