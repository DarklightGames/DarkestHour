//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVotingHandler extends xVotingHandler;

var localized string lmsgMapVotedTooRecently;
var localized string SwapAndRestartText;

var config float MapVoteIntervalDuration;
var config bool bUseSwapVote;

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
        for (i = 0; i < MVRI.Length; ++i)
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

// function to strip prefix
function string PrepMapStr(string MapName)
{
    local string StrippedMapName;

    StrippedMapName = Repl(MapName, "DH-", ""); // Remove DH- prefix
    StrippedMapName = Repl(StrippedMapName, ".rom", ""); // Remove .rom if it exists
    StrippedMapName = Repl(StrippedMapName, "_", " "); // Remove _ for space

    return StrippedMapName;
}

// overidden to stop rapid-fire voting, handle more aesthetic messages, and handle swap teams vote
function SubmitMapVote(int MapIndex, int GameIndex, Actor Voter)
{
    local int Index, VoteCount, PrevMapVote, PrevGameVote;
    local MapHistoryInfo MapInfo;
    local DHPlayer P;

    P = DHPlayer(Voter);

    if (P != none && P.MapVoteTime != 0.0 && Level.TimeSeconds < (P.MapVoteTime + MapVoteIntervalDuration))
    {
        TextMessage = lmsgMapVotedTooRecently;
        TextMessage = Repl(TextMessage, "%seconds%", int(Ceil(P.MapVoteTime + MapVoteIntervalDuration) - Level.TimeSeconds));

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
        TextMessage = Repl(TextMessage, "%mapname%", PrepMapStr(MapList[MapIndex].MapName));

        Level.Game.Broadcast(self, TextMessage);

        log("Admin has forced map switch to " $ MapList[MapIndex].MapName $ "(" $ GameConfig[GameIndex].Acronym $ ")",'MapVote');

        if (MapList[MapIndex].MapName == SwapAndRestartText)
        {
            ExitVoteAndSwap();
            return;
        }

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
            VoteCount = 1;
            TextMessage = lmsgMapVotedFor;
        }
    }

    if (P != none)
    {
        P.MapVoteTime = Level.TimeSeconds;
    }

    if (!DarkestHourGame(Level.Game).IsInState('MatchOver'))
    {
        TextMessage = Repl(TextMessage, "%votecount%", string(VoteCount));
        TextMessage = Repl(TextMessage, "%playername%", PlayerController(Voter).PlayerReplicationInfo.PlayerName);
        TextMessage = Repl(TextMessage, "%mapname%", PrepMapStr(MapList[MapIndex].MapName));
        Level.Game.Broadcast(self,TextMessage);
    }

    UpdateVoteCount(MapIndex, GameIndex, VoteCount);

    if (PrevMapVote > -1 && PrevGameVote > -1)
    {
        UpdateVoteCount(PrevMapVote, PrevGameVote, -MVRI[Index].VoteCount); // undo previous vote
    }

    MVRI[Index].VoteCount = VoteCount;

    TallyVotes(false);
}

