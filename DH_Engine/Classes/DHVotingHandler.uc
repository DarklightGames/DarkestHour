//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHVotingHandler extends xVotingHandler;

var localized string    lmsgMapVotedTooRecently;
var localized string    SwapAndRestartText;

var config    float     MapVoteIntervalDuration;
var config    bool      bUseSwapVote;

var array<JSONObject>   MapObjects;

var TreeMap_string_int  MapNameIndices;

function PostBeginPlay()
{
    MapNameIndices = new class'TreeMap_string_int';

    super.PostBeginPlay();
}

function int GetMapIndex(string MapName)
{
    local int Index;

    if (MapNameIndices != none && MapNameIndices.Get(MapName, Index))
    {
        return Index;
    }

    return -1;
}

// Modified to avoid calling PlayCountDown() on the VotingReplicationInfo as that just spams log errors as this game doesn't have a StatusAnnouncer actor
function Timer()
{
    local MapHistoryInfo MapInfo;
    local int            Mapidx, GameIdx;

    if (bLevelSwitchPending)
    {
        if (Level.NextURL == "")
        {
            // If negative then level switch failed
            if (Level.NextSwitchCountdown < 0)
            {
                Log("___Map change FAILED - bad or missing map file", 'MapVote');
                GetDefaultMap(Mapidx, GameIdx);
                MapInfo = History.PlayMap(MapList[Mapidx].MapName);
                ServerTravelString = SetupGameMap(MapList[Mapidx], GameIdx, MapInfo);
                Log("ServerTravelString =" @ ServerTravelString, 'MapVoteDebug');
                History.Save();
                Level.ServerTravel(ServerTravelString, false); // change the map
            }
        }

        return;
    }

    if (ScoreBoardTime > -1)
    {
        if (ScoreBoardTime == 0)
        {
            OpenAllVoteWindows();
        }

        ScoreBoardTime--;

        return;
    }

    TimeLeft--;

    // Force level switch if time limit is up (if no-one has voted a random map will be chosen)
    if (TimeLeft == 0)
    {
        TallyVotes(true);
    }
}

// Modified to handle map specific repeat limit
function AddMap(string MapName, string Mutators, string GameOptions)
{
    local MapHistoryInfo        MapInfo;
    local bool                  bUpdate;
    local int                   i, MapRepeatLimit;
    local JSONObject            MapObject;
    local string                DecodedString;

    // Dont add duplicate map names
    for (i = 0; i < MapList.Length; ++i)
    {
        if(MapName ~= MapList[i].MapName)
        {
            return;
        }
    }

    MapInfo = History.GetMapHistory(MapName);

    MapList.Length = MapCount + 1;

    if (MapInfo.G != "")
    {
        DecodedString = class'UTF8Encoding'.static.FromByteArray(class'Base64Encoding'.static.Decode(MapInfo.G));
        MapObject = (new class'JSONParser').ParseObject(DecodedString);

        if (MapObject != none)
        {
            MapObject.PutString("MapName", MapName);
        }

        MapObjects[MapCount] = MapObject;

        if (MapNameIndices != none)
        {
            MapNameIndices.Put(MapName, MapCount);
        }

        MapList[MapCount].MapName = MapObject.Encode();
    }
    else
    {
        MapList[MapCount].MapName = MapName;
    }

    MapList[MapCount].PlayCount = MapInfo.P;
    MapList[MapCount].Sequence = MapInfo.S;

    // Check if there is specific repeat limit for this map
    if (MapObject != none && MapObject.Get("RepeatLimit") != none)
    {
        // Change MapRepeatLimit to our specific value for this map
        MapRepeatLimit = MapObject.Get("RepeatLimit").AsInteger();
    }
    else
    {
        MapRepeatLimit = RepeatLimit; // Server base value
    }

    // Set the map to enabled/disabled based on MapRepeatLimit
    MapList[MapCount].bEnabled = MapInfo.S > MapRepeatLimit || MapInfo.S == 0;

    ++MapCount;

    if (Mutators != "" && Mutators != MapInfo.U)
    {
        MapInfo.U = Mutators;
        bUpdate = true;
    }

    if (MapInfo.M == "")
    {
        MapInfo.M = MapName;
        bUpdate = true;
    }

    if (bUpdate)
    {
        History.AddMap(MapInfo);
    }
}

