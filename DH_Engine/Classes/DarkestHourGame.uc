//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

// To do: Stop casting GRI and just make a damn class variable and set it in PBP (we have 24 functions which declare a local)

class DarkestHourGame extends ROTeamGame;

var     Hashtable_string_Object     PlayerSessions; // When a player leaves the server this info is stored for the session so if they return these values won't reset

var     DH_LevelInfo                DHLevelInfo;

var     DHAmmoResupplyVolume        DHResupplyAreas[10];

var     array<DHSpawnArea>          DHMortarSpawnAreas;
var     DHSpawnArea                 DHCurrentMortarSpawnArea[2];

const   OBJECTIVES_MAX = 32;
var     DHObjective                 DHObjectives[OBJECTIVES_MAX];

var     DHSpawnManager              SpawnManager;
var     DHObstacleManager           ObstacleManager;
var     DHConstructionManager       ConstructionManager;

var     array<string>               FFViolationIDs;                         // Array of ROIDs that have been kicked once this session
var()   config bool                 bSessionKickOnSecondFFViolation;
var()   config bool                 bUseWeaponLocking;                      // Weapons can lock (preventing fire) for punishment
var     int                         WeaponLockTimeSecondsInterval;
var     int                         WeaponLockTimeSecondsMaximum;

var     bool                        bSkipPreStartTime;                      // Whether or not to skip the PreStartTime configured on the server

var     class<DHObstacleManager>    ObstacleManagerClass;

var()   config int                  ChangeTeamInterval;                     // Server setting determines how long before a player can change teams again after doing so
                                                                            // Also currently is the length of time for which a player can change teams for free at the beginning of a round
                                                                            // Note: if bPlayersBalanceTeams is false, players will still be able to change teams

var     array<float>                ReinforcementMessagePercentages;
var     int                         TeamReinforcementMessageIndices[2];
var     int                         bTeamOutOfReinforcements[2];
var     int                         OriginalReinforcementIntervals[2];

const SERVERTICKRATE_UPDATETIME =   5.0; // The duration we use to calculate the average tick the server is running
const MAXINFLATED_INTERVALTIME =    60.0; // The max value to add to reinforcement time for inflation
const SPAWN_KILL_RESPAWN_TIME =     2;

var()   config float                ServerTickForInflation;                 // Value that determines when inflation will start if ServerTickRateAverage is less than
var     float                       ServerTickRateAverage;                  // The average tick rate over the past SERVERTICKRATE_UPDATETIME
var     float                       ServerTickRateConsolidated;             // Keeps track of tick rates over time, used to calculate average
var     int                         ServerTickFrameCount;                   // Keeps track of how many frames are between ServerTickRateConsolidated

var     float                       CalculatedAttritionRate[2];
var     float                       TeamAttritionCounter[2];

var     bool                        bSwapTeams;
var     bool                        bUseReinforcementWarning;
var     bool                        bUseInfiniteReinforcements;             // Level should have infinite reinforcements regardless of the setting
var     bool                        bRoundEndsAtZeroReinf;
var     bool                        bTimeChangesAtZeroReinf;
var     bool                        bUseAttritionCurve;                     // Attrition will set in and change to the curve over time

var     InterpCurve                 ElapsedTimeAttritionCurve;              // Curve which inputs elapsed time and outputs attrition amount
                                                                            // used to setup a pseudo time limit for Advance/Attrition game modes
                                                                            // this way if there are not many players on, the round will eventually end

var     float                       AlliesToAxisRatio;

var     class<DHMetrics>            MetricsClass;
var     DHMetrics                   Metrics;
var     config bool                 bEnableMetrics;

var     bool                        bPublicPlay;                            // Variable to determine how things should behave (Private vs Public play)
                                                                            // An organized unit will want to set this to false in a mutator so they can control
                                                                            // settings for private matches (ex- change to false in realism match mode)
var     UVersion                    Version;
var     DHSquadReplicationInfo      SquadReplicationInfo;

var()   config int                  EmptyTankUnlockTime;                    // Server config option for how long (secs) before unlocking a locked armored vehicle if abandoned by its crew

// Patreon
var     array<string>   PatronROIDs;
var     HTTPRequest     PatronsRequest;

// Overridden to make new clamp of MaxPlayers
event InitGame(string Options, out string Error)
{
    super.InitGame(Options, Error);

    if (bIgnore32PlayerLimit)
    {
        MaxPlayers = Clamp(GetIntOption(Options, "MaxPlayers", MaxPlayers), 0, 128);
        default.MaxPlayers = Clamp(default.MaxPlayers, 0, 128);
    }

    if (Level.NetMode == NM_DedicatedServer)
    {
        // Send a request to get a list of all the patron ROIDs
        PatronsRequest = Spawn(class'HTTPRequest');
        PatronsRequest.Method = "GET";
        PatronsRequest.Host = "darkesthour.darklightgames.com";
        PatronsRequest.Path = "/client/patrons.php";
        PatronsRequest.OnResponse = PatronsRequestOnResponse;
        PatronsRequest.Send();
    }
}

function PreBeginPlay()
{
    super.PreBeginPlay();

    SquadReplicationInfo = Spawn(class'DHSquadReplicationInfo');
}

function PatronsRequestOnResponse(int Status, TreeMap_string_string Headers, string Content)
{
    local JSONParser Parser;
    local JSONArray A;
    local int i;
    local Controller C;
    local DHPlayer PC;
    local DHPlayerReplicationInfo PRI;

    if (Status == 200)
    {
        Parser = new class'JSONParser';
        A = Parser.ParseArray(Content);

        if (A != none)
        {
            // Clear old patron list
            PatronROIDs.Length = 0;

            for (i = 0 ; i < A.Size(); ++i)
            {
                PatronROIDs[PatronROIDs.Length] = A.Get(i).AsString();
            }

            // Go through existing controllers and assign their patron status
            for (C = Level.ControllerList; C != none; C = C.nextController)
            {
                PC = DHPlayer(C);
                PRI = DHPlayerReplicationInfo(C.PlayerReplicationInfo);

                if (PC != none && PRI != none)
                {
                    PRI.bIsPatron = IsPatron(PC.ROIDHash);
                }
            }
        }
    }
    else
    {
        Warn("Failed to fetch patron list!");
    }
}

function bool IsPatron(string ROIDHash)
{
    local int i;

    for (i = 0; i < PatronROIDs.Length; ++i)
    {
        if (ROIDHash ~= PatronROIDs[i])
        {
            return true;
        }
    }

    return false;
}

function PostBeginPlay()
{
    local DHGameReplicationInfo GRI;
    local ROLevelInfo           LI;
    local ROMapBoundsNE         NE;
    local ROMapBoundsSW         SW;
    local DHSpawnArea           DHSA;
    local DHAmmoResupplyVolume  ARV;
    local ROMineVolume          MV;
    local ROArtilleryTrigger    RAT;
    local SpectatorCam          ViewPoint;
    local DHObstacleInfo        DHOI;
    local bool                  bMultipleLevelInfos;
    local int                   i, j, k, m, n, o, p;

    // Matt: for info, this hack could be used to prevent net clients & SP from logging "accessed none" errors for redundant SteamStatsAndAchievements actor
    // Even though PostLogin() event has been overridden & SS&A functionality removed, some native code still calls the event's Super from GameInfo class
    // That tries to spawn a SS&A actor from GameInfo's default SS&A class, which is none, so the Super logs 2 errors as it lacks "!= none" checks
    // By setting a default SS&A class the actor gets spawned harmlessly without log errors, although it is pointless & immediately destroys itself
//  if (Level.NetMode != NM_DedicatedServer)
//  {
//      class'PlayerController'.default.SteamStatsAndAchievementsClass = class'ROSteamStatsAndAchievements';
//  }

    // Don't call the RO super because we already do everything for DH and don't
    // want levels using ROLevelInfo
    super(TeamGame).PostBeginPlay();

    Level.bKickLiveIdlers = MaxIdleTime > 0.0;

    // Find the DHLevelInfo
    // Note the DHLI is an extension of RHLI, so we look for RHLIs as that allows us to check for multiple DH/ROLevelInfos (a map set up error)
    foreach AllActors(class'ROLevelInfo', LI)
    {
        if (LevelInfo != none) // if we previously found either an ROLI or a DHLI, it will have been recorded as LevelInfo, so we've got some kind of extra LI
        {
            bMultipleLevelInfos = true;
        }

        if (LI.IsA('DH_LevelInfo') && DHLevelInfo == none)
        {
            DHLevelInfo = DH_LevelInfo(LI);
        }

        if (LevelInfo == none || (LevelInfo != DHLevelInfo && DHLevelInfo != none))
        {
            LevelInfo = LI; // even if we found & recorded an ROLevelInfo, if it's not the DHLI then we make it the DHLI (DHLI takes precedence)
        }

        if (bMultipleLevelInfos)
        {
            Log("DarkestHourGame: More than one DH/ROLevelInfo actor detected - should only be a single DHLevelInfo!");

            if (DHLevelInfo != none) // if we don't yet have a DHLI we'll keep looking as that is essential
            {
                break;
            }
        }
    }

    foreach AllActors(class'DHObstacleInfo', DHOI)
    {
        ObstacleManager = Spawn(ObstacleManagerClass);
        break;
    }

    // Make sure we have a DH_LevelInfo actor (stops an ROLevelInfo from trying to work with DH levels)
    if (DHLevelInfo == none)
    {
        if (class'DHLib'.static.GetMapName(Level) != "DHIntro") // simple hack to prevent logging errors for intro map
        {
            Warn("DarkestHourGame: No DH_LevelInfo detected!");
            Warn("Level may not be using DH_LevelInfo and needs to be!");
        }

        return; // don't setup the game if LevelInfo isn't DH
    }

    // We made it here so lets setup our DarkestHourGame

    // Setup spectator viewpoints
    for (n = 0; n < LevelInfo.EntryCamTags.Length; ++n)
    {
        foreach AllActors(class'SpectatorCam', ViewPoint, LevelInfo.EntryCamTags[n])
        {
            ViewPoints[ViewPoints.Length] = ViewPoint;
        }
    }

    RoundDuration = LevelInfo.RoundDuration * 60;
    AlliesToAxisRatio = DHLevelInfo.AlliesToAxisRatio;

    // Stored the level's original ReinforcementIntervals so we can reset to it when round restarts (in case the level edits it)
    OriginalReinforcementIntervals[AXIS_TEAM_INDEX] = LevelInfo.Axis.ReinforcementInterval;
    OriginalReinforcementIntervals[ALLIES_TEAM_INDEX] = LevelInfo.Allies.ReinforcementInterval;

    // Setup some GRI stuff
    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (GRI == none)
    {
        return;
    }

    // Allow weapon dropping (this is here in case it is set to false and then the server changes map and saved as false)
    bAllowWeaponThrowing = true;

    // Setup game type variables
    switch (DHLevelInfo.GameType)
    {
        case GT_Push:
            GRI.CurrentGameType = "Push";
            bUseInfiniteReinforcements = true;
            bUseReinforcementWarning = false;
            break;

        case GT_Attrition:
            GRI.CurrentGameType = "Attrition";
            bUseAttritionCurve = true;
            bRoundEndsAtZeroReinf = true;
            break;

        case GT_Advance:
            GRI.CurrentGameType = "Advance";
            bUseAttritionCurve = true;
            bRoundEndsAtZeroReinf = true;
            bUseReinforcementWarning = false;
            break;

        case GT_Cutoff:
            GRI.CurrentGameType = "GT_Cutoff";
            bUseReinforcementWarning = false;
            bTimeChangesAtZeroReinf = false;
            bRoundEndsAtZeroReinf = false;
            break;

        default:
            break; // do nothing
    }

    // General game type settings
    GRI.bAllowNetDebug = bAllowNetDebug;

    if (bSkipPreStartTime)
    {
        GRI.PreStartTime = 0;
    }
    else
    {
        GRI.PreStartTime = PreStartTime;
    }

    GRI.RoundDuration = RoundDuration;
    GRI.bReinforcementsComing[AXIS_TEAM_INDEX] = 0;
    GRI.bReinforcementsComing[ALLIES_TEAM_INDEX] = 0;
    GRI.ReinforcementInterval[AXIS_TEAM_INDEX] = LevelInfo.Axis.ReinforcementInterval;
    GRI.ReinforcementInterval[ALLIES_TEAM_INDEX] = LevelInfo.Allies.ReinforcementInterval;
    GRI.UnitName[AXIS_TEAM_INDEX] = LevelInfo.Axis.UnitName;
    GRI.UnitName[ALLIES_TEAM_INDEX] = LevelInfo.Allies.UnitName;
    GRI.NationIndex[AXIS_TEAM_INDEX] = LevelInfo.Axis.Nation;
    GRI.NationIndex[ALLIES_TEAM_INDEX] = LevelInfo.Allies.Nation;
    GRI.UnitInsignia[AXIS_TEAM_INDEX] = LevelInfo.Axis.UnitInsignia;
    GRI.UnitInsignia[ALLIES_TEAM_INDEX] = LevelInfo.Allies.UnitInsignia;
    GRI.MapImage = LevelInfo.MapImage;
    GRI.bPlayerMustReady = bPlayersMustBeReady;
    GRI.RoundLimit = RoundLimit;
    GRI.MaxPlayers = MaxPlayers;
    GRI.bShowServerIPOnScoreboard = bShowServerIPOnScoreboard;
    GRI.bShowTimeOnScoreboard = bShowTimeOnScoreboard;

    // Artillery
    GRI.ArtilleryStrikeLimit[AXIS_TEAM_INDEX] = LevelInfo.Axis.ArtilleryStrikeLimit;
    GRI.ArtilleryStrikeLimit[ALLIES_TEAM_INDEX] = LevelInfo.Allies.ArtilleryStrikeLimit;
    GRI.bArtilleryAvailable[AXIS_TEAM_INDEX] = 0;
    GRI.bArtilleryAvailable[ALLIES_TEAM_INDEX] = 0;
    GRI.LastArtyStrikeTime[AXIS_TEAM_INDEX] = LevelInfo.GetStrikeInterval(AXIS_TEAM_INDEX);
    GRI.LastArtyStrikeTime[ALLIES_TEAM_INDEX] = LevelInfo.GetStrikeInterval(ALLIES_TEAM_INDEX);
    GRI.TotalStrikes[AXIS_TEAM_INDEX] = 0;
    GRI.TotalStrikes[ALLIES_TEAM_INDEX] = 0;

    for (k = 0; k < arraycount(GRI.AxisRallyPoints); ++k)
    {
        GRI.AlliedRallyPoints[k].OfficerPRI = none;
        GRI.AlliedRallyPoints[k].RallyPointLocation = vect(0.0, 0.0, 0.0);
        GRI.AxisRallyPoints[k].OfficerPRI = none;
        GRI.AxisRallyPoints[k].RallyPointLocation = vect(0.0, 0.0, 0.0);
    }

    // Clear help requests array
    for (k = 0; k < arraycount(GRI.AlliedHelpRequests); ++k)
    {
        GRI.AlliedHelpRequests[k].OfficerPRI = none;
        GRI.AlliedHelpRequests[k].RequestType = 255;
        GRI.AxisHelpRequests[k].OfficerPRI = none;
        GRI.AxisHelpRequests[k].RequestType = 255;
    }

    ResetArtilleryTargets();

    if (LevelInfo.OverheadOffset == OFFSET_90)
    {
        GRI.OverheadOffset = 90;
    }
    else if (LevelInfo.OverheadOffset == OFFSET_180)
    {
        GRI.OverheadOffset = 180;
    }
    else if (LevelInfo.OverheadOffset == OFFSET_270)
    {
        GRI.OverheadOffset = 270;
    }
    else
    {
        GRI.OverheadOffset = 0;
    }

    GRI.AlliedNationID = int(DHLevelInfo.AlliedNation);

    // Find the location of the map bounds
    foreach AllActors(class'ROMapBoundsNE', NE)
    {
        GRI.NorthEastBounds = NE.Location;
    }

    foreach AllActors(class'ROMapBoundsSW', SW)
    {
        GRI.SouthWestBounds = SW.Location;
    }

    // Find all the radios
    foreach AllActors(class'ROArtilleryTrigger', RAT)
    {
        if ((RAT.TeamCanUse == AT_Axis || RAT.TeamCanUse == AT_Both) && i < arraycount(GRI.AxisRadios))
        {
            GRI.AxisRadios[i] = RAT;
            ++i;
        }

        if ((RAT.TeamCanUse == AT_Allies || RAT.TeamCanUse == AT_Both) && j < arraycount(GRI.AlliedRadios))
        {
            GRI.AlliedRadios[j] = RAT;
            ++j;
        }

        if (i >= arraycount(GRI.AxisRadios) && j >= arraycount(GRI.AlliedRadios)) // can only record maximum 10 per team as defined in RO as static arrays
        {
            break;
        }
    }

    // Find all the resupply areas
    foreach AllActors(class'DHAmmoResupplyVolume', ARV)
    {
        DHResupplyAreas[m] = ARV;
        GRI.ResupplyAreas[m].ResupplyVolumeLocation = ARV.Location;
        GRI.ResupplyAreas[m].Team = ARV.Team;
        GRI.ResupplyAreas[m].bActive = ARV.bActive;

        if (ARV.ResupplyType == RT_Players)
        {
            GRI.ResupplyAreas[m].ResupplyType = 0;
        }
        else if (ARV.ResupplyType == RT_Vehicles)
        {
            GRI.ResupplyAreas[m].ResupplyType = 1;
        }
        else if (ARV.ResupplyType == RT_All)
        {
            GRI.ResupplyAreas[m].ResupplyType = 2;
        }

        m++;

        if (m >= arraycount(GRI.ResupplyAreas)) // can only record maximum of 10 as defined in RO as a static array
        {
            break;
        }
    }

    foreach AllActors(class'ROMineVolume', MV)
    {
        MineVolumes[o] = MV;
        o++;
    }

    // Added for our overridden DHSpawnArea class - saves me having to check in subsequent functions repeatedly, just lay 'em all out here once
    foreach AllActors(class'DHSpawnArea', DHSA)
    {
        if (DHSA.bMortarmanSpawnArea)
        {
            DHMortarSpawnAreas[p++] = DHSA;
        }
    }

    // Make sure MaxTeamDifference is an acceptable value
    if (MaxTeamDifference < 1)
    {
        MaxTeamDifference = 1;
    }

    foreach AllActors(class'DHSpawnManager', SpawnManager)
    {
        break;
    }

    if (SpawnManager == none)
    {
        Warn("DHSpawnManager could not be found");
    }

    if (bEnableMetrics && MetricsClass != none)
    {
        Metrics = Spawn(MetricsClass);
    }

    PlayerSessions = class'Hashtable_string_Object'.static.Create(128);
}

// Modified to remove any return on # of bots
function int GetNumPlayers()
{
    return Min(NumPlayers, MaxPlayers);
}

event Tick(float DeltaTime)
{
    ServerTickRateConsolidated += DeltaTime;

    // This code should only execute every SERVERTICKRATE_UPDATETIME seconds
    if (ServerTickRateConsolidated > SERVERTICKRATE_UPDATETIME)
    {
        ServerTickRateAverage = ServerTickFrameCount / ServerTickRateConsolidated;
        ServerTickFrameCount = 0;
        ServerTickRateConsolidated -= SERVERTICKRATE_UPDATETIME;

        HandleReinforceIntervalInflation();

        //Log("Average Server Tick Rate:" @ ServerTickRateAverage);
    }
    else
    {
        ++ServerTickFrameCount;
    }

    super.Tick(DeltaTime);
}

// Raises the reinforcement interval used in GRI if the server is performing poorly, otherwise it sets it to default
function HandleReinforceIntervalInflation()
{
    local float TickRatio;

    if (DHGameReplicationInfo(GameReplicationInfo) == none)
    {
        return;
    }

    // Lets perform some changes to GRI.ReinforcementInterval if average tick is less than desired
    if (ServerTickRateAverage < ServerTickForInflation)
    {
        TickRatio = 1.0 - ServerTickRateAverage / ServerTickForInflation;

        DHGameReplicationInfo(GameReplicationInfo).ReinforcementInterval[0] = LevelInfo.Axis.ReinforcementInterval + int(TickRatio * MAXINFLATED_INTERVALTIME);
        DHGameReplicationInfo(GameReplicationInfo).ReinforcementInterval[1] = LevelInfo.Allies.ReinforcementInterval + int(TickRatio * MAXINFLATED_INTERVALTIME);

        //Warn("Server is not performing at desired tick rate, raising reinforcement interval based on how bad we are performing!");
    }
    else
    {
        DHGameReplicationInfo(GameReplicationInfo).ReinforcementInterval[0] = LevelInfo.Axis.ReinforcementInterval;
        DHGameReplicationInfo(GameReplicationInfo).ReinforcementInterval[1] = LevelInfo.Allies.ReinforcementInterval;
    }
}