// Overriden to fix accessed none errors. The logic of the function itself is a
// nightmare and whoever wrote it is a criminal.
function GetDefaultMap(out int mapidx, out int gameidx)
{
    local int i, x, y, r, p, GCIdx;
    local array<string> PrefixList;
    local bool bLoop;

    if (MapCount <= 0)
    {
        return;
    }

    // set the default gametype
    if (bDefaultToCurrentGameType)
    {
        GCIdx = CurrentGameConfig;
    }
    else
    {
        GCIdx = DefaultGameConfig;
    }

    // Parse Prefix list for default game type
    PrefixList.Length = 0;
    p = Split(GameConfig[GCIdx].Prefix, ",", PrefixList);

    if (PrefixList.Length == 0)
    {
        gameidx = GCIdx;
        mapidx = 0;
        return;
    }

    // choose a map at random, check if it is enabled and the prefix is in the prefix list
    r = 0;

    bLoop = true;

    while(bLoop)
    {
        i = Rand(MapCount);

        if (MapList[i].bEnabled)
        {
            for(x = 0; x < PrefixList.Length; ++x)
            {
                if (Left(MapList[i].MapName, Len(PrefixList[x])) ~= PrefixList[x])
                {
                    bLoop = false;

                    break;
                }
            }
        }

        if (bLoop && r++ > 100)
        {
            // give up after 100 unsuccessful attempts.
            // find the first map that matches up to default gametype
            for (i = 0; i < MapCount; ++i)
            {
                if (MapList[i].bEnabled)
                {
                    for(x = 0; x < PrefixList.Length; ++x)
                    {
                        if (Left(MapList[i].MapName, Len(PrefixList[x])) ~= PrefixList[x])
                        {
                            // ding ding ding, found one
                            bLoop = false;
                            break;
                        }
                    }
                }
            }

            if (bLoop) // still didnt find any, then find the first enabled map and find its gameconfig
            {
                for(i = 0; i < MapCount; ++i)
                {
                    if (MapList[i].bEnabled)
                    {
                        // find prefix in GameConfigs
                        for(y = 0; y < GameConfig.Length; ++y)
                        {
                            // Parse Prefix list for game type
                            PrefixList.Length = 0;
                            p = Split(GameConfig[y].Prefix, ",", PrefixList);

                            if (PrefixList.Length > 0)
                            {
                                for(x = 0; x < PrefixList.Length; ++x)
                                {
                                    if (Left(MapList[i].MapName, Len(PrefixList[x])) ~= PrefixList[x])
                                    {
                                        // ding ding ding, found one
                                        GCIdx = y;
                                        bLoop = false;
                                        break;
                                    }
                                }
                            }

                            if (!bLoop)
                            {
                                break;
                            }
                        }

                        break;
                    }
                }
            }

            break;
        }
    }

    gameidx = GCIdx;
    mapidx = i;

    log("Default Map Chosen = " $ MapList[mapidx].MapName $ "(" $ GameConfig[gameidx].Acronym $ ")",'MapVoteDebug');
}