// Modified to use DHVotingReplicationInfo
function AddMapVoteReplicationInfo(PlayerController Player)
{
    local DHVotingReplicationInfo M;

    if (class'DH_LevelInfo'.static.DHDebugMode())
    {
        Log("___Spawning VotingReplicationInfo", 'MapVoteDebug');
    }

    M = Spawn(class'DHVotingReplicationInfo', Player, , Player.Location);

    if (M == none)
    {
        Log("___Failed to spawn VotingReplicationInfo", 'MapVote');
        return;
    }

    M.PlayerID = Player.PlayerReplicationInfo.PlayerID;
    MVRI[MVRI.Length] = M;
}

// NOTE: overridden to fix vote 'duplication' bug
function PlayerExit(Controller Exiting)
{
    local int ExitingPlayerIndex, i, x;

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
                Log("exiting player MVRI found" @ i, 'MapVoteDebug');

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

// Function to strip prefix
function string PrepMapStr(string MapName)
{
    MapName = Repl(MapName, "DH-", "");  // remove DH- prefix
    MapName = Repl(MapName, ".rom", ""); // remove .rom if it exists
    MapName = Repl(MapName, "_", " ");   // remove _ for space

    return MapName;
}

// Overridden to stop rapid-fire voting, handle more aesthetic messages, and handle swap teams vote
function SubmitMapVote(int MapIndex, int GameIndex, Actor Voter)
{
    local MapHistoryInfo MapInfo;
    local DHPlayer       P;
    local int            Index, VoteCount, PrevMapVote, PrevGameVote;
    local string         MapNameString;
    local JSONObject     MapObject;

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

    // Check for invalid vote from unpatch players
    if (!IsValidVote(MapIndex, GameIndex))
    {
        return;
    }

    MapObject = MapObjects[MapIndex];

    if (MapObject != none && MapObject.Get("MapName") != none)
    {
        MapNameString = MapObject.Get("MapName").AsString();
    }
    else
    {
        MapNameString = MapList[MapIndex].MapName;
    }

    if (PlayerController(Voter).PlayerReplicationInfo.bAdmin || PlayerController(Voter).PlayerReplicationInfo.bSilentAdmin) // administrator vote
    {
        TextMessage = lmsgAdminMapChange;
        TextMessage = Repl(TextMessage, "%mapname%", PrepMapStr(MapNameString));
        Level.Game.Broadcast(self, TextMessage);
        Log("Admin has forced map switch to " $ MapNameString $ "(" $ GameConfig[GameIndex].Acronym $ ")", 'MapVote');

        if (MapNameString == SwapAndRestartText)
        {
            ExitVoteAndSwap();

            return;
        }

        CloseAllVoteWindows();
        bLevelSwitchPending = true;
        MapInfo = History.PlayMap(MapNameString);
        ServerTravelString = SetupGameMap(MapList[MapIndex], GameIndex, MapInfo);
        Log("ServerTravelString = " $ ServerTravelString, 'MapVoteDebug');
        Level.ServerTravel(ServerTravelString, false); // change the map
        SetTimer(1.0, true);

        return;
    }

    // Spectators cant vote
    if (PlayerController(Voter).PlayerReplicationInfo.bOnlySpectator)
    {
        PlayerController(Voter).ClientMessage(lmsgSpectatorsCantVote);

        return;
    }

    // Check for invalid map, invalid gametype, player isn't re-voting same as previous vote, & map chosen isn't disabled
    if (MapIndex < 0 ||
        MapIndex >= MapCount ||
        GameIndex >= GameConfig.Length ||
        (MVRI[Index].GameVote == GameIndex && MVRI[Index].MapVote == MapIndex) ||
        !MapList[MapIndex].bEnabled)
    {
        return;
    }

    if (class'DH_LevelInfo'.static.DHDebugMode())
    {
        Log("___" $ Index $ " - " $ PlayerController(Voter).PlayerReplicationInfo.PlayerName $ " voted for " $ MapNameString $ "(" $ GameConfig[GameIndex].Acronym $ ")", 'MapVote');
    }

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
        TextMessage = Repl(TextMessage, "%mapname%", PrepMapStr(MapNameString));
        Level.Game.Broadcast(self, TextMessage);
    }

    UpdateVoteCount(MapIndex, GameIndex, VoteCount);

    if (PrevMapVote > -1 && PrevGameVote > -1)
    {
        UpdateVoteCount(PrevMapVote, PrevGameVote, -MVRI[Index].VoteCount); // undo previous vote
    }

    MVRI[Index].VoteCount = VoteCount;

    TallyVotes(false);
}

