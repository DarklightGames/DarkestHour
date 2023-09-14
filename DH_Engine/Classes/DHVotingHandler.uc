//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVotingHandler extends xVotingHandler;

var class<VotingReplicationInfo> VotingReplicationInfoClass;

var config private int   PatronVoteModifiers[5];
var config         float MaxVotePower;

var localized string    lmsgMapVotedTooRecently;
var localized string    SwapAndRestartText;

var config    float     MapVoteIntervalDuration;
var config    bool      bUseSwapVote;

var private bool        bIsReapplyingVotes; // HACK: Flag to stop admin votes from force-switching the map upon reapplication of votes

// Deprecated functions
function SaveAccVotes(int WinningMapIndex, int WinningGameIndex){}
function SubmitKickVote(int PlayerID, Actor Voter){}
function UpdateKickVoteCount(int PlayerID, int VoteCountDelta){}
function TallyKickVotes(){}
function KickPlayer(int PlayerIndex){}

// Overriden to allow map voting in single-player (for debug purposes)
function PostBeginPlay()
{
    local int i;

    super(VotingHandler).PostBeginPlay();

    if (Level.NetMode == NM_Standalone &&
        !class'DHVotingReplicationInfo'.default.bEnableSinglePlayerVoting)
    {
        return;
    }

    bMatchSetup = bMatchSetup && MATCHSETUPALLOWED;

    if (bKickVote)
    {
        Log("Kick Voting Enabled", 'MapVote');
    }
    else
    {
        Log("Kick Voting Disabled", 'MapVote');
    }

    if (bMapVote)
    {
        Log("Map Voting Enabled", 'MapVote');

        // Check current game settings
        if (GameConfig.Length > 0)
        {
            if (!(string(Level.Game.Class) ~= GameConfig[CurrentGameConfig].GameClass))
            {
                CurrentGameConfig = 0;

                // Find matching game type in game config
                for (i=0; i < GameConfig.Length; i++)
                {
                    if (GameConfig[i].GameClass ~= string(Level.Game.Class))
                    {
                        CurrentGameConfig = i;
                        break;
                    }
                }
            }
        }
        else
        {
            CurrentGameConfig = 0;
        }

        LoadMapList();
    }
    else
    {
        Log("Map Voting Disabled", 'MapVote');
    }

    if (bMatchSetup)
    {
        Log("MatchSetup Enabled", 'MapVote');

        MatchProfile = CreateMatchProfile();
        MatchProfile.Init(Level);
        MatchProfile.LoadCurrentSettings();
    }
    else
    {
        Log("MatchSetup Disabled", 'MapVote');
    }
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

// Overriden to use DHVotingReplicationInfo
function AddMapVoteReplicationInfo(PlayerController Player)
{
    local VotingReplicationInfo M;

    Log("___Spawning VotingReplicationInfo", 'MapVoteDebug');

    M = Spawn(VotingReplicationInfoClass, Player,, Player.Location);

    if (M == None)
    {
        Log("___Failed to spawn VotingReplicationInfo", 'MapVote');
        return;
    }

    M.PlayerID = Player.PlayerReplicationInfo.PlayerID;
    MVRI[MVRI.Length] = M;
}

// Modified to allow for specific repeat limit
function AddMap(string MapName, string Mutators, string GameOptions) // called from the MapListLoader
{
    local MapHistoryInfo MapInfo;
    local bool bUpdate;
    local int i;
    local int RepeatLimitInstance;

    for (i = 0; i < MapList.Length; i++)  // dont add duplicate map names
    {
        if (MapName ~= MapList[i].MapName)
        {
            return;
        }
    }

    // Get the MapInfo (important to have above other stuff)
    MapInfo = History.GetMapHistory(MapName);

    RepeatLimitInstance = RepeatLimit;

    if (MapInfo.U != "" && int(MapInfo.U) >= 0)
    {
        RepeatLimitInstance = int(MapInfo.U);
    }

    MapList.Length = MapCount + 1;
    MapList[MapCount].MapName = MapName;
    MapList[MapCount].PlayCount = MapInfo.P;
    MapList[MapCount].Sequence = MapInfo.S;
    MapList[MapCount].bEnabled = MapInfo.S == 0 || MapInfo.S > RepeatLimitInstance;

    MapCount++;

    /* Commented out to instead support per map vote repeat limit (this might be moved later)
    if (Mutators != "" && Mutators != MapInfo.U)
    {
        MapInfo.U = Mutators;
        bUpdate = true;
    }
    */

    if (GameOptions != "" && GameOptions != MapInfo.G)
    {
        MapInfo.G = GameOptions;
        bUpdate = true;
    }

    if (MapInfo.M == "") // if map not found in MapVoteHistory then add it
    {
        MapInfo.M = MapName;
        bUpdate = true;
    }

    if (bUpdate)
    {
        History.AddMap(MapInfo);
    }
}

// Modified to not include per-map game options in the URL string (so we can instead use it for a level's specific repeat limit for voting)
function string SetupGameMap(MapVoteMapList MapInfo, int GameIndex, MapHistoryInfo MapHistoryInfo)
{
    local string            ReturnString, MutatorString, OptionString;
    local array<string>     MapsInRotation;
    local int               i;

    // Add Per-GameType Mutators
    if (GameConfig[GameIndex].Mutators != "")
    {
        MutatorString = MutatorString $ GameConfig[GameIndex].Mutators;
    }

    // Add Per-Map Mutators
    /* Commented out for support of per-map vote repeat limit
    if (MapHistoryInfo.U != "")
    {
        MutatorString = MutatorString $ "," $ MapHistoryInfo.U;
    }
    */

    // Add Per-GameType Game Options
    if (GameConfig[GameIndex].Options != "")
    {
        OptionString = OptionString $ Repl(Repl(GameConfig[GameIndex].Options,",","?")," ","");
    }

    // Remove the .rom off of the map name, if it exists
    if (Right(MapInfo.MapName, 4) == ".rom")
    {
        ReturnString = Left(MapInfo.MapName, Len(MapInfo.MapName) - 4);
    }
    else
    {
        ReturnString = MapInfo.MapName;
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

    ReturnString = ReturnString $ "?Game=" $ GameConfig[GameIndex].GameClass;

    if (MutatorString != "")
    {
        ReturnString = ReturnString $ "?Mutator=" $ MutatorString;
    }

    if (OptionString != "")
    {
        ReturnString = ReturnString $ "?" $ OptionString;
    }

    return ReturnString;
}

// Overriden to add single-player debugging
function PlayerJoin(PlayerController Player)
{
    if (Level.NetMode == NM_Standalone &&
        !class'DHVotingReplicationInfo'.default.bEnableSinglePlayerVoting)
    {
        return;
    }

    if (!Player.IsA('XPlayer')) // no bots
    {
        return;
    }

    if (bMapVote || bKickVote || bMatchSetup)
    {
        Log("___New Player Joined - " $
            Player.PlayerReplicationInfo.PlayerName $
            ", " $
            Player.GetPlayerNetworkAddress(),'MapVote');
        AddMapVoteReplicationInfo(Player);
    }
}

// NOTE: overridden to fix vote 'duplication' bug
function PlayerExit(Controller Exiting)
{
    local int ExitingPlayerIndex, i, x;

    if (Level.NetMode == NM_Standalone &&
        !class'DHVotingReplicationInfo'.default.bEnableSinglePlayerVoting)
    {
        return;
    }

    ExitingPlayerIndex = -1;

    if (bMapVote)
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
            }

            if (MVRI[i] != none && (MVRI[i].PlayerOwner == none || MVRI[i].PlayerOwner == Exiting))
            {
                Log("___Destroying VRI...", 'MapVoteDebug');

                MVRI[i].Destroy();
                MVRI[i] = none;

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
// also guts out other vote modes as we should only be using 1 in DH
function SubmitMapVote(int MapIndex, int GameIndex, Actor Voter)
{
    local MapHistoryInfo MapInfo;
    local DHPlayer       P;
    local int            Index, VoteCount, PrevMapVote, PrevGameVote;

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

    if (!bIsReapplyingVotes && PlayerController(Voter).PlayerReplicationInfo.bAdmin || PlayerController(Voter).PlayerReplicationInfo.bSilentAdmin) // administrator vote
    {
        TextMessage = lmsgAdminMapChange;
        TextMessage = Repl(TextMessage, "%mapname%", PrepMapStr(MapList[MapIndex].MapName));
        Level.Game.Broadcast(self, TextMessage);
        Log("Admin has forced map switch to " $ MapList[MapIndex].MapName $ "(" $ GameConfig[GameIndex].Acronym $ ")", 'MapVote');

        if (MapList[MapIndex].MapName == SwapAndRestartText)
        {
            ExitVoteAndSwap();

            return;
        }

        CloseAllVoteWindows();
        bLevelSwitchPending = true;
        MapInfo = History.PlayMap(MapList[MapIndex].MapName);
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

    Log("___" $ Index $ " - " $ PlayerController(Voter).PlayerReplicationInfo.PlayerName $ " voted for " $ MapList[MapIndex].MapName $ "(" $ GameConfig[GameIndex].Acronym $ ")", 'MapVote');

    PrevMapVote = MVRI[Index].MapVote;
    PrevGameVote = MVRI[Index].GameVote;
    MVRI[Index].MapVote = MapIndex;
    MVRI[Index].GameVote = GameIndex;

    // Sets the vote count for the player based on the player's score (to a maximum)
    VoteCount = GetPlayerVotePower(PlayerController(Voter));
    TextMessage = lmsgMapVotedForWithCount;

    if (P != none)
    {
        P.MapVoteTime = Level.TimeSeconds;
    }

    if (!DarkestHourGame(Level.Game).IsInState('MatchOver'))
    {
        TextMessage = Repl(TextMessage, "%votecount%", string(VoteCount));
        TextMessage = Repl(TextMessage, "%playername%", PlayerController(Voter).PlayerReplicationInfo.PlayerName);
        TextMessage = Repl(TextMessage, "%mapname%", PrepMapStr(MapList[MapIndex].MapName));
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
// Guts voting mode options, as DH only uses 1 vote method
function TallyVotes(bool bForceMapSwitch)
{
    local MapHistoryInfo MapInfo;
    local string         CurrentMap;
    local array<int>     VoteCount, Ranking;
    local int            Index, MapIdx, GameIdx, TopMap, PlayersThatVoted, Votes, TieCount, r, x, y;

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

            // Get the vote power of the player
            Votes = GetPlayerVotePower(MVRI[x].PlayerOwner);

            VoteCount[MVRI[x].GameVote * MapCount + MVRI[x].MapVote] = VoteCount[MVRI[x].GameVote * MapCount + MVRI[x].MapVote] + Votes;
        }
    }

    Log("___Voted - " $ PlayersThatVoted, 'MapVoteDebug');

    // Mid game vote initiated
    if (Level.Game.GetNumPlayers() > 2 && !Level.Game.bGameEnded && !bMidGameVote && (float(PlayersThatVoted) / float(Level.Game.GetNumPlayers())) * 100 >= MidGameVotePercent)
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

            while (MapList[TopMap - (TopMap / MapCount) * MapCount].MapName ~= CurrentMap)
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

    // If everyone has voted go ahead and change map
    if (bForceMapSwitch || (Level.Game.GetNumPlayers() == PlayersThatVoted && Level.Game.GetNumPlayers() > 0))
    {
        if (MapList[TopMap - TopMap / MapCount * MapCount].MapName == "")
        {
            return;
        }

        if (MapList[TopMap - TopMap / MapCount * MapCount].MapName == SwapAndRestartText)
        {
            ExitVoteAndSwap();

            return;
        }

        TextMessage = lmsgMapWon;
        TextMessage = Repl(TextMessage, "%mapname%", MapList[TopMap - TopMap / MapCount * MapCount].MapName $ "(" $ GameConfig[TopMap / MapCount].Acronym $ ")");
        Level.Game.Broadcast(self, TextMessage);

        CloseAllVoteWindows();

        MapInfo = History.PlayMap(MapList[TopMap - TopMap / MapCount * MapCount].MapName);
        ServerTravelString = SetupGameMap(MapList[TopMap - TopMap / MapCount * MapCount], TopMap / MapCount, MapInfo);
        Log("ServerTravelString =" $ ServerTravelString, 'MapVoteDebug');
        History.Save();

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

// DH function which will calculate a specific player's voting power
function int GetPlayerVotePower(PlayerController Player)
{
    local DHPlayerReplicationInfo PRI;

    PRI = DHPlayerReplicationInfo(Player.PlayerReplicationInfo);

    if (PRI == none)
    {
        return 0;
    }

    return 1 + PatronVoteModifiers[PRI.PatronTier];
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

// Updates all map votes that have been cast
function ReapplyMapVotes()
{
    local int i, x;

    bIsReapplyingVotes = true;

    // Reapply votes
    for (i = 0; i < MVRI.Length; ++i)
    {
        if (MVRI[i] != none && MVRI[i].MapVote > -1 && MVRI[i].GameVote > -1) // Did the player vote
        {
            for (x = 0; x < MapVoteCount.Length; x++)
            {
                if (MVRI[i].MapVote == MapVoteCount[x].MapIndex && MVRI[i].GameVote == MapVoteCount[x].GameConfigIndex)
                {
                    SubmitMapVote(MapVoteCount[x].MapIndex, MapVoteCount[x].GameConfigIndex, MVRI[i].PlayerOwner);
                    break;
                }
            }
        }
    }

    bIsReapplyingVotes = false;
}

// Override to add additional vote options
function LoadMapList()
{
    local class<MapListLoader> MapListLoaderClass;
    local MapListLoader        Loader;
    local int                  i;

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

    if (bUseSwapVote)
    {
        AddMap(SwapAndRestartText, "", "");
    }

    Loader.LoadMapList(self);

    Log(MapCount $ " maps loaded.", 'MapVote');

    History.Save();

    Loader.Destroy();
}

function MidGameVote()
{
    if (bMidGameVote)
    {
        return;
    }

    Level.Game.Broadcast(self, lmsgMidGameVote);
    bMidGameVote = true;
    TimeLeft = VoteTimeLimit;
    ScoreBoardTime = 1;
    SetTimer(1.0, true);
}

// Override to remove deprecated server options
static function FillPlayInfo(PlayInfo PlayInfo)
{
    super(VotingHandler).FillPlayInfo(PlayInfo);

    PlayInfo.AddSetting(default.MapVoteGroup,"bMapVote",default.PropsDisplayText[0],0,1,"Check",,,true,false);
    PlayInfo.AddSetting(default.MapVoteGroup,"bAutoOpen",default.PropsDisplayText[1],0,1,"Check",,,true,true);
    PlayInfo.AddSetting(default.MapVoteGroup,"ScoreBoardDelay",default.PropsDisplayText[2],0,1,"Text","3;0:60",,true,true);
    PlayInfo.AddSetting(default.MapVoteGroup,"RepeatLimit",default.PropsDisplayText[7],0,1,"Text","4;0:9999",,true,true);
    PlayInfo.AddSetting(default.MapVoteGroup,"VoteTimeLimit",default.PropsDisplayText[8],0,1,"Text","3;10:300",,true,true);
    PlayInfo.AddSetting(default.MapVoteGroup,"MidGameVotePercent",default.PropsDisplayText[9],0,1,"Text","3;1:100",,true,true);
    PlayInfo.AddSetting(default.MapVoteGroup,"bDefaultToCurrentGameType",default.PropsDisplayText[10],0,1,"Check",,,true,true);
    PlayInfo.AddSetting(default.MapVoteGroup,"GameConfig",default.PropsDisplayText[15],0, 1,"Custom",";;"$default.GameConfigPage,,true,true);

    class'DefaultMapListLoader'.static.FillPlayInfo(PlayInfo);
    PlayInfo.PopClass();
}

defaultproperties
{
    VotingReplicationInfoClass=class'DHVotingReplicationInfo'

    bUseSwapVote=true
    MapVoteIntervalDuration=3.0
    lmsgMapVotedTooRecently="Please wait %seconds% seconds before voting another map!"
    SwapAndRestartText="DH-[Swap Teams and Restart]"

    MaxVotePower=10

    PatronVoteModifiers(0)=0    // Not Patron
    PatronVoteModifiers(1)=1    // Lead
    PatronVoteModifiers(2)=2    // Bronze
    PatronVoteModifiers(3)=3    // Silver
    PatronVoteModifiers(4)=4    // Gold
}