// Override to support additional vote options like Swap Teams and Restart
function TallyVotes(bool bForceMapSwitch)
{
    local int        index,x,y,topmap,r,mapidx,gameidx;
    local array<int> VoteCount;
    local array<int> Ranking;
    local int        PlayersThatVoted;
    local int        TieCount;
    local string     CurrentMap;
    local int        Votes;
    local MapHistoryInfo MapInfo;

    if(bLevelSwitchPending)
        return;

    PlayersThatVoted = 0;
    VoteCount.Length = GameConfig.Length * MapCount;

    for(x=0;x < MVRI.Length;x++) // for each player
    {
        if(MVRI[x] != none && MVRI[x].MapVote > -1 && MVRI[x].GameVote > -1) // if this player has voted
        {
            PlayersThatVoted++;

            if(bScoreMode)
            {
                if(bAccumulationMode)
                    Votes = GetAccVote(MVRI[x].PlayerOwner) + int(GetPlayerScore(MVRI[x].PlayerOwner));
                else
                    Votes = int(GetPlayerScore(MVRI[x].PlayerOwner));
            }
            else
            {  // Not Score Mode == Majority (one vote per player)
                if(bAccumulationMode)
                    Votes = GetAccVote(MVRI[x].PlayerOwner) + 1;
                else
                    Votes = 1;
            }
            VoteCount[MVRI[x].GameVote * MapCount + MVRI[x].MapVote] = VoteCount[MVRI[x].GameVote * MapCount + MVRI[x].MapVote] + Votes;

            if(!bScoreMode)
            {
                // If more then half the players voted for the same map as this player then force a winner
                if(Level.Game.NumPlayers > 2 && float(VoteCount[MVRI[x].GameVote * MapCount + MVRI[x].MapVote]) / float(Level.Game.NumPlayers) > 0.5 && Level.Game.bGameEnded)
                    bForceMapSwitch = true;
            }
        }
    }
    log("___Voted - " $ PlayersThatVoted,'MapVoteDebug');

    if(Level.Game.NumPlayers > 2 && !Level.Game.bGameEnded && !bMidGameVote && (float(PlayersThatVoted) / float(Level.Game.NumPlayers)) * 100 >= MidGameVotePercent) // Mid game vote initiated
    {
        Level.Game.Broadcast(self,lmsgMidGameVote);
        bMidGameVote = true;
        // Start voting count-down timer
        TimeLeft = VoteTimeLimit;
        ScoreBoardTime = 1;
        settimer(1,true);
    }

    index = 0;
    for(x=0;x < VoteCount.Length;x++) // for each map
    {
        if(VoteCount[x] > 0)
        {
            Ranking.Insert(index,1);
            Ranking[index++] = x; // copy all vote indexes to the ranking list if someone has voted for it.
        }
    }

    if(PlayersThatVoted > 1)
    {
        // bubble sort ranking list by vote count
        for(x=0; x<index-1; x++)
        {
            for(y=x+1; y<index; y++)
            {
                if(VoteCount[Ranking[x]] < VoteCount[Ranking[y]])
                {
                topmap = Ranking[x];
                Ranking[x] = Ranking[y];
                Ranking[y] = topmap;
                }
            }
        }
    }
    else
    {
        if(PlayersThatVoted == 0)
        {
            GetDefaultMap(mapidx, gameidx);
            topmap = gameidx * MapCount + mapidx;
        }
        else
            topmap = Ranking[0];  // only one player voted
    }

    //Check for a tie
    if(PlayersThatVoted > 1) // need more than one player vote for a tie
    {
        if(index > 1 && VoteCount[Ranking[0]] == VoteCount[Ranking[1]] && VoteCount[Ranking[0]] != 0)
        {
            TieCount = 1;
            for(x=1; x<index; x++)
            {
                if(VoteCount[Ranking[0]] == VoteCount[Ranking[x]])
                TieCount++;
            }
            //reminder ---> int Rand( int Max ); Returns a random number from 0 to Max-1.
            topmap = Ranking[Rand(TieCount)];

            // Don't allow same map to be choosen
            CurrentMap = GetURLMap();

            r = 0;
            while(MapList[topmap - (topmap/MapCount) * MapCount].MapName ~= CurrentMap)
            {
                topmap = Ranking[Rand(TieCount)];
                if(r++>100)
                    break;  // just incase
            }
        }
        else
        {
            topmap = Ranking[0];
        }
    }

    // if everyone has voted go ahead and change map
    if(bForceMapSwitch || (Level.Game.NumPlayers == PlayersThatVoted && Level.Game.NumPlayers > 0) )
    {
        if (MapList[topmap - topmap/MapCount * MapCount].MapName == "")
            return;

        if (MapList[topmap - topmap/MapCount * MapCount].MapName == SwapAndRestartText)
        {
            ExitVoteAndSwap();
            return;
        }

        TextMessage = lmsgMapWon;
        TextMessage = repl(TextMessage,"%mapname%",MapList[topmap - topmap/MapCount * MapCount].MapName $ "(" $ GameConfig[topmap/MapCount].Acronym $ ")");
        Level.Game.Broadcast(self,TextMessage);

        CloseAllVoteWindows();

        MapInfo = History.PlayMap(MapList[topmap - topmap/MapCount * MapCount].MapName);

        ServerTravelString = SetupGameMap(MapList[topmap - topmap/MapCount * MapCount], topmap/MapCount, MapInfo);

        log("ServerTravelString = " $ ServerTravelString ,'MapVoteDebug');

        History.Save();

        if(bEliminationMode)
            RepeatLimit++;

        if(bAccumulationMode)
            SaveAccVotes(topmap - topmap/MapCount * MapCount, topmap/MapCount);

        CurrentGameConfig = topmap/MapCount;
        if( !bAutoDetectMode )
            SaveConfig();

        bLevelSwitchPending = true;
        settimer(Level.TimeDilation,true);  // timer() will monitor the server-travel and detect a failure

        Level.ServerTravel(ServerTravelString, false);    // change the map
    }
}