// Modified to avoid logging a misleading warning every time ("Warning - PATHS NOT DEFINED or NO PLAYERSTART with positive rating")
// Also removed associated redundancy as game only accepts PlayerStart actors, which aren't in NavigationPointList (checking that is root cause of misleading warning)
function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string IncomingName)
{
    local NavigationPoint BestStart;
    local PlayerStart     PS;
    local float           BestRating, NewRating;

    // If player has a StartSpot, record it as the most recent one so it gets de-prioritised next time
    if (Player != none && Player.StartSpot != none)
    {
        LastPlayerStartSpot = Player.StartSpot;
    }

    // In single player if player has a StartSpot & we're waiting to start, we'll use the StartSpot
    if (Level.NetMode == NM_Standalone && Player != none && Player.StartSpot != none
        && (bWaitingToStartMatch || (Player.PlayerReplicationInfo != none && Player.PlayerReplicationInfo.bWaitingPlayer)))
    {
        BestStart = Player.StartSpot;
    }
    // If we have a rules modifier, give that a chance to find a start
    else if (GameRulesModifiers != none)
    {
        BestStart = GameRulesModifiers.FindPlayerStart(Player, InTeam, IncomingName);
    }

    // Assuming we don't yet have a start we'll find the highest rated PlayerStart
    if (BestStart == none)
    {
        // Get player's team (use passed InTeam if player doesn't yet have a team)
        if (Player != none && Player.PlayerReplicationInfo != none && Player.PlayerReplicationInfo.Team != none)
        {
            InTeam = Player.PlayerReplicationInfo.Team.TeamIndex;
        }

        BestRating = -100000000.0;

        foreach AllActors(class'PlayerStart', PS)
        {
            NewRating = RatePlayerStart(PS, InTeam, Player); // now passing the actual team, where this used to pass zero (& so always axis)
            NewRating += 20.0 * FRand(); // add some randomisation

            if (NewRating > BestRating)
            {
                BestRating = NewRating;
                BestStart = PS;
            }
        }
    }

    // Providing we found a start, record it as the most recent one so it gets de-prioritised next time
    // Then return the best start we identified
    if (BestStart != none)
    {
        LastStartSpot = BestStart;
    }
    else
    {
        Log("Warning - FindPlayerStart failed to find anything!");
    }

    return BestStart;
}

// Modified to include check for mortar crew spawn area
// Also removed redundant check on PlayerStart being for enemy team, as a PlayerStart's TeamNumber is obsolete in RO/DH
function float RatePlayerStart(NavigationPoint N, byte Team, Controller Player)
{
    local PlayerStart P;
    local DHRoleInfo  DHRI;
    local Controller  OtherPlayer;
    local float       Score, NextDist;

    P = PlayerStart(N);

    // Return extreme negative rating if not a PlayerStart or not enabled or in a WaterVolume
    if (P == none || !P.bEnabled || (P.PhysicsVolume != none && P.PhysicsVolume.bWaterVolume))
    {
        return -10000000.0;
    }

    // Return very low rating if level uses spawn areas & this PlayerStart is not linked to the relevant current spawn
    if (LevelInfo.bUseSpawnAreas && Team < arraycount(CurrentSpawnArea) && CurrentSpawnArea[Team] != none)
    {
        if (Player != none && ROPlayerReplicationInfo(Player.PlayerReplicationInfo) != none)
        {
            DHRI = DHRoleInfo(ROPlayerReplicationInfo(Player.PlayerReplicationInfo).RoleInfo);
        }

        if (CurrentTankCrewSpawnArea[Team] != none && DHRI != none && DHRI.bCanBeTankCrew)
        {
            if (P.Tag != CurrentTankCrewSpawnArea[Team].Tag)
            {
                return -9000000.0;
            }
        }
        // Mortar spawn addition - Colin Basnett, 2010
        else if (DHCurrentMortarSpawnArea[Team] != none && DHRI != none && DHRI.bCanUseMortars)
        {
            if (P.Tag != DHCurrentMortarSpawnArea[Team].Tag)
            {
                return -9000000.0;
            }
        }
        else if (P.Tag != CurrentSpawnArea[Team].Tag)
        {
            return -9000000.0;
        }
    }

    // A possible start position, so begin rating it by assigning a base score
    if (P.bPrimaryStart)
    {
        Score = 10000000.0;
    }
    else
    {
        Score = 5000000.0;
    }

    // De-prioritise PlayerStart if used last time
    if (N == LastStartSpot || N == LastPlayerStartSpot)
    {
        Score -= 10000.0;
    }
    // Otherwise add some randomisation to the score
    else
    {
        Score += 3000.0 * FRand();
    }

    // Check the PlayerStart's proximity to other players & de-prioritise if near
    for (OtherPlayer = Level.ControllerList; OtherPlayer != none; OtherPlayer = OtherPlayer.NextController)
    {
        if (OtherPlayer.Pawn != none && OtherPlayer.bIsPlayer)
        {
            if (OtherPlayer.Pawn.Region.Zone == N.Region.Zone)
            {
                Score -= 1500.0;
            }

            NextDist = VSize(OtherPlayer.Pawn.Location - N.Location);

            if (NextDist < OtherPlayer.Pawn.CollisionRadius + OtherPlayer.Pawn.CollisionHeight)
            {
                Score -= 1000000.0;

            }
            else if (NextDist < 3000.0 && FastTrace(N.Location, OtherPlayer.Pawn.Location))
            {
                Score -= (10000.0 - NextDist);
            }
            else if (NumPlayers + NumBots == 2)
            {
                Score += 2.0 * VSize(OtherPlayer.Pawn.Location - N.Location);

                if (FastTrace(N.Location, OtherPlayer.Pawn.Location))
                {
                    Score -= 10000.0;
                }
            }
        }
    }

    return FMax(Score, 5.0);
}

// Modified to have bots fall into teams based on AlliesToAxisRatio
function UnrealTeamInfo GetBotTeam(optional int TeamBots)
{
    local int TeamSizes[2];
    local int IdealTeamSizes[2];
    local float TeamSizeRatings[2];

    // Calc the team balance variables
    CalculateTeamBalanceValues(TeamSizes, IdealTeamSizes, TeamSizeRatings);

    // Always weaker team
    if (TeamSizeRatings[0] > TeamSizeRatings[1])
    {
        return Teams[1];
    }
    else
    {
        return Teams[0];
    }
}

// Spawns the bot and randomly gives them a role
function Bot SpawnBot(optional string botName)
{
    local DHBot          NewBot;
    local RosterEntry    Chosen;
    local UnrealTeamInfo BotTeam;
    local int            MyRole;
    local RORoleInfo     RI;

    BotTeam = GetBotTeam();
    Chosen = BotTeam.ChooseBotClass(botName);

    if (Chosen.PawnClass == none)
    {
        Chosen.Init();
    }

    // Change default bot class
    Chosen.PawnClass = class<Pawn>(DynamicLoadObject(DefaultPlayerClassName, class'class'));

    NewBot = DHBot(Spawn(Chosen.PawnClass.default.ControllerClass));

    if (NewBot != none)
    {
        InitializeBot(NewBot, BotTeam, Chosen);

        MyRole = GetDHBotNewRole(NewBot, BotTeam.TeamIndex);

        if (MyRole >= 0)
        {
            RI = GetRoleInfo(BotTeam.TeamIndex, MyRole);
        }

        if (MyRole == -1 || RI == none)
        {
            NewBot.Destroy();
            return none;
        }

        NewBot.CurrentRole = MyRole;
        NewBot.DesiredRole = MyRole;

        // Increment the RoleCounter for the new role
        if (BotTeam.TeamIndex == AXIS_TEAM_INDEX)
        {
            ++DHGameReplicationInfo(GameReplicationInfo).DHAxisRoleCount[NewBot.CurrentRole];
        }
        else if (BotTeam.TeamIndex == ALLIES_TEAM_INDEX)
        {
            ++DHGameReplicationInfo(GameReplicationInfo).DHAlliesRoleCount[NewBot.CurrentRole];
        }

        // Tone down the "gamey" bot parameters
        NewBot.Jumpiness = 0.0;
        NewBot.TranslocUse = 0.0;

        // Set the bots favorite weapon to their primary weapon
        NewBot.FavoriteWeapon = class<ROWeapon>(RI.PrimaryWeapons[0].Item);

        // Tweak the bots abilities and characteristics based on their role
        switch (RI.PrimaryWeaponType)
        {
            case WT_SMG:
                NewBot.CombatStyle = 1.0 - (FRand() * 0.2);
                NewBot.Accuracy = 0.3;
                NewBot.StrafingAbility = 0.0;
                break;

            case WT_SemiAuto:
                NewBot.CombatStyle = 0.0;
                NewBot.Accuracy = 0.5;
                NewBot.StrafingAbility = -1.0;
                break;

            case WT_Rifle:
                NewBot.CombatStyle = -1.0 + (FRand() * 0.4);
                NewBot.Accuracy = 0.75;
                NewBot.StrafingAbility = -1.0;
                break;

            case WT_LMG:
                NewBot.CombatStyle = -1.0;
                NewBot.Accuracy = 0.75;
                NewBot.StrafingAbility = -1.0;
                break;

            case WT_Sniper:
                NewBot.CombatStyle = -1.0;
                NewBot.Accuracy = 1.0;
                NewBot.StrafingAbility = -1.0;
                break;
        }

        DHPlayerReplicationInfo(NewBot.PlayerReplicationInfo).RoleInfo = RI;
        ChangeWeapons(NewBot, -2, -2, -2);
        SetCharacter(NewBot);
    }

    return NewBot;
}

// Override to handle picking a team with AlliesToAxisRatio calculated in
function byte PickTeam(byte num, Controller C)
{
    local UnrealTeamInfo NewTeam;
    local int            SmallTeam, BigTeam, TeamSizes[2], IdealTeamSizes[2];
    local float          TeamSizeRatings[2];

    if (bPlayersVsBots && (Level.NetMode != NM_Standalone))
    {
        if (PlayerController(C) != none)
        {
            return 1;
        }

        return 0;
    }

    // Calc the team balance stuff
    CalculateTeamBalanceValues(TeamSizes, IdealTeamSizes, TeamSizeRatings);

    if (TeamSizeRatings[0] > TeamSizeRatings[1])
    {
        SmallTeam = 1;
        BigTeam = 0;
    }
    else
    {
        SmallTeam = 0;
        BigTeam = 1;
    }

    if (num < 2)
    {
        NewTeam = Teams[num];
    }

    if (NewTeam == none)
    {
        NewTeam = Teams[SmallTeam];
    }
    else if (bPlayersBalanceTeams && Level.NetMode != NM_Standalone && PlayerController(C) != none)
    {
        // If the teams are on the verge of being off balance, force the player onto the small team
        if (Abs(IdealTeamSizes[0] - TeamSizes[0]) >= MaxTeamDifference || Abs(IdealTeamSizes[1] - TeamSizes[1]) >= MaxTeamDifference)
        {
            NewTeam = Teams[SmallTeam];
        }
    }

    return NewTeam.TeamIndex;
}

// Handles calculation of team balance variables (in separate function so this code isn't duplicated in a couple places)
function CalculateTeamBalanceValues(out int TeamSizes[2], out int IdealTeamSizes[2], out float TeamSizeRatings[2])
{
    local float TeamRatios[2];
    local float TeamSizeFactor;

    // Do some integral checks
    if (DHLevelInfo == none)
    {
        return;
    }
    else if (AlliesToAxisRatio < 0.0 || AlliesToAxisRatio > 1.0)
    {
        Log("AlliesToAxisRatio for this level is out of bounds, please make sure it is between 0.0 and 1.0");
        Level.Game.Broadcast(self, "AlliesToAxisRatio for this level is out of bounds, please make sure it is between 0.0 and 1.0", 'Say');

        return;
    }

    // Get the current TeamSizes for all players/bots who have selected a role
    GetTeamSizes(TeamSizes);

    // If HardRatio then TeamSizeFactor should be 0.5
    if (DHLevelInfo.bHardTeamRatio)
    {
        TeamRatios[0] = AlliesToAxisRatio;
        TeamRatios[1] = 1.0 - AlliesToAxisRatio;
    }
    else
    {
        TeamSizeFactor = ((float(TeamSizes[0] + TeamSizes[1]) / float(MaxPlayers)) * (AlliesToAxisRatio - 0.5));
        TeamRatios[0] = (TeamSizeFactor + 0.5);
        TeamRatios[1] = (1.0 - (TeamSizeFactor + 0.5));
    }

    TeamSizeRatings[0] = TeamRatios[0] * TeamSizes[0];
    TeamSizeRatings[1] = TeamRatios[1] * TeamSizes[1];

    IdealTeamSizes[0] = Round((TeamSizes[0] + TeamSizes[1]) * TeamRatios[1]);
    IdealTeamSizes[1] = Round((TeamSizes[0] + TeamSizes[1]) * TeamRatios[0]);

    // Update the GRI CurrentAlliedToAxisRatio
    if (DHGameReplicationInfo(GameReplicationInfo) != none)
    {
        DHGameReplicationInfo(GameReplicationInfo).CurrentAlliedToAxisRatio = Abs(TeamRatios[0]);
    }
}

// Get imbalance team "count", but calculate AlliedToAxisRatio
function int GetTeamUnbalanceCount(out UnrealTeamInfo BigTeam, out UnrealTeamInfo SmallTeam)
{
    local int TeamSizes[2];
    local int IdealTeamSizes[2];
    local float TeamSizeRatings[2];

    // Calc the team balance variables
    CalculateTeamBalanceValues(TeamSizes, IdealTeamSizes, TeamSizeRatings);

    // If Axis has higher rating than Allies
    if (TeamSizeRatings[0] > TeamSizeRatings[1])
    {
        SmallTeam = Teams[1];
        BigTeam = Teams[0];

        // We need to return an int that expects 0 for even teams and > 0 if imbalanced (higher meaning more imbalanced)
        return Ceil(Abs(IdealTeamSizes[0] - TeamSizes[0]) - MaxTeamDifference);
    }
    else
    {
        SmallTeam = Teams[0];
        BigTeam = Teams[1];

        // We need to return an int that expects 0 for even teams and > 0 if imbalanced (higher meaning more imbalanced)
        return Ceil(Abs(IdealTeamSizes[1] - TeamSizes[1]) - MaxTeamDifference);
    }
}

// Get a new random role for a bot - replaces old GetBotNewRole to use DHBots instead
// If a new role is successfully found the role number for that role will be returned (if a role cannot be found, returns -1)
function int GetDHBotNewRole(DHBot ThisBot, int BotTeamNum)
{
    local int i;
    local DHGameReplicationInfo GRI;

    //return GetBotNewRole(ThisBot, BotTeamNum); // Use this for debuging (when you need to see bots as other roles)

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (GRI == none)
    {
        return -1;
    }

    for (i = 0; i < arraycount(GRI.DHAxisRoles); ++i)
    {
        if (GetRoleInfo(BotTeamNum, i).Limit == 255)
        {
            return i;
        }
    }
}

// Give player points for destroying an enemy vehicle
function ScoreVehicleKill(Controller Killer, ROVehicle Vehicle, float Points)
{
    if (Killer == none || Points <= 0 || Killer.PlayerReplicationInfo == none || Killer.GetTeamNum() == Vehicle.GetTeamNum())
    {
        return;
    }

    // Decide to reward or punish score based on spawn kill
    if (DHVehicle(Vehicle) != none && DHVehicle(Vehicle).IsSpawnProtected())
    {
        DHPlayerReplicationInfo(Killer.PlayerReplicationInfo).StashedScore -= Points;
    }
    else
    {
        DHPlayerReplicationInfo(Killer.PlayerReplicationInfo).StashedScore += Points;
    }

    ScoreEvent(Killer.PlayerReplicationInfo, Points, "Vehicle_kill");
}

// Give player a point for resupplying an MG gunner
function ScoreMGResupply(Controller Dropper, Controller Gunner)
{
    local int ResupplyAward;

    if (Dropper == Gunner)
    {
        return;
    }
    else if (DHPlayerReplicationInfo(Dropper.PlayerReplicationInfo) != none && DHPlayerReplicationInfo(Dropper.PlayerReplicationInfo).RoleInfo != none)
    {
        ResupplyAward = 5;
        DHPlayerReplicationInfo(Dropper.PlayerReplicationInfo).StashedScore += ResupplyAward;

        ScoreEvent(Dropper.PlayerReplicationInfo, ResupplyAward, "MG_resupply");
    }
}

// Give player a point for resupplying an AT gunner
function ScoreATResupply(Controller Dropper, Controller Gunner)
{
    local int ResupplyAward;

    if (Dropper == Gunner)
    {
        return;
    }
    else if (DHPlayerReplicationInfo(Dropper.PlayerReplicationInfo) != none && DHPlayerReplicationInfo(Dropper.PlayerReplicationInfo).RoleInfo != none)
    {
        ResupplyAward = 2;
        DHPlayerReplicationInfo(Dropper.PlayerReplicationInfo).StashedScore += ResupplyAward;

        ScoreEvent(Dropper.PlayerReplicationInfo, ResupplyAward, "AT_resupply");
    }
}

// Give player a point for loading an AT gunner
function ScoreATReload(Controller Loader, Controller Gunner)
{
    local int LoadAward;

    if (Loader == Gunner)
    {
        return;
    }
    else if (DHPlayerReplicationInfo(Loader.PlayerReplicationInfo) != none && DHPlayerReplicationInfo(Loader.PlayerReplicationInfo).RoleInfo != none)
    {
        LoadAward = 1;
        DHPlayerReplicationInfo(Loader.PlayerReplicationInfo).StashedScore += LoadAward;

        ScoreEvent(Loader.PlayerReplicationInfo, LoadAward, "AT_reload");
    }
}

// Give radio operator points for teaming up with artillery officer to call in arty
function ScoreRadioUsed(Controller Radioman)
{
    local int RadioUsedAward;

    if (DHPlayerReplicationInfo(Radioman.PlayerReplicationInfo) != none && DHPlayerReplicationInfo(Radioman.PlayerReplicationInfo).RoleInfo != none)
    {
        RadioUsedAward = 5;
        DHPlayerReplicationInfo(Radioman.PlayerReplicationInfo).StashedScore += RadioUsedAward;

        ScoreEvent(Radioman.PlayerReplicationInfo, RadioUsedAward, "Radioman_used");
    }
}

// Give player two points for resupplying a mortar operator
function ScoreMortarResupply(Controller Dropper, Controller Gunner)
{
    local int ResupplyAward;

    if (Dropper == none || Dropper == Gunner || Dropper.PlayerReplicationInfo == none)
    {
        return;
    }

    DHPlayerReplicationInfo(Dropper.PlayerReplicationInfo).StashedScore += 2;
    ScoreEvent(Dropper.PlayerReplicationInfo, ResupplyAward, "Mortar_resupply");
}

// Give spotter a point or two for spotting a kill
function ScoreMortarSpotAssist(Controller Spotter, Controller Mortarman)
{
    if (Spotter == none || Spotter == Mortarman || Spotter.PlayerReplicationInfo == none || Mortarman == none || Mortarman.PlayerReplicationInfo == none)
    {
        return;
    }

    DHPlayerReplicationInfo(Spotter.PlayerReplicationInfo).StashedScore += 2;
    DHPlayerReplicationInfo(Mortarman.PlayerReplicationInfo).StashedScore += 1;
}

// Modified to handle StashedScore and prevent fellow vehicle crewman from getting kills and score for yours
function ScoreKill(Controller Killer, Controller Other)
{
    local float                         Amount;
    local DHPlayerReplicationInfo       PRI;

    if (Killer == Other || Killer == none)
    {
        Other.PlayerReplicationInfo.Score -= 1;
        ScoreEvent(Other.PlayerReplicationInfo, -1, "self_frag");
    }
    else if (Other.bIsPlayer && Killer.bIsPlayer && Killer.PlayerReplicationInfo.Team == Other.PlayerReplicationInfo.Team)
    {
        if (ROPlayerReplicationInfo(Other.PlayerReplicationInfo) != none && ROPlayerReplicationInfo(Other.PlayerReplicationInfo).RoleInfo != none)
        {
            Amount = -2 * ROPlayerReplicationInfo(Other.PlayerReplicationInfo).RoleInfo.default.PointValue;
            DHPlayerReplicationInfo(Killer.PlayerReplicationInfo).StashedScore += Amount;
        }
        else
        {
            Amount = -2;
            DHPlayerReplicationInfo(Killer.PlayerReplicationInfo).StashedScore += Amount;
        }

        ScoreEvent(Killer.PlayerReplicationInfo, Amount, "team_frag");
    }
    else if (Killer.PlayerReplicationInfo != none)
    {
        PRI = DHPlayerReplicationInfo(Other.PlayerReplicationInfo);

        if (PRI != none && PRI.RoleInfo != none)
        {
            Amount = PRI.RoleInfo.default.PointValue;
        }
        else
        {
            Amount = 1;
        }

        // TODO: When implementing the new scoring system, look at the RO version of this function and add back the killer's occupants logic
        // giving other crewman a reduced score sounds like a good idea (not riders though), but not kills
        DHPlayerReplicationInfo(Killer.PlayerReplicationInfo).StashedScore += Amount;
        Killer.PlayerReplicationInfo.Kills++;

        ScoreEvent(Killer.PlayerReplicationInfo, Amount, "frag");
    }

    if (GameRulesModifiers != none)
    {
        GameRulesModifiers.ScoreKill(Killer, Other);
    }
}

