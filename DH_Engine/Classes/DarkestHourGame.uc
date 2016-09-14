//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DarkestHourGame extends ROTeamGame;

// When a player leaves the server this info is stored for the session so if they return these values won't reset
var     Hashtable_string_Object     PlayerSessions;

var     DH_LevelInfo                DHLevelInfo;

var     DHAmmoResupplyVolume        DHResupplyAreas[10];

var     array<DHSpawnArea>          DHMortarSpawnAreas;
var     DHSpawnArea                 DHCurrentMortarSpawnArea[2];

const   OBJECTIVES_MAX = 32;
var     DHObjective                 DHObjectives[OBJECTIVES_MAX];

var     DHSpawnManager              SpawnManager;
var     DHObstacleManager           ObstacleManager;

var     array<string>               FFViolationIDs;                         // Array of ROIDs that have been kicked once this session
var()   config bool                 bSessionKickOnSecondFFViolation;
var()   config bool                 bUseWeaponLocking;                      // Weapons can lock (preventing fire) for punishment
var     int                         WeaponLockTimes[6];

var     class<DHObstacleManager>    ObstacleManagerClass;

var     float                       ChangeTeamInterval;

var     array<float>                ReinforcementMessagePercentages;
var     int                         TeamReinforcementMessageIndices[2];
var     int                         bTeamOutOfReinforcements[2];

const SERVERTICKRATE_UPDATETIME =   5.0; // The duration we use to calculate the average tick the server is running
const MAXINFLATED_INTERVALTIME =    60.0; // The max value to add to reinforcement time for inflation
const SPAWN_KILL_RESPAWN_TIME =     2;

var()   config float                ServerTickForInflation;                 // Value that determines when inflation will start if ServerTickRateAverage is less than
var     float                       ServerTickRateAverage;                  // The average tick rate over the past SERVERTICKRATE_UPDATETIME
var     float                       ServerTickRateConsolidated;             // Keeps track of tick rates over time, used to calculate average
var     int                         ServerTickFrameCount;                   // Keeps track of how many frames are between ServerTickRateConsolidated

var     float                       TeamAttritionCounter[2];

var     array<int>                  AttritionObjOrder;                      // Order of objectives that were randomly opened

var     bool                        bSwapTeams;

var     float                       AlliesToAxisRatio;

var     class<DHMetrics>            MetricsClass;
var     DHMetrics                   Metrics;
var     config bool                 bEnableMetrics;

var     UVersion                    Version;

// Overridden to make new clamp of MaxPlayers
event InitGame(string Options, out string Error)
{
    super.InitGame(Options, Error);

    if (bIgnore32PlayerLimit)
    {
        MaxPlayers = Clamp(GetIntOption(Options, "MaxPlayers", MaxPlayers), 0, 64);
        default.MaxPlayers = Clamp(default.MaxPlayers, 0, 64);
    }
}