function ExitVoteAndSwap()
{
    CloseAllVoteWindows();

    ResetMapVotes();

    bMidGameVote = false;

    SetTimer(0.0, false); // Stop the timer

    DarkestHourGame(Level.Game).bGameEnded = false;
    DarkestHourGame(Level.Game).SwapTeams();
}

// Resets all player votes
function ResetMapVotes()
{
    local int i, x;

    for (i = 0; i < MVRI.Length; ++i)
    {
        if (bMapVote && MVRI[i] != none && MVRI[i].MapVote > -1 && MVRI[i].GameVote > -1)
        {
            for (x = 0; x < MapVoteCount.Length; x++)
            {
                if (MVRI[i].MapVote == MapVoteCount[x].MapIndex && MVRI[i].GameVote == MapVoteCount[x].GameConfigIndex)
                {
                    UpdateVoteCount(MapVoteCount[x].MapIndex, MapVoteCount[x].GameConfigIndex, -MVRI[i].VoteCount);
                    MVRI[i].MapVote = -1;
                    break;
                }
            }
        }
    }
}

// Override to add additional vote options
function LoadMapList()
{
    local int i,EnabledMapCount;
    local class<MapListLoader> MapListLoaderClass;
    local MapListLoader Loader;

    MapList.Length = 0;
    MapCount = 0;

    MapVoteHistoryClass = class<MapVoteHistory>(DynamicLoadObject(MapVoteHistoryType, class'Class'));
    History = new(None,"MapVoteHistory"$string(ServerNumber)) MapVoteHistoryClass;

    if (History == None)
    {
        History = new(None,"MapVoteHistory"$string(ServerNumber)) class'MapVoteHistory_INI';
    }

    log("GameTypes:",'MapVote');

    if(GameConfig.Length == 0)
    {
        bAutoDetectMode = true;
        // default to ONLY current game type and maps
        GameConfig.Length = 1;
        GameConfig[0].GameClass = string(Level.Game.Class);
        GameConfig[0].Prefix = Level.Game.MapPrefix;
        GameConfig[0].Acronym = Level.Game.Acronym;
        GameConfig[0].GameName = Level.Game.GameName;
        GameConfig[0].Mutators="";
        GameConfig[0].Options="";
    }
    MapCount = 0;

    for (i=0;i < GameConfig.Length;i++)
    {
        if (GameConfig[i].GameClass != "")
        {
            log(GameConfig[i].GameName,'MapVote');
        }
    }

    log("MapListLoaderType = " $ MapListLoaderType,'MapVote');

    MapListLoaderClass = class<MapListLoader>(DynamicLoadObject(MapListLoaderType, class'Class'));
    Loader = spawn(MapListLoaderClass);
    if (Loader == None)
    {
        Loader = spawn(class'DefaultMapListLoader');
    }
    Loader.LoadMapList(self);

    if (bUseSwapVote)
    {
        AddMap(SwapAndRestartText, "", "");
    }

    log(MapCount $ " maps loaded.",'MapVote');

    History.Save();

    if (bEliminationMode)
    {
        // Count the Remaining Enabled maps
        EnabledMapCount = 0;
        for (i=0;i<MapCount;i++)
        {
            if (MapList[i].bEnabled)
                EnabledMapCount++;
        }
        if (EnabledMapCount < MinMapCount || EnabledMapCount == 0)
        {
            log("Elimination Mode Reset/Reload.",'MapVote');
            RepeatLimit = 0;
            MapList.Length = 0;
            MapCount = 0;
            SaveConfig();
            Loader.LoadMapList(self);
        }
    }

    Loader.Destroy();
}

defaultproperties
{
    bUseSwapVote=true
    MapVoteIntervalDuration=5.0
    lmsgMapVotedTooRecently="Please wait %seconds% seconds before voting for another map!"
    SwapAndRestartText="DH-[Swap Teams and Restart]"
}