// Modified to check if the player has just used a select-a-spawn teleport and should be protected from damage
// Also if the old spawn area system is used, it only checks spawn damage protection for the spawn that is relevant to the player, including any mortar crew spawn
function int ReduceDamage(int Damage, Pawn Injured, Pawn InstigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
    local RORoleInfo  RoleInfo;
    local ROSpawnArea SpawnArea;
    local int         TeamIndex;

    // Check if the player has recently spawned & should be protected from damage
    if (InstigatedBy != none && Injured != none && InstigatedBy != Injured && Injured.PlayerReplicationInfo != none)
    {
        // Check if the player has just used a select-a-spawn teleport and is protected
        if (DHPawn(Injured) != none && DHPawn(Injured).IsSpawnProtected())
        {
            return 0;
        }

        // Check if the vehicle has protection
        if (DHVehicle(Injured) != none && DHVehicle(Injured).IsSpawnProtected())
        {
            return 0;
        }

        // If the instigator has weapons locked, return no damage
        if (DHPlayer(InstigatedBy.Controller) != none && DHPlayer(InstigatedBy.Controller).AreWeaponsLocked(true)) // passing true suppresses usual screen message if locked
        {
            return 0;
        }

        // Check if the player is in a spawn area and is protected
        if (LevelInfo.bUseSpawnAreas && Injured.PlayerReplicationInfo.Team != none && ROPlayerReplicationInfo(Injured.PlayerReplicationInfo) != none)
        {
            TeamIndex = Injured.PlayerReplicationInfo.Team.TeamIndex;
            RoleInfo = ROPlayerReplicationInfo(Injured.PlayerReplicationInfo).RoleInfo;

            if (RoleInfo != none)
            {
                if (RoleInfo.bCanBeTankCrew && CurrentTankCrewSpawnArea[TeamIndex] != none)
                {
                    SpawnArea = CurrentTankCrewSpawnArea[TeamIndex];
                }
                else if (DHRoleInfo(RoleInfo) != none && DHRoleInfo(RoleInfo).bCanUseMortars && DHCurrentMortarSpawnArea[TeamIndex] != none)
                {
                    SpawnArea = DHCurrentMortarSpawnArea[TeamIndex];
                }
                else if (CurrentSpawnArea[TeamIndex] != none)
                {
                    SpawnArea = CurrentSpawnArea[TeamIndex];
                }

                if (SpawnArea != none && SpawnArea.PreventDamage(Injured))
                {
                    return 0;
                }
            }
        }
    }

    Damage = super(TeamGame).ReduceDamage(Damage, Injured, InstigatedBy, HitLocation, Momentum, DamageType); // skip over Super in ROTeamGame as it is re-stated here

    // Check for friendly fire damage here since it's convenient
    if (Damage > 0 && ROPawn(InstigatedBy) != none && InstigatedBy.IsHumanControlled() && ROPawn(Injured) != none && Injured != InstigatedBy
        && InstigatedBy.PlayerReplicationInfo != none && Injured.PlayerReplicationInfo != none && InstigatedBy.PlayerReplicationInfo.Team == Injured.PlayerReplicationInfo.Team)
    {
        ROPlayerReplicationInfo(InstigatedBy.PlayerReplicationInfo).FFDamage += Damage;
        PlayerController(InstigatedBy.Controller).ReceiveLocalizedMessage(GameMessageClass, 15);

        if (ROPlayerReplicationInfo(InstigatedBy.PlayerReplicationInfo).FFDamage > FFDamageLimit && FFDamageLimit != 0)
        {
            HandleFFViolation(PlayerController(InstigatedBy.Controller));
        }
    }

    return Damage;
}

/**
// TODO: this override has somewhat scrambled this function as returns from the Super in GameInfo are being treated as returns from the function here
// That means this override can ignore functionality in other, closer Super classes (UnrealMPGameInfo & DeathMatch)
// A return from the Super in GameInfo would return 'control' to the Super class that called it (UnrealMPGameInfo)
// Functionality in the closer Supers would & should still execute - so this override needs re-working
// Suggest best way may be to re-state the long GameInfo Super as a separate function (called say Login_GameInfo or whatever), modified as required
// That could be called from here & return as it normally would, & this function could handle the closer Supers & any extra DH code
// Re-factoring this as one function could be done but would end up overly complicated, with lots of extra nested bracketing and/or local bools based on 'soft return' results
// Matt, Aug 2017
*/
// Modified for Squad system and so it doesn't call ChangeTeam() when a player "Logins" to the server
// Will also make it so when a player joins the server it doesn't say they joined Axis before they actually pick their team
// This function has a lot of code that probably isn't needed, but kept in case it is (may need cleaned up at some point)
event PlayerController Login(string Portal, string Options, out string Error)
{
    local PlayerController NewPlayer, TestPlayer;
    local DHPlayer         PC;
    local Controller       C;
    local NavigationPoint  StartSpot;
    local string           InName, InAdminName, InPassword, InChecksum, InCharacter, InSex;
    local byte             InTeam;
    local bool             bSpectator, bAdmin;
    local class<Security>  MySecurityClass;
    local Pawn             TestPawn;

    // Stop the game from automatically trimming longer names
    InName = Left(ParseOption(Options, "Name"), 32);

    if (MaxLives > 0)
    {
        // Check that game isn't too far along (ancient Unreal code dealing with NumLives and LateEntryLives
        // This could probably be removed
        for (C = Level.ControllerList; C != none; C = C.NextController)
        {
            if (C.PlayerReplicationInfo != none && C.PlayerReplicationInfo.NumLives > LateEntryLives)
            {
                Options = "?SpectatorOnly=1" $ Options;
                break;
            }
        }
    }

    Options = StripColor(Options); // strip out color codes

    BaseMutator.ModifyLogin(Portal, Options);

    // Get URL options
    InName      = Left(ParseOption(Options, "Name"), 20);
    InTeam      = GetIntOption(Options, "Team", 255); // default to "no team"
    InAdminName = ParseOption(Options, "AdminName");
    InPassword  = ParseOption(Options, "Password");
    InChecksum  = ParseOption(Options, "Checksum");

    // TODO: we don't support save games, this could probably go bye bye also
    if (HasOption(Options, "Load"))
    {
        Log("Loading Savegame");
        InitSavedLevel();
        bIsSaveGame = true;

        // Try to match up to existing unoccupied player in level,
        // for savegames - also needed coop level switching.
        foreach DynamicActors(class'PlayerController', TestPlayer)
        {
            if (TestPlayer.Player == none && TestPlayer.PlayerOwnerName ~= InName)
            {
                TestPawn = TestPlayer.Pawn;

                if (TestPawn != none)
                {
                    TestPawn.SetRotation(TestPawn.Controller.Rotation);
                    Log("FOUND" @ TestPlayer @ TestPlayer.PlayerReplicationInfo.PlayerName);
                }

                return TestPlayer;
            }
        }
    }

    bSpectator = (ParseOption(Options, "SpectatorOnly") ~= "1");

    if (AccessControl != none)
    {
        bAdmin = AccessControl.CheckOptionsAdmin(Options);
    }

    // Make sure there is capacity except for admins (this might have changed since the PreLogin call)
    if (!bAdmin && AtCapacity(bSpectator))
    {
        Error = GameMessageClass.default.MaxedOutMessage;

        return none;
    }

    // If admin, force spectate mode if the server already full of reg. players
    if (bAdmin && AtCapacity(false))
    {
        bSpectator = true;
    }

    // Pick a team (if need teams)
    InTeam = PickTeam(InTeam, none);

    // Find a start spot
    StartSpot = FindPlayerStart(none, InTeam, Portal);

    if (StartSpot == none)
    {
        Error = GameMessageClass.default.FailedPlaceMessage;

        return none;
    }

    if (PlayerControllerClass == none)
    {
        PlayerControllerClass = class<PlayerController>(DynamicLoadObject(PlayerControllerClassName, class'Class'));
    }

    NewPlayer = Spawn(PlayerControllerClass,,, StartSpot.Location, StartSpot.Rotation);

    // Handle spawn failure
    if (NewPlayer == none)
    {
        Log("Couldn't spawn player controller of class" @ PlayerControllerClass);
        Error = GameMessageClass.default.FailedSpawnMessage;

        return none;
    }

    NewPlayer.StartSpot = StartSpot;

    // Init player's replication info
    NewPlayer.GameReplicationInfo = GameReplicationInfo;

    // Apply security to this controller
    MySecurityClass=class<Security>(DynamicLoadObject(SecurityClass, class'class'));

    if (MySecurityClass != none)
    {
        NewPlayer.PlayerSecurity = Spawn(MySecurityClass, NewPlayer);

        if (NewPlayer.PlayerSecurity == none)
        {
            Log("Could not spawn security for player" @ NewPlayer, 'Security');
        }
    }
    else if (SecurityClass == "")
    {
        Log("No value for Engine.GameInfo.SecurityClass -- system is not secure.", 'Security');
    }
    else
    {
        Log("Unknown security class [" $ SecurityClass $ "] -- system is not secure.", 'Security');
    }

    if (bAttractCam)
    {
        NewPlayer.GotoState('AttractMode');
    }
    else
    {
        NewPlayer.GotoState('Spectating');
    }

    // Init player's name
    if (InName == "")
    {
        InName = DefaultPlayerName;
    }
    if (Level.NetMode != NM_Standalone || NewPlayer.PlayerReplicationInfo.PlayerName == DefaultPlayerName)
    {
        ChangeName(NewPlayer, InName, false);
    }

    // Custom voicepack (this probably doesn't work, but might be needed)
    NewPlayer.PlayerReplicationInfo.VoiceTypeName = ParseOption(Options, "Voice");

    InCharacter = ParseOption(Options, "Character");
    NewPlayer.SetPawnClass(DefaultPlayerClassName, InCharacter);
    InSex = ParseOption(Options, "Sex");

    // Look at this garbage
    if (Left(InSex,3) ~= "F")
    {
        NewPlayer.SetPawnFemale(); // only effective if character not valid
    }

    // Set the player's ID
    NewPlayer.PlayerReplicationInfo.PlayerID = CurrentID++;

    // Here is where the ChangeTeam() call was removed
    if (bSpectator || NewPlayer.PlayerReplicationInfo.bOnlySpectator) // || !ChangeTeam(NewPlayer, InTeam, false) )
    {
        NewPlayer.PlayerReplicationInfo.bOnlySpectator = true;
        NewPlayer.PlayerReplicationInfo.bIsSpectator = true;
        NewPlayer.PlayerReplicationInfo.bOutOfLives = true;
        NumSpectators++;

        return NewPlayer;
    }

    NewPlayer.StartSpot = StartSpot;

    // Init player's administrative privileges & log it
    if (AccessControl != none && AccessControl.AdminLogin(NewPlayer, InAdminName, InPassword))
    {
        AccessControl.AdminEntered(NewPlayer, InAdminName);
    }

    NumPlayers++;

    if (NumPlayers > 20)
    {
        bLargeGameVOIP = true;
    }

    bWelcomePending = true;

    // WTF is this?
    if (bTestMode)
    {
        TestLevel();
    }

    // If delayed start, don't give a pawn to the player yet
    // Normal for multiplayer games
    if (bDelayedStart)
    {
        NewPlayer.GotoState('PlayerWaiting');
    }

    // Init voice chat if we are in a MP environment
    if (Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer)
    {
        NewPlayer.VoiceReplicationInfo = VoiceReplicationInfo;

        if (Level.NetMode == NM_ListenServer && Level.GetLocalPlayerController() == PC)
        {
            NewPlayer.InitializeVoiceChat();
        }
    }

    if (bMustJoinBeforeStart && GameReplicationInfo.bMatchHasBegun)
    {
        UnrealPlayer(NewPlayer).bLatecomer = true;
    }

    if (Level.NetMode == NM_Standalone)
    {
        if (NewPlayer.PlayerReplicationInfo.bOnlySpectator)
        {
            // Compensate for the space left for the player
            if (!bCustomBots && (bAutoNumBots || (bTeamGame && (InitialBots % 2 == 1))))
            {
                InitialBots++;
            }
        }
        else
        {
            StandalonePlayer = NewPlayer;
        }
    }

    PC = DHPlayer(NewPlayer);

    if (PC != none)
    {
        PC.SquadReplicationInfo = SquadReplicationInfo;
    }

    ChangeName(NewPlayer, InName, false);

    return NewPlayer;
}

// Overridden to increase max name length from 20 to 32 chars
function ChangeName(Controller Other, string S, bool bNameChange)
{
    local Controller APlayer, C, P;

    if (S == "")
    {
        return;
    }

    S = StripColor(S); // strip out color codes

    if (Other == none || Other.PlayerReplicationInfo == none || Other.PlayerReplicationInfo.PlayerName ~= S)
    {
        return;
    }

    S = Left(S, 32);
    ReplaceText(S, "\"", "");

    if (bEpicNames && Bot(Other) != none)
    {
        if (TotalEpic < 21)
        {
            S = EpicNames[EpicOffset % 21];
            ++EpicOffset;
            ++TotalEpic;
        }
        else
        {
            S = NamePrefixes[NameNumber % 10] $ "CliffyB" $ NameSuffixes[NameNumber % 10];
            ++NameNumber;
        }
    }

    for (APlayer = Level.ControllerList; APlayer != none; APlayer = APlayer.NextController)
    {
        if (APlayer.bIsPlayer && APlayer.PlayerReplicationInfo.PlayerName ~= S)
        {
            if (Other.IsA('PlayerController'))
            {
                PlayerController(Other).ReceiveLocalizedMessage(GameMessageClass, 8);

                return;
            }
            else
            {
                if (Other.PlayerReplicationInfo.bIsFemale)
                {
                    S = FemaleBackupNames[FemaleBackupNameOffset % 32];
                    ++FemaleBackupNameOffset;
                }
                else
                {
                    S = MaleBackupNames[MaleBackupNameOffset % 32];
                    ++MaleBackupNameOffset;
                }

                for (P = Level.ControllerList; P != none; P = P.NextController)
                {
                    if (P.bIsPlayer && P.PlayerReplicationInfo.PlayerName ~= S)
                    {
                        S = NamePrefixes[NameNumber % 10] $ S $ NameSuffixes[NameNumber % 10];
                        ++NameNumber;
                        break;
                    }
                }

                break;
            }

            S = NamePrefixes[NameNumber % 10] $ S $ NameSuffixes[NameNumber % 10];
            ++NameNumber;
            break;
        }
    }

    if (bNameChange)
    {
        GameEvent("NameChange", S, Other.PlayerReplicationInfo);
    }

    if (S ~= "CliffyB")
    {
        bEpicNames = true;
    }

    Other.PlayerReplicationInfo.SetPlayerName(S);

    // Notify local players
    if  (bNameChange)
    {
        for (C = Level.ControllerList; C != none; C = C.NextController)
        {
            if (PlayerController(C) != none && Viewport(PlayerController(C).Player) != none)
            {
                PlayerController(C).ReceiveLocalizedMessage(class'GameMessage', 2, Other.PlayerReplicationInfo);
            }
        }
    }

    if (Metrics != none)
    {
        Metrics.OnPlayerChangeName(PlayerController(Other));
    }
}

function BroadcastLastObjectiveMessage(int Team_that_is_about_to_win)
{
    BroadcastLocalizedMessage(class'DHLastObjectiveMessage', Team_that_is_about_to_win);
}

function AddDefaultInventory(Pawn aPawn)
{
    if (DHPawn(aPawn) != none)
    {
        DHPawn(aPawn).AddDefaultInventory();
    }

    SetPlayerDefaults(aPawn);
}

//The following is a clusterfuck of hacky overriding of RO's arbitrarily low limit of roles from 10 to 16
function AddRole(RORoleInfo NewRole)
{
    local DHGameReplicationInfo GRI;
    local DHRoleInfo            DHRI;

    GRI = DHGameReplicationInfo(GameReplicationInfo);
    DHRI = DHRoleInfo(NewRole);

    if (NewRole.Side == SIDE_Allies)
    {
        if (AlliesRoleIndex >= arraycount(GRI.DHAlliesRoles))
        {
            Warn(NewRole @ "ignored when adding Allied roles to the map, exceeded limit");

            return;
        }

        GRI.DHAlliesRoles[AlliesRoleIndex] = DHRI;
        GRI.DHAlliesRoleLimit[AlliesRoleIndex] = NewRole.Limit;
        ++AlliesRoleIndex;
    }
    else
    {
        if (AxisRoleIndex >= arraycount(GRI.DHAxisRoles))
        {
            Warn(NewRole @ "ignored when adding Axis roles to the map, exceeded limit");

            return;
        }

        GRI.DHAxisRoles[AxisRoleIndex] = DHRI;
        GRI.DHAxisRoleLimit[AxisRoleIndex] = NewRole.Limit;
        ++AxisRoleIndex;
    }
}

function RORoleInfo GetRoleInfo(int Team, int Num)
{
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (Team > 1 || Num < 0 || Num >= arraycount(GRI.DHAxisRoles))
    {
        return none;
    }

    if (Team == AXIS_TEAM_INDEX)
    {
        return GRI.DHAxisRoles[Num];
    }
    else if (Team == ALLIES_TEAM_INDEX)
    {
        return GRI.DHAlliesRoles[Num];
    }

    return none;
}

function bool RoleLimitReached(int Team, int Num)
{
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    // This shouldn't even happen, but if it does, just say the limit was reached
    if (Team > 1 || Num < 0 || (Team == AXIS_TEAM_INDEX && GRI.DHAxisRoles[Num] == none) || (Team == ALLIES_TEAM_INDEX && GRI.DHAlliesRoles[Num] == none) || Num >= arraycount(GRI.DHAxisRoles))
    {
        return true;
    }

    if (Team == AXIS_TEAM_INDEX && GRI.DHAxisRoleLimit[Num] != 255 && GRI.DHAxisRoleCount[Num] >= GRI.DHAxisRoleLimit[Num])
    {
        return true;
    }
    else if (Team == ALLIES_TEAM_INDEX && GRI.DHAlliesRoleLimit[Num] != 255 && GRI.DHAlliesRoleCount[Num] >= GRI.DHAlliesRoleLimit[Num])
    {
        return true;
    }

    return false;
}

function bool HumanWantsRole(int Team, int Num)
{
    local Controller            C;
    local ROBot                 BotHasRole;
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    // This shouldn't even happen, but if it does, just say the limit was reached
    if (Team > 1 || Num < 0 || (Team == AXIS_TEAM_INDEX && GRI.DHAxisRoles[Num] == none) || (Team == ALLIES_TEAM_INDEX && GRI.DHAlliesRoles[Num] == none) || Num >= arraycount(GRI.DHAxisRoles))
    {
        return false;
    }

    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        if (C.PlayerReplicationInfo != none && C.PlayerReplicationInfo.Team != none && C.PlayerReplicationInfo.Team.TeamIndex == Team)
        {
            if (ROBot(C) != none && ROBot(C).CurrentRole == Num)
            {
                BotHasRole = ROBot(C);

                break;
            }
        }
    }

    if (BotHasRole != none)
    {
        BotHasRole.Destroy();

        if (Team == AXIS_TEAM_INDEX)
        {
            --GRI.DHAxisRoleCount[Num];
            --GRI.DHAxisRoleBotCount[Num];
        }
        else if (Team == ALLIES_TEAM_INDEX)
        {
            --GRI.DHAlliesRoleCount[Num];
            --GRI.DHAlliesRoleBotCount[Num];
        }

        return true;
    }

    return false;
}

function int GetVehicleRole(int Team, int Num)
{
    local int i;
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    // This shouldn't even happen, but if it does, just say the limit was reached
    if (Team > 1 || Num < 0 || (Team == AXIS_TEAM_INDEX && GRI.DHAxisRoles[Num] == none) || (Team == ALLIES_TEAM_INDEX && GRI.DHAlliesRoles[Num] == none) || Num >= arraycount(GRI.DHAxisRoles))
    {
        return -1;
    }

    // Should probably do this team specific in case the teams have different amounts of roles
    for (i = 0; i < arraycount(GRI.DHAxisRoles); ++i)
    {
        if (GetRoleInfo(Team, i) != none && GetRoleInfo(Team, i).bCanBeTankCrew && !RoleLimitReached(Team, i))
        {
            return i;
        }
    }

    return -1;
}

function int GetBotNewRole(ROBot ThisBot, int BotTeamNum)
{
    local int MyRole, Count, AltRole;
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (ThisBot != none)
    {
        MyRole = Rand(arraycount(GRI.DHAxisRoles));

        do
        {
            if (FRand() < LevelInfo.VehicleBotRoleBalance)
            {
                AltRole = GetVehicleRole(ThisBot.PlayerReplicationInfo.Team.TeamIndex, MyRole);

                if (AltRole != -1)
                {
                    MyRole = AltRole;
                    break;
                }
            }

            // Temp hack to prevent bots from getting MG roles
            if (RoleLimitReached(ThisBot.PlayerReplicationInfo.Team.TeamIndex, MyRole) || GetRoleInfo(BotTeamNum, MyRole).PrimaryWeaponType == WT_LMG
                || GetRoleInfo(BotTeamNum, MyRole).PrimaryWeaponType == WT_PTRD)
            {
                ++Count;

                if (Count > arraycount(GRI.DHAxisRoles))
                {
                    Log("ROTeamGame: Unable to find a suitable role in SpawnBot()");

                    return -1;
                }
                else
                {
                    ++MyRole;

                    if (MyRole >= arraycount(GRI.DHAxisRoles))
                    {
                        MyRole = 0;
                    }
                }
            }
            else
            {
                break;
            }
        }

        return MyRole;
    }

    return -1;
}

function UpdateRoleCounts()
{
    local Controller C;
    local int i;
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    for (i = 0; i < arraycount(GRI.DHAxisRoles); ++i)
    {
        if (GRI.DHAxisRoles[i] != none)
        {
            GRI.DHAxisRoleCount[i] = 0;
            GRI.DHAxisRoleBotCount[i] = 0;
        }
    }

    for (i = 0; i < arraycount(GRI.DHAlliesRoles); ++i)
    {
        if (GRI.DHAlliesRoles[i] != none)
        {
            GRI.DHAlliesRoleCount[i] = 0;
            GRI.DHAlliesRoleBotCount[i] = 0;
        }
    }

    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        if (C.PlayerReplicationInfo != none && C.PlayerReplicationInfo.Team != none)
        {
            if (ROPlayer(C) != none && ROPlayer(C).CurrentRole != -1)
            {
                if (C.PlayerReplicationInfo.Team.TeamIndex == ALLIES_TEAM_INDEX)
                {
                    GRI.DHAlliesRoleCount[ROPlayer(C).CurrentRole]++;
                }
                else if (C.PlayerReplicationInfo.Team.TeamIndex == AXIS_TEAM_INDEX)
                {
                    GRI.DHAxisRoleCount[ROPlayer(C).CurrentRole]++;
                }
            }
            else if (ROBot(C) != none && ROBot(C).CurrentRole != -1)
            {
                if (C.PlayerReplicationInfo.Team.TeamIndex == ALLIES_TEAM_INDEX)
                {
                    GRI.DHAlliesRoleCount[ROBot(C).CurrentRole]++;
                    GRI.DHAlliesRoleBotCount[ROBot(C).CurrentRole]++;
                }
                else if (C.PlayerReplicationInfo.Team.TeamIndex == AXIS_TEAM_INDEX)
                {
                    GRI.DHAxisRoleCount[ROBot(C).CurrentRole]++;
                    GRI.DHAxisRoleBotCount[ROBot(C).CurrentRole]++;
                }
            }
        }
    }
}