// Overridden to handle consolidated MapName
function bool IsValidVote(int MapIndex, int GameIndex)
{
    local int               i;
    local array<string>     PrefixList;
    local JSONObject        MapObject;
    local string            MapNameString;

    // Check if the maps prefix is one listed for the gametype
    Split(GameConfig[GameIndex].Prefix, ",", PrefixList);

    MapObject = MapObjects[MapIndex];

    if (MapObject != none && MapObject.Get("MapName") != none)
    {
        MapNameString = MapObject.Get("MapName").AsString();
    }
    else
    {
        MapNameString = MapList[MapIndex].MapName;
    }

    for (i = 0; i < PreFixList.Length; ++i)
    {
        if (Left(MapNameString, Len(PrefixList[i])) ~= PrefixList[i])
        {
            return true;
        }
    }

    return false;
}

// Overridden for consolidate MapName
function string SetupGameMap(MapVoteMapList MapInfo, int GameIndex, MapHistoryInfo MapHistoryInfo)
{
    local string            ReturnString, MutatorString, OptionString, MapNameString;
    local array<string>     MapsInRotation;
    local int               i;
    local JSONObject        MapObject;

    // Add Per-GameType Mutators
    if (GameConfig[GameIndex].Mutators != "")
    {
        MutatorString = MutatorString $ GameConfig[GameIndex].Mutators;
    }

    // Add Per-Map Mutators
    if (MapHistoryInfo.U != "")
    {
        MutatorString = MutatorString $ "," $ MapHistoryInfo.U;
    }

    // Add Per-GameType Game Options
    if (GameConfig[GameIndex].Options != "")
    {
        OptionString = OptionString $ Repl(Repl(GameConfig[GameIndex].Options, ",", "?"), " ", "");
    }

    // Add Per-Map Game Options
    if (MapHistoryInfo.G != "")
    {
        OptionString = OptionString $ "?" $ MapHistoryInfo.G;
    }

    MapObject = MapObjects[GetMapIndex(MapInfo.MapName)];

    if (MapObject != none && MapObject.Get("MapName") != none)
    {
        MapNameString = MapObject.Get("MapName").AsString();
    }
    else
    {
        MapNameString = MapInfo.MapName;
    }

    // Remove the .rom off of the map name, if it exists
    if (Right(MapNameString, 4) == ".rom")
    {
        ReturnString = Left(MapNameString, Len(MapNameString) - 4);
    }
    else
    {
        ReturnString = MapNameString;
    }

    MapsInRotation = Level.Game.MaplistHandler.GetCurrentMapRotation();

    for (i = 0; i < MapsInRotation.Length; ++i)
    {
        if (InStr(MapsInRotation[i], ReturnString) != -1)
        {
            ReturnString = MapsInRotation[i];
            break;
        }
    }

    return ReturnString;
}