function PostBeginPlay()
{
    local DHGameReplicationInfo GRI;
    local DH_LevelInfo          DLI;
    local ROLevelInfo           LI;
    local ROMapBoundsNE         NE;
    local ROMapBoundsSW         SW;
    local DHSpawnArea           DHSA;
    local DHAmmoResupplyVolume  ARV;
    local ROMineVolume          MV;
    local ROArtilleryTrigger    RAT;
    local SpectatorCam          ViewPoint;
    local int                   i, j, k, m, n, o, p;
    local DHObstacleInfo        DHOI;

    // Don't call the RO super because we already do everything for DH and don't
    // want levels using ROLevelInfo
    super(TeamGame).PostBeginPlay();

    Level.bKickLiveIdlers = MaxIdleTime > 0.0;

    // Find the ROLevelInfo
    foreach AllActors(class'ROLevelInfo', LI)
    {
        if (LevelInfo == none)
        {
            LevelInfo = LI;
        }
        else
        {
            Log("DarkestHourGame: More than one ROLevelInfo detected!");
            break;
        }
    }

    // Find the DH_LevelInfo
    foreach AllActors(class'DH_LevelInfo', DLI)
    {
        if (DHLevelInfo != none)
        {
            Log("DarkestHourGame: More than one DH_LevelInfo detected!");
            break;
        }

        DHLevelInfo = DLI;
    }

    foreach AllActors(class'DHObstacleInfo', DHOI)
    {
        ObstacleManager = Spawn(ObstacleManagerClass);
        break;
    }

    // Darkest Hour Game Check
    // Prevents ROLevelInfo from working with DH levels
    if (LevelInfo == none || !LevelInfo.IsA('DH_LevelInfo'))
    {
        Warn("DarkestHourGame: No DH_LevelInfo detected!");
        Warn("Level may not be using DH_LevelInfo and needs to be!");

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
    AlliesToAxisRatio = DH_LevelInfo(LevelInfo).AlliesToAxisRatio;

    // Setup some GRI stuff
    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (GRI == none)
    {
        return;
    }

    // Setup game type variables
    switch (DHLevelInfo.GameType)
    {
        case GT_Push:
            GRI.CurrentGameType = "Push";
            break;

        case GT_Attrition:
            GRI.CurrentGameType = "Attrition";
            break;

        case GT_Advance:
            GRI.CurrentGameType = "Advance";
            GRI.bUseDeathPenaltyCount = true;
            break;

        case GT_SearchAndDestroy:
            GRI.CurrentGameType = "SearchAndDestroy";
            break;

        default:
            // do nothing
        break;
    }

    // General game type settings
    GRI.bAllowNetDebug = bAllowNetDebug;
    GRI.PreStartTime = PreStartTime;
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
        GRI.AlliedHelpRequests[k].requestType = 255;
        GRI.AxisHelpRequests[k].OfficerPRI = none;
        GRI.AxisHelpRequests[k].requestType = 255;
    }

    ResetMortarTargets();

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
        if (RAT.TeamCanUse == AT_Axis || RAT.TeamCanUse == AT_Both)
        {
            GRI.AxisRadios[i] = RAT;
            ++i;
        }

        if (RAT.TeamCanUse == AT_Allies || RAT.TeamCanUse == AT_Both)
        {
            GRI.AlliedRadios[j] = RAT;
            ++j;
        }
    }

    foreach AllActors(class'DHAmmoResupplyVolume', ARV)
    {
        DHResupplyAreas[m] = ARV;
        GRI.ResupplyAreas[m].ResupplyVolumeLocation = ARV.Location;
        GRI.ResupplyAreas[m].Team = ARV.Team;
        GRI.ResupplyAreas[m].bActive = !ARV.bUsesSpawnAreas;

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

    // Here we see if the victory music is set to a sound group and pick an index to replicate to the clients
    if (DHLevelInfo.AlliesWinsMusic != none && DHLevelInfo.AlliesWinsMusic.IsA('SoundGroup'))
    {
        GRI.AlliesVictoryMusicIndex = Rand(SoundGroup(DHLevelInfo.AlliesWinsMusic).Sounds.Length - 1);
    }

    if (DHLevelInfo.AxisWinsMusic != none && DHLevelInfo.AxisWinsMusic.IsA('SoundGroup'))
    {
        GRI.AxisVictoryMusicIndex = Rand(SoundGroup(DHLevelInfo.AxisWinsMusic).Sounds.Length - 1);
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

// Raises the reinforcement interval used in the level if the server is performing poorly, otherwise it sets it to default
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

function CheckResupplyVolumes()
{
    local DHGameReplicationInfo GRI;
    local int i;

    // Activate any resupply areas that are activated based on spawn areas
    GRI = DHGameReplicationInfo(GameReplicationInfo);

    for (i = 0; i < arraycount(DHResupplyAreas); ++i)
    {
        if (DHResupplyAreas[i] == none)
        {
            continue;
        }

        if (DHResupplyAreas[i].bUsesSpawnAreas)
        {
            if (DHResupplyAreas[i].Team == AXIS_TEAM_INDEX)
            {
                if ((CurrentTankCrewSpawnArea[AXIS_TEAM_INDEX] != none && CurrentTankCrewSpawnArea[AXIS_TEAM_INDEX].Tag == DHResupplyAreas[i].Tag)
                    || CurrentSpawnArea[AXIS_TEAM_INDEX].Tag == DHResupplyAreas[i].Tag)
                {
                    GRI.ResupplyAreas[i].bActive = true;
                    DHResupplyAreas[i].bActive = true;
                }
                else
                {
                    GRI.ResupplyAreas[i].bActive = false;
                    DHResupplyAreas[i].bActive = false;
                }
            }

            if (DHResupplyAreas[i].Team == ALLIES_TEAM_INDEX)
            {
                if ((CurrentTankCrewSpawnArea[ALLIES_TEAM_INDEX] != none && CurrentTankCrewSpawnArea[ALLIES_TEAM_INDEX].Tag == DHResupplyAreas[i].Tag)
                    || CurrentSpawnArea[ALLIES_TEAM_INDEX].Tag == DHResupplyAreas[i].Tag)
                {
                    GRI.ResupplyAreas[i].bActive = true;
                    DHResupplyAreas[i].bActive = true;
                }
                else
                {
                    GRI.ResupplyAreas[i].bActive = false;
                    DHResupplyAreas[i].bActive = false;
                }
            }
        }
        else
        {
            GRI.ResupplyAreas[i].bActive = true;
            DHResupplyAreas[i].bActive = true;
        }
    }
}

// Modified to use more efficient DynamicActors iteration instead of AllActors (vehicle factories aren't static actors), & re-factored to generally optimise
function CheckVehicleFactories()
{
    local ROVehicleFactory VehFact;
    local int              TeamIndex;

    foreach DynamicActors(class'ROVehicleFactory', VehFact)
    {
        if (VehFact.bUsesSpawnAreas)
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
                if (DHObjectives[DHMortarSpawnAreas[i].AxisRequiredObjectives[j]].ObjState != OBJ_Axis)
                {
                    bReqsMet = false;
                    break;
                }
            }

            for (h = 0; h < DHMortarSpawnAreas[i].AxisRequiredObjectives.Length; ++h)
            {
                if (DHObjectives[DHMortarSpawnAreas[i].AxisRequiredObjectives[h]].ObjState == OBJ_Axis)
                {
                    bSomeReqsMet = true;
                    break;
                }
            }

            if (DHMortarSpawnAreas[i].bIncludeNeutralObjectives)
            {
                for (k = 0; k < DHMortarSpawnAreas[i].NeutralRequiredObjectives.Length; ++k)
                {
                    if (DHObjectives[DHMortarSpawnAreas[i].NeutralRequiredObjectives[k]].ObjState == OBJ_Neutral)
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
                if (DHObjectives[DHMortarSpawnAreas[i].AlliesRequiredObjectives[j]].ObjState != OBJ_Allies)
                {
                    bReqsMet = false;
                    break;
                }
            }

            // Added in conjunction with TeamMustLoseAllRequired enum in SpawnAreas
            // Allows Mappers to force all objectives to be lost/won before moving spawns, instead of just one
            for (h = 0; h < DHMortarSpawnAreas[i].AlliesRequiredObjectives.Length; ++h)
            {
                if (DHObjectives[DHMortarSpawnAreas[i].AlliesRequiredObjectives[h]].ObjState == OBJ_Allies)
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
                    if (DHObjectives[DHMortarSpawnAreas[i].NeutralRequiredObjectives[k]].ObjState == OBJ_Neutral)
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

function float RatePlayerStart(NavigationPoint N, byte Team, Controller Player)
{
    local PlayerStart P;
    local DHRoleInfo DHRI;
    local float       Score, NextDist;
    local Controller  OtherPlayer;

    P = PlayerStart(N);

    if (P == none || Player == none)
    {
        return -10000000.0;
    }

    DHRI = DHRoleInfo(DHPlayerReplicationInfo(Player.PlayerReplicationInfo).RoleInfo);

    if (LevelInfo.bUseSpawnAreas && CurrentSpawnArea[Team] != none)
    {
        if (CurrentTankCrewSpawnArea[Team]!= none && Player != none && DHRI.bCanBeTankCrew)
        {
            if (P.Tag != CurrentTankCrewSpawnArea[Team].Tag)
            {
                return -9000000.0;
            }
        }

        // Mortar spawn addition - Colin Basnett, 2010
        else if (DHCurrentMortarSpawnArea[Team] != none && Player != none && DHRI != none && DHRI.bCanUseMortars)
        {
            if (P.Tag != DHCurrentMortarSpawnArea[Team].Tag)
            {
                return -9000000.0;
            }
        }
        else
        {
            if (P.Tag != CurrentSpawnArea[Team].Tag)
            {
                return -9000000.0;
            }
        }
    }
    else if (Team != P.TeamNumber)
    {
        return -9000000.0;
    }

    P = PlayerStart(N);

    if (P == none || !P.bEnabled || P.PhysicsVolume.bWaterVolume)
    {
        return -10000000.0;
    }

    // Assess candidate
    if (P.bPrimaryStart)
    {
        Score = 10000000.0;
    }
    else
    {
        Score = 5000000.0;
    }

    if (N == LastStartSpot || N == LastPlayerStartSpot)
    {
        Score -= 10000.0;
    }
    else
    {
        Score += 3000.0 * FRand(); // randomize
    }

    for (OtherPlayer = Level.ControllerList; OtherPlayer != none; OtherPlayer = OtherPlayer.NextController)
    {
        if (OtherPlayer.bIsPlayer && (OtherPlayer.Pawn != none))
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
    local int SmallTeam, BigTeam;

    local int TeamSizes[2];
    local int IdealTeamSizes[2];
    local float TeamSizeRatings[2];

    if (bPlayersVsBots && (Level.NetMode != NM_Standalone))
    {
        if (PlayerController(C) != None)
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

    if (NewTeam == None)
    {
        NewTeam = Teams[SmallTeam];
    }
    else if (bPlayersBalanceTeams && (Level.NetMode != NM_Standalone) && (PlayerController(C) != None))
    {
        // If the teams are on the verge of being off balance, force the player onto the small team
        if ((Abs(IdealTeamSizes[0] - TeamSizes[0]) >=  MaxTeamDifference) || (Abs(IdealTeamSizes[1] - TeamSizes[1]) >=  MaxTeamDifference))
        {
            NewTeam = Teams[SmallTeam];
        }
    }

    return NewTeam.TeamIndex;
}

// Handles calculation of team balance variables (in seperate function so this code isn't duplicated in a couple places)
function CalculateTeamBalanceValues(out int TeamSizes[2], out int IdealTeamSizes[2], out float TeamSizeRatings[2])
{
    local float TeamRatios[2];
    local float TeamSizeFactor;

    // Do some integral checks
    if (DH_LevelInfo(LevelInfo) == none)
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
    if (DH_LevelInfo(LevelInfo).bHardTeamRatio)
    {
        TeamRatios[0] = 1.0 - AlliesToAxisRatio;
        TeamRatios[1] = AlliesToAxisRatio;
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
        Killer.PlayerReplicationInfo.Score -= Points;
    }
    else
    {
        Killer.PlayerReplicationInfo.Score += Points;
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
        Dropper.PlayerReplicationInfo.Score += ResupplyAward;

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
        Dropper.PlayerReplicationInfo.Score += ResupplyAward;

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
        Loader.PlayerReplicationInfo.Score += LoadAward;

        ScoreEvent(Loader.PlayerReplicationInfo, LoadAward, "AT_reload");
    }
}

// Give player a point for resupplying an MG gunner
function ScoreRadioUsed(Controller Radioman)
{
    local int RadioUsedAward;

    if (DHPlayerReplicationInfo(Radioman.PlayerReplicationInfo) != none && DHPlayerReplicationInfo(Radioman.PlayerReplicationInfo).RoleInfo != none)
    {
        RadioUsedAward = 5;
        Radioman.PlayerReplicationInfo.Score += RadioUsedAward;

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

    Dropper.PlayerReplicationInfo.Score += 2;
    ScoreEvent(Dropper.PlayerReplicationInfo, ResupplyAward, "Mortar_resupply");
}

// Give spotter a point or two for spotting a kill
function ScoreMortarSpotAssist(Controller Spotter, Controller Mortarman)
{
    if (Spotter == none || Spotter == Mortarman || Spotter.PlayerReplicationInfo == none || Mortarman == none || Mortarman.PlayerReplicationInfo == none)
    {
        return;
    }

    Spotter.PlayerReplicationInfo.Score += 2;
    Mortarman.PlayerReplicationInfo.Score += 1;
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
        if (DHPlayer(InstigatedBy.Controller) != none && DHPlayer(InstigatedBy.Controller).IsWeaponLocked())
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

event PlayerController Login(string Portal, string Options, out string Error)
{
    local string InName;
    local PlayerController NewPlayer;

    // Stop the game from automatically trimming longer names
    InName = Left(ParseOption(Options, "Name"), 32);

    NewPlayer = super.Login(Portal, Options, Error);

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

    GRI = DHGameReplicationInfo(GameReplicationInfo);

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
                GRI.ClearMortarTarget(DHPlayer(aPlayer));
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
    local Controller        P;
    local DHPlayer          DHP;
    local DHPawn            KPawn;
    local float             FFPenalty;
    local int               Num, i;

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

        if (KilledPawn != none)
        {
            KPawn = DHPawn(KilledPawn);
            DHP = DHPlayer(Killer);
        }

        // If this was a spawn kill, handle the rules for spawn kill and adjust damage type
        // Suiciding will not count as a Spawn Kill, did this because suiciding after a combat spawn will not act the same way, and thus is not intuitive
        if (DHP != none && KPawn != none && KPawn.IsSpawnKillProtected() && Killer != Killed && DHPlayer(Killed) != none)
        {
            // Inform the victim's DHPlayer that it was spawn killed
            DHPlayer(Killed).bSpawnedKilled = true;

            // Increase infantry reinforcements for victim's team (only if nonzero)
            ModifyReinforcements(Killed.GetTeamNum(), 1, false, true);

            // Change the damage type because this was a spawn kill and we want to signify that
            DamageType = class'DHSpawnKillDamageType';

            // Punish instigator for spawn killing (lock weapons)
            DHP.WeaponLockViolations++;
            DHP.LockWeapons(WeaponLockTimes[Min(DHP.WeaponLockViolations, arraycount(WeaponLockTimes))]);

            // Punish instigator for spawn killing (reduce score)
            DHP.PlayerReplicationInfo.Score -= 2;

            // Allow the player to spawn a vehicle right away
            DHP.NextVehicleSpawnTime = DHP.LastKilledTime + SPAWN_KILL_RESPAWN_TIME;
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
                    else if (class<ROGrenadeDamType>(DamageType) != none || class<ROSatchelDamType>(DamageType) != none || class<ROTankShellExplosionDamage>(DamageType) != none)
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

    // Check whether we need to end the round because neither team has any reinforcements left
    for (i = 0; i < 2; ++i)
    {
        if (SpawnLimitReached(i))
        {
            Num = 0;

            for (P = Level.ControllerList; P != none; P = P.NextController)
            {
                if (P.bIsPlayer && P.Pawn != none && P.Pawn.Health > 0 && P.PlayerReplicationInfo.Team.TeamIndex == i)
                {
                    ++Num;
                }
            }

            if (Num == 0)
            {
                EndRound(int(!bool(i))); // it looks like a hack, but hey, it's the easiest way to find the opposite team :)
            }
        }
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
    local int i;
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (TeamID == 0)
    {
        for (i = 0; i < arraycount(GRI.DHAxisRoles); ++i)
        {
            if (GRI.DHAxisRoles[i] == RI)
            {
                return true;
            }
        }
    }
    else if (TeamID == 1)
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

        // Noticing no cast/ref checks here :P

        // Reset all round properties
        RoundStartTime = ElapsedTime;
        GRI = DHGameReplicationInfo(GameReplicationInfo);
        GRI.RoundStartTime = RoundStartTime;
        GRI.RoundEndTime = RoundStartTime + RoundDuration;

        GRI.AttritionRate[AXIS_TEAM_INDEX] = 0;
        GRI.AttritionRate[ALLIES_TEAM_INDEX] = 0;

        TeamAttritionCounter[AXIS_TEAM_INDEX] = 0;
        TeamAttritionCounter[ALLIES_TEAM_INDEX] = 0;

        AttritionObjOrder.Length = 0;

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
            GRI.AlliedHelpRequests[i].requestType = 255;
            GRI.AxisHelpRequests[i].OfficerPRI = none;
            GRI.AxisHelpRequests[i].requestType = 255;
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

        ResetMortarTargets();

        GRI.SpawnsRemaining[ALLIES_TEAM_INDEX] = LevelInfo.Allies.SpawnLimit;
        GRI.SpawnsRemaining[AXIS_TEAM_INDEX] = LevelInfo.Axis.SpawnLimit;

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

        // Activate attrition objectives
        if (DHLevelInfo.GameType == GT_Attrition)
        {
            AttritionSelectObjectiveOrder();

            for (i = 0; i < DHLevelInfo.AttritionMaxOpenObj; ++i)
            {
                AttritionUnlockObjective();
            }
        }

    }

    // Modified for DHObjectives
    function NotifyObjStateChanged()
    {
        local DHGameReplicationInfo GRI;
        local int i, Num[2], NumReq[2], NumObj, NumObjReq;

        for (i = 0; i < arraycount(DHObjectives); ++i)
        {
            if (DHObjectives[i] == none)
            {
                break;
            }
            else if (DHObjectives[i].ObjState == OBJ_Axis)
            {
                Num[AXIS_TEAM_INDEX]++;

                if (DHObjectives[i].bRequired)
                {
                    NumReq[AXIS_TEAM_INDEX]++;
                }
            }
            else if (DHObjectives[i].ObjState == OBJ_Allies)
            {
                Num[ALLIES_TEAM_INDEX]++;

                if (DHObjectives[i].bRequired)
                {
                    NumReq[ALLIES_TEAM_INDEX]++;
                }
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
            // Calculate attrition rates
            GRI.AttritionRate[ALLIES_TEAM_INDEX] = InterpCurveEval(DHLevelInfo.AttritionRateCurve, (float(Max(0, Num[AXIS_TEAM_INDEX]   - Num[ALLIES_TEAM_INDEX])) / NumObj)) / 60.0;
            GRI.AttritionRate[AXIS_TEAM_INDEX]   = InterpCurveEval(DHLevelInfo.AttritionRateCurve, (float(Max(0, Num[ALLIES_TEAM_INDEX] - Num[AXIS_TEAM_INDEX]))   / NumObj)) / 60.0;
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

    function EndRound(int Winner)
    {
        local string MapName;
        local int    i;
        local bool   bMatchOver, bRussianSquadLeader;

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

        // Used for Steam Stats below
        bMatchOver = true;

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
            bMatchOver = false;
            GotoState('RoundOver');
        }

        // Get the MapName out of the URL
        MapName = class'DHLib'.static.GetMapName(Level);

        // Set the map as won in the Steam Stats of everyone on the winning team
        for (i = 0; i < GameReplicationInfo.PRIArray.Length; ++i)
        {
            if (ROSteamStatsAndAchievements(GameReplicationInfo.PRIArray[i].SteamStatsAndAchievements) != none)
            {
                if (GameReplicationInfo.PRIArray[i].Team != none && GameReplicationInfo.PRIArray[i].Team.TeamIndex == Winner)
                {
                    if (bMatchOver)
                    {
                        if (GameReplicationInfo.PRIArray[i].Team.TeamIndex == ALLIES_TEAM_INDEX && ROPlayerReplicationInfo(GameReplicationInfo.PRIArray[i]) != none)
                        {
                            bRussianSquadLeader = ROPlayerReplicationInfo(GameReplicationInfo.PRIArray[i]).RoleInfo.bIsLeader &&
                                !ROPlayerReplicationInfo(GameReplicationInfo.PRIArray[i]).RoleInfo.bCanBeTankCrew;
                        }
                        else
                        {
                            bRussianSquadLeader = false;
                        }

                        // NOTE: This MUST be called before ROSteamStatsAndAchievements.MatchEnded()
                        ROSteamStatsAndAchievements(GameReplicationInfo.PRIArray[i].SteamStatsAndAchievements).WonMatch(MapName, Winner, bRussianSquadLeader);
                    }
                    else
                    {
                        // NOTE: This MUST be called before ROSteamStatsAndAchievements.MatchEnded()
                        ROSteamStatsAndAchievements(GameReplicationInfo.PRIArray[i].SteamStatsAndAchievements).WonRound();
                    }
                }

                ROSteamStatsAndAchievements(GameReplicationInfo.PRIArray[i].SteamStatsAndAchievements).MatchEnded();
            }
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
        local DHPlayer PC;

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

        // If team is taking attrition losses, decrement their reinforcements
        for (i = 0; i < 2; ++i)
        {
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
            if ((GRI.TotalStrikes[i] < GRI.ArtilleryStrikeLimit[i]) && ElapsedTime > GRI.LastArtyStrikeTime[i] + ArtilleryStrikeInt && GRI.ArtyStrikeLocation[i] == vect(0.0, 0.0, 0.0))
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

        // Send "weapon unlock" notification to players
        for (P = Level.ControllerList; P != none; P = P.nextController)
        {
            PC = DHPlayer(P);

            if (PC != none && PC.bAreWeaponsLocked && ElapsedTime > PC.WeaponUnlockTime)
            {
                PC.bAreWeaponsLocked = false;

                PC.ReceiveLocalizedMessage(class'DHWeaponsLockedMessage', 2);
            }
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

state RoundOver
{
    // Modified to replace ROArtillerySpawner with DHArtillerySpawner
    function BeginState()
    {
        local DHArtillerySpawner AS;

        RoundStartTime = ElapsedTime;
        ROGameReplicationInfo(GameReplicationInfo).bReinforcementsComing[AXIS_TEAM_INDEX] = 0;
        ROGameReplicationInfo(GameReplicationInfo).bReinforcementsComing[ALLIES_TEAM_INDEX] = 0;

        // Destroy any artillery spawners so they don't keep calling arty
        foreach DynamicActors(class'DHArtillerySpawner', AS)
        {
            AS.Destroy();
        }
    }

    // Modified to spawn a DHClientResetGame actor on a server, which replicates to net clients to remove any temporary client-only actors, e.g. smoke effects
    function Timer()
    {
        global.Timer();

        if (ElapsedTime > RoundStartTime + 5.0)
        {
            if (Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer)
            {
                Spawn(class'DHClientResetGame');
            }

            GotoState('RoundInPlay');
        }
    }
}

function ModifyReinforcements(int Team, int Amount, optional bool bSetReinforcements, optional bool bOnlyIfNotZero)
{
    local DHGameReplicationInfo GRI;
    local bool                  bIsDefendingTeam;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (GRI == none)
    {
        return;
    }

    // Don't increase if value is zero and bOnlyIfNotZero
    if (GRI.SpawnsRemaining[Team] == 0 && bOnlyIfNotZero)
    {
        return;
    }

    // Update GRI with the new value
    if (!bSetReinforcements && GRI.SpawnsRemaining[Team] != -1)
    {
        GRI.SpawnsRemaining[Team] = Max(0, GRI.SpawnsRemaining[Team] += Amount);
    }
    else
    {
        GRI.SpawnsRemaining[Team] = Max(-1, Amount);
    }

    // Check for zero reinforcements
    if (GRI.SpawnsRemaining[Team] == 0)
    {
        if (bTeamOutOfReinforcements[Team] == 0)
        {
            // Colin: Determine if player's team is defending
            bIsDefendingTeam = (Team == AXIS_TEAM_INDEX && LevelInfo.DefendingSide == SIDE_Axis) ||
                               (Team == ALLIES_TEAM_INDEX && LevelInfo.DefendingSide == SIDE_Allies);

            // Colin: Team is just now out of reinforcements.
            bTeamOutOfReinforcements[Team] = 1;

            if ((LevelInfo.DefendingSide != SIDE_none && !bIsDefendingTeam) || LevelInfo.DefendingSide == SIDE_none)
            {
                // Colin: if this team is attacking OR there is no defending side
                // set the round time to 60 seconds, Theel: added special case to choosewinner if Atrrition is used
                if (RoundDuration == 0 && DHLevelInfo.AttritionRateCurve.Points.Length > 0.0)
                {
                    Level.Game.Broadcast(self, "The battle ended because a team's reinforcements reached zero by attrition", 'Say');
                    Choosewinner();
                }
                else
                {
                    ModifyRoundTime(Min(GetRoundTime(), 90), 2); //Set time remaining to 90 seconds
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

function ResetMortarTargets()
{
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (GRI != none)
    {
        GRI.ClearAllMortarTargets();
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

    //TODO: look into improving or rewriting this, as this is garbage looking
    if (PC.GetTeamNum() == ALLIES_TEAM_INDEX && LevelInfo.Allies.SpawnLimit > 0 && GRI.SpawnsRemaining[ALLIES_TEAM_INDEX] != -1)
    {
        ModifyReinforcements(ALLIES_TEAM_INDEX, -1);

        ReinforcementPercent = float(GRI.SpawnsRemaining[ALLIES_TEAM_INDEX]) / float(LevelInfo.Allies.SpawnLimit);

        while (TeamReinforcementMessageIndices[ALLIES_TEAM_INDEX] < default.ReinforcementMessagePercentages.Length &&
                ReinforcementPercent <= default.ReinforcementMessagePercentages[TeamReinforcementMessageIndices[ALLIES_TEAM_INDEX]])
        {
            SendReinforcementMessage(ALLIES_TEAM_INDEX, 100 * default.ReinforcementMessagePercentages[TeamReinforcementMessageIndices[ALLIES_TEAM_INDEX]]);

            ++TeamReinforcementMessageIndices[ALLIES_TEAM_INDEX];
        }
    }
    else if (PC.GetTeamNum() == AXIS_TEAM_INDEX && LevelInfo.Axis.SpawnLimit > 0 && GRI.SpawnsRemaining[AXIS_TEAM_INDEX] != -1)
    {
        ModifyReinforcements(AXIS_TEAM_INDEX, -1);

        ReinforcementPercent = float(GRI.SpawnsRemaining[AXIS_TEAM_INDEX]) / float(LevelInfo.Axis.SpawnLimit);

        while (TeamReinforcementMessageIndices[AXIS_TEAM_INDEX] < default.ReinforcementMessagePercentages.Length &&
                ReinforcementPercent <= default.ReinforcementMessagePercentages[TeamReinforcementMessageIndices[AXIS_TEAM_INDEX]])
        {
            SendReinforcementMessage(AXIS_TEAM_INDEX, 100 * default.ReinforcementMessagePercentages[TeamReinforcementMessageIndices[AXIS_TEAM_INDEX]]);

            ++TeamReinforcementMessageIndices[AXIS_TEAM_INDEX];
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

    return super.ParseChatPercVar(BaseMutator, Who, Cmd);
}

//***********************************************************************************
// exec FUNCTIONS - These functions natively require admin access
//***********************************************************************************

// Quick test function to change a role's limit (Allied only)
// function doesn't support bots
exec function DebugSetRoleLimit(int Team, int Index, int NewLimit)
{
    local Controller C;
    local DHPlayer PC;
    local DHGameReplicationInfo GRI;
    local int i;
    local int RoleLimit;
    local int RoleBotCount;
    local int RoleCount;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (GRI == none)
    {
        return;
    }

    if (Team == 0)
    {
        GRI.DHAxisRoleLimit[Index] = NewLimit;
        GRI.GetRoleCounts(GRI.DHAxisRoles[Index], RoleCount, RoleBotCount, RoleLimit);
    }
    else if (Team == 1)
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
        AlliesToAxisRatio = DH_LevelInfo(LevelInfo).AlliesToAxisRatio;
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
    DH_LevelInfo(LevelInfo).bHardTeamRatio = bNewHardTeamRatio;
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
        if (DHObjectives[i].bActive && DHObjectives[i].ObjState != Team)
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

    // Colin: There is a 5 second buffer time between switching teams. This
    // stops players from being able to rapid-fire switch teams and spam
    // others with team-change messages.
    if (PC != none && PC.NextChangeTeamTime >= Level.TimeSeconds)
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

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (Other.PlayerReplicationInfo.Team != none)
    {
        Other.PlayerReplicationInfo.Team.RemoveFromTeam(Other);

        if (PC != none)
        {
            PC.DesiredRole = -1;
            PC.CurrentRole = -1;
            PC.PrimaryWeapon = -1;
            PC.SecondaryWeapon = -1;
            PC.GrenadeWeapon = -1;
            PC.bWeaponsSelected = false;
            PC.SavedArtilleryCoords = vect(0.0, 0.0, 0.0);

            // DARKEST HOUR
            PC.SpawnPointIndex = 255;
            PC.SpawnVehicleIndex = 255;

            GRI.UnreserveVehicle(PC);
        }
    }

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

    // Since we're changing teams, remove all rally points/help requests/etc
    ClearSavedRequestsAndRallyPoints(ROPlayer(Other), false);

    if (GRI != none)
    {
        GRI.ClearMortarTarget(DHPlayer(Other));
    }

    if (PC != none)
    {
        PC.NextChangeTeamTime = Level.TimeSeconds + default.ChangeTeamInterval;
    }

    return true;
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
    myLevel.AddPrecacheMaterial(Material'Effects_Tex.explosions.fire_16frame');
    myLevel.AddPrecacheMaterial(Material'Effects_Tex.Vehicles.DustCloud');
    myLevel.AddPrecacheMaterial(Material'Effects_Tex.Vehicles.Dust_KickUp');
    myLevel.AddPrecacheMaterial(Material'Effects_Tex.Vehicles.vehiclesparkhead');

    // From ROTreadCraft:
    myLevel.AddPrecacheMaterial(Material'Effects_Tex.explosions.aptankmark_dirt');
    myLevel.AddPrecacheMaterial(Material'Effects_Tex.explosions.aptankmark_snow');
    myLevel.AddPrecacheMaterial(Material'Effects_Tex.BulletHits.glowfinal');

    // From DHArmoredVehicle:
    myLevel.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.Alpha');

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

    // Attrition check
    // Check to see who has more reinforcements
    if (DHLevelInfo.AttritionRateCurve.Points.Length > 0.0)
    {
        // This game is using attrition; therefore, the winner is the one with higher reinforcements (no concern over objective counts)
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
        else if (DHObjectives[i].ObjState == OBJ_Axis)
        {
            Num[AXIS_TEAM_INDEX]++;

            if (DHObjectives[i].bRequired)
            {
                NumReq[AXIS_TEAM_INDEX]++;
            }
        }
        else if (DHObjectives[i].ObjState == OBJ_Allies)
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

//Theel: Convert to use DHObjectives, though this isn't supposed to be used
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
                if (DHObjectives[SpawnAreas[i].AxisRequiredObjectives[j]] != none && DHObjectives[SpawnAreas[i].AxisRequiredObjectives[j]].ObjState != OBJ_Axis)
                {
                    bReqsMet = false;
                    break;
                }
            }

            // Added in conjunction with TeamMustLoseAllRequired enum in SpawnAreas
            // Allows mappers to force all objectives to be lost/won before moving spawns, instead of just one - Ramm
            for (h = 0; h < SpawnAreas[i].AxisRequiredObjectives.Length; ++h)
            {
                if (DHObjectives[SpawnAreas[i].AxisRequiredObjectives[h]] != none && DHObjectives[SpawnAreas[i].AxisRequiredObjectives[h]].ObjState == OBJ_Axis)
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
                    if (DHObjectives[SpawnAreas[i].NeutralRequiredObjectives[k]] != none && DHObjectives[SpawnAreas[i].NeutralRequiredObjectives[k]].ObjState == OBJ_Neutral)
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
                if (DHObjectives[SpawnAreas[i].AlliesRequiredObjectives[j]] != none && DHObjectives[SpawnAreas[i].AlliesRequiredObjectives[j]].ObjState != OBJ_Allies)
                {
                    bReqsMet = false;
                    break;
                }
            }

            // Added in conjunction with TeamMustLoseAllRequired enum in SpawnAreas
            // Allows mappers to force all objectives to be lost/won before moving spawns, instead of just one - Ramm
            for (h = 0; h < SpawnAreas[i].AlliesRequiredObjectives.Length; ++h)
            {
                if (DHObjectives[SpawnAreas[i].AlliesRequiredObjectives[h]] != none && DHObjectives[SpawnAreas[i].AlliesRequiredObjectives[h]].ObjState == OBJ_Allies)
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
                    if (DHObjectives[SpawnAreas[i].NeutralRequiredObjectives[k]] != none && DHObjectives[SpawnAreas[i].NeutralRequiredObjectives[k]].ObjState == OBJ_Neutral)
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

    if (CurrentSpawnArea[AXIS_TEAM_INDEX] == none)
    {
        Log("ROTeamGame: no valid Axis spawn area found!");
    }

    if (CurrentSpawnArea[ALLIES_TEAM_INDEX] == none)
    {
        Log("ROTeamGame: no valid Allied spawn area found!");
    }
}

// Theel: This function is no longer used, but I converted to use DHObjectives just in case we make use of it
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
                if (DHObjectives[TankCrewSpawnAreas[i].AxisRequiredObjectives[j]].ObjState != OBJ_Axis)
                {
                    bReqsMet = false;
                    break;
                }
            }

            // Added in conjunction with TeamMustLoseAllRequired enum in SpawnAreas
            // Allows Mappers to force all objectives to be lost/won before moving spawns, instead of just one - Ramm
            for (h = 0; h < TankCrewSpawnAreas[i].AxisRequiredObjectives.Length; ++h)
            {
                if (DHObjectives[TankCrewSpawnAreas[i].AxisRequiredObjectives[h]].ObjState == OBJ_Axis)
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
                    if (DHObjectives[TankCrewSpawnAreas[i].NeutralRequiredObjectives[k]].ObjState == OBJ_Neutral)
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
                if (DHObjectives[TankCrewSpawnAreas[i].AlliesRequiredObjectives[j]].ObjState != OBJ_Allies)
                {
                    bReqsMet = false;
                    break;
                }
            }

            // Added in conjunction with TeamMustLoseAllRequired enum in SpawnAreas
            // Allows Mappers to force all objectives to be lost/won before moving spawns, instead of just one - Ramm
            for (h = 0; h < TankCrewSpawnAreas[i].AlliesRequiredObjectives.Length; ++h)
            {
                if (DHObjectives[TankCrewSpawnAreas[i].AlliesRequiredObjectives[h]].ObjState == OBJ_Allies)
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
                    if (DHObjectives[TankCrewSpawnAreas[i].NeutralRequiredObjectives[k]].ObjState == OBJ_Neutral)
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

// New function that spawns vehicles near the player (Distance is raised to 5 if <5)
function SpawnVehicle(DHPlayer DHP, string VehicleString, int Distance, optional int SetAsCrew)
{
    local class<Pawn>           VehicleClass;
    local Pawn                  CreatedVehicle;
    local vector                TargetLocation;
    local rotator               Direction;

    if (DHP != none && DHP.Pawn != none)
    {
        Direction.Yaw = DHP.Pawn.Rotation.Yaw;
        TargetLocation = DHP.Pawn.Location + (vector(Direction) * class'DHUnits'.static.MetersToUnreal(Max(Distance, 5)));

        VehicleClass = class<Pawn>(DynamicLoadObject(VehicleString, class'class'));
        CreatedVehicle = Spawn(VehicleClass,,, TargetLocation, Direction);

        if (bool(SetAsCrew) == true && DHPlayerReplicationInfo(DHP.PlayerReplicationInfo) != none && DHPlayerReplicationInfo(DHP.PlayerReplicationInfo).RoleInfo != none)
        {
            DHPlayerReplicationInfo(DHP.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew = true;
        }

        Level.Game.Broadcast(self, "Admin" @ DHP.GetHumanReadableName() @ "spawned a" @ CreatedVehicle.GetHumanReadableName());
    }
}

// New function that spawns bots on the player
function SpawnBots(DHPlayer DHP, int Team, int NumBots, int Distance)
{
    local Controller C;
    local ROBot      B;
    local vector     TargetLocation, RandomOffset;
    local rotator    Direction;
    local int        i;

    if (DHP != none && DHP.Pawn != none)
    {
        TargetLocation = DHP.Pawn.Location;

        // If a Distance has been specified, move the target spawn location that many metres away from the player's location, in the yaw direction he is facing
        if (Distance > 0)
        {
            Direction.Yaw = DHP.Pawn.Rotation.Yaw;
            TargetLocation = TargetLocation + (vector(Direction) * class'DHUnits'.static.MetersToUnreal(Distance));
        }

        for (C = Level.ControllerList; C != none; C = C.NextController)
        {
            B = ROBot(C);

            // Look for bots that aren't in game & are on the the specified team (Team 2 signifies to spawn bots of both teams)
            if (B != none && B.Pawn == none && (Team == 2 || B.GetTeamNum() == Team))
            {
                // Spawn bot
                DeployRestartPlayer(B, false, true);

                if (B != none && B.Pawn != none)
                {
                    // Randomise location a little, so bots don't all spawn on top of each other
                    RandomOffset = VRand() * 120.0;
                    RandomOffset.Z = 0.0;

                    // Move bot to target location
                    if (B.Pawn.SetLocation(TargetLocation + RandomOffset))
                    {
                        // If spawn & move successful, check if we've reached any specified number of bots to spawn (NumBots zero signifies no limit, so skip this check)
                        if (NumBots > 0 && ++i >= NumBots)
                        {
                            break;
                        }
                    }
                    // But if we couldn't move the bot to the target, kill the pawn
                    else
                    {
                        B.Pawn.Suicide();
                    }
                }
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
        GRI.ClearMortarTarget(PC);
        GRI.UnreserveVehicle(PC);

        PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
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

    for (P = Level.ControllerList; P != none; P = P.NextController)
    {
        if (P.bIsPlayer && P.PlayerReplicationInfo.Team != none && P.PlayerReplicationInfo.Team.TeamIndex != 2)
        {
            DHPlayer(P).ClientProposeMenu("DH_Interface.DHDeployMenu");
        }
    }
}

// Override to tell client to save their ROID to their ini so they can easily copy it, store session data, and handle metrics
event PostLogin(PlayerController NewPlayer)
{
    local DHPlayer PC;
    local DHPlayerReplicationInfo PRI;
    local Object O;
    local DHPlayerSession S;

    super.PostLogin(NewPlayer);

    PC = DHPlayer(NewPlayer);

    if (PC == none)
    {
        return;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    if (PRI == none)
    {
        return;
    }

    if (Level.NetMode == NM_DedicatedServer)
    {
        PC.ROIDHash = PC.GetPlayerIDHash(); // server (important)
        PC.ClientSaveROIDHash(PC.GetPlayerIDHash());  // client (nice thing for client)
    }

    if (Metrics != none)
    {
        Metrics.OnPlayerLogin(PC);
    }

    if (PC.GetPlayerIDHash() != "" && PlayerSessions.Get(PC.GetPlayerIDHash(), O))
    {
        S = DHPlayerSession(O);

        PRI.Deaths = S.Deaths;
        PRI.Kills = S.Kills;
        PRI.Score = S.Score;
        PC.LastKilledTime = S.LastKilledTime;
        PC.WeaponLockViolations = S.WeaponLockViolations;
        PC.DeathPenaltyCount = S.DeathPenaltyCount;

        if (S.WeaponUnlockTime > GameReplicationInfo.ElapsedTime)
        {
            PC.LockWeapons(S.WeaponUnlockTime - GameReplicationInfo.ElapsedTime);
        }
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
        S.Score = PRI.Score;
        S.LastKilledTime = PC.LastKilledTime;
        S.WeaponUnlockTime = PC.WeaponUnlockTime;
        S.WeaponLockViolations = PC.WeaponLockViolations;
        S.DeathPenaltyCount = PC.DeathPenaltyCount;
    }
}

function int GetNumObjectives()
{
    local int i;
    local int count;

    for (i = 0; i < arraycount(DHObjectives); ++i)
    {
        if (DHObjectives[i] != none)
        {
            ++count;
        }
    }

    return count;
}

// This is called at the start of an attrition round, it develops a random order at which the objectives will unlock
function AttritionSelectObjectiveOrder()
{
    local int i;

    AttritionObjOrder.Length = 0; // Clear the array just in case, (we do reset it at the beginning of the round also)

    // Build array of objective indices
    for (i = 0; i < arraycount(DHObjectives); ++i)
    {
        if (DHObjectives[i] != none)
        {
            AttritionObjOrder[AttritionObjOrder.Length] = i;
        }
    }

    // Shuffle the constructed array
    class'UArray'.static.IShuffle(AttritionObjOrder);
}

// This function unlocks the next objective that is not active in the attrition objective order
// It is called when an objective is taken and at the beginning of the round foreach AttritionMaxOpenObj
function AttritionUnlockObjective(optional int ObjNum)
{
    local int i, j, StartIndex;

    StartIndex = class'UArray'.static.IIndexOf(AttritionObjOrder, ObjNum);

    if (StartIndex == -1)
    {
        Warn("Issue in AttritionUnlockObjective()");
        return;
    }

    // i = 1 so we skip the objective just captured (otherwise it'll pick itself each time due to setting itself inactive in HandleCompletion)
    for (i = 1; i < AttritionObjOrder.Length; ++i)
    {
        j = AttritionObjOrder[(StartIndex + i) % AttritionObjOrder.Length];

        if (DHObjectives[j].IsActive())
        {
            continue;
        }
        else if (!DHObjectives[j].IsActive())
        {
            DHObjectives[j].SetActive(true);
            break;
        }
    }
}

defaultproperties
{
    ServerTickForInflation=20.0

    // Default settings based on common used server settings in DH
    bIgnore32PlayerLimit=true // allows more than 32 players
    bVACSecured=true

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
    GermanNames(0)="Günther Liebing"
    GermanNames(1)="Heinz Werner"
    GermanNames(2)="Rudolf Giesler"
    GermanNames(3)="Seigfried Hauber"
    GermanNames(4)="Gustav Beier"
    GermanNames(5)="Joseph Peitsch"
    GermanNames(6)="Willi Eiken"
    GermanNames(7)="Wolfgang Steyer"
    GermanNames(8)="Rolf Steiner"
    GermanNames(9)="Anton Müller"
    GermanNames(10)="Klaus Triebig"
    GermanNames(11)="Hans Grüschke"
    GermanNames(12)="Wilhelm Krüger"
    GermanNames(13)="Herrmann Dietrich"
    GermanNames(14)="Erich Klein"
    GermanNames(15)="Horst Altmann"
    Acronym="DH"
    MapPrefix="DH"
    BeaconName="DH"
    GameName="DarkestHourGame"

    // Class references
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

    ChangeTeamInterval=1.0

    ReinforcementMessagePercentages(0)=0.5
    ReinforcementMessagePercentages(1)=0.25
    ReinforcementMessagePercentages(2)=0.1
    ReinforcementMessagePercentages(3)=0.0

    Begin Object Class=UVersion Name=VersionObject
        Major=7
        Minor=0
        Patch=3
    End Object
    Version=VersionObject

    MetricsClass=class'DHMetrics'
    bEnableMetrics=true
    bUseWeaponLocking=true

    WeaponLockTimes(0)=0
    WeaponLockTimes(1)=5
    WeaponLockTimes(2)=15
    WeaponLockTimes(3)=30
    WeaponLockTimes(4)=45
    WeaponLockTimes(5)=60
}