function ChangeRole(Controller aPlayer, int i, optional bool bForceMenu)
{
    local RORoleInfo RI;
    local DHPlayer   Playa;
    local ROBot      MrRoboto;
    local DHGameReplicationInfo GRI;

    if (aPlayer == none || !aPlayer.bIsPlayer || aPlayer.PlayerReplicationInfo.Team == none || aPlayer.PlayerReplicationInfo.Team.TeamIndex > 1)
    {
        return;
    }

    RI = GetRoleInfo(aPlayer.PlayerReplicationInfo.Team.TeamIndex, i);

    if (RI == none)
    {
        return;
    }

    Playa = DHPlayer(aPlayer);

    if (Playa == none)
    {
        MrRoboto = ROBot(aPlayer);
    }

    if (Playa != none)
    {
        Playa.DesiredRole = i;

        if (aPlayer.Pawn == none)
        {
            // Try and kick a bot out of this role if bots are occupying it
            if (RoleLimitReached(aPlayer.PlayerReplicationInfo.Team.TeamIndex, i))
            {
                HumanWantsRole(aPlayer.PlayerReplicationInfo.Team.TeamIndex, i);
            }

            if (!RoleLimitReached(aPlayer.PlayerReplicationInfo.Team.TeamIndex, i))
            {
                if (bForceMenu)
                {
                    Playa.ClientReplaceMenu("ROInterface.ROUT2K4PlayerSetupPage", false, "Weapons");
                }
                else
                {
                    // Decrement the RoleCounter for the old role
                    if (Playa.CurrentRole != -1)
                    {
                        if (aPlayer.PlayerReplicationInfo.Team.TeamIndex == AXIS_TEAM_INDEX)
                        {
                            DHGameReplicationInfo(GameReplicationInfo).DHAxisRoleCount[Playa.CurrentRole]--;
                        }
                        else if (aPlayer.PlayerReplicationInfo.Team.TeamIndex == ALLIES_TEAM_INDEX)
                        {
                            DHGameReplicationInfo(GameReplicationInfo).DHAlliesRoleCount[Playa.CurrentRole]--;
                        }
                    }

                    Playa.CurrentRole = i;

                    // Increment the RoleCounter for the new role
                    if (aPlayer.PlayerReplicationInfo.Team.TeamIndex == AXIS_TEAM_INDEX)
                    {
                        DHGameReplicationInfo(GameReplicationInfo).DHAxisRoleCount[Playa.CurrentRole]++;
                    }
                    else if (aPlayer.PlayerReplicationInfo.Team.TeamIndex == ALLIES_TEAM_INDEX)
                    {
                        DHGameReplicationInfo(GameReplicationInfo).DHAlliesRoleCount[Playa.CurrentRole]++;
                    }

                    ROPlayerReplicationInfo(aPlayer.PlayerReplicationInfo).RoleInfo = RI;
                    Playa.PrimaryWeapon = -1;
                    Playa.DHPrimaryWeapon = -1;
                    Playa.SecondaryWeapon = -1;
                    Playa.DHSecondaryWeapon = -1;
                    Playa.GrenadeWeapon = -1;
                    Playa.bWeaponsSelected = false;
                    Playa.SavedArtilleryCoords = vect(0.0, 0.0, 0.0); // stops arty co-ords remaining on player's map if he stops being an arty officer
                    SetCharacter(aPlayer);
                }
            }
            else
            {
                Playa.DesiredRole = Playa.CurrentRole;
                PlayerController(aPlayer).ReceiveLocalizedMessage(GameMessageClass, 17, none, none, RI);
            }

            // Since we're changing roles, clear all associated requests/rally points
            ClearSavedRequestsAndRallyPoints(Playa, false);

            GRI = DHGameReplicationInfo(GameReplicationInfo);

            if (GRI != none)
            {
                GRI.ClearArtilleryTarget(DHPlayer(aPlayer));
            }
        }
        else
        {
            PlayerController(aPlayer).ReceiveLocalizedMessage(GameMessageClass, 16, none, none, RI);
        }
    }
    else if (MrRoboto != none)
    {
        if (MrRoboto.CurrentRole == i)
        {
            return;
        }

        MrRoboto.DesiredRole = i;

        if (aPlayer.Pawn == none)
        {
            if (!RoleLimitReached(aPlayer.PlayerReplicationInfo.Team.TeamIndex, i))
            {
                // Decrement the RoleCounter for the old role
                if (MrRoboto.CurrentRole != -1)
                {
                    if (aPlayer.PlayerReplicationInfo.Team.TeamIndex == AXIS_TEAM_INDEX)
                    {
                        DHGameReplicationInfo(GameReplicationInfo).DHAxisRoleCount[MrRoboto.CurrentRole]--;
                    }
                    else if (aPlayer.PlayerReplicationInfo.Team.TeamIndex == ALLIES_TEAM_INDEX)
                    {
                        DHGameReplicationInfo(GameReplicationInfo).DHAlliesRoleCount[MrRoboto.CurrentRole]--;
                    }
                }

                MrRoboto.CurrentRole = i;

                // Increment the RoleCounter for the new role
                if (aPlayer.PlayerReplicationInfo.Team.TeamIndex == AXIS_TEAM_INDEX)
                {
                    DHGameReplicationInfo(GameReplicationInfo).DHAxisRoleCount[MrRoboto.CurrentRole]++;
                }
                else if (aPlayer.PlayerReplicationInfo.Team.TeamIndex == ALLIES_TEAM_INDEX)
                {
                    DHGameReplicationInfo(GameReplicationInfo).DHAlliesRoleCount[MrRoboto.CurrentRole]++;
                }

                ROPlayerReplicationInfo(aPlayer.PlayerReplicationInfo).RoleInfo = RI;
                SetCharacter(aPlayer);
            }
            else
            {
                MrRoboto.DesiredRole = ROBot(aPlayer).CurrentRole;
            }
        }
    }
}

function Killed(Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> DamageType)
{
    local DHPlayer   DHKilled, DHKiller;
    local Controller P;
    local float      FFPenalty;
    local int        i;
    local bool       bHasAPlayerAlive;

    if (Killed == none)
    {
        return;
    }

    if (Killer != none && Killer.bIsPlayer && Killed.bIsPlayer && DamageType != none)
    {
        DamageType.static.IncrementKills(Killer);
    }

    if (Killed.bIsPlayer)
    {
        if (Killed.PlayerReplicationInfo != none)
        {
            Killed.PlayerReplicationInfo.Deaths += 1.0;
        }

        // Special handling if this was a spawn kill
        // Suiciding won't count as a spawn kill - did this because suiciding after a combat spawn will not act the same way & thus is not intuitive
        if (DHPawn(KilledPawn) != none && DHPawn(KilledPawn).IsSpawnKillProtected() && Killer != Killed)
        {
            DHKilled = DHPlayer(Killed);
            DHKiller = DHPlayer(Killer);

            if (DHKiller != none && DHKilled != none) // only relevant to player vs player spawn kills
            {
                DamageType = class'DHSpawnKillDamageType'; // change the damage type to signify this was a spawn kill

                // Inform victim's controller that it was spawn killed, allow player to re-spawn in a vehicle quickly,
                // & increment player reinforcements for victim's team so they don't suffer loss
                DHKilled.bSpawnedKilled = true;
                DHKilled.NextVehicleSpawnTime = DHKilled.LastKilledTime + SPAWN_KILL_RESPAWN_TIME;
                ModifyReinforcements(DHKilled.GetTeamNum(), 1, false, true);

                // Punish killer for spawn killing if the killed wasn't a combat spawn by incrementing his WeaponLockViolations & reducing his score
                if (!DHPawn(KilledPawn).IsCombatSpawned())
                {
                    DHKiller.WeaponLockViolations++;
                    DHKiller.LockWeapons(Min(WeaponLockTimeSecondsMaximum, DHKiller.WeaponLockViolations * WeaponLockTimeSecondsInterval)); // TODO: probably add 1 second as we are 'mid second' in game time

                    if (DHPlayerReplicationInfo(DHKiller.PlayerReplicationInfo) != none)
                    {
                        DHPlayerReplicationInfo(DHKiller.PlayerReplicationInfo).StashedScore -= 2;
                    }
                }

                if (DHPawn(KilledPawn) != none && DHPawn(KilledPawn).SpawnPoint != none)
                {
                    DHPawn(KilledPawn).SpawnPoint.OnSpawnKill(KilledPawn, Killer);
                }
            }

        }

        BroadcastDeathMessage(Killer, Killed, DamageType);

        ClearSavedRequestsAndRallyPoints(ROPlayer(Killed), true); // remove any help/rally requests by killed player

        // If player suicided or there is no Killer
        if (Killer == Killed || Killer == none)
        {
            if (Killer == none)
            {
                KillEvent("K", none, Killed.PlayerReplicationInfo, DamageType);
            }
            else
            {
                KillEvent("K", Killer.PlayerReplicationInfo, Killed.PlayerReplicationInfo, DamageType);
            }
        }
        // Friendly fire
        else
        {
            if (bTeamGame && Killer.PlayerReplicationInfo != none && Killed.PlayerReplicationInfo != none && Killer.PlayerReplicationInfo.Team == Killed.PlayerReplicationInfo.Team)
            {
                // Allow server admins an option of reducing damage from different types of friendly fire
                if (DamageType != none)
                {
                    if (class<ROArtilleryDamType>(DamageType) != none)
                    {
                        FFPenalty = FFArtyScale;
                    }
                    // Added mortar HE (& removed specific satchel damage as now all thrown explosives extend from ROGrenadeDamType via DHThrowableExplosiveDamageType)
                    else if (class<ROGrenadeDamType>(DamageType) != none || class<ROTankShellExplosionDamage>(DamageType) != none || class<DHMortarDamageType>(DamageType) != none)
                    {
                        FFPenalty = FFExplosivesScale;
                    }
                    else
                    {
                        FFPenalty = 1.0;
                    }
                }

                if (ROPlayerReplicationInfo(Killer.PlayerReplicationInfo) != none)
                {
                    ROPlayerReplicationInfo(Killer.PlayerReplicationInfo).FFKills += FFPenalty; // increase recorded FF kills
                }

                if (PlayerController(Killer) != none)
                {
                    BroadcastLocalizedMessage(GameMessageClass, 13, Killer.PlayerReplicationInfo);

                    // If bForgiveFFKillsEnabled, store the friendly Killer into the Killed player's controller, so if they choose to forgive, we'll know who to forgive
                    if (bForgiveFFKillsEnabled && ROPlayer(Killed) != none)
                    {
                        ROPlayer(Killed).ReceiveLocalizedMessage(GameMessageClass, 18, Killer.PlayerReplicationInfo);
                        ROPlayer(Killed).LastFFKiller = ROPlayerReplicationInfo(Killer.PlayerReplicationInfo);
                        ROPlayer(Killed).LastFFKillAmount = FFPenalty;
                    }

                    // Take action if player has exceeded FF kills limit
                    if (ROPlayerReplicationInfo(Killer.PlayerReplicationInfo) != none && ROPlayerReplicationInfo(Killer.PlayerReplicationInfo).FFKills > FFKillLimit)
                    {
                        HandleFFViolation(PlayerController(Killer));
                    }
                }

                KillEvent("TK", Killer.PlayerReplicationInfo, Killed.PlayerReplicationInfo, DamageType);
            }
            else
            {
                KillEvent("K", Killer.PlayerReplicationInfo, Killed.PlayerReplicationInfo, DamageType);
            }
        }
    }

    ScoreKill(Killer, Killed);
    DiscardInventory(KilledPawn);
    NotifyKilled(Killer, Killed, KilledPawn);

    // Check whether we need to end the round because a team has 0 reinforcements and no one alive
    // If this logic is ever duplicated or resused, it needs to be made a function instead
    for (i = 0; i < 2; ++i)
    {
        // Make this false for now, because we are going to check and set it to true if we do find someone alive, and it needs to reset for each team we check!
        bHasAPlayerAlive = false;

        if (SpawnLimitReached(i))
        {
            for (P = Level.ControllerList; P != none; P = P.NextController)
            {
                if (P.bIsPlayer && P.Pawn != none && P.Pawn.Health > 0 && P.PlayerReplicationInfo.Team.TeamIndex == i)
                {
                    bHasAPlayerAlive = true;
                    break;
                }
            }

            if (!bHasAPlayerAlive)
            {
                EndRound(int(!bool(i))); // it looks like a hack, but hey, it's the easiest way to find the opposite team :)
            }
        }
    }

    // Update the killed player's score
    UpdatePlayerScore(Killed);
}

function UpdateAllPlayerScores()
{
    local DHPlayerReplicationInfo   PRI;
    local Controller                C;

    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        if (DHPlayerReplicationInfo(C.PlayerReplicationInfo) != none)
        {
            PRI = DHPlayerReplicationInfo(C.PlayerReplicationInfo);

            PRI.Score += PRI.StashedScore;
            PRI.StashedScore = 0;
        }
    }
}

function UpdatePlayerScore(controller C)
{
    local DHPlayerReplicationInfo PRI;

    if (C != none && DHPlayerReplicationInfo(C.PlayerReplicationInfo) != none)
    {
        PRI = DHPlayerReplicationInfo(C.PlayerReplicationInfo);

        PRI.Score += PRI.StashedScore;
        PRI.StashedScore = 0;
    }
}

// Modified to call ClientAddHudDeathMessage instead of RO's AddHudDeathMessage (also re-factored to shorten & reduce code duplication)
// Also to pass Killer's PRI even if Killer is same as Killed, so DHDeathMessage class can work out foir itself whether it needs to display a suicide message
// And fixed bug in original function that affected DM_Personal mode, which wouldn't send DM to killer if they killed a bot
function BroadcastDeathMessage(Controller Killer, Controller Killed, class<DamageType> DamageType)
{
    local PlayerReplicationInfo KillerPRI, KilledPRI;
    local Controller C;

    if (DeathMessageMode == DM_None || Killed == none)
    {
        return;
    }

    if (Killer != none)
    {
        KillerPRI = Killer.PlayerReplicationInfo;
    }

    KilledPRI = Killed.PlayerReplicationInfo;

    // Send DM to every human player
    if (DeathMessageMode == DM_All)
    {
        // Loop through all controllers & DM each human player
        for (C = Level.ControllerList; C != none; C = C.NextController)
        {
            if (DHPlayer(C) != none)
            {
                DHPlayer(C).ClientAddHudDeathMessage(KillerPRI, KilledPRI, DamageType);
            }
        }
    }
    // OnDeath means only send DM to player who is killed, Personal means send DM to both killed & killer
    else if (DeathMessageMode == DM_OnDeath || DeathMessageMode == DM_Personal)
    {
        // Send DM to a killed human player
        if (DHPlayer(Killed) != none)
        {
            DHPlayer(Killed).ClientAddHudDeathMessage(KillerPRI, KilledPRI, DamageType);
        }

        // If mode is Personal, also send DM to the killer (if human)
        // Had to move this away from the if (DHPlayer(Killed) != none) above, as that stopped a human player from getting a DM for killing a bot
        if (DeathMessageMode == DM_Personal && DHPlayer(Killer) != none)
        {
            DHPlayer(Killer).ClientAddHudDeathMessage(KillerPRI, KilledPRI, DamageType);
        }
    }
}

function bool RoleExists(byte TeamID, DHRoleInfo RI)
{
    local DHGameReplicationInfo GRI;
    local int                   i;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (TeamID == AXIS_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(GRI.DHAxisRoles); ++i)
        {
            if (GRI.DHAxisRoles[i] == RI)
            {
                return true;
            }
        }
    }
    else if (TeamID == ALLIES_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(GRI.DHAlliesRoles); ++i)
        {
            if (GRI.DHAlliesRoles[i] == RI)
            {
                return true;
            }
        }
    }

    return false;
}