// Overridden to fix accessed none errors - the logic of the function itself is a nightmare and whoever wrote it is a criminal
function GetDefaultMap(out int MapIdx, out int GameIdx)
{
    local array<string> PrefixList;
    local bool          bLoop;
    local int           GCIdx, i, p, r, x, y;

    if (MapCount <= 0)
    {
        return;
    }

    // Set the default gametype
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
        GameIdx = GCIdx;
        MapIdx = 0;

        return;
    }

    // Choose a map at random, check if it is enabled and the prefix is in the prefix list
    r = 0;
    bLoop = true;

    while (bLoop)
    {
        i = Rand(MapCount);

        if (MapList[i].bEnabled)
        {
            for (x = 0; x < PrefixList.Length; ++x)
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
            // Find the first map that matches up to default gametype
            // Give up after 100 unsuccessful attempts
            for (i = 0; i < MapCount; ++i)
            {
                if (MapList[i].bEnabled)
                {
                    for (x = 0; x < PrefixList.Length; ++x)
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
                for (i = 0; i < MapCount; ++i)
                {
                    if (MapList[i].bEnabled)
                    {
                        // Find prefix in GameConfigs
                        for (y = 0; y < GameConfig.Length; ++y)
                        {
                            // Parse Prefix list for game type
                            PrefixList.Length = 0;
                            p = Split(GameConfig[y].Prefix, ",", PrefixList);

                            if (PrefixList.Length > 0)
                            {
                                for (x = 0; x < PrefixList.Length; ++x)
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

    GameIdx = GCIdx;
    MapIdx = i;

    Log("Default Map Chosen = " $ MapList[MapIdx].MapName $ "(" $ GameConfig[GameIdx].Acronym $ ")", 'MapVoteDebug');
}

// Override to support additional vote options like Swap Teams and Restart
function TallyVotes(bool bForceMapSwitch)
{
    local MapHistoryInfo MapInfo;
    local string         CurrentMap, MapNameString;
    local array<int>     VoteCount, Ranking;
    local int            Index, MapIdx, GameIdx, TopMap, PlayersThatVoted, Votes, TieCount, r, x, y, CalcIndex;
    local JSONObject     MapObject;

    if (bLevelSwitchPending)
    {
        return;
    }

    PlayersThatVoted = 0;
    VoteCount.Length = GameConfig.Length * MapCount;

    for (x = 0; x < MVRI.Length; ++x) // for each player
    {
        if (MVRI[x] != none && MVRI[x].MapVote > -1 && MVRI[x].GameVote > -1) // if this player has voted
        {
            PlayersThatVoted++;

            if (bScoreMode)
            {
                if (bAccumulationMode)
                {
                    Votes = GetAccVote(MVRI[x].PlayerOwner) + int(GetPlayerScore(MVRI[x].PlayerOwner));
                }
                else
                {
                    Votes = int(GetPlayerScore(MVRI[x].PlayerOwner));
                }
            }
            // Not Score Mode == Majority (one vote per player)
            else
            {
                if (bAccumulationMode)
                {
                    Votes = GetAccVote(MVRI[x].PlayerOwner) + 1;
                }
                else
                {
                    Votes = 1;
                }
            }

            VoteCount[MVRI[x].GameVote * MapCount + MVRI[x].MapVote] = VoteCount[MVRI[x].GameVote * MapCount + MVRI[x].MapVote] + Votes;

            // If more then half the players voted for the same map as this player then force a winner
            if (!bScoreMode && Level.Game.NumPlayers > 2 && float(VoteCount[MVRI[x].GameVote * MapCount + MVRI[x].MapVote]) / float(Level.Game.NumPlayers) > 0.5 && Level.Game.bGameEnded)
            {
                bForceMapSwitch = true;
            }
        }
    }

    Log("___Voted - " $ PlayersThatVoted, 'MapVoteDebug');

    // Mid game vote initiated
    if (Level.Game.NumPlayers > 2 && !Level.Game.bGameEnded && !bMidGameVote && (float(PlayersThatVoted) / float(Level.Game.NumPlayers)) * 100 >= MidGameVotePercent)
    {
        MidGameVote();
    }

    Index = 0;

    for (x = 0; x < VoteCount.Length; ++x) // for each map
    {
        if (VoteCount[x] > 0)
        {
            Ranking.Insert(Index, 1);
            Ranking[Index++] = x; // copy all vote indexes to the ranking list if someone has voted for it.
        }
    }

    if (PlayersThatVoted > 1)
    {
        // Bubble sort ranking list by vote count
        for (x = 0; x < Index - 1; ++x)
        {
            for (y = x + 1; y < Index; ++y)
            {
                if (VoteCount[Ranking[x]] < VoteCount[Ranking[y]])
                {
                    TopMap = Ranking[x];
                    Ranking[x] = Ranking[y];
                    Ranking[y] = TopMap;
                }
            }
        }
    }
    else
    {
        if (PlayersThatVoted == 0)
        {
            GetDefaultMap(MapIdx, GameIdx);
            TopMap = GameIdx * MapCount + MapIdx;
        }
        else
        {
            TopMap = Ranking[0]; // only one player voted
        }
    }

    CalcIndex = TopMap - TopMap / MapCount * MapCount;

    if (GetMapIndex(MapList[CalcIndex].MapName) >= 0 && GetMapIndex(MapList[CalcIndex].MapName) < MapObjects.Length)
    {
        MapObject = MapObjects[GetMapIndex(MapList[CalcIndex].MapName)];
    }

    if (MapObject != none && MapObject.Get("MapName") != none)
    {
        MapNameString = MapObject.Get("MapName").AsString();
    }
    else
    {
        MapNameString = MapList[CalcIndex].MapName;
    }

    // Check for a tie
    if (PlayersThatVoted > 1) // need more than one player vote for a tie
    {
        if (Index > 1 && VoteCount[Ranking[0]] == VoteCount[Ranking[1]] && VoteCount[Ranking[0]] != 0)
        {
            TieCount = 1;

            for (x = 1; x < Index; ++x)
            {
                if (VoteCount[Ranking[0]] == VoteCount[Ranking[x]])
                {
                    TieCount++;
                }
            }

            // Reminder ---> int Rand(int Max); Returns a random number from 0 to Max-1.
            TopMap = Ranking[Rand(TieCount)];

            // Don't allow same map to be chosen
            CurrentMap = GetURLMap();

            r = 0;

            while (MapNameString ~= CurrentMap)
            {
                TopMap = Ranking[Rand(TieCount)];

                if (r++ > 100)
                {
                    break; // just in case
                }
            }
        }
        else
        {
            TopMap = Ranking[0];
        }
    }

    CalcIndex = TopMap - TopMap / MapCount * MapCount;

    // If everyone has voted go ahead and change map
    if (bForceMapSwitch || (Level.Game.NumPlayers == PlayersThatVoted && Level.Game.NumPlayers > 0))
    {
        if (MapNameString == "")
        {
            return;
        }

        if (MapNameString == SwapAndRestartText)
        {
            ExitVoteAndSwap();

            return;
        }

        TextMessage = lmsgMapWon;
        TextMessage = Repl(TextMessage, "%mapname%", MapNameString $ "(" $ GameConfig[TopMap / MapCount].Acronym $ ")");
        Level.Game.Broadcast(self, TextMessage);

        CloseAllVoteWindows();

        MapInfo = History.PlayMap(MapNameString);
        ServerTravelString = SetupGameMap(MapList[CalcIndex], TopMap / MapCount, MapInfo);
        Log("ServerTravelString =" $ ServerTravelString, 'MapVoteDebug');
        History.Save();

        if (bEliminationMode)
        {
            RepeatLimit++;
        }

        if (bAccumulationMode)
        {
            SaveAccVotes(CalcIndex, TopMap / MapCount);
        }

        CurrentGameConfig = TopMap / MapCount;

        if (!bAutoDetectMode)
        {
            SaveConfig();
        }

        bLevelSwitchPending = true;
        SetTimer(Level.TimeDilation, true); // Timer() will monitor the server-travel & detect a failure
        Level.ServerTravel(ServerTravelString, false); // change the map
    }
}

function ExitVoteAndSwap()
{
    local DarkestHourGame DHG;

    CloseAllVoteWindows();
    ResetMapVotes();
    bMidGameVote = false;
    SetTimer(0.0, false); // stop the timer
    DHG = DarkestHourGame(Level.Game);

    if (DHG != none)
    {
        DHG.bGameRestarted = false; // have to reset this for the next round, or at the end of it the server will end up jammed (state MatchOver timer won't re-start)
        DHG.bGameEnded = false;
        DHG.SwapTeams();
    }
}

// Resets all player votes
function ResetMapVotes()
{
    local int i, x;

    if (!bMapVote)
    {
        return;
    }

    for (i = 0; i < MVRI.Length; ++i)
    {
        if (MVRI[i] != none && MVRI[i].MapVote > -1 && MVRI[i].GameVote > -1)
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
    local class<MapListLoader> MapListLoaderClass;
    local MapListLoader        Loader;
    local int                  EnabledMapCount, i;

    MapList.Length = 0;
    MapCount = 0;

    MapVoteHistoryClass = class<MapVoteHistory>(DynamicLoadObject(MapVoteHistoryType, class'Class'));
    History = new(none, "MapVoteHistory" $ string(ServerNumber)) MapVoteHistoryClass;

    if (History == none)
    {
        History = new(none, "MapVoteHistory" $ string(ServerNumber)) class'MapVoteHistory_INI';
    }

    Log("GameTypes:", 'MapVote');

    if (GameConfig.Length == 0)
    {
        bAutoDetectMode = true;

        // Default to ONLY current game type and maps
        GameConfig.Length = 1;
        GameConfig[0].GameClass = string(Level.Game.Class);
        GameConfig[0].Prefix = Level.Game.MapPrefix;
        GameConfig[0].Acronym = Level.Game.Acronym;
        GameConfig[0].GameName = Level.Game.GameName;
        GameConfig[0].Mutators="";
        GameConfig[0].Options="";
    }

    MapCount = 0;

    for (i = 0; i < GameConfig.Length; ++i)
    {
        if (GameConfig[i].GameClass != "")
        {
            Log(GameConfig[i].GameName, 'MapVote');
        }
    }

    Log("MapListLoaderType = " $ MapListLoaderType, 'MapVote');

    MapListLoaderClass = class<MapListLoader>(DynamicLoadObject(MapListLoaderType, class'Class'));
    Loader = Spawn(MapListLoaderClass);

    if (Loader == none)
    {
        Loader = Spawn(class'DefaultMapListLoader');
    }

    Loader.LoadMapList(self);

    if (bUseSwapVote)
    {
        AddMap(SwapAndRestartText, "", "");
    }

    Log(MapCount $ " maps loaded.", 'MapVote');

    History.Save();

    if (bEliminationMode)
    {
        // Count the Remaining Enabled maps
        EnabledMapCount = 0;

        for (i = 0; i < MapCount; ++i)
        {
            if (MapList[i].bEnabled)
            {
                EnabledMapCount++;
            }
        }

        if (EnabledMapCount < MinMapCount || EnabledMapCount == 0)
        {
            Log("Elimination Mode Reset/Reload.", 'MapVote');
            RepeatLimit = 0;
            MapList.Length = 0;
            MapCount = 0;
            SaveConfig();
            Loader.LoadMapList(self);
        }
    }

    Loader.Destroy();
}

function MidGameVote()
{
    if (bMidGameVote)
    {
        return;
    }

    Level.Game.Broadcast(self, lmsgMidGameVote);//
    bMidGameVote = true;
    TimeLeft = VoteTimeLimit;
    ScoreBoardTime = 1;
    SetTimer(1.0, true);
}

defaultproperties
{
    bUseSwapVote=true
    MapVoteIntervalDuration=5.0
    lmsgMapVotedTooRecently="Please wait %seconds% seconds before voting for another map!"
    SwapAndRestartText="DH-[Swap Teams and Restart]"
}