state RoundInPlay
{
    function BeginState()
    {
        local Controller P, NextC;
        local Actor A;
        local int i;
        local DHGameReplicationInfo GRI;
        local ROVehicleFactory ROV;

        // Begin reseting all round properties!!!
        RoundStartTime = ElapsedTime;

        // Reset the level's reinforcement interval time (levels can change it, so we store the values in game in beginplay)
        LevelInfo.Axis.ReinforcementInterval = OriginalReinforcementIntervals[AXIS_TEAM_INDEX];
        LevelInfo.Allies.ReinforcementInterval = OriginalReinforcementIntervals[ALLIES_TEAM_INDEX];

        GRI = DHGameReplicationInfo(GameReplicationInfo);
        GRI.bRoundIsOver = false;
        GRI.RoundStartTime = RoundStartTime;
        GRI.RoundEndTime = RoundStartTime + RoundDuration;
        GRI.AttritionRate[AXIS_TEAM_INDEX] = 0;
        GRI.AttritionRate[ALLIES_TEAM_INDEX] = 0;

        // Here we see if the victory music is set to a sound group and pick an index to replicate to the clients
        if (DHLevelInfo.AlliesWinsMusic != none && DHLevelInfo.AlliesWinsMusic.IsA('SoundGroup'))
        {
            GRI.AlliesVictoryMusicIndex = Rand(SoundGroup(DHLevelInfo.AlliesWinsMusic).Sounds.Length);
        }

        if (DHLevelInfo.AxisWinsMusic != none && DHLevelInfo.AxisWinsMusic.IsA('SoundGroup'))
        {
            GRI.AxisVictoryMusicIndex = Rand(SoundGroup(DHLevelInfo.AxisWinsMusic).Sounds.Length);
        }

        TeamAttritionCounter[AXIS_TEAM_INDEX] = 0;
        TeamAttritionCounter[ALLIES_TEAM_INDEX] = 0;

        // Reset PlayerSessions
        PlayerSessions.Clear();

        // Role limits
        for (i = 0; i < arraycount(GRI.DHAlliesRoleLimit); ++i)
        {
            if (GRI.DHAlliesRoles[i] != none)
            {
                GRI.DHAlliesRoleLimit[i] = GRI.DHAlliesRoles[i].Limit;
            }
        }

        for (i = 0; i < arraycount(GRI.DHAxisRoleLimit); ++i)
        {
            if (GRI.DHAxisRoles[i] != none)
            {
                GRI.DHAxisRoleLimit[i] = GRI.DHAxisRoles[i].Limit;
            }
        }

        // Arty
        GRI.bArtilleryAvailable[AXIS_TEAM_INDEX] = 0;
        GRI.bArtilleryAvailable[ALLIES_TEAM_INDEX] = 0;
        GRI.LastArtyStrikeTime[AXIS_TEAM_INDEX] = ElapsedTime - LevelInfo.GetStrikeInterval(AXIS_TEAM_INDEX);
        GRI.LastArtyStrikeTime[ALLIES_TEAM_INDEX] = ElapsedTime - LevelInfo.GetStrikeInterval(ALLIES_TEAM_INDEX);
        GRI.TotalStrikes[AXIS_TEAM_INDEX] = 0;
        GRI.TotalStrikes[ALLIES_TEAM_INDEX] = 0;

        for (i = 0; i < arraycount(GRI.AxisRallyPoints); ++i)
        {
            GRI.AlliedRallyPoints[i].OfficerPRI = none;
            GRI.AlliedRallyPoints[i].RallyPointLocation = vect(0.0, 0.0, 0.0);
            GRI.AxisRallyPoints[i].OfficerPRI = none;
            GRI.AxisRallyPoints[i].RallyPointLocation = vect(0.0, 0.0, 0.0);
        }

        // Clear help requests
        for (i = 0; i < arraycount(GRI.AxisHelpRequests); ++i)
        {
            GRI.AlliedHelpRequests[i].OfficerPRI = none;
            GRI.AlliedHelpRequests[i].RequestType = 255;
            GRI.AxisHelpRequests[i].OfficerPRI = none;
            GRI.AxisHelpRequests[i].RequestType = 255;
        }

        // Reset all controllers
        P = Level.ControllerList;

        while (P != none)
        {
            NextC = P.NextController;

            if (P.PlayerReplicationInfo == none || !P.PlayerReplicationInfo.bOnlySpectator)
            {
                if (PlayerController(P) != none)
                {
                    PlayerController(P).ClientReset();
                }

                P.Reset();
            }

            P = NextC;
        }

        // Reset ALL actors (except controllers and ROVehicleFactorys)
        foreach AllActors(class'Actor', A)
        {
            if (!A.IsA('Controller') && !A.IsA('ROVehicleFactory'))
            {
                A.Reset();
            }
        }

        // Reset ALL ROVehicleFactorys - must reset these after vehicles, otherwise the vehicles that get spawned by the vehicle factories get destroyed instantly as they are reset
        foreach DynamicActors(class'ROVehicleFactory', ROV)
        {
            ROV.Reset();
        }

        // Use the starting spawns
        if (LevelInfo.bUseSpawnAreas)
        {
            CheckSpawnAreas();
            CheckTankCrewSpawnAreas();
            CheckVehicleFactories();
            CheckResupplyVolumes();
            CheckMineVolumes();
        }

        // Make the bots find objectives when the round starts
        FindNewObjectives(none);

        // Notify players that the map has been updated
        NotifyPlayersOfMapInfoChange(NEUTRAL_TEAM_INDEX, none, true);

        ResetArtilleryTargets();

        // Set reinforcements
        if (bUseInfiniteReinforcements)
        {
            GRI.SpawnsRemaining[ALLIES_TEAM_INDEX] = -1;
            GRI.SpawnsRemaining[AXIS_TEAM_INDEX] = -1;
        }
        else
        {
            GRI.SpawnsRemaining[ALLIES_TEAM_INDEX] = LevelInfo.Allies.SpawnLimit;
            GRI.SpawnsRemaining[AXIS_TEAM_INDEX] = LevelInfo.Axis.SpawnLimit;
        }

        // Set ReinforcementsComing
        if (!SpawnLimitReached(AXIS_TEAM_INDEX))
        {
            GRI.bReinforcementsComing[AXIS_TEAM_INDEX] = 1;
        }

        if (!SpawnLimitReached(ALLIES_TEAM_INDEX))
        {
            GRI.bReinforcementsComing[ALLIES_TEAM_INDEX] = 1;
        }

        TeamReinforcementMessageIndices[ALLIES_TEAM_INDEX] = 0;
        TeamReinforcementMessageIndices[AXIS_TEAM_INDEX] = 0;

        bTeamOutOfReinforcements[ALLIES_TEAM_INDEX] = 0;
        bTeamOutOfReinforcements[AXIS_TEAM_INDEX] = 0;

        if (Metrics != none)
        {
            Metrics.OnRoundBegin();
        }
    }

    // Modified for DHObjectives
    function NotifyObjStateChanged()
    {
        local DHGameReplicationInfo GRI;
        local int i, Num[2], NumReq[2], NumObj, NumObjReq;
        local float AttRateAllies, AttRateAxis;

        for (i = 0; i < arraycount(DHObjectives); ++i)
        {
            if (DHObjectives[i] == none)
            {
                break;
            }
            else if (DHObjectives[i].IsAxis())
            {
                Num[AXIS_TEAM_INDEX]++;

                if (DHObjectives[i].bRequired)
                {
                    NumReq[AXIS_TEAM_INDEX]++;
                }

                // Add up objective based attrition
                AttRateAllies += DHObjectives[i].AxisOwnedAttritionRate;
            }
            else if (DHObjectives[i].IsAllies())
            {
                Num[ALLIES_TEAM_INDEX]++;

                if (DHObjectives[i].bRequired)
                {
                    NumReq[ALLIES_TEAM_INDEX]++;
                }

                // Add up objective based attrition
                AttRateAxis += DHObjectives[i].AlliedOwnedAttritionRate;
            }

            if (DHObjectives[i].bRequired)
            {
                NumObjReq++;
            }

            NumObj++;
        }

        GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

        if (GRI != none)
        {
            // Add attrition rates from the AttritionRateCurve to the already established specific objective attrition rates (look above in this function)
            AttRateAxis   += InterpCurveEval(DHLevelInfo.AttritionRateCurve, float(Max(0, Num[ALLIES_TEAM_INDEX] - Num[AXIS_TEAM_INDEX]))   / NumObj);
            AttRateAllies += InterpCurveEval(DHLevelInfo.AttritionRateCurve, float(Max(0, Num[AXIS_TEAM_INDEX]   - Num[ALLIES_TEAM_INDEX])) / NumObj);

            // Update the calculated attrition rate
            CalculatedAttritionRate[AXIS_TEAM_INDEX]   = AttRateAxis;
            CalculatedAttritionRate[ALLIES_TEAM_INDEX] = AttRateAllies;
        }

        if (LevelInfo.NumObjectiveWin == 0)
        {
            if (Num[AXIS_TEAM_INDEX] == NumObj && (LevelInfo.DefendingSide == SIDE_None || LevelInfo.DefendingSide == SIDE_Allies))
            {
                EndRound(AXIS_TEAM_INDEX);
            }
            else if (Num[ALLIES_TEAM_INDEX] == NumObj && (LevelInfo.DefendingSide == SIDE_None || LevelInfo.DefendingSide == SIDE_Axis))
            {
                EndRound(ALLIES_TEAM_INDEX);
            }
            else
            {
                // Check if we're down to last objective..
                if (Num[AXIS_TEAM_INDEX] == NumObj - 1 && (LevelInfo.DefendingSide == SIDE_None || LevelInfo.DefendingSide == SIDE_Allies))
                {
                    BroadcastLastObjectiveMessage(AXIS_TEAM_INDEX);
                }

                if (Num[ALLIES_TEAM_INDEX] == NumObj - 1 && (LevelInfo.DefendingSide == SIDE_None || LevelInfo.DefendingSide == SIDE_Axis))
                {
                    BroadcastLastObjectiveMessage(ALLIES_TEAM_INDEX);
                }
            }
        }
        else if (Num[AXIS_TEAM_INDEX] >= LevelInfo.NumObjectiveWin && NumReq[AXIS_TEAM_INDEX] == NumObjReq
            && (LevelInfo.DefendingSide == SIDE_None || LevelInfo.DefendingSide == SIDE_Allies))
        {
            EndRound(AXIS_TEAM_INDEX);
        }
        else if (Num[ALLIES_TEAM_INDEX] >= LevelInfo.NumObjectiveWin && NumReq[ALLIES_TEAM_INDEX] == NumObjReq
            && (LevelInfo.DefendingSide == SIDE_None || LevelInfo.DefendingSide == SIDE_Axis))
        {
            EndRound(ALLIES_TEAM_INDEX);
        }
        // Check if we're down to last objective
        else
        {
            // One non-required objective missing
            if (Num[AXIS_TEAM_INDEX] == LevelInfo.NumObjectiveWin - 1 && NumReq[AXIS_TEAM_INDEX] == NumObjReq
                && (LevelInfo.DefendingSide == SIDE_None || LevelInfo.DefendingSide == SIDE_Allies))
            {
                BroadcastLastObjectiveMessage(AXIS_TEAM_INDEX);
            }
            // One required objective missing
            else if (Num[AXIS_TEAM_INDEX] >= LevelInfo.NumObjectiveWin - 1 && NumReq[AXIS_TEAM_INDEX] == NumObjReq - 1
                && (LevelInfo.DefendingSide == SIDE_None || LevelInfo.DefendingSide == SIDE_Allies))
            {
                BroadcastLastObjectiveMessage(AXIS_TEAM_INDEX);
            }
            if (Num[ALLIES_TEAM_INDEX] == LevelInfo.NumObjectiveWin - 1 && NumReq[ALLIES_TEAM_INDEX] == NumObjReq
                && (LevelInfo.DefendingSide == SIDE_None || LevelInfo.DefendingSide == SIDE_Axis))
            {
                BroadcastLastObjectiveMessage(ALLIES_TEAM_INDEX);
            }
            else if (Num[ALLIES_TEAM_INDEX] >= LevelInfo.NumObjectiveWin - 1 && NumReq[ALLIES_TEAM_INDEX] == NumObjReq - 1
                && (LevelInfo.DefendingSide == SIDE_None || LevelInfo.DefendingSide == SIDE_Axis))
            {
                BroadcastLastObjectiveMessage(ALLIES_TEAM_INDEX);
            }
        }

        if (LevelInfo.bUseSpawnAreas)
        {
            CheckSpawnAreas();
            CheckTankCrewSpawnAreas();
            CheckVehicleFactories();
            CheckResupplyVolumes();
            CheckMineVolumes();
        }

        // Notify the objective managers
        NotifyObjectiveManagers();
    }

    // Modified to use DHRoundOverMessage class & to add DH metrics recording (also removes redundant SteamStatsAndAchievements stuff)
    function EndRound(int Winner)
    {
        switch (Winner)
        {
            case AXIS_TEAM_INDEX:
                Teams[AXIS_TEAM_INDEX].Score += 1.0;
                BroadcastLocalizedMessage(class'DHRoundOverMessage', 0,,, DHLevelInfo);
                TeamScoreEvent(AXIS_TEAM_INDEX, 1, "team_victory");
                break;

            case ALLIES_TEAM_INDEX:
                Teams[ALLIES_TEAM_INDEX].Score += 1.0;
                BroadcastLocalizedMessage(class'DHRoundOverMessage', 1,,, DHLevelInfo);
                TeamScoreEvent(ALLIES_TEAM_INDEX, 1, "team_victory");
                break;

            default:
                BroadcastLocalizedMessage(class'RORoundOverMsg', 2);
                break;
        }

        RoundCount++;

        UpdateAllPlayerScores();

        if (RoundLimit != 0 && RoundCount >= RoundLimit)
        {
            EndGame(none, "RoundLimit");
        }
        else if (WinLimit != 0 && (Teams[AXIS_TEAM_INDEX].Score >= WinLimit || Teams[ALLIES_TEAM_INDEX].Score >= WinLimit))
        {
            EndGame(none, "WinLimit");
        }
        else
        {
            GotoState('RoundOver');
        }

        if (Metrics != none)
        {
            Metrics.OnRoundEnd(Winner);
        }
    }

    function EndState()
    {
        local Pawn P;

        super.EndState();

        foreach DynamicActors(class'Pawn', P)
        {
            P.StopWeaponFiring();
        }
    }

    function Timer()
    {
        local int i, ArtilleryStrikeInt;
        local Controller P;
        local DHGameReplicationInfo GRI;

        global.Timer();

        GRI = DHGameReplicationInfo(GameReplicationInfo);

        // Go through both teams and spawn reinforcements if necessary
        for (i = 0; i < 2; ++i)
        {
            if (!SpawnLimitReached(i))
            {
                for (P = Level.ControllerList; P != none; P = P.NextController)
                {
                    if (!P.bIsPlayer || P.Pawn != none || P.PlayerReplicationInfo == none || P.PlayerReplicationInfo.Team == none || P.PlayerReplicationInfo.Team.TeamIndex != i)
                    {
                        continue;
                    }

                    if (ROPlayer(P) != none && ROPlayer(P).CanRestartPlayer())
                    {
                        RestartPlayer(P);
                    }
                    else if (ROBot(P) != none && ROPlayerReplicationInfo(P.PlayerReplicationInfo).RoleInfo != none)
                    {
                        RestartPlayer(P);
                    }
                }
            }
        }

        // Attrition calculation, set, and reinforcement modification
        for (i = 0; i < 2; ++i)
        {
            // Combine attrition values and set GRI
            GRI.AttritionRate[i] = (InterpCurveEval(ElapsedTimeAttritionCurve, float(GRI.ElapsedTime)) + CalculatedAttritionRate[i]) / 60;

            TeamAttritionCounter[i] += GRI.AttritionRate[i];

            if (TeamAttritionCounter[i] >= 1.0)
            {
                ModifyReinforcements(i, -TeamAttritionCounter[i]);
                TeamAttritionCounter[i] = TeamAttritionCounter[i] % 1.0;
            }
        }

        // Go through both teams and update artillery availability
        for (i = 0; i < 2; ++i)
        {
            ArtilleryStrikeInt = LevelInfo.GetStrikeInterval(i);

            // Artillery is not available if out of strikes, if still waiting on next call, or a strike is currently in progress
            if ((GRI.TotalStrikes[i] < GRI.ArtilleryStrikeLimit[i]) && ElapsedTime > (GRI.LastArtyStrikeTime[i] + ArtilleryStrikeInt) && GRI.ArtyStrikeLocation[i] == vect(0.0, 0.0, 0.0))
            {
                GRI.bArtilleryAvailable[i] = 1;
            }
            else
            {
                GRI.bArtilleryAvailable[i] = 0;
            }
        }

        // if round time is up, the defending team wins, if any
        if (RoundDuration != 0 && ElapsedTime > GRI.RoundEndTime)
        {
            Level.Game.Broadcast(self, "The battle ended because time ran out", 'Say');
            ChooseWinner();
        }

        // Check whether local player has his weapons locked, but it's now time to unlock them (applies to single player or listen server host)
        if (DHPlayer(Level.GetLocalPlayerController()) != none)
        {
            DHPlayer(Level.GetLocalPlayerController()).CheckUnlockWeapons();
        }
    }
}

state ResetGameCountdown
{
    // Modified to replace ROArtillerySpawner with DHArtillerySpawner
    function BeginState()
    {
        local DHArtillerySpawner AS;

        if (bSwapTeams)
        {
            ChangeSides(); // Change sides if bSwapTeams is true
            bSwapTeams = false;
        }

        RoundStartTime = ElapsedTime + 10.0;

        ROGameReplicationInfo(GameReplicationInfo).bReinforcementsComing[AXIS_TEAM_INDEX] = 0;
        ROGameReplicationInfo(GameReplicationInfo).bReinforcementsComing[ALLIES_TEAM_INDEX] = 0;

        // Destroy any artillery spawners so they don't keep calling arty.
        foreach DynamicActors(class'DHArtillerySpawner', AS)
        {
            AS.Destroy();
        }

        Level.Game.BroadcastLocalized(none, class'ROResetGameMsg', 10);
    }

    // Modified to spawn a DHClientResetGame actor on a server, which replicates to net clients to remove any temporary client-only actors, e.g. smoke effects
    // Also will call function that auto-opens DHDeployMenu for players
    function Timer()
    {
        global.Timer();

        if (ElapsedTime > RoundStartTime - 1.0) // the -1.0 gets rid of "The game will restart in 0 seconds"
        {
            if (Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer)
            {
                Spawn(class'DHClientResetGame');
            }

            Level.Game.BroadcastLocalized(none, class'ROResetGameMsg', 11);
            ResetScores();
            OpenPlayerMenus();
            GotoState('RoundInPlay');
        }
        else
        {
            Level.Game.BroadcastLocalized(none, class'ROResetGameMsg', RoundStartTime - ElapsedTime);
        }
    }
}

// Modified to reset stashed score in addition to score
function ResetScores()
{
    local DHPlayerReplicationInfo   PRI;
    local Controller                C;

    RemainingTime = 60 * TimeLimit;
    ElapsedTime = 0;
    GameReplicationInfo.ElapsedTime = 0;
    GameReplicationInfo.ElapsedQuarterMinute = 1;
    RoundCount = 0;
    Teams[AXIS_TEAM_INDEX].Score = 0;
    Teams[ALLIES_TEAM_INDEX].Score = 0;

    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        if (DHPlayerReplicationInfo(C.PlayerReplicationInfo) != none)
        {
            PRI = DHPlayerReplicationInfo(C.PlayerReplicationInfo);
            PRI.Score = 0;
            PRI.StashedScore = 0;
        }
    }
}

state RoundOver
{
    // Modified to replace ROArtillerySpawner with DHArtillerySpawner
    function BeginState()
    {
        local DHArtillerySpawner AS;
        local DHGameReplicationInfo GRI;

        GRI = DHGameReplicationInfo(GameReplicationInfo);

        RoundStartTime = ElapsedTime;

        if (GRI != none)
        {
            GRI.bReinforcementsComing[AXIS_TEAM_INDEX] = 0;
            GRI.bReinforcementsComing[ALLIES_TEAM_INDEX] = 0;
            GRI.bRoundIsOver = true;
        }

        // Destroy any artillery spawners so they don't keep calling arty
        foreach DynamicActors(class'DHArtillerySpawner', AS)
        {
            AS.Destroy();
        }
    }

    // Modified to spawn a DHClientResetGame actor on a server, which replicates to net clients to remove any temporary client-only actors, e.g. smoke effects
    function Timer()
    {
        local float TempScore;

        global.Timer();

        if (ElapsedTime > RoundStartTime + 5.0)
        {
            if (Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer)
            {
                Spawn(class'DHClientResetGame');
            }

            // Determine if teams needs swapped
            if (DHLevelInfo != none && DHLevelInfo.bSwapTeamsOnRoundEnd)
            {
                ChangeSides();

                // Swap team score as well
                TempScore = GameReplicationInfo.Teams[0].Score;
                GameReplicationInfo.Teams[0].Score = GameReplicationInfo.Teams[1].Score;
                GameReplicationInfo.Teams[1].Score = TempScore;
            }

            GotoState('RoundInPlay');
        }
    }
}

// Extended to inform GRI that the round is over so the time remaining can "pause" on the second the round ended (instead of continuing to count down)
function EndGame(PlayerReplicationInfo Winner, string Reason)
{
    local Inventory Inv;

    if (DHGameReplicationInfo(GameReplicationInfo) != none)
    {
        DHGameReplicationInfo(GameReplicationInfo).bRoundIsOver = true;
    }

    // Destroy all Inventory (hopeful fix to the constant MG firing)
    foreach DynamicActors(class'Inventory', Inv)
    {
        Inv.Destroy();
    }

    super.EndGame(Winner, Reason);
}

function ModifyReinforcements(int Team, int Amount, optional bool bSetReinforcements, optional bool bOnlyIfNotZero)
{
    local DHGameReplicationInfo GRI;
    local bool                  bIsDefendingTeam, bIsInfinite, bOutOfReinf;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (GRI == none || (Team != AXIS_TEAM_INDEX && Team != ALLIES_TEAM_INDEX))
    {
        return;
    }

    bIsInfinite = GRI.SpawnsRemaining[Team] == -1;
    bOutOfReinf = GRI.SpawnsRemaining[Team] == 0;

    // If we are NOT setting reinforcements & if reinf is infinite, then return
    // Also if reinf is zero (out) and we are to only modify if NOT zero, then return
    if ((!bSetReinforcements && bIsInfinite) || (bOutOfReinf && bOnlyIfNotZero))
    {
        return;
    }

    // Update GRI with the new value
    if (bSetReinforcements)
    {
        GRI.SpawnsRemaining[Team] = Max(-1, Amount);
    }
    else
    {
        GRI.SpawnsRemaining[Team] = Max(0, GRI.SpawnsRemaining[Team] + Amount);
    }

    // If out of reinforcements, then handle checks to end the round
    if (bOutOfReinf && bTeamOutOfReinforcements[Team] == 0)
    {
        // Determine if player's team is defending
        bIsDefendingTeam = (Team == AXIS_TEAM_INDEX && LevelInfo.DefendingSide == SIDE_Axis) ||
                           (Team == ALLIES_TEAM_INDEX && LevelInfo.DefendingSide == SIDE_Allies);

        // Team is now out of reinforcements
        bTeamOutOfReinforcements[Team] = 1;

        // If the round is meant to end when a team runs out of reinforcements, then end it (and exit function)
        if (bRoundEndsAtZeroReinf)
        {
            Level.Game.Broadcast(self, "The battle ended because a team's reinforcements reached zero", 'Say');
            ChooseWinner();
            return; // Leave function as we don't want to change round time as round is over
        }

        else if (bTimeChangesAtZeroReinf && (LevelInfo.DefendingSide != SIDE_None && !bIsDefendingTeam) || LevelInfo.DefendingSide == SIDE_None)
        {
            // If the time is meant to change when a team runs out of reinf
            // AND the player killed was an Attacker (with a defending side)
            // OR the defending side is none
            // THEN modify the round time
            ModifyRoundTime(Min(GetRoundTime(), 90), 2); // Set time remaining to 90 seconds, if greater than 90 seconds
        }
    }
}

function ResetArtilleryTargets()
{
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (GRI != none)
    {
        GRI.ClearAllArtilleryTargets();
    }
}

// Handle reinforcment checks and balances
function HandleReinforcements(Controller C)
{
    local DHPlayer PC;
    local DHGameReplicationInfo GRI;
    local float ReinforcementPercent;

    PC = DHPlayer(C);
    GRI = DHGameReplicationInfo(GameReplicationInfo);

    // Don't subtract / calc reinforcements as the player didn't get a pawn
    if (PC == none || PC.Pawn == none || GRI == none)
    {
        return;
    }

    if (PC.GetTeamNum() == ALLIES_TEAM_INDEX && GRI.SpawnsRemaining[ALLIES_TEAM_INDEX] != -1)
    {
        ModifyReinforcements(ALLIES_TEAM_INDEX, -1);

        ReinforcementPercent = float(GRI.SpawnsRemaining[ALLIES_TEAM_INDEX]) / float(LevelInfo.Allies.SpawnLimit);

        // Handle reinforcement % message
        if (bUseReinforcementWarning)
        {
            while (TeamReinforcementMessageIndices[ALLIES_TEAM_INDEX] < default.ReinforcementMessagePercentages.Length &&
                    ReinforcementPercent <= default.ReinforcementMessagePercentages[TeamReinforcementMessageIndices[ALLIES_TEAM_INDEX]])
            {
                SendReinforcementMessage(ALLIES_TEAM_INDEX, 100 * default.ReinforcementMessagePercentages[TeamReinforcementMessageIndices[ALLIES_TEAM_INDEX]]);

                ++TeamReinforcementMessageIndices[ALLIES_TEAM_INDEX];
            }
        }
    }
    else if (PC.GetTeamNum() == AXIS_TEAM_INDEX && GRI.SpawnsRemaining[AXIS_TEAM_INDEX] != -1)
    {
        ModifyReinforcements(AXIS_TEAM_INDEX, -1);

        ReinforcementPercent = float(GRI.SpawnsRemaining[AXIS_TEAM_INDEX]) / float(LevelInfo.Axis.SpawnLimit);

        // Handle reinforcement % message
        if (bUseReinforcementWarning)
        {
            while (TeamReinforcementMessageIndices[AXIS_TEAM_INDEX] < default.ReinforcementMessagePercentages.Length &&
                    ReinforcementPercent <= default.ReinforcementMessagePercentages[TeamReinforcementMessageIndices[AXIS_TEAM_INDEX]])
            {
                SendReinforcementMessage(AXIS_TEAM_INDEX, 100 * default.ReinforcementMessagePercentages[TeamReinforcementMessageIndices[AXIS_TEAM_INDEX]]);

                ++TeamReinforcementMessageIndices[AXIS_TEAM_INDEX];
            }
        }
    }

    if (PC.bFirstRoleAndTeamChange && GetStateName() == 'RoundInPlay')
    {
        PC.NotifyOfMapInfoChange();
        PC.bFirstRoleAndTeamChange = true;
    }
}

// This function adds functionality so when you type "%r" in teamsay it'll output helpful debug info for reporting bugs in MP (returns mapname & coordinates)
static function string ParseChatPercVar(Mutator BaseMutator, Controller Who, string Cmd)
{
    local string Str;
    local string MapName;

    if (Who.Pawn == none)
    {
        return Cmd;
    }

    // Coordinates
    if (cmd ~= "%r")
    {
        // Get the level name string
        MapName = string(Who.Outer);

        if (MapName == "")
        {
            MapName = "Error No MapName";
        }

        // Finish parsing the string
        Str = "Map:" @ MapName @ "Coord:" @ string(Who.Pawn.Location) @ "Report: ";

        return Str;
    }

    if (cmd ~= "%h")
    {
        if (Who != none && DHVehicle(Who.Pawn) != none && DHVehicle(Who.Pawn).Driver != none)
        {
            return "[Vehicle HP:" @ Who.Pawn.Health $ "] [Engine HP:" @ DHVehicle(Who.Pawn).EngineHealth $ "] [Player HP:" @ DHVehicle(Who.Pawn).Driver.Health $ "]";
        }
        else if (Who.Pawn != none)
        {
            return Who.Pawn.Health $ " Health";
        }
        else
        {
            return "No Pawn";
        }
    }

    return super.ParseChatPercVar(BaseMutator, Who, Cmd);
}

//***********************************************************************************
// exec FUNCTIONS - These functions natively require admin access
//***********************************************************************************

exec function DebugDestroyConstructions()
{
    local DHConstruction C;

    foreach AllActors(class'DHConstruction', C)
    {
        C.GotoState('Broken');
    }
}

// Quick test function to change a role's limit (doesn't support bots)
exec function DebugSetRoleLimit(int Team, int Index, int NewLimit)
{
    local DHGameReplicationInfo GRI;
    local Controller            C;
    local DHPlayer              PC;
    local int                   RoleCount, RoleBotCount, RoleLimit, i;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (GRI == none)
    {
        return;
    }

    if (Team == AXIS_TEAM_INDEX)
    {
        GRI.DHAxisRoleLimit[Index] = NewLimit;
        GRI.GetRoleCounts(GRI.DHAxisRoles[Index], RoleCount, RoleBotCount, RoleLimit);
    }
    else if (Team == ALLIES_TEAM_INDEX)
    {
        GRI.DHAlliesRoleLimit[Index] = NewLimit;
        GRI.GetRoleCounts(GRI.DHAlliesRoles[Index], RoleCount, RoleBotCount, RoleLimit);
    }

    if (RoleCount - NewLimit > 0)
    {
        for (C = Level.ControllerList; C != none; C = C.NextController)
        {
            PC = DHPlayer(C);

            if (PC == none)
            {
                continue;
            }

            if (PC.GetTeamNum() == Team && (PC.GetRoleInfo() == GRI.DHAlliesRoles[Index] ||
                                            PC.GetRoleInfo() == GRI.DHAxisRoles[Index]))
            {
                DHPlayerReplicationInfo(PC.PlayerReplicationInfo).RoleInfo = none;
                PC.bSpawnPointInvalidated = true;

                if (i >= RoleCount - NewLimit)
                {
                    return;
                }

                ++i;
            }
        }
    }
}

// Function for changing the AlliesToAxisRatio for testing and real time balance changes
exec function SetAlliesToAxisRatio(float Value)
{
    // Pass -1 to reset
    if (Value == -1.0)
    {
        AlliesToAxisRatio = DHLevelInfo.AlliesToAxisRatio;
    }

    // Prevent values outside of range
    if (Value < 0.0 || Value > 1.0)
    {
        Log("Valued supplied in SetAlliesToAxisRatio is out of bounds");
        return;
    }

    AlliesToAxisRatio = Value;

    Level.Game.Broadcast(self, "Changed AlliesToAxisRatio to: " $ Value);
}

// Function for changing bHardTeamRatio at real time
exec function SetHardTeamRatio(bool bNewHardTeamRatio)
{
    DHLevelInfo.bHardTeamRatio = bNewHardTeamRatio;
}

// Function for changing a team's ReinforcementInterval
exec function SetReinforcementInterval(int Team, int Amount)
{
    if (Amount > 0 && DHGameReplicationInfo(GameReplicationInfo) != none)
    {
        if (Team == AXIS_TEAM_INDEX)
        {
            LevelInfo.Axis.ReinforcementInterval = Amount;
        }
        else if (Team == ALLIES_TEAM_INDEX)
        {
            LevelInfo.Allies.ReinforcementInterval = Amount;
        }

        DHGameReplicationInfo(GameReplicationInfo).ReinforcementInterval[Team] = Amount;
    }
}

// Function for winning a round
exec function WinRound(optional int TeamToWin)
{
    EndRound(TeamToWin);
}

exec function SetReinforcements(int Team, int Amount)
{
    ModifyReinforcements(Team, Amount, true);
}

// Function to allow for capturing a currently active objective (for the supplied team), useful for debugging
exec function CaptureObj(int Team)
{
    local int i;

    for (i = 0; i < arraycount(DHObjectives); ++i)
    {
        if (DHObjectives[i] != none &&
            DHObjectives[i].bActive &&
            DHObjectives[i].ObjState != Team)
        {
            DHObjectives[i].ObjectiveCompleted(none, Team);

            return;
        }
    }
}

// This function is for admins who want to change round time on the fly, can pass a value (in minutes) and a type (default: set)
exec function ChangeRoundTime(int Minutes, optional string Type)
{
    if (Minutes < 0)
    {
        return;
    }

    switch (Type)
    {
    case "Add":
        ModifyRoundTime(Minutes * 60, 0);
        break;
    case "Subtract":
        ModifyRoundTime(Minutes * 60, 1);
        break;
    default:
        ModifyRoundTime(Minutes * 60, 2);
        break;
    }
}

// Override to allow more than 32 bots (but not too many, 128 max)
exec function AddBots(int num)
{
    num = Clamp(num, 0, 128 - (NumPlayers + NumBots));

    while (--num >= 0)
    {
        if (Level.NetMode != NM_Standalone)
        {
            MinPlayers = Max(MinPlayers + 1, NumPlayers + NumBots + 1);
        }

        AddBot();
    }
}

// Override to actually kill all bots if no num is given
exec function KillBots(int num)
{
    local Controller C, nextC;

    bPlayersVsBots = false;

    if (num == 0)
    {
        num = 128;
    }

    C = Level.ControllerList;

    if (Level.NetMode != NM_Standalone)
    {
        MinPlayers = 0;
    }

    bKillBots = true;

    while (C != none && num > 0)
    {
        nextC = C.NextController;

        if (KillBot(C))
        {
            --num;
        }

        if (nextC != none)
        {
            C = nextC;
        }
        else
        {
            C = none;
        }
    }

    bKillBots = false;
}

// This function will initiate a reset game with swap teams
exec function SwapTeams()
{
    bSwapTeams = true;
    ResetGame();
}

// Forces a mid game vote to start
exec function MidGameVote()
{
    local DHVotingHandler VH;

    VH = DHVotingHandler(VotingHandler);

    if (VH != none)
    {
        VH.MidGameVote();
    }
}

//***********************************************************************************
// END exec Functions!!!
//***********************************************************************************

function RestartPlayer(Controller C)
{
    DeployRestartPlayer(C, true, false);
}

function DeployRestartPlayer(Controller C, optional bool bHandleReinforcements, optional bool bUseOldRestart)
{
    local DHPlayer PC;

    if (bUseOldRestart || DHLevelInfo.SpawnMode == ESM_RedOrchestra)
    {
        SetCharacter(C);

        super(TeamGame).RestartPlayer(C);

        if (bHandleReinforcements)
        {
            HandleReinforcements(C);
        }
    }
    else if (!DHRestartPlayer(C, bHandleReinforcements) && PlayerController(C) != none)
    {
        PC = DHPlayer(C);

        if (PC != none)
        {
            PC.DeployMenuStartMode = MODE_Map;
            PC.ClientProposeMenu("DH_Interface.DHDeployMenu");
        }
    }
}

function bool DHRestartPlayer(Controller C, optional bool bHandleReinforcements)
{
    local TeamInfo BotTeam, OtherTeam;
    local DHPlayer DHC;

    DHC = DHPlayer(C);

    if (DHC == none)
    {
        return false;
    }

    if ((!bPlayersVsBots || (Level.NetMode == NM_Standalone)) &&
        bBalanceTeams && Bot(C) != none &&
        (!bCustomBots || (Level.NetMode != NM_Standalone)))
    {
        BotTeam = C.PlayerReplicationInfo.Team;

        if (BotTeam == Teams[0])
        {
            OtherTeam = Teams[1];
        }
        else
        {
            OtherTeam = Teams[0];
        }

        if (OtherTeam.Size < BotTeam.Size - 1)
        {
            C.Destroy();

            return false;
        }
    }

    if (bMustJoinBeforeStart && (UnrealPlayer(C) != none) && UnrealPlayer(C).bLatecomer)
    {
        return false;
    }

    if (C.PlayerReplicationInfo.bOutOfLives)
    {
        return false;
    }

    if (C.IsA('Bot') && TooManyBots(C))
    {
        C.Destroy();

        return false;
    }

    if (bRestartLevel && Level.NetMode != NM_DedicatedServer && Level.NetMode != NM_ListenServer)
    {
        return false;
    }

    if (!SpawnLimitReached(C.PlayerReplicationInfo.Team.TeamIndex) && IsInState('RoundInPlay'))
    {
        if (!SpawnManager.SpawnPlayer(DHC))
        {
            return false;
        }

        if (DHC.Pawn != none)
        {
            DHC.ClientFadeFromBlack(3.0);
        }

        if (bHandleReinforcements)
        {
            HandleReinforcements(C);
        }
    }

    return true;
}

// Functionally identical to ROTeamGame.ChangeTeam except we reset additional parameters in DHPlayer
function bool ChangeTeam(Controller Other, int Num, bool bNewTeam)
{
    local int OldTeam;
    local UnrealTeamInfo NewTeam;
    local DHPlayer       PC;
    local DHGameReplicationInfo GRI;

    OldTeam = Other.GetTeamNum();

    if (bMustJoinBeforeStart && GameReplicationInfo.bMatchHasBegun)
    {
        return false; // only allow team changes before match starts
    }

    if (CurrentGameProfile != none && !CurrentGameProfile.CanChangeTeam(Other, Num))
    {
        return false;
    }

    if (Other.IsA('PlayerController') && Other.PlayerReplicationInfo.bOnlySpectator)
    {
        Other.PlayerReplicationInfo.Team = none;

        return true;
    }

    PC = DHPlayer(Other);
    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (GRI == none)
    {
        return false;
    }

    // Do a check to see if we can change teams yet
    if (bPlayersBalanceTeams && PC != none && PC.NextChangeTeamTime >= GRI.ElapsedTime)
    {
        return false;
    }

    NewTeam = Teams[PickTeam(Num, Other)];

    // Check if already on this team
    if (Other.PlayerReplicationInfo.Team == NewTeam)
    {
        return false;
    }

    Other.StartSpot = none;

    PlayerLeftTeam(PC);

    if (NewTeam.AddToTeam(Other))
    {
        if (NewTeam == Teams[ALLIES_TEAM_INDEX])
        {
            BroadcastLocalizedMessage(GameMessageClass, 3, Other.PlayerReplicationInfo, none, NewTeam);
        }
        else
        {
            BroadcastLocalizedMessage(GameMessageClass, 12, Other.PlayerReplicationInfo, none, NewTeam);
        }

        if (bNewTeam && PlayerController(Other) != none)
        {
            GameEvent("TeamChange", "" $ Num, Other.PlayerReplicationInfo);
        }
    }

    // If we changed team, and if elapsed time hasn't gone past the change team interval, and we aren't in standalone then set the NextChangeTeamTime
    // The reason why we compare ElapsedTime to ChangeTeamInterval is we want to allow players to change teams freely for a duration from the start
    // The duration desired is roughly 120 seconds which is what ChangeTeamInterval is currently set to, so if that changes, this if statement (might) need changed as well
    if (PC != none && bNewTeam && GRI.ElapsedTime > ChangeTeamInterval && Level.NetMode != NM_Standalone && !class'DH_LevelInfo'.static.DHDebugMode())
    {
        // This sets the DHPlayer NextChangeTeamTime which determines when a player can change team next
        // If the player leaves, it is stored in a player session and restored if they rejoin
        PC.NextChangeTeamTime = GRI.ElapsedTime + default.ChangeTeamInterval;
    }

    return true;
}

function bool BecomeSpectator(PlayerController P)
{
    if (!super.BecomeSpectator(P))
    {
        return false;
    }

    PlayerLeftTeam(P);

    P.PlayerReplicationInfo.Team = none;
    P.PlayerReplicationInfo.bIsSpectator = true;
    P.PlayerReplicationInfo.bOnlySpectator = true;
}

function PlayerLeftTeam(PlayerController P)
{
    local DHPlayer PC;
    local DHGameReplicationInfo GRI;
    local DHPlayerReplicationInfo PRI;

    PC = DHPlayer(P);
    GRI = DHGameReplicationInfo(GameReplicationInfo);
    PRI = DHPlayerReplicationInfo(P.PlayerReplicationInfo);

    if (PC != none)
    {
        PC.DesiredRole = -1;
        PC.CurrentRole = -1;
        PC.PrimaryWeapon = -1;
        PC.DesiredPrimary = 0;
        PC.SecondaryWeapon = -1;
        PC.DesiredSecondary = 0;
        PC.GrenadeWeapon = -1;
        PC.DesiredGrenade = 0;
        PC.bWeaponsSelected = false;
        PC.SavedArtilleryCoords = vect(0.0, 0.0, 0.0);
        PC.SpawnPointIndex = -1;
        PC.bSpawnPointInvalidated = true;

        ClearSavedRequestsAndRallyPoints(PC, false);
    }

    if (PRI != none)
    {
        if (PRI.Team != none)
        {
            PRI.Team.RemoveFromTeam(P);
        }

        PRI.RoleInfo = none;
    }

    if (GRI != none)
    {
        GRI.UnreserveVehicle(PC);
        GRI.ClearArtilleryTarget(PC);
    }

    if (SquadReplicationInfo != none)
    {
        SquadReplicationInfo.LeaveSquad(PRI);
    }
}

// Modified to support one normal kick, then session kick for FF violation
function HandleFFViolation(PlayerController Offender)
{
    local bool   bSuccess, bFoundID;
    local string OffenderID;
    local int    i;

    if (FFPunishment == FFP_None || Level.NetMode == NM_Standalone || Offender.PlayerReplicationInfo.bAdmin)
    {
        return;
    }

    // Stop if the controller is pending deletion
    if (Offender.bDeleteMe || Offender.bPendingDelete || Offender.bPendingDestroy)
    {
        return;
    }

    OffenderID = Offender.GetPlayerIDHash();

    BroadcastLocalizedMessage(GameMessageClass, 14, Offender.PlayerReplicationInfo);
    Log("Kicking" @ Offender.GetHumanReadableName() @ "due to a friendly fire violation.");

    // The player has been kicked once and needs to be session kicked
    if (FFPunishment == FFP_Kick && bSessionKickOnSecondFFViolation)
    {
        for (i = 0; i < FFViolationIDs.Length; ++i)
        {
            if (FFViolationIDs[i] == OffenderID)
            {
                bFoundID = true;
                AccessControl.BanPlayer(Offender, true); //Session kick
                return;
            }
        }

        if (!bFoundID)
        {
            FFViolationIDs.Insert(0, 1);
            FFViolationIDs[0] = OffenderID;
        }
    }

    if (FFPunishment == FFP_Kick)
    {
        bSuccess = KickPlayer(Offender);
    }
    else if (FFPunishment == FFP_SessionBan)
    {
        bSuccess = AccessControl.BanPlayer(Offender, true);
    }
    else
    {
        bSuccess = AccessControl.BanPlayer(Offender);
    }

    if (!bSuccess)
    {
        Log("Unable to remove" @ Offender.GetHumanReadableName() @ "from the server.");
    }
}

// Modified to add all literal material references from vehicle classes, so they aren't repeated again & again for every vehicle (most were already in the Super in ROTeamGame)
static function PrecacheGameTextures(LevelInfo myLevel)
{
    super.PrecacheGameTextures(myLevel);

    // From ROWheeledVehicle:
    myLevel.AddPrecacheMaterial(material'Effects_Tex.explosions.fire_16frame');
    myLevel.AddPrecacheMaterial(material'Effects_Tex.Vehicles.DustCloud');
    myLevel.AddPrecacheMaterial(material'Effects_Tex.Vehicles.Dust_KickUp');
    myLevel.AddPrecacheMaterial(material'Effects_Tex.Vehicles.vehiclesparkhead');

    // From ROTreadCraft:
    myLevel.AddPrecacheMaterial(material'Effects_Tex.explosions.aptankmark_dirt');
    myLevel.AddPrecacheMaterial(material'Effects_Tex.explosions.aptankmark_snow');
    myLevel.AddPrecacheMaterial(material'Effects_Tex.BulletHits.glowfinal');

    // From DHArmoredVehicle:
    myLevel.AddPrecacheMaterial(material'DH_VehiclesGE_tex2.ext_vehicles.Alpha');

    // From ROTankCannon:
    myLevel.AddPrecacheMaterial(material'Weapons3rd_tex.tank_shells.shell_122mm');
    myLevel.AddPrecacheMaterial(material'Weapons3rd_tex.tank_shells.shell_76mm');
    myLevel.AddPrecacheMaterial(material'Weapons3rd_tex.tank_shells.shell_85mm');
    myLevel.AddPrecacheMaterial(material'Effects_Tex.fire_quad');
    myLevel.AddPrecacheMaterial(material'ROEffects.SmokeAlphab_t');
}

// Overridden so we can grab the primary and secondary weapons to feed to replication
function ChangeWeapons(Controller aPlayer, int Primary, int Secondary, int Grenade)
{
    local DHPlayer PC;

    super.ChangeWeapons(aPlayer, Primary, Secondary, Grenade);

    PC = DHPlayer(aPlayer);

    if (PC != none)
    {
        PC.DHPrimaryWeapon = PC.PrimaryWeapon;
        PC.DHSecondaryWeapon = PC.SecondaryWeapon;
    }
}

// Modified for DHObjectives
function ChooseWinner()
{
    local Controller C;
    local int i, Num[2], NumReq[2], AxisScore, AlliedScore;
    local float AxisReinforcementsPercent, AlliedReinforcementsPercent;
    local DHGameReplicationInfo GRI;

    // Setup some GRI stuff
    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (GRI == none)
    {
        return;
    }

    AxisReinforcementsPercent = (float(GRI.SpawnsRemaining[AXIS_TEAM_INDEX]) / LevelInfo.Axis.SpawnLimit) * 100;
    AlliedReinforcementsPercent = (float(GRI.SpawnsRemaining[ALLIES_TEAM_INDEX]) / LevelInfo.Allies.SpawnLimit) * 100;

    // Check to see who has more reinforcements when bRoundEndsAtZeroReinf
    if (bRoundEndsAtZeroReinf)
    {
        // The winner is the one with higher reinforcements (no concern over objective counts)
        if (AxisReinforcementsPercent > AlliedReinforcementsPercent)
        {
            Level.Game.Broadcast(self, "The Axis won the battle because they have more reinforcements", 'Say');
            EndRound(AXIS_TEAM_INDEX);
            return;
        }
        else if (AlliedReinforcementsPercent > AxisReinforcementsPercent)
        {
            Level.Game.Broadcast(self, "The Allies won the battle because they have more reinforcements", 'Say');
            EndRound(ALLIES_TEAM_INDEX);
            return;
        }
        else // Both teams have same reinforcements so its a tie "No Decisive Victory"
        {
            Level.Game.Broadcast(self, "Neither side won the battle because they have equal reinforcements", 'Say');
            EndRound(2);
            return;
        }
    }

    // Attack/Defend check
    // Check to see if a defending side won (this is most common type of win)
    if (LevelInfo.DefendingSide == SIDE_Axis)
    {
        Level.Game.Broadcast(self, "The defending Axis won the battle because they still hold an objective", 'Say');
        EndRound(AXIS_TEAM_INDEX);
        return;
    }
    else if (LevelInfo.DefendingSide == SIDE_Allies)
    {
        Level.Game.Broadcast(self, "The defending Allies won the battle because they still hold an objective", 'Say');
        EndRound(ALLIES_TEAM_INDEX);
        return;
    }

    // Attack/Attack check
    // Count objectives (required and total)
    for (i = 0; i < arraycount(DHObjectives); ++i)
    {
        if (DHObjectives[i] == none)
        {
            break;
        }
        else if (DHObjectives[i].IsAxis())
        {
            Num[AXIS_TEAM_INDEX]++;

            if (DHObjectives[i].bRequired)
            {
                NumReq[AXIS_TEAM_INDEX]++;
            }
        }
        else if (DHObjectives[i].IsAllies())
        {
            Num[ALLIES_TEAM_INDEX]++;

            if (DHObjectives[i].bRequired)
            {
                NumReq[ALLIES_TEAM_INDEX]++;
            }
        }
    }

    // Side with more required objectives wins, if equal, then total objectives, if equal then continues
    if (NumReq[AXIS_TEAM_INDEX] != NumReq[ALLIES_TEAM_INDEX])
    {
        if (NumReq[AXIS_TEAM_INDEX] > NumReq[ALLIES_TEAM_INDEX])
        {
            Level.Game.Broadcast(self, "The Axis won the battle because they control a greater number of crucial objectives", 'Say');
            EndRound(AXIS_TEAM_INDEX);

            return;
        }
        else
        {
            Level.Game.Broadcast(self, "The Allies won the battle because they control a greater number of crucial objectives", 'Say');
            EndRound(ALLIES_TEAM_INDEX);

            return;
        }
    }
    else if (Num[AXIS_TEAM_INDEX] != Num[ALLIES_TEAM_INDEX])
    {
        if (Num[AXIS_TEAM_INDEX] > Num[ALLIES_TEAM_INDEX])
        {
            Level.Game.Broadcast(self, "The Axis won the battle because they control a greater number of objectives", 'Say');
            EndRound(AXIS_TEAM_INDEX);

            return;
        }
        else
        {
            Level.Game.Broadcast(self, "The Allies won the battle because they control a greater number of objectives", 'Say');
            EndRound(ALLIES_TEAM_INDEX);

            return;
        }
    }

    // Get team score (combined player score)
    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        if (C.PlayerReplicationInfo != none && C.PlayerReplicationInfo.Team != none)
        {
            if (C.PlayerReplicationInfo.Team.TeamIndex == AXIS_TEAM_INDEX)
            {
                AxisScore += C.PlayerReplicationInfo.Score;
            }
            else if (C.PlayerReplicationInfo.Team.TeamIndex == ALLIES_TEAM_INDEX)
            {
                AlliedScore += C.PlayerReplicationInfo.Score;
            }
        }
    }

    // Highest score wins, if equal continue
    if (AxisScore != AlliedScore)
    {
        if (AxisScore > AlliedScore)
        {
            Level.Game.Broadcast(self, "The Axis won the battle because they have a higher score than the Allies", 'Say');
            EndRound(AXIS_TEAM_INDEX);

            return;
        }
        else
        {
            Level.Game.Broadcast(self, "The Allies won the battle because they have a higher score than the Axis", 'Say');
            EndRound(ALLIES_TEAM_INDEX);

            return;
        }
    }

    // Highest reinforcements percent wins, if equal continue
    if (AxisReinforcementsPercent != AlliedReinforcementsPercent)
    {
        if (AxisReinforcementsPercent > AlliedReinforcementsPercent)
        {
            Level.Game.Broadcast(self, "The Axis won the battle because they have more reinforcements", 'Say');
            EndRound(AXIS_TEAM_INDEX);

            return;
        }
        else
        {
            Level.Game.Broadcast(self, "The Allies won the battle because they have more reinforcements", 'Say');
            EndRound(ALLIES_TEAM_INDEX);

            return;
        }
    }

    // If by some crazy turn of events everything above this is still equal, then do a "No Decisive Victory"
    Level.Game.Broadcast(self, "No clear victor because both sides have equal Objectives, Score, Reinforcements, and there is no attrition", 'Say');
    EndRound(2);
}

function CheckSpawnAreas()
{
    local ROSpawnArea Best[2];
    local bool        bReqsMet, bSomeReqsMet;
    local int         h, i, j, k;

    for (i = 0; i < SpawnAreas.Length; ++i)
    {
        if (!SpawnAreas[i].bEnabled)
        {
            continue;
        }

        if (SpawnAreas[i].bAxisSpawn && (Best[AXIS_TEAM_INDEX] == none || SpawnAreas[i].AxisPrecedence > Best[AXIS_TEAM_INDEX].AxisPrecedence))
        {
            bReqsMet = true;
            bSomeReqsMet = false;

            for (j = 0; j < SpawnAreas[i].AxisRequiredObjectives.Length; ++j)
            {
                if (DHObjectives[SpawnAreas[i].AxisRequiredObjectives[j]] != none && !DHObjectives[SpawnAreas[i].AxisRequiredObjectives[j]].IsAxis())
                {
                    bReqsMet = false;
                    break;
                }
            }

            // Added in conjunction with TeamMustLoseAllRequired enum in SpawnAreas
            // Allows mappers to force all objectives to be lost/won before moving spawns, instead of just one - Ramm
            for (h = 0; h < SpawnAreas[i].AxisRequiredObjectives.Length; ++h)
            {
                if (DHObjectives[SpawnAreas[i].AxisRequiredObjectives[h]] != none && DHObjectives[SpawnAreas[i].AxisRequiredObjectives[h]].IsAxis())
                {
                    bSomeReqsMet = true;
                    break;
                }
            }

            // Added in conjunction with bIncludeNeutralObjectives in SpawnAreas
            // allows mappers to have spawns be used when objectives are neutral, not just captured
            if (SpawnAreas[i].bIncludeNeutralObjectives)
            {
                for (k = 0; k < SpawnAreas[i].NeutralRequiredObjectives.Length; ++k)
                {
                    if (DHObjectives[SpawnAreas[i].NeutralRequiredObjectives[k]] != none && DHObjectives[SpawnAreas[i].NeutralRequiredObjectives[k]].IsNeutral())
                    {
                        bSomeReqsMet = true;
                        break;
                    }
                }
            }

            if (bReqsMet)
            {
                Best[AXIS_TEAM_INDEX] = SpawnAreas[i];
            }
            else if (bSomeReqsMet && SpawnAreas[i].TeamMustLoseAllRequired == SPN_Axis)
            {
                Best[AXIS_TEAM_INDEX] = SpawnAreas[i];
            }
        }

        if (SpawnAreas[i].bAlliesSpawn && (Best[ALLIES_TEAM_INDEX] == none || SpawnAreas[i].AlliesPrecedence > Best[ALLIES_TEAM_INDEX].AlliesPrecedence))
        {
            bReqsMet = true;
            bSomeReqsMet = false;

            for (j = 0; j < SpawnAreas[i].AlliesRequiredObjectives.Length; ++j)
            {
                if (DHObjectives[SpawnAreas[i].AlliesRequiredObjectives[j]] != none && !DHObjectives[SpawnAreas[i].AlliesRequiredObjectives[j]].IsAllies())
                {
                    bReqsMet = false;
                    break;
                }
            }

            // Added in conjunction with TeamMustLoseAllRequired enum in SpawnAreas
            // Allows mappers to force all objectives to be lost/won before moving spawns, instead of just one - Ramm
            for (h = 0; h < SpawnAreas[i].AlliesRequiredObjectives.Length; ++h)
            {
                if (DHObjectives[SpawnAreas[i].AlliesRequiredObjectives[h]] != none && DHObjectives[SpawnAreas[i].AlliesRequiredObjectives[h]].IsAllies())
                {
                    bSomeReqsMet = true;
                    break;
                }
            }

            // Added in conjunction with bIncludeNeutralObjectives in SpawnAreas
            // allows mappers to have spawns be used when objectives are neutral, not just captured
            if (SpawnAreas[i].bIncludeNeutralObjectives)
            {
                for (k = 0; k < SpawnAreas[i].NeutralRequiredObjectives.Length; ++k)
                {
                    if (DHObjectives[SpawnAreas[i].NeutralRequiredObjectives[k]] != none && DHObjectives[SpawnAreas[i].NeutralRequiredObjectives[k]].IsNeutral())
                    {
                        bSomeReqsMet = true;
                        break;
                    }
                }
            }

            if (bReqsMet)
            {
                Best[ALLIES_TEAM_INDEX] = SpawnAreas[i];
            }
            else if (bSomeReqsMet && SpawnAreas[i].TeamMustLoseAllRequired == SPN_Allies)
            {
                Best[ALLIES_TEAM_INDEX] = SpawnAreas[i];
            }
        }
    }

    CurrentSpawnArea[AXIS_TEAM_INDEX] = Best[AXIS_TEAM_INDEX];
    CurrentSpawnArea[ALLIES_TEAM_INDEX] = Best[ALLIES_TEAM_INDEX];

    // Run this check for levelers, if they set DH_LevelInfo to use spawn areas, but don't put any on the map, we should inform them
    if (CurrentSpawnArea[AXIS_TEAM_INDEX] == none || CurrentSpawnArea[ALLIES_TEAM_INDEX] == none)
    {
        bReqsMet = false;

        foreach DynamicActors(class'ROSpawnArea', Best[0])
        {
            bReqsMet = true;
        }

        if (!bReqsMet)
        {
            Warn("No SpawnAreas found in the level when DarkestHourGame is expecting them!");
        }
    }
}

// This function is no longer used officially, but is converted to use DHObjectives just in case some map is using SpawnAreas
function CheckTankCrewSpawnAreas()
{
    local int i, j, h, k;
    local ROSpawnArea Best[2];
    local bool bReqsMet, bSomeReqsMet;

    for (i = 0; i < TankCrewSpawnAreas.Length; ++i)
    {
        if (!TankCrewSpawnAreas[i].bEnabled)
        {
            continue;
        }

        if (TankCrewSpawnAreas[i].bAxisSpawn && (Best[AXIS_TEAM_INDEX] == none || TankCrewSpawnAreas[i].AxisPrecedence > Best[AXIS_TEAM_INDEX].AxisPrecedence))
        {
            bReqsMet = true;
            bSomeReqsMet = false;

            for (j = 0; j < TankCrewSpawnAreas[i].AxisRequiredObjectives.Length; ++j)
            {
                if (!DHObjectives[TankCrewSpawnAreas[i].AxisRequiredObjectives[j]].IsAxis())
                {
                    bReqsMet = false;
                    break;
                }
            }

            // Added in conjunction with TeamMustLoseAllRequired enum in SpawnAreas
            // Allows Mappers to force all objectives to be lost/won before moving spawns, instead of just one - Ramm
            for (h = 0; h < TankCrewSpawnAreas[i].AxisRequiredObjectives.Length; ++h)
            {
                if (DHObjectives[TankCrewSpawnAreas[i].AxisRequiredObjectives[h]].IsAxis())
                {
                    bSomeReqsMet = true;
                    break;
                }
            }

            // Added in conjunction with bIncludeNeutralObjectives in SpawnAreas
            // Allows mappers to have spawns be used when objectives are neutral, not just captured
            if (TankCrewSpawnAreas[i].bIncludeNeutralObjectives)
            {
                for (k = 0; k < TankCrewSpawnAreas[i].NeutralRequiredObjectives.Length; k++)
                {
                    if (DHObjectives[TankCrewSpawnAreas[i].NeutralRequiredObjectives[k]].IsNeutral())
                    {
                        bSomeReqsMet = true;
                        break;
                    }
                }
            }

            if (bReqsMet)
            {
                Best[AXIS_TEAM_INDEX] = TankCrewSpawnAreas[i];
            }
            else if (bSomeReqsMet && TankCrewSpawnAreas[i].TeamMustLoseAllRequired == SPN_Axis)
            {
                Best[AXIS_TEAM_INDEX] = TankCrewSpawnAreas[i];
            }
        }

        if (TankCrewSpawnAreas[i].bAlliesSpawn && (Best[ALLIES_TEAM_INDEX] == none || TankCrewSpawnAreas[i].AlliesPrecedence > Best[ALLIES_TEAM_INDEX].AlliesPrecedence))
        {
            bReqsMet = true;
            bSomeReqsMet = false;

            for (j = 0; j < TankCrewSpawnAreas[i].AlliesRequiredObjectives.Length; ++j)
            {
                if (!DHObjectives[TankCrewSpawnAreas[i].AlliesRequiredObjectives[j]].IsAllies())
                {
                    bReqsMet = false;
                    break;
                }
            }

            // Added in conjunction with TeamMustLoseAllRequired enum in SpawnAreas
            // Allows Mappers to force all objectives to be lost/won before moving spawns, instead of just one - Ramm
            for (h = 0; h < TankCrewSpawnAreas[i].AlliesRequiredObjectives.Length; ++h)
            {
                if (DHObjectives[TankCrewSpawnAreas[i].AlliesRequiredObjectives[h]].IsAllies())
                {
                    bSomeReqsMet = true;
                    break;
                }
            }

            // Added in conjunction with bIncludeNeutralObjectives in SpawnAreas
            // Allows mappers to have spawns be used when objectives are neutral, not just captured
            if (TankCrewSpawnAreas[i].bIncludeNeutralObjectives)
            {
                for (k = 0; k < TankCrewSpawnAreas[i].NeutralRequiredObjectives.Length; k++)
                {
                    if (DHObjectives[TankCrewSpawnAreas[i].NeutralRequiredObjectives[k]].IsNeutral())
                    {
                        bSomeReqsMet = true;
                        break;
                    }
                }
            }

            if (bReqsMet)
            {
                Best[ALLIES_TEAM_INDEX] = TankCrewSpawnAreas[i];
            }
            else if (bSomeReqsMet && TankCrewSpawnAreas[i].TeamMustLoseAllRequired == SPN_Allies)
            {
                Best[ALLIES_TEAM_INDEX] = TankCrewSpawnAreas[i];
            }
        }
    }

    CurrentTankCrewSpawnArea[AXIS_TEAM_INDEX] = Best[AXIS_TEAM_INDEX];
    CurrentTankCrewSpawnArea[ALLIES_TEAM_INDEX] = Best[ALLIES_TEAM_INDEX];

    // Check mortar spawns areas (No longer used?)
    CheckMortarmanSpawnAreas();
}

function CheckMortarmanSpawnAreas()
{
    local DHSpawnArea Best[2];
    local bool        bReqsMet, bSomeReqsMet;
    local int         i, j, h, k;

    for (i = 0; i < DHMortarSpawnAreas.Length; ++i)
    {
        if (!DHMortarSpawnAreas[i].bEnabled)
        {
            continue;
        }

        // Axis plus: either no best or this one has higher precedence
        if (DHMortarSpawnAreas[i].bAxisSpawn && (Best[AXIS_TEAM_INDEX] == none || DHMortarSpawnAreas[i].AxisPrecedence > Best[AXIS_TEAM_INDEX].AxisPrecedence))
        {
            bReqsMet = true;
            bSomeReqsMet = false;

            for (j = 0; j < DHMortarSpawnAreas[i].AxisRequiredObjectives.Length; ++j)
            {
                if (!DHObjectives[DHMortarSpawnAreas[i].AxisRequiredObjectives[j]].IsAxis())
                {
                    bReqsMet = false;
                    break;
                }
            }

            for (h = 0; h < DHMortarSpawnAreas[i].AxisRequiredObjectives.Length; ++h)
            {
                if (DHObjectives[DHMortarSpawnAreas[i].AxisRequiredObjectives[h]].IsAxis())
                {
                    bSomeReqsMet = true;
                    break;
                }
            }

            if (DHMortarSpawnAreas[i].bIncludeNeutralObjectives)
            {
                for (k = 0; k < DHMortarSpawnAreas[i].NeutralRequiredObjectives.Length; ++k)
                {
                    if (DHObjectives[DHMortarSpawnAreas[i].NeutralRequiredObjectives[k]].IsNeutral())
                    {
                        bSomeReqsMet = true;
                        break;
                    }
                }
            }

            if (bReqsMet)
            {
                Best[AXIS_TEAM_INDEX] = DHMortarSpawnAreas[i];
            }
            else if (bSomeReqsMet && DHMortarSpawnAreas[i].TeamMustLoseAllRequired == SPN_Axis)
            {
                Best[AXIS_TEAM_INDEX] = DHMortarSpawnAreas[i];
            }
        }

        // Allies plus: either no best or this one has higher precedence
        if (DHMortarSpawnAreas[i].bAlliesSpawn && (Best[ALLIES_TEAM_INDEX] == none || DHMortarSpawnAreas[i].AlliesPrecedence > Best[ALLIES_TEAM_INDEX].AlliesPrecedence))
        {
            bReqsMet = true;
            bSomeReqsMet = false;

            for (j = 0; j < DHMortarSpawnAreas[i].AlliesRequiredObjectives.Length; ++j)
            {
                if (!DHObjectives[DHMortarSpawnAreas[i].AlliesRequiredObjectives[j]].IsAllies())
                {
                    bReqsMet = false;
                    break;
                }
            }

            // Added in conjunction with TeamMustLoseAllRequired enum in SpawnAreas
            // Allows Mappers to force all objectives to be lost/won before moving spawns, instead of just one
            for (h = 0; h < DHMortarSpawnAreas[i].AlliesRequiredObjectives.Length; ++h)
            {
                if (DHObjectives[DHMortarSpawnAreas[i].AlliesRequiredObjectives[h]].IsAllies())
                {
                    bSomeReqsMet = true;
                    break;
                }
            }

            // Added in conjunction with bIncludeNeutralObjectives in SpawnAreas
            // Allows mappers to have spawns be used when objectives are neutral, not just captured
            if (DHMortarSpawnAreas[i].bIncludeNeutralObjectives)
            {
                for (k = 0; k < DHMortarSpawnAreas[i].NeutralRequiredObjectives.Length; ++k)
                {
                    if (DHObjectives[DHMortarSpawnAreas[i].NeutralRequiredObjectives[k]].IsNeutral())
                    {
                        bSomeReqsMet = true;
                        break;
                    }
                }
            }

            if (bReqsMet)
            {
                Best[ALLIES_TEAM_INDEX] = DHMortarSpawnAreas[i];
            }
            else if (bSomeReqsMet && DHMortarSpawnAreas[i].TeamMustLoseAllRequired == SPN_Allies)
            {
                Best[ALLIES_TEAM_INDEX] = DHMortarSpawnAreas[i];
            }
        }
    }

    DHCurrentMortarSpawnArea[AXIS_TEAM_INDEX] = Best[AXIS_TEAM_INDEX];
    DHCurrentMortarSpawnArea[ALLIES_TEAM_INDEX] = Best[ALLIES_TEAM_INDEX];
}

// Modified to use more efficient DynamicActors iteration instead of AllActors (vehicle factories aren't static actors), & re-factored to generally optimise
// Do nothing if factory flagged as controlled by a DH spawn point even if bUseSpawnAreas=true (leveller may misunderstand bUseSpawnAreas & assume means spawn point)
function CheckVehicleFactories()
{
    local DHVehicleFactory VehFact;
    local int              TeamIndex;

    foreach DynamicActors(class'DHVehicleFactory', VehFact)
    {
        if (VehFact.bUsesSpawnAreas && !VehFact.bControlledBySpawnPoint)
        {
            if (class<ROVehicle>(VehFact.VehicleClass) != none)
            {
                TeamIndex = class<ROVehicle>(VehFact.VehicleClass).default.VehicleTeam;

                if ((TeamIndex == AXIS_TEAM_INDEX || TeamIndex == ALLIES_TEAM_INDEX) &&
                    ((CurrentTankCrewSpawnArea[TeamIndex] != none && CurrentTankCrewSpawnArea[TeamIndex].Tag == VehFact.Tag) ||
                    (CurrentSpawnArea[TeamIndex] != none && CurrentSpawnArea[TeamIndex].Tag == VehFact.Tag)))
                {
                    VehFact.ActivatedBySpawn(TeamIndex);
                }
                else
                {
                    VehFact.Deactivate();
                }
            }
        }
    }
}

// Modified so we only activate/deactivate resupply volumes if their status actually needs to change, based on any current spawn areas (if the level even has them)
// Note that the newer DHSpawnPoint system that replaces spawn areas does not use this, & instead the spawn point itself activates/deactivates any linked resupply
// So this override is necessary to stop CheckResupplyVolumes() functionality from screwing up the new DH functionality (& also to use the new DHResupplyAreas array)
// Do nothing if resupply flagged as controlled by a DH spawn point even if bUseSpawnAreas=true (leveller may misunderstand bUseSpawnAreas & assume means spawn point)
function CheckResupplyVolumes()
{
    local DHGameReplicationInfo GRI;
    local int  TeamIndex, i;
    local bool bShouldBeActive;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (GRI != none)
    {
        for (i = 0; i < arraycount(DHResupplyAreas); ++i)
        {
            if (DHResupplyAreas[i] != none && DHResupplyAreas[i].bUsesSpawnAreas && !DHResupplyAreas[i].bControlledBySpawnPoint)
            {
                TeamIndex = DHResupplyAreas[i].Team;

                if (TeamIndex == AXIS_TEAM_INDEX || TeamIndex == ALLIES_TEAM_INDEX)
                {
                    bShouldBeActive = CurrentSpawnArea[TeamIndex].Tag == DHResupplyAreas[i].Tag ||
                        (CurrentTankCrewSpawnArea[TeamIndex] != none && CurrentTankCrewSpawnArea[TeamIndex].Tag == DHResupplyAreas[i].Tag);

                    DHResupplyAreas[i].bActive = bShouldBeActive;
                    GRI.ResupplyAreas[i].bActive = bShouldBeActive;
                }
            }
        }
    }
}

// Modified so we only activate/deactivate mine volumes if their status actually needs to change, based on any current spawn areas (if the level even has them)
// Note that the newer DHSpawnPoint system that replaces spawn areas does not use this, & instead the spawn point itself activates/deactivates any linked MV
// DHMineVolumes may also be controlled by modify actors in the level, triggered by specified events during player
// The new MV functionality also uses an bInitiallyActive setting (subject to subsequent activation/deactivation by a spawn point or modify actor)
// So this override is necessary to stop CheckMineVolumes() functionality from screwing up the new DH functionality
function CheckMineVolumes()
{
    local int i;

    for (i = 0; i < MineVolumes.Length; ++i)
    {
        if (MineVolumes[i] != none && MineVolumes[i].bUsesSpawnAreas && MineVolumes[i].Tag != '')
        {
            if ((CurrentSpawnArea[AXIS_TEAM_INDEX] != none && CurrentSpawnArea[AXIS_TEAM_INDEX].Tag == MineVolumes[i].Tag) ||
                (CurrentTankCrewSpawnArea[AXIS_TEAM_INDEX] != none && CurrentTankCrewSpawnArea[AXIS_TEAM_INDEX].Tag == MineVolumes[i].Tag) ||
                (CurrentSpawnArea[ALLIES_TEAM_INDEX] != none && CurrentSpawnArea[ALLIES_TEAM_INDEX].Tag == MineVolumes[i].Tag) ||
                (CurrentTankCrewSpawnArea[ALLIES_TEAM_INDEX] != none && CurrentTankCrewSpawnArea[ALLIES_TEAM_INDEX].Tag == MineVolumes[i].Tag))
            {
                MineVolumes[i].Activate();
            }
            else
            {
                MineVolumes[i].Deactivate();
            }
        }
    }
}

function NotifyLogout(Controller Exiting)
{
    local DHGameReplicationInfo GRI;
    local DHPlayer PC;
    local DHPlayerReplicationInfo PRI;

    GRI = DHGameReplicationInfo(GameReplicationInfo);
    PC = DHPlayer(Exiting);

    ClearSavedRequestsAndRallyPoints(PC, false);

    if (GRI != none && PC != none)
    {
        GRI.ClearArtilleryTarget(PC);
        GRI.UnreserveVehicle(PC);

        PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

        SquadReplicationInfo.LeaveSquad(PRI);
    }

    super.Destroyed();
}

function SendReinforcementMessage(int Team, int Num)
{
    local Controller P;

    for (P = Level.ControllerList; P != none; P = P.NextController)
    {
        if (PlayerController(P) != none &&
            P.PlayerReplicationInfo.Team != none &&
            P.PlayerReplicationInfo.Team.TeamIndex == Team)
        {
            PlayerController(P).ReceiveLocalizedMessage(class'DHReinforcementMsg', Num);
        }
    }
}

// Modified to remove reliance on SpawnCount and instead just use SpawnsRemaining
function bool SpawnLimitReached(int Team)
{
    return DHGameReplicationInfo(GameReplicationInfo) != none && DHGameReplicationInfo(GameReplicationInfo).SpawnsRemaining[Team] == 0;
}

function int GetRoundTime()
{
    return Max(0, DHGameReplicationInfo(GameReplicationInfo).RoundEndTime - ElapsedTime);
}

// This function allows proper time remaining to be adjusted as desired
function ModifyRoundTime(int RoundTime, int Type)
{
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (GRI != none && self.IsInState('RoundInPlay'))
    {
        switch (Type)
        {
            case 0: //Add
                GRI.RoundEndTime += RoundTime;
                break;
            case 1: //Subtract
                GRI.RoundEndTime -= RoundTime;
                break;
            case 2: //Set
                GRI.RoundEndTime = GRI.ElapsedTime + RoundTime;
                break;
            default:
                GRI.RoundEndTime = GRI.ElapsedTime + RoundTime;
                break;
        }

        Level.Game.BroadcastLocalizedMessage(class'DH_ModifyRoundTimeMessage', Type);
    }
}

// Players change sides
function ChangeSides()
{
    local Controller P;

    // We need to disable auto team balance
    bPlayersBalanceTeams = false;

    // Cycle through controllers, for each player on a team tell them to change teams
    for (P = Level.ControllerList; P != none; P = P.NextController)
    {
        if (P.bIsPlayer && P.PlayerReplicationInfo.Team != none && P.PlayerReplicationInfo.Team.TeamIndex != 2)
        {
            ChangeTeam(P, int(!bool(P.PlayerReplicationInfo.Team.TeamIndex)), true);
            DHPlayer(P).Suicide(); // Slay players as their team has changed and it's confusing if they are still alive while round restarts
            DHPlayer(P).bWeaponsSelected = true; // The player needs to know that they have selected weapons, otherwise it takes them to the team menu
        }
    }

    // Re-enable auto team balance (if applicable)
    bPlayersBalanceTeams = default.bPlayersBalanceTeams;
}

// This will request all players to open their DeployMenu
function OpenPlayerMenus()
{
    local Controller P;
    local DHPlayer PC;

    for (P = Level.ControllerList; P != none; P = P.NextController)
    {
        PC = DHPlayer(P);

        if (PC != none && PC.bIsPlayer && PC.GetTeamNum() != 255)
        {
            PC.DeployMenuStartMode = MODE_Map;
            PC.ClientProposeMenu("DH_Interface.DHDeployMenu");
        }
    }
}

// Modified to tell client to save their ROID to their .ini file so they can easily copy it, store session data & handle metrics
// Also to remove redundant SteamStatsAndAchievements stuff that caused "accessed none" log errors (some other redundancy also removed)
// Note: on net client & SP it appears some native code is calling the Super of this event from GameInfo class, so any override here is ignored by that
event PostLogin(PlayerController NewPlayer)
{
    local class<HUD>              HudClass;
    local class<Scoreboard>       ScoreboardClass;
    local SpectatorCam            StartSpectatorCamera;
    local DHPlayerReplicationInfo PRI;
    local DHPlayer                PC;
    local Object                  O;
    local DHPlayerSession         S;
    local string                  ROIDHash;

    if (NewPlayer == none)
    {
        return;
    }

    // If we are using a GameStats actor, log the player's login
    if (GameStats != none && !bIsSaveGame && NewPlayer.PlayerReplicationInfo != none)
    {
        GameStats.ConnectEvent(NewPlayer.PlayerReplicationInfo);
        GameStats.GameEvent("NameChange", NewPlayer.PlayerReplicationInfo.PlayerName, NewPlayer.PlayerReplicationInfo);
    }

    // Tell client what HUD & scoreboard to use
    if (HUDType != "")
    {
        HudClass = class<HUD>(DynamicLoadObject(HUDType, class'Class'));
    }

    if (HudClass == none)
    {
        Log("Can't find HUD class" @ HUDType, 'Error');
    }

    if (ScoreBoardType != "")
    {
        ScoreboardClass = class<Scoreboard>(DynamicLoadObject(ScoreBoardType, class'Class'));
    }

    if (ScoreboardClass == none)
    {
        Log("Can't find scoreboard class" @ ScoreBoardType, 'Error');
    }

    NewPlayer.ClientSetHUD(HudClass, ScoreboardClass);

    // Pass server's weapon view shake setting to client
    SetWeaponViewShake(NewPlayer);

    if (bIsSaveGame)
    {
        return;
    }

    // Various updates & notifications
    if (NewPlayer.Pawn != none)
    {
        NewPlayer.Pawn.ClientSetRotation(NewPlayer.Pawn.Rotation);
    }

    if (VotingHandler != none)
    {
        VotingHandler.PlayerJoin(NewPlayer);
    }

    if (AccessControl != none)
    {
        NewPlayer.LoginDelay = AccessControl.LoginDelaySeconds;
    }

    if (NewPlayer.Player != none)
    {
        NewPlayer.ClientCapBandwidth(NewPlayer.Player.CurrentNetSpeed);
    }

    if (NewPlayer.PlayerReplicationInfo != none)
    {
        NotifyLogin(NewPlayer.PlayerReplicationInfo.PlayerID);
        Log("New Player" @ NewPlayer.PlayerReplicationInfo.PlayerName @ " ID =" @ NewPlayer.GetPlayerIDHash());

        if (NewPlayer.PlayerReplicationInfo.Team != none)
        {
            GameEvent("TeamChange", "" $ NewPlayer.PlayerReplicationInfo.Team.TeamIndex, NewPlayer.PlayerReplicationInfo);
        }
    }

    // Find & set player's starting view location based on level's start spectator camera
    if (NewPlayer.Pawn == none && LevelInfo != none && LevelInfo.StartCamTag != '' && Role == ROLE_Authority)
    {
        foreach AllActors(class'SpectatorCam', StartSpectatorCamera, LevelInfo.StartCamTag)
        {
            break;
        }

        if (StartSpectatorCamera != none)
        {
            NewPlayer.SetLocation(StartSpectatorCamera.Location);
            NewPlayer.ClientSetLocation(StartSpectatorCamera.Location, StartSpectatorCamera.Rotation);
        }
    }

    // Set player's spectator properties, copied from the GameInfo's properties
    // Server Admins please use the desired settings for public play, overriding may result in further steps to enforce these settings on your server
    if (bPublicPlay)
    {
        NewPlayer.bLockedBehindView = true;
        NewPlayer.bFirstPersonSpectateOnly = true;
        NewPlayer.bAllowRoamWhileSpectating = true;
        NewPlayer.bViewBlackWhenDead = false;
        NewPlayer.bViewBlackOnDeadNotViewingPlayers = true;
        NewPlayer.bAllowRoamWhileDeadSpectating = false;
    }
    else
    {
        NewPlayer.bLockedBehindView = bSpectateLockedBehindView;
        NewPlayer.bFirstPersonSpectateOnly = bSpectateFirstPersonOnly;
        NewPlayer.bAllowRoamWhileSpectating = bSpectateAllowRoaming;
        NewPlayer.bViewBlackWhenDead = bSpectateBlackoutWhenDead;
        NewPlayer.bViewBlackOnDeadNotViewingPlayers = bSpectateBlackoutWhenNotViewingPlayers;
        NewPlayer.bAllowRoamWhileDeadSpectating = bSpectateAllowDeadRoaming;
    }

    PC = DHPlayer(NewPlayer);

    if (PC != none)
    {
        PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
    }

    if (PRI == none)
    {
        return;
    }

    // Set up the player in the DH metrics recording actor
    if (Metrics != none)
    {
        Metrics.OnPlayerLogin(PC);
    }

    ROIDHash = PC.GetPlayerIDHash();

    if (ROIDHash != "")
    {
        // Record player's ROID on server & his client
        if (Level.NetMode == NM_DedicatedServer)
        {
            PC.ROIDHash = ROIDHash;          // server (important)
            PC.ClientSaveROIDHash(ROIDHash); // client (nice thing for client)
        }

        // If player has been on server before during this round, restore his game status from his player session record
        if (PlayerSessions != none && PlayerSessions.Get(ROIDHash, O))
        {
            S = DHPlayerSession(O);

            if (S != none)
            {
                PRI.Deaths = S.Deaths;
                PRI.Kills = S.Kills;
                PRI.Score = S.Score;

                Teams[S.TeamIndex].AddToTeam(PC);

                PC.LastKilledTime = S.LastKilledTime;
                PC.WeaponLockViolations = S.WeaponLockViolations;
                PC.DeathPenaltyCount = S.DeathPenaltyCount;
                PC.NextChangeTeamTime = S.NextChangeTeamTime;

                if (GameReplicationInfo != none && S.WeaponUnlockTime > GameReplicationInfo.ElapsedTime)
                {
                    PC.LockWeapons(S.WeaponUnlockTime - GameReplicationInfo.ElapsedTime);
                }
            }
        }

        // Patron status look-up
        PRI.bIsPatron = IsPatron(ROIDHash);
    }
}

// Override to leave hash and info in PlayerData, basically to save PRI data for the session
function Logout(Controller Exiting)
{
    local DHPlayer PC;
    local DHPlayerReplicationInfo PRI;
    local Object O;
    local DHPlayerSession S;

    super.Logout(Exiting);

    PC = DHPlayer(Exiting);

    if (PC == none)
    {
        return;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    if (PRI == none)
    {
        return;
    }

    if (PC.ROIDHash != "" && !PlayerSessions.Get(PC.ROIDHash, O))
    {
        O = new class'DHPlayerSession';
        PlayerSessions.Put(PC.ROIDHash, O);
    }

    S = DHPlayerSession(O);

    if (S != none)
    {
        S.Deaths = PRI.Deaths;
        S.Kills = PRI.Kills;
        S.Score = PRI.Score; // No need to add StashedScore here, because it is done on the pawn's death (which it does die)
        S.LastKilledTime = PC.LastKilledTime;
        S.WeaponUnlockTime = PC.WeaponUnlockTime;
        S.WeaponLockViolations = PC.WeaponLockViolations;
        S.DeathPenaltyCount = PC.DeathPenaltyCount;
        S.NextChangeTeamTime = PC.NextChangeTeamTime;

        if (PRI.Team != none)
        {
            S.TeamIndex = PRI.Team.TeamIndex;
        }
    }
}

function int GetNumObjectives()
{
    local int i;
    local int Count;

    for (i = 0; i < arraycount(DHObjectives); ++i)
    {
        if (DHObjectives[i] != none)
        {
            ++Count;
        }
    }

    return count;
}

function BroadcastSquad(Controller Sender, coerce string Msg, optional name Type)
{
    local DHBroadcastHandler BH;

    BH = DHBroadcastHandler(BroadcastHandler);

    if (BH != none)
    {
        BH.BroadcastSquad(Sender, Msg, Type);
    }
}

function Pawn SpawnPawn(DHPlayer C, vector SpawnLocation, rotator SpawnRotation, DHSpawnPointBase SP)
{
    if (C == none)
    {
        return none;
    }

    if (C.PreviousPawnClass != none && C.PawnClass != C.PreviousPawnClass)
    {
        BaseMutator.PlayerChangedClass(C);
    }

    // Spawn player pawn
    if (C.PawnClass != none)
    {
        C.Pawn = Spawn(C.PawnClass,,, SpawnLocation, SpawnRotation);
    }

    // If spawn failed, try again using default player class
    if (C.Pawn == none)
    {
        C.Pawn = Spawn(GetDefaultPlayerClass(C),,, SpawnLocation, SpawnRotation);
    }

    // Hard spawning the player at the spawn location failed, most likely because spawn function was blocked
    // Try again with black room spawn & teleport them to spawn location
    if (C.Pawn == none)
    {
        DeployRestartPlayer(C, false, true);

        if (C.Pawn != none)
        {
            if (C.TeleportPlayer(SpawnLocation, SpawnRotation))
            {
                return C.Pawn; // exit as we used old spawn system & don't need to do anything else in this function
            }
            else
            {
                C.Pawn.Suicide(); // teleport failed & pawn is still in the black room, so kill it
            }
        }
    }

    // Still haven't managed to spawn a player pawn, so go to state 'Dead' & exit
    if (C.Pawn == none)
    {
        C.GotoState('Dead');
        C.ClientGotoState('Dead', 'Begin');

        return none;
    }

    // We have a new player pawn, so handle the necessary set up & possession
    C.TimeMargin = -0.1;

    C.Pawn.LastStartTime = Level.TimeSeconds;
    C.PreviousPawnClass = C.Pawn.Class;
    C.Possess(C.Pawn);
    C.PawnClass = C.Pawn.Class;
    C.Pawn.PlayTeleportEffect(true, true);
    C.ClientSetRotation(C.Pawn.Rotation);

    // Set proper spawn kill protection times
    if (DHPawn(C.Pawn) != none && SP != none)
    {
        DHPawn(C.Pawn).SpawnProtEnds = Level.TimeSeconds + SP.SpawnProtectionTime;
        DHPawn(C.Pawn).SpawnKillTimeEnds = Level.TimeSeconds + SP.SpawnKillProtectionTime;
        DHPawn(C.Pawn).SpawnPoint = SP;
    }

    AddDefaultInventory(C.Pawn);

    return C.Pawn;
}

// Modified so a silent admin can also pause a game when bAdminCanPause is true
function bool SetPause(bool bPause, PlayerController P)
{
    if (P != none && (Level.Netmode == NM_Standalone || (bAdminCanPause && (IsAdmin(P) || P.IsA('Admin'))) || bPauseable))
    {
        if (bPause)
        {
            Level.Pauser = P.PlayerReplicationInfo;
        }
        else
        {
            Level.Pauser = none;
        }

        return true;
    }

    return false;
}

// Overridden to undo the exclusion of players who hadn't yet selected a role.
function GetTeamSizes(out int TeamSizes[2])
{
    if (DHGameReplicationInfo(GameReplicationInfo) != none)
    {
        DHGameReplicationInfo(GameReplicationInfo).GetTeamSizes(TeamSizes);
    }
}

defaultproperties
{
    ServerTickForInflation=20.0

    // Default settings based on common used server settings in DH
    bIgnore32PlayerLimit=true // allows more than 32 players
    bVACSecured=true

    ElapsedTimeAttritionCurve=(Points=((InVal=0.0,OutVal=0.0),(InVal=3600.0,OutVal=0.0),(InVal=7200.0,OutVal=500.0),(InVal=10800.0,OutVal=1000.0)))

    bSessionKickOnSecondFFViolation=true
    FFDamageLimit=0       // this stops the FF damage system from kicking based on FF damage
    FFKillLimit=4         // new default of 4 unforgiven FF kills before punishment
    FFArtyScale=0.5       // makes it so arty FF kills count as .5
    FFExplosivesScale=0.5 // make it so other explosive FF kills count as .5

    WinLimit=1 // 1 round per map, server admins are able to customize win/rounds to the level in webadmin
    RoundLimit=1

    MaxTeamDifference=2
    bAutoBalanceTeamsOnDeath=true // if teams become imbalanced it'll force the next player to die to the weaker team
    MaxIdleTime=300

    bShowServerIPOnScoreboard=true
    bShowTimeOnScoreboard=true

    EmptyTankUnlockTime=60

    // Strings/hints
    ROHints(1)="You can 'cook' a Mk II grenade by pressing %FIRE3% while holding the grenade back."
    ROHints(13)="You cannot change the 30 Cal barrel, be careful not to overheat!"
    ROHints(17)="Once you've fired the Bazooka or Panzerschreck get to fresh cover FAST, as the smoke of your backblast will reveal your location. Return fire will almost certainly follow!"
    ROHints(18)="Do not stand directly behind rocket weapons when they're firing; you can sustain serious injury from the exhaust!"
    ROHints(19)="AT soldiers should always take a friend with them for ammo supplies, faster reloads and protection."
    ROHints(20)="AT weapons will be automatically unloaded if you change to another weapon. It is a good idea to stick with a teammate to speed up reloading when needed."
    RussianNames(0)="Colin Basnett"
    RussianNames(1)="Graham Merrit"
    RussianNames(2)="Ian Campbell"
    RussianNames(3)="Eric Parris"
    RussianNames(4)="Tom McDaniel"
    RussianNames(5)="Sam Cousins"
    RussianNames(6)="Jeff Duquette"
    RussianNames(7)="Chris Young"
    RussianNames(8)="Kenneth Kjeldsen"
    RussianNames(9)="John Wayne"
    RussianNames(10)="Clint Eastwood"
    RussianNames(11)="Tom Hanks"
    RussianNames(12)="Leroy Jenkins"
    RussianNames(13)="Telly Savalas"
    RussianNames(14)="Audie Murphy"
    RussianNames(15)="George Baker"
    GermanNames(0)="G�nther Liebing"
    GermanNames(1)="Heinz Werner"
    GermanNames(2)="Rudolf Giesler"
    GermanNames(3)="Seigfried Hauber"
    GermanNames(4)="Gustav Beier"
    GermanNames(5)="Joseph Peitsch"
    GermanNames(6)="Willi Eiken"
    GermanNames(7)="Wolfgang Steyer"
    GermanNames(8)="Rolf Steiner"
    GermanNames(9)="Anton M�ller"
    GermanNames(10)="Klaus Triebig"
    GermanNames(11)="Hans Gr�schke"
    GermanNames(12)="Wilhelm Kr�ger"
    GermanNames(13)="Herrmann Dietrich"
    GermanNames(14)="Erich Klein"
    GermanNames(15)="Horst Altmann"
    Acronym="DH"
    MapPrefix="DH"
    BeaconName="DH"
    GameName="DarkestHourGame"

    // Class references
    AccessControlClass="DH_Engine.DHAccessControl"
    LoginMenuClass="DH_Interface.DHPlayerSetupPage"
    DefaultPlayerClassName="DH_Engine.DHPawn"
    ScoreBoardType="DH_Interface.DHScoreBoard"
    HUDType="DH_Engine.DHHud"
    MapListType="DH_Engine.DHMapList"
    BroadcastHandlerClass="DH_Engine.DHBroadcastHandler"
    PlayerControllerClassName="DH_Engine.DHPlayer"
    GameReplicationInfoClass=class'DH_Engine.DHGameReplicationInfo'
    VoiceReplicationInfoClass=class'DH_Engine.DHVoiceReplicationInfo'
    VotingHandlerClass=class'DH_Engine.DHVotingHandler'
    DecoTextName="DH_Engine.DarkestHourGame"
    ObstacleManagerClass=class'DH_Engine.DHObstacleManager'
    DeathMessageClass=class'DH_Engine.DHDeathMessage'
    GameMessageClass=class'DH_Engine.DHGameMessage'
    TeamAIType(0)=class'DH_Engine.DHTeamAI'
    TeamAIType(1)=class'DH_Engine.DHTeamAI'

    ChangeTeamInterval=120

    ReinforcementMessagePercentages(0)=0.5
    ReinforcementMessagePercentages(1)=0.25
    ReinforcementMessagePercentages(2)=0.1
    ReinforcementMessagePercentages(3)=0.0

    Begin Object Class=UVersion Name=VersionObject
        Major=8
        Minor=0
        Patch=0
        Prerelease="alpha"
    End Object
    Version=VersionObject

    MetricsClass=class'DHMetrics'
    bEnableMetrics=false
    bUseWeaponLocking=true
    bUseReinforcementWarning=true
    bTimeChangesAtZeroReinf=true
    bPublicPlay=true

    WeaponLockTimeSecondsInterval=5
    WeaponLockTimeSecondsMaximum=120
}
