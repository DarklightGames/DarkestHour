//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHSquadReplicationInfo extends ReplicationInfo;

const SQUAD_SIZE_MIN = 8;
const SQUAD_SIZE_MAX = 12;
const SQUAD_RALLY_POINTS_MAX = 2;           // The number of squad rally points that can be exist at one time.
const SQUAD_RALLY_POINTS_ACTIVE_MAX = 1;    // The number of squad rally points that are "active" at one time.
const TEAM_SQUAD_MEMBERS_MAX = 64;
const TEAM_SQUADS_MAX = 7;                  // SQUAD_SIZE_MIN / TEAM_SQUAD_MEMBERS_MAX

const RALLY_POINTS_MAX = 32;                // TEAM_SQUADS_MAX * SQUAD_RALLY_POINTS_MAX * 2

const SQUAD_NAME_LENGTH_MIN = 3;
const SQUAD_NAME_LENGTH_MAX = 20;

const SQUAD_LEADER_INDEX = 0;

const SQUAD_DISBAND_THRESHOLD = 2;
const SQUAD_LEADER_DRAW_DURATION_SECONDS = 15;

const SQUAD_MERGE_REQUEST_INTERVAL = 15.0;

// This nightmare is necessary because UnrealScript cannot replicate large
// arrays of structs.
var private DHPlayerReplicationInfo AxisMembers[TEAM_SQUAD_MEMBERS_MAX];
var private byte                    AxisAssistantSquadLeaderMemberIndices[TEAM_SQUADS_MAX];
var private string                  AxisNames[TEAM_SQUADS_MAX];
var private byte                    AxisLocked[TEAM_SQUADS_MAX];
var private int                     AxisNextRallyPointTimes[TEAM_SQUADS_MAX];   // Stores the next time (in relation to Level.TimeSeconds) that a squad can place a new rally point.

// Rally points
var DHSpawnPoint_SquadRallyPoint    RallyPoints[RALLY_POINTS_MAX];
var float                           RallyPointInitialDelaySeconds;
var float                           RallyPointChangeLeaderDelaySeconds;
var float                           RallyPointRadiusInMeters;
var float                           RallyPointSquadmatePlacementRadiusInMeters;
var int                             RallyPointInitialSpawnsMinimum;
var float                           RallyPointInitialSpawnsMemberFactor;
var float                           RallyPointInitialSpawnsDangerZoneFactor;
var config  bool                    bAllowRallyPointsBehindEnemyLines;

var private DHPlayerReplicationInfo AlliesMembers[TEAM_SQUAD_MEMBERS_MAX];
var private byte                    AlliesAssistantSquadLeaderMemberIndices[TEAM_SQUADS_MAX];
var private string                  AlliesNames[TEAM_SQUADS_MAX];
var private byte                    AlliesLocked[TEAM_SQUADS_MAX];
var private int                     AlliesNextRallyPointTimes[TEAM_SQUADS_MAX]; // Stores the next time (in relation to Level.TimeSeconds) that a squad can place a new rally point.

var globalconfig private int        AxisSquadSize;
var globalconfig private int        AlliesSquadSize;

var class<LocalMessage>             SquadMessageClass;

var int                             NextRallyPointInterval;
var bool                            bAreRallyPointsEnabled;

var int                             SquadLockMemberCountMin;    // The amount of squad member required to be able to lock a squad and keep it locked.
var int                             SquadLeaderRallyPointInactivityThreshold;

struct SquadLeaderVolunteer
{
    var int TeamIndex;
    var int SquadIndex;
    var array<DHPlayerReplicationInfo> Volunteers;
};
var array<SquadLeaderVolunteer>     SquadLeaderVolunteers;

struct SquadLeaderDraw
{
    var int TeamIndex;
    var int SquadIndex;
    var int ExpirationTime;
};
var array<SquadLeaderDraw>          SquadLeaderDraws;

// Squads Bans
struct SquadBan
{
    var int TeamIndex;
    var int SquadIndex;
    var string ROID;
};
var array<SquadBan>                 SquadBans;

// Squad Merge Requests
enum ESquadMergeRequestResult
{
    RESULT_Throttled,
    RESULT_Fatal,
    RESULT_CannotMerge,
    RESULT_Duplicate,
    RESULT_Sent
};

struct SquadMergeRequest
{
    var int ID;
    var int TeamIndex;
    var int SenderSquadIndex;
    var int RecipientSquadIndex;
};
var array<SquadMergeRequest>        SquadMergeRequests;
var int                             NextSquadMergeRequestID;

var private DHGameReplicationInfo   GRI;    // only valid on the server, clients should use GetGameReplicationInfo()

var localized array<string>         SquadMergeRequestResultStrings;
var localized array<string>         SquadPromotionRequestResultStrings;

// Squad Promotion Requests
enum ESquadPromotionRequestResult
{
    SPPR_Fatal,
    SPPR_Duplicate,
    SPPR_Sent
};

struct SquadPromotionRequest
{
    var int ID;
    var int TeamIndex;
    var int SquadIndex;
    var DHPlayerReplicationInfo Sender;
    var DHPlayerReplicationInfo Recipient;
};

var array<SquadPromotionRequest>    SquadPromotionRequests;
var int                             NextSquadPromotionRequestID;

var int                             JoinSquadNagMessageInterval;    // How often to nag unassigned players to join a squad.
var int                             NextJoinSquadNagTime;           // The next time to nag unassigned players to join a squad.

enum ERallyPointPlacementErrorType
{
    ERROR_None,
    ERROR_Fatal,
    ERROR_NotOnFoot/*=52*/,                             // PC.ReceiveLocalizedMessage(SquadMessageClass, 52); // "You must be on foot to create a rally point."
    ERROR_TooCloseToOtherRallyPoint/*=45*/,             // PC.ReceiveLocalizedMessage(SquadMessageClass, Class'UInteger'.static.FromShorts(45, E.OptionalInt));
    ERROR_InUncontrolledObjective/*=78*/,               // PC.ReceiveLocalizedMessage(SquadMessageClass, 78);
    ERROR_TooSoon/*=53*/,                               // PC.ReceiveLocalizedMessage(SquadMessageClass, Class'UInteger'.static.FromShorts(53, E.OptionalInt));
    ERROR_MissingSquadmate/*=47*/,                      // PC.ReceiveLocalizedMessage(SquadMessageClass, 47);
    ERROR_BadLocation/*=56*/,
    ERROR_BehindEnemyLines/*=80*/,
};

struct RallyPointPlacementError
{
    var ERallyPointPlacementErrorType Type;
    var float OptionalFloat;
    var int OptionalInt;
    var string OptionalString;
    var Object OptionalObject;
    var Vector HitLocation;
    var Vector HitNormal;
};

struct RallyPointPlacementResult
{
    var RallyPointPlacementError Error;
    var bool    bIsInDangerZone;
    var Vector  HitLocation;
    var Vector  HitNormal;
};

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        AxisSquadSize, AlliesSquadSize,
        AxisMembers, AxisNames, AxisLocked, AlliesMembers, AlliesNames,
        AlliesLocked, bAreRallyPointsEnabled, RallyPoints,
        AxisNextRallyPointTimes, AlliesNextRallyPointTimes;
}

simulated function PostBeginPlay()
{
    local DH_LevelInfo LI;

    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

        SetTeamSquadSize(AXIS_TEAM_INDEX, AxisSquadSize);
        SetTeamSquadSize(ALLIES_TEAM_INDEX, AlliesSquadSize);

        foreach AllActors(Class'DH_LevelInfo', LI)
        {
            bAreRallyPointsEnabled = LI.GameTypeClass.default.bAreRallyPointsEnabled;
            break;
        }
    }
}

function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if (Role == ROLE_Authority)
    {
        SetTimer(1.0, true);
    }
}

private function SendJoinSquadNagMessage()
{
    local Controller C;
    local DHPlayer PC;

    for (C = Level.ControllerList; C != none; C = C.nextController)
    {
        PC = DHPlayer(C);
        
        if (PC != none && !PC.IsInSquad())
        {
            PC.ReceiveLocalizedMessage(SquadMessageClass, 73,,, PC);
            continue;
        }
    }

    NextJoinSquadNagTime = Level.Game.GameReplicationInfo.ElapsedTime + JoinSquadNagMessageInterval;
}

function Timer()
{
    local DHPlayer PC;
    local DHPlayerReplicationInfo PRI;
    local Controller C;
    local bool bShouldSendJoinSquadNagMessage;

    // When appropriate, all unassigned players will be berated to join a squad at regular intervals.
    bShouldSendJoinSquadNagMessage = Level.NetMode != NM_Standalone && bAreRallyPointsEnabled && Level.Game.GameReplicationInfo.ElapsedTime >= NextJoinSquadNagTime;

    if (bShouldSendJoinSquadNagMessage)
    {
        SendJoinSquadNagMessage();
    }

    for (C = Level.ControllerList; C != none; C = C.nextController)
    {
        PC = DHPlayer(C);

        if (PC == none)
        {
            continue;
        }

        PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

        if (PRI == none || PRI.Team == none)
        {
            continue;
        }

        // SLs, ASLs and radio operators should know where all squad leaders are.
        if (PRI.IsSLorASL() || PRI.IsRadioman())
        {
            UpdateSquadLeaderLocations(PC);
        }

        UpdateSquadMemberLocations(PC);
    }

    UpdateSquadRallyPoints();
    UpdateSquadLeaderDraws();
}

private function UpdateSquadMemberLocations(DHPlayer PC)
{
    local int i;
    local DHPlayerReplicationInfo PRI, OtherPRI;
    local Controller OtherController;
    local float X, Y;
    
    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    // We want our player to know where his squadmates are at all times by
    // looking at the situation map. However, since the player may not have
    // all squadmates replicated on his machine, he needs another way to know
    // his squadmates' locations and rotations.
    //
    // The method below sends the position (X, Y) and rotation (Z) of each
    // member in the players' squad every 2 seconds.
    for (i = 0; i < GetTeamSquadSize(PC.GetTeamNum()); ++i)
    {
        OtherPRI = GetMember(PC.GetTeamNum(), PRI.SquadIndex, i);

        if (OtherPRI != none)
        {
            OtherController = Controller(OtherPRI.Owner);

            if (OtherController != none && OtherController.Pawn != none)
            {
                GRI.GetMapCoords(OtherController.Pawn.Location, X, Y);
                PC.SquadMemberLocations[i] = Class'UQuantize'.static.QuantizeClamped2DPose(X, Y, OtherController.Pawn.Rotation.Yaw);
                continue;
            }
        }

        PC.SquadMemberLocations[i] = 0;
    }
}

// Updates the position of squad leaders for the specified player. These positions
// are used for map icons.
private function UpdateSquadLeaderLocations(DHPlayer PC)
{
    local int i;
    local DHPlayerReplicationInfo OtherPRI;
    local Controller OtherController;
    local float X, Y;

    for (i = 0; i < GetTeamSquadLimit(PC.GetTeamNum()); ++i)
    {
        PC.SquadLeaderLocations[i] = 0;

        if (!IsSquadActive(PC.GetTeamNum(), i))
        {
            continue;
        }

        OtherPRI = GetSquadLeader(PC.GetTeamNum(), i);

        if (OtherPRI == none)
        {
            continue;
        }

        OtherController = Controller(OtherPRI.Owner);

        if (OtherController != none && OtherController.Pawn != none)
        {
            GRI.GetMapCoords(OtherController.Pawn.Location, X, Y);
            PC.SquadLeaderLocations[i] = Class'UQuantize'.static.QuantizeClamped2DPose(X, Y, OtherController.Pawn.Rotation.Yaw);
        }
    }
}

private function UpdateSquadRallyPoints()
{
    local int i, TeamIndex, SquadIndex, UnblockedCount;
    local array<DHSpawnPoint_SquadRallyPoint> SquadRallyPoints, ActiveSquadRallyPoints;
    local UComparator Comparator;
    local DHSpawnPoint_SquadRallyPoint RP;
    local bool bShouldAccrueSpawns;

    for (TeamIndex = AXIS_TEAM_INDEX; TeamIndex <= ALLIES_TEAM_INDEX; ++TeamIndex)
    {
        for (SquadIndex = 0; SquadIndex < GetTeamSquadLimit(TeamIndex); ++SquadIndex)
        {
            if (!IsSquadActive(TeamIndex, SquadIndex))
            {
                continue;
            }

            SquadRallyPoints = GetSquadRallyPoints(TeamIndex, SquadIndex);

            for (i = 0; i < SquadRallyPoints.Length; ++i)
            {
                SquadRallyPoints[i].Timer();
            }

            // Sort active rally point list by creation time, oldest first.
            ActiveSquadRallyPoints = GetActiveSquadRallyPoints(TeamIndex, SquadIndex);
            Comparator = new Class'UComparator';
            Comparator.CompareFunction = RallyPointSortFunction;
            Class'USort'.static.Sort(ActiveSquadRallyPoints, Comparator);

            // Check if this squad already has more than the maximum rally points.
            // If so, forcibly delete the oldest ones.
            while (ActiveSquadRallyPoints.Length > SQUAD_RALLY_POINTS_MAX)
            {
                RP = RallyPoints[ActiveSquadRallyPoints[0].RallyPointIndex];

                if (RP != none && RP.MetricsObject != none)
                {
                    RP.MetricsObject.DestroyedReason = REASON_Replaced;
                }

                RP.Destroy();

                ActiveSquadRallyPoints.Remove(0, 1);
            }

            // Count how many active are non-blocked, if it's more than
            // the maximum allowed, block the oldest ones (their block-state
            // will be overwritten on the next timer pop)
            UnblockedCount = 0;

            for (i = ActiveSquadRallyPoints.Length - 1; i >= 0; --i)
            {
                if (!ActiveSquadRallyPoints[i].IsBlocked())
                {
                    ++UnblockedCount;
                }

                if (UnblockedCount > SQUAD_RALLY_POINTS_ACTIVE_MAX)
                {
                    // If a squad rally point is blocked because it isn't the
                    // primary squad rally point at the moment, let's award an
                    // additional spawn at regular intervals.
                    ActiveSquadRallyPoints[i].BlockReason = SPBR_Full;

                    bShouldAccrueSpawns = !ActiveSquadRallyPoints[i].bIsExposed;

                    if (bShouldAccrueSpawns)
                    {
                        ActiveSquadRallyPoints[i].SpawnAccrualTimer += 1;

                        if (ActiveSquadRallyPoints[i].SpawnAccrualTimer >= ActiveSquadRallyPoints[i].SpawnAccrualThreshold)
                        {
                            ActiveSquadRallyPoints[i].SpawnAccrualTimer = 0;
                            ActiveSquadRallyPoints[i].SpawnsRemaining = Min(ActiveSquadRallyPoints[i].SpawnsRemaining + 1, GetSquadRallyPointInitialSpawns(ActiveSquadRallyPoints[i]));
                        }
                    }
                }
                else
                {
                    ActiveSquadRallyPoints[i].SpawnAccrualTimer = 0;
                }
            }

            UpdateSquadRallyPointInfo(TeamIndex, SquadIndex);
        }
    }
}

// Called when a squad leader draw has ended.
private function OnSquadLeaderDrawEnded(SquadLeaderDraw SquadLeaderDraw)
{
    // Draw ended! Let's see who the new squad leader is.
    local int i, TeamIndex, SquadIndex;
    local array<DHPlayerReplicationInfo> Volunteers;

    TeamIndex = SquadLeaderDraw.TeamIndex;
    SquadIndex = SquadLeaderDraw.SquadIndex;

    GetSquadLeaderVolunteers(TeamIndex, SquadIndex, Volunteers);

    if (Volunteers.Length == 0)
    {
        // There were no volunteers!
        if (GetMemberCount(TeamIndex, SquadIndex) <= SQUAD_DISBAND_THRESHOLD)
        {
            // "Your squad has been disbanded because the squad is too
            // small and no members volunteered to be squad leader."
            BroadcastSquadLocalizedMessage(TeamIndex, SquadIndex, SquadMessageClass, 67);
            DisbandSquad(TeamIndex, SquadIndex);
        }
        else
        {
            // The squad is big enough to not be disbanded, so someone
            // in the squad (who isn't the squad assistant) is going to
            // randomly be assigned the leader.

            // "No members volunteered to be squad leader."
            BroadcastSquadLocalizedMessage(TeamIndex, SquadIndex, SquadMessageClass, 66);
            GetMembers(TeamIndex, SquadIndex, Volunteers);

            for (i = 0; i < Volunteers.Length; ++i)
            {
                if (IsSquadAssistant(Volunteers[i], TeamIndex, SquadIndex))
                {
                    Volunteers.Remove(i, 1);
                    break;
                }
            }
        }
    }

    // If the squad hasn't been disbanded, select the new squad leader.
    if (IsSquadActive(TeamIndex, SquadIndex))
    {
        SelectNewSquadLeader(TeamIndex, SquadIndex, Volunteers);
    }

    // If somehow there are no volunteers (e.g., ASL is the only one left in the squad and didn't volunteer), just disband the squad.
    if (Volunteers.Length == 0)
    {
        DisbandSquad(TeamIndex, SquadIndex);
    }
}

// Handles logic for resolving squad leader draws.
private function UpdateSquadLeaderDraws()
{
    local int i, TeamIndex, SquadIndex;

    // Squad leader draws
    for (i = SquadLeaderDraws.Length - 1; i >= 0; --i)
    {
        TeamIndex = SquadLeaderDraws[i].TeamIndex;
        SquadIndex = SquadLeaderDraws[i].SquadIndex;

        if (!IsSquadActive(TeamIndex, SquadIndex))
        {
            // Squad is no longer active, cancel the draw.
            SquadLeaderDraws.Remove(i, 1);
            continue;
        }

        if (Level.Game.GameReplicationInfo.ElapsedTime >= SquadLeaderDraws[i].ExpirationTime)
        {
            OnSquadLeaderDrawEnded(SquadLeaderDraws[i]);

            // New squad leader has been selected, remove draw from the list.
            SquadLeaderDraws.Remove(i, 1);
        }
    }
}

protected function ResetPlayerSquadInfo(DHPlayerReplicationInfo PRI)
{
    if (PRI != none)
    {
        PRI.SquadIndex = PRI.default.SquadIndex;
        PRI.SquadMemberIndex = PRI.default.SquadMemberIndex;
        PRI.bIsSquadAssistant = PRI.default.bIsSquadAssistant;
    }
}

function ResetSquadNextRallyPointTimes()
{
    local int i;

    for (i = 0; i < arraycount(AxisNextRallyPointTimes); ++i)
    {
        AxisNextRallyPointTimes[i] = 0.0;
    }

    for (i = 0; i < arraycount(AlliesNextRallyPointTimes); ++i)
    {
        AlliesNextRallyPointTimes[i] = 0.0;
    }
}

function ResetSquadRallyPoints()
{
    local int i;

    for (i = 0; i < arraycount(RallyPoints); ++i)
    {
        if (RallyPoints[i] != none)
        {
            RallyPoints[i].Destroy();
            RallyPoints[i] = none;
        }
    }
    
    ResetSquadNextRallyPointTimes();
}

function ResetSquadInfo()
{
    local int i;

    for (i = 0; i < arraycount(AxisMembers); ++i)
    {
        if (AxisMembers[i] != none)
        {
            ResetPlayerSquadInfo(AxisMembers[i]);
            AxisMembers[i] = none;
        }
    }

    for (i = 0; i < arraycount(AlliesMembers); ++i)
    {
        if (AlliesMembers[i] != none)
        {
            ResetPlayerSquadInfo(AlliesMembers[i]);
            AlliesMembers[i] = none;
        }
    }

    for (i = 0; i < arraycount(AxisAssistantSquadLeaderMemberIndices); ++i)
    {
        AxisAssistantSquadLeaderMemberIndices[i] = -1;
    }

    for (i = 0; i < arraycount(AxisNames); ++i)
    {
        AxisNames[i] = "";
    }

    for (i = 0; i < arraycount(AxisLocked); ++i)
    {
        AxisLocked[i] = 0;
    }

    for (i = 0; i < arraycount(AlliesAssistantSquadLeaderMemberIndices); ++i)
    {
        AlliesAssistantSquadLeaderMemberIndices[i] = -1;
    }

    for (i = 0; i < arraycount(AlliesNames); ++i)
    {
        AlliesNames[i] = "";
    }

    for (i = 0; i < arraycount(AlliesLocked); ++i)
    {
        AlliesLocked[i] = 0;
    }

    SquadBans.Length = 0;
    SquadLeaderDraws.Length = 0;
    SquadLeaderVolunteers.Length = 0;
    SquadMergeRequests.Length = 0;
    NextSquadMergeRequestID = default.NextSquadMergeRequestID;
    SquadPromotionRequests.Length = 0;
    NextSquadPromotionRequestID = default.NextSquadPromotionRequestID;
}

// Gets the maximum size of a squad for a given team.
simulated function int GetTeamSquadSize(int TeamIndex)
{
    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            return AxisSquadSize;
        case ALLIES_TEAM_INDEX:
            return AlliesSquadSize;
        default:
            return 0;
    }
}

// Gets the the number of squads a team can have.
simulated function int GetTeamSquadLimit(int TeamIndex)
{
    local int TeamSquadSize;

    TeamSquadSize = GetTeamSquadSize(TeamIndex);

    // Avoid a divide-by-zero error.
    if (TeamSquadSize <= 0)
    {
        return 0;
    }

    return Min(TEAM_SQUADS_MAX, TEAM_SQUAD_MEMBERS_MAX / GetTeamSquadSize(TeamIndex));
}

// Returns true when there are members in the squad.
simulated function bool IsSquadActive(byte TeamIndex, int SquadIndex)
{
    local int i;

    if (SquadIndex < 0 || SquadIndex >= GetTeamSquadLimit(TeamIndex))
    {
        return false;
    }

    for (i = 0; i < GetTeamSquadSize(TeamIndex); ++i)
    {
        if (GetMember(TeamIndex, SquadIndex, i) != none)
        {
            return true;
        }
    }

    return false;
}

// Returns true if the specified player is a squad leader.
simulated function bool IsASquadLeader(DHPlayerReplicationInfo PRI)
{
    return PRI != none && PRI.Team != none && PRI == GetSquadLeader(PRI.Team.TeamIndex, PRI.SquadIndex);
}

// Returns the squad leader for the specified squad,.
simulated function DHPlayerReplicationInfo GetSquadLeader(int TeamIndex, int SquadIndex)
{
    return GetMember(TeamIndex, SquadIndex, SQUAD_LEADER_INDEX);
}

// Returns true if the squad has a squad leader.
simulated function bool HasSquadLeader(int TeamIndex, int SquadIndex)
{
    return GetSquadLeader(TeamIndex, SquadIndex) != none;
}

simulated function bool HasAssistant(int TeamIndex, int SquadIndex)
{
    return GetAssistantSquadLeader(TeamIndex, SquadIndex) != none;
}

// Returns true if the specified player is the squad leader of the specified squad.
simulated function bool IsSquadLeader(DHPlayerReplicationInfo PRI, int TeamIndex, int SquadIndex)
{
    if (PRI == none || PRI.SquadIndex == -1 || PRI.Team == none || PRI.Team.TeamIndex != TeamIndex || PRI.SquadIndex != SquadIndex)
    {
        return false;
    }

    return PRI.SquadMemberIndex == SQUAD_LEADER_INDEX;
}

// Returns true if the specified player is the assistant of the specified squad.
simulated function bool IsSquadAssistant(DHPlayerReplicationInfo PRI, int TeamIndex, int SquadIndex)
{
    return GetAssistantSquadLeader(TeamIndex, SquadIndex) == PRI;
}

// Swaps the position of squad members in the same squad by index.
private function bool SwapSquadMembersByIndex(int TeamIndex, int SquadIndex, int MemberIndex1, int MemberIndex2)
{
    local DHPlayerReplicationInfo PRI1, PRI2;

    if (!IsSquadActive(TeamIndex, SquadIndex) ||
        MemberIndex1 >= GetTeamSquadSize(TeamIndex) ||
        MemberIndex2 >= GetTeamSquadSize(TeamIndex))
    {
        return false;
    }

    PRI1 = GetMember(TeamIndex, SquadIndex, MemberIndex1);
    PRI2 = GetMember(TeamIndex, SquadIndex, MemberIndex2);

    SetMember(TeamIndex, SquadIndex, MemberIndex1, PRI2);
    SetMember(TeamIndex, SquadIndex, MemberIndex2, PRI1);

    return true;
}

// Swaps the position of squad members in the same squad.
function bool SwapSquadMembers(DHPlayerReplicationInfo A, DHPlayerReplicationInfo B)
{
    local int T, U;

    if (A == B || !Class'DHPlayerReplicationInfo'.static.IsInSameSquad(A, B))
    {
        return false;
    }

    T = A.SquadMemberIndex;
    U = B.SquadMemberIndex;

    SetMember(A.Team.TeamIndex, A.SquadIndex, T, B);
    SetMember(A.Team.TeamIndex, A.SquadIndex, U, A);

    return true;
}

// Returns the default squad name for the specified team and squad index.
simulated function string GetDefaultSquadName(int TeamIndex, int SquadIndex)
{
    local DH_LevelInfo LI;

    LI = Class'DH_LevelInfo'.static.GetInstance(Level);

    if (SquadIndex < 0 || SquadIndex > GetTeamSquadLimit(TeamIndex) && LI != none)
    {
        return "";
    }

    return LI.GetTeamNationClass(TeamIndex).default.DefaultSquadNames[SquadIndex];
}

// Creates a squad. Returns the index of the newly created squad, or -1 if there was an error.
function int CreateSquad(DHPlayerReplicationInfo PRI, optional string Name)
{
    local int i;
    local int TeamIndex;
    local DHPlayer PC;
    local DHVoiceReplicationInfo VRI;

    if (PRI == none)
    {
        return -1;
    }

    PC = DHPlayer(PRI.Owner);

    if (PC == none)
    {
        return -1;
    }

    if (PRI.SquadIndex != -1)
    {
        return -1;
    }

    TeamIndex = PC.GetTeamNum();

    for (i = 0; i < GetTeamSquadLimit(TeamIndex); ++i)
    {
        if (!IsSquadActive(TeamIndex, i))
        {
            SetName(TeamIndex, i, Name);

            // Clear out the assistant squad leader role.
            SetAssistantSquadLeader(TeamIndex, i, none);

            SetMember(TeamIndex, i, SQUAD_LEADER_INDEX, PRI);

            VRI = DHVoiceReplicationInfo(PC.VoiceReplicationInfo);

            if (VRI != none)
            {
                VRI.JoinSquadChannel(PRI, TeamIndex, i);
                PC.Speak("SQUAD");
            }

            // "You have created a squad."
            PC.ReceiveLocalizedMessage(SquadMessageClass, 43);

            // Unlock the squad.
            SetSquadLockedInternal(TeamIndex, i, false);

            // Have a slight delay in placing rally points to dissuade players
            // from trying to exploit the system.
            SetSquadNextRallyPointTime(TeamIndex, i, Level.Game.GameReplicationInfo.ElapsedTime + RallyPointInitialDelaySeconds);

            // New squad will have no rallies. Reset the no rally points time to now.
            UpdateSquadLeaderNoRallyPointsTime(TeamIndex, i);

            // This new squad leader may need to have their role invalidated.
            MaybeInvalidateRole(PC);

            return i;
        }
    }

    return -1;
}

// Changes the squad leader. Returns true if the squad leader was successfully changed.
// NOTE: Duplicates functionality of `ComandeerSquad` function.
function bool ChangeSquadLeader(DHPlayerReplicationInfo PRI, int TeamIndex, int SquadIndex, DHPlayerReplicationInfo NewSquadLeader)
{
    local DHBot Bot;
    local DHPlayer PC, OtherPC;
    local DHPlayerReplicationInfo Admin, CurrentSquadLeader;
    local bool bRequestedByAdmin;

    if (PRI == none)
    {
        return false;
    }

    // Change has been requested by an admin: swap PRI with the actual SL.
    if (PRI.IsLoggedInAsAdmin() && NewSquadLeader != none)
    {
        Admin = PRI;
        CurrentSquadLeader = GetSquadLeader(TeamIndex, NewSquadLeader.SquadIndex);

        if (CurrentSquadLeader != none && CurrentSquadLeader != Admin)
        {
            PRI = CurrentSquadLeader;
            SquadIndex = NewSquadLeader.SquadIndex;
            bRequestedByAdmin = true;
        }
    }

    PC = DHPlayer(PRI.Owner);
    Bot = DHBot(PRI.Owner);

    if (PC == none && Bot == none)
    {
        return false;
    }

    if (!IsSquadLeader(PRI, TeamIndex, SquadIndex))
    {
        // Player is not a squad leader.
        return false;
    }

    if (PRI == NewSquadLeader || !Class'DHPlayerReplicationInfo'.static.IsInSameSquad(PRI, NewSquadLeader))
    {
        return false;
    }

    // If the new squad leader is the assistant squad leader, clear the assistant.
    if (GetAssistantSquadLeader(TeamIndex, SquadIndex) == NewSquadLeader)
    {
        SetAssistantSquadLeader(TeamIndex, SquadIndex, none);
    }

    // Rescind squad leader volunteer application.
    ClearSquadLeaderVolunteer(PRI, TeamIndex, SquadIndex);

    if (!SwapSquadMembers(PRI, NewSquadLeader))
    {
        return false;
    }

    MaybeLeaveCommandVoiceChannel(PRI);

    if (bRequestedByAdmin)
    {
        Class'DarkestHourGame'.static.BroadcastTeamLocalizedMessage(Level,
                                                                    TeamIndex,
                                                                    Class'DHAdminMessage',
                                                                    Class'UInteger'.static.FromShorts(1, SquadIndex),
                                                                    Admin,
                                                                    NewSquadLeader,
                                                                    self);
    }

    if (PC != none)
    {
        // "You are no longer the squad leader"
        PC.ReceiveLocalizedMessage(SquadMessageClass, 33);
    }

    OtherPC = DHPlayer(NewSquadLeader.Owner);

    if (OtherPC != none)
    {
        // "You are now the squad leader"
        OtherPC.ReceiveLocalizedMessage(SquadMessageClass, 34);
    }

    // Both the incoming and outgoing squad leader may need to have their current roles invalidated.
    MaybeInvalidateRole(PC);
    MaybeInvalidateRole(OtherPC);

    // "{0} has become the squad leader"
    BroadcastSquadLocalizedMessage(PRI.Team.TeamIndex, PRI.SquadIndex, SquadMessageClass, 35, NewSquadLeader);

    // Have a slight delay in placing rally points to dissuade players
    // from trying to exploit the system.
    SetSquadNextRallyPointTime(TeamIndex, SquadIndex, Level.Game.GameReplicationInfo.ElapsedTime + RallyPointChangeLeaderDelaySeconds);

    return true;
}

function bool ScoreComparatorFunction(Object LHS, Object RHS)
{
    return DHPlayerReplicationInfo(LHS).Score < DHPlayerReplicationInfo(RHS).Score;
}

// Called when the squad leader leaves their squad.
private function OnSquadLeaderLeftSquad(int TeamIndex, int SquadIndex)
{
    local array<DHPlayerReplicationInfo> Volunteers;

    // "The squad leader has left the squad."
    BroadcastSquadLocalizedMessage(TeamIndex, SquadIndex, SquadMessageClass, 40);

    ClearSquadMergeRequests(TeamIndex, SquadIndex);

    GetSquadLeaderVolunteers(TeamIndex, SquadIndex, Volunteers);

    if (Volunteers.Length > 0)
    {
        // There are volunteers, so let's make one of them the new
        // squad leader without delay.
        SelectNewSquadLeader(TeamIndex, SquadIndex, Volunteers);
    }
    else
    {
        // No volunteers, start a new squad leader draw.
        StartSquadLeaderDraw(TeamIndex, SquadIndex);
    }
}

// Makes the specified player leave their squad, if it exists.
// Returns true if player successfully leaves his squad.
// The player is guaranteed to not be a member of a squad after this
// call, regardless of the return value.
// TODO: these optional bools are ugly and are indicative that a minor refactor is required around this code flow.
function bool LeaveSquad(DHPlayerReplicationInfo PRI, optional bool bShouldShowLeftMessage, optional bool bShouldNotInvalidateRole)
{
    local int TeamIndex, SquadIndex, SquadMemberIndex;
    local DHPlayer PC;
    local DHBot Bot;
    local DHVoiceReplicationInfo VRI;
    local VoiceChatRoom SquadVCR;
    local DarkestHourGame G;
    local bool bHasActiveChannelChanged;

    G = DarkestHourGame(Level.Game);

    if (PRI == none || PRI.Team == none || GRI == none)
    {
        return false;
    }

    PC = DHPlayer(PRI.Owner);
    Bot = DHBot(PRI.Owner);

    if (PC == none && Bot == none)
    {
        return false;
    }

    TeamIndex = PRI.Team.TeamIndex;
    SquadIndex = PRI.SquadIndex;
    SquadMemberIndex = PRI.SquadMemberIndex;

    if (GetMember(TeamIndex, SquadIndex, SquadMemberIndex) != PRI)
    {
        return false;
    }

    // If this member was the assistant squad leader, clear the assistant squad
    // leader.
    if (GetAssistantSquadLeader(TeamIndex, SquadIndex) == PRI)
    {
        SetAssistantSquadLeader(TeamIndex, SquadIndex, none);
    }

    // Remove squad member.
    SetMember(TeamIndex, SquadIndex, SquadMemberIndex, none);
    ResetPlayerSquadInfo(PRI);

    if (!bShouldNotInvalidateRole)
    {
        MaybeInvalidateRole(PC);
    }

    // Clear squad leader volunteer application.
    ClearSquadLeaderVolunteer(PRI, TeamIndex, SquadIndex);

    // "{0} has left the squad."
    BroadcastSquadLocalizedMessage(TeamIndex, SquadIndex, SquadMessageClass, 31, PRI);

    if (bShouldShowLeftMessage && PC != none)
    {
        // "You have left the squad."
        PC.ReceiveLocalizedMessage(SquadMessageClass, 64);
    }

    if (SquadMemberIndex == SQUAD_LEADER_INDEX)
    {
        OnSquadLeaderLeftSquad(TeamIndex, SquadIndex);
    }

    // Remove the squad leader from the command voice channel
    bHasActiveChannelChanged = MaybeLeaveCommandVoiceChannel(GetSquadLeader(TeamIndex, SquadIndex));

    // Leave the squad voice channel
    VRI = DHVoiceReplicationInfo(PRI.VoiceInfo);

    if (VRI != none)
    {
        SquadVCR = VRI.GetSquadChannel(TeamIndex, SquadIndex);

        if (PC != none)
        {
            if (SquadVCR != none)
            {
                PC.ServerLeaveVoiceChannel(SquadVCR.ChannelIndex);
            }

            if (!bHasActiveChannelChanged)
            {
                // Set active channel to the local channel
                PC.Speak(VRI.LocalChannelName);
            }
        }
    }

    if (IsSquadLocked(TeamIndex, SquadIndex) && GetMemberCount(TeamIndex, SquadIndex) < SquadLockMemberCountMin)
    {
        // Forcibly unlock a previously locked squad if the member count has
        // dropped below the required minimum.
        SetSquadLockedInternal(TeamIndex, SquadIndex, false);

        // "The squad has been unlocked."
        BroadcastSquadLocalizedMessage(TeamIndex, SquadIndex, SquadMessageClass, 42);
    }

    if (!IsSquadActive(TeamIndex, SquadIndex))
    {
        // Squad is now empty, reset the squad.
        ResetSquad(TeamIndex, SquadIndex);
    }

    return true;
}

function ResetSquad(int TeamIndex, int SquadIndex)
{
    local int i;

    // Clear any squad-specific map markers so that
    // if the squad becomes active again, there aren't leftover markers
    // sitting around.
    GRI.ClearSquadMapMarkers(TeamIndex, SquadIndex);

    // Destroy all rally points.
    for (i = 0; i < arraycount(RallyPoints); ++i)
    {
        if (RallyPoints[i] != none &&
            RallyPoints[i].GetTeamIndex() == TeamIndex &&
            RallyPoints[i].SquadIndex == SquadIndex)
        {
            RallyPoints[i].Destroy();
        }
    }

    // Clear other squad-specific info.
    SetSquadNextRallyPointTime(TeamIndex, SquadIndex, 0.0);
    ClearSquadBans(TeamIndex, SquadIndex);
    ClearSquadLeaderVolunteers(TeamIndex, SquadIndex);
    ClearSquadMergeRequests(TeamIndex, SquadIndex);
    ClearSquadPromotionRequests(TeamIndex, SquadIndex);
}

// Attempts to make the specified player the leader of the specified squad.
// Returns true if the specified player is now the new squad leader.
function bool CommandeerSquad(DHPlayerReplicationInfo PRI, int TeamIndex, int SquadIndex)
{
    local DHPlayer PC;
    local bool bResult;

    if (!IsInSquad(PRI, TeamIndex, SquadIndex))
    {
        return false;
    }

    // NOTE: It is critically important that be done before the indices are swapped!
    if (GetAssistantSquadLeader(TeamIndex, SquadIndex) == PRI)
    {
        SetAssistantSquadLeader(TeamIndex, SquadIndex, none);
    }

    bResult = SwapSquadMembersByIndex(TeamIndex, SquadIndex, PRI.SquadMemberIndex, SQUAD_LEADER_INDEX);

    if (bResult)
    {
        PC = DHPlayer(PRI.Owner);

        if (PC != none)
        {
            // "You are now the squad leader"
            PC.ReceiveLocalizedMessage(SquadMessageClass, 34);
        }

        // "{0} has become the squad leader"
        BroadcastSquadLocalizedMessage(PRI.Team.TeamIndex, PRI.SquadIndex, SquadMessageClass, 35, PRI);

        UpdateSquadLeaderNoRallyPointsTime(PRI.Team.TeamIndex, PRI.SquadIndex);

        // Reset the squad name to prevent squad leaders being blamed for
        // unsavory names they can inherit.
        SetName(TeamIndex, SquadIndex, "");
    }

    return bResult;
}

// Returns true if the specified player is a member of the specified squad.
simulated function bool IsInSquad(DHPlayerReplicationInfo PRI, byte TeamIndex, int SquadIndex)
{
    return PRI != none && PRI.Team != none && PRI.Team.TeamIndex == TeamIndex && PRI.SquadIndex == SquadIndex;
}

simulated function bool IsSquadJoinable(int TeamIndex, int SquadIndex)
{
    return IsSquadActive(TeamIndex, SquadIndex) &&
           !IsSquadFull(TeamIndex, SquadIndex) &&
           !IsSquadLocked(TeamIndex, SquadIndex) &&
           GetSquadLeader(TeamIndex, SquadIndex) != none;
}

simulated function bool IsAnySquadJoinable(int TeamIndex)
{
    local int i;

    for (i = 0; i < GetTeamSquadLimit(TeamIndex); ++i)
    {
        if (IsSquadJoinable(TeamIndex, i))
        {
            return true;
        }
    }

    return false;
}

// Attempt to make the specified player join the most populous open squad.
// Returns the squad index of the newly joined squad, or -1 if it failed.
function int JoinSquadAuto(DHPlayerReplicationInfo PRI)
{
    local int i, SquadIndex, MaxMemberCount, MemberCount;
    local DHPlayer PC;

    if (PRI == none || PRI.Team == none)
    {
        return -1;
    }

    PC = DHPlayer(PRI.Owner);

    if (PC == none)
    {
        return -1;
    }

    if (PRI.IsInSquad())
    {
        // "You are already in a squad."
        PC.ReceiveLocalizedMessage(SquadMessageClass, 69);
        return -1;
    }

    SquadIndex = -1;

    for (i = 0; i < GetTeamSquadLimit(PRI.Team.TeamIndex); ++i)
    {
        if (!IsSquadJoinable(PRI.Team.TeamIndex, i) ||
            IsPlayerBannedFromSquad(PRI, PRI.Team.TeamIndex, i))
        {
            continue;
        }

        MemberCount = GetMemberCount(PRI.Team.TeamIndex, i);

        if (MemberCount > MaxMemberCount)
        {
            SquadIndex = i;
            MaxMemberCount = MemberCount;
        }
    }

    if (SquadIndex >= 0)
    {
        return JoinSquad(PRI, PRI.Team.TeamIndex, SquadIndex);
    }

    // "There are no squads that you are eligible to join."
    PC.ReceiveLocalizedMessage(SquadMessageClass, 63);

    return -1;
}

private function int GetEmptySquadMemberIndex(byte TeamIndex, int SquadIndex)
{
    local int i;

    for (i = 0; i < GetTeamSquadSize(TeamIndex); ++i)
    {
        if (GetMember(TeamIndex, SquadIndex, i) == none)
        {
            return i;
        }
    }

    return -1;
}

// Attempts to make the specified player join the specified squad.
// Returns the index of the player's new SquadMemberIndex or -1 if
// they were unable to join the squad.
function int JoinSquad(DHPlayerReplicationInfo PRI, byte TeamIndex, int SquadIndex, optional bool bWasInvited, optional bool bIsQuiet)
{
    local int MemberIndex;
    local DHPlayer PC;
    local DHBot Bot;
    local DHVoiceReplicationInfo VRI;

    if (PRI == none || PRI.Team == none || PRI.Team.TeamIndex != TeamIndex)
    {
        return -1;
    }

    PC = DHPlayer(PRI.Owner);
    Bot = DHBot(PRI.Owner);

    if (PC == none && Bot == none)
    {
        return -1;
    }

    if (!IsSquadActive(TeamIndex, SquadIndex) || IsInSquad(PRI, TeamIndex, SquadIndex) || GetSquadLeader(TeamIndex, SquadIndex) == none)
    {
        return -1;
    }

    if (!bWasInvited)
    {
        if (IsPlayerBannedFromSquad(PRI, TeamIndex, SquadIndex))
        {
            // "You are unable to join this squad as you have been banned."
            PC.ReceiveLocalizedMessage(Class'DHSquadMessage', 62);
            return -1;
        }

        if (IsSquadLocked(TeamIndex, SquadIndex))
        {
            return -1;
        }
    }
    
    MemberIndex = GetEmptySquadMemberIndex(TeamIndex, SquadIndex);
    
    if (MemberIndex >= 0)
    {
        // Leave the squad, but do not invalidate the role within LeaveSquad.
        LeaveSquad(PRI, false, true);

        SetMember(TeamIndex, SquadIndex, MemberIndex, PRI);
        
        if (!bIsQuiet)
        {
            // "{0} has joined the squad"
            BroadcastSquadLocalizedMessage(TeamIndex, SquadIndex, SquadMessageClass, 30, PRI);
        }

        if (PC != none)
        {
            // The player may have an invalid role after (for example, joining this squad from another squad).
            MaybeInvalidateRole(PC);

            // If the kicked player was an actual human player, remove them from the squad voice channel.
            VRI = DHVoiceReplicationInfo(PC.VoiceReplicationInfo);

            if (VRI != none)
            {
                VRI.JoinSquadChannel(PRI, TeamIndex, SquadIndex);
                PC.Speak(VRI.SquadChannelName);
            }
        }

        // Clear the squad ban, if it exists.
        ClearSquadBan(TeamIndex, SquadIndex, PRI);
    }
}

// Attempts to kick the specified player from the specified squad.
// Returns true if the the player was successfully kicked from a squad.
function bool KickFromSquad(DHPlayerReplicationInfo PRI, byte TeamIndex, int SquadIndex, DHPlayerReplicationInfo MemberToKick)
{
    local DHPlayer OtherPC;

    if (PRI == none || MemberToKick == none || PRI == MemberToKick)
    {
        return false;
    }

    if (!IsSquadLeader(PRI, TeamIndex, SquadIndex) || !IsInSquad(MemberToKick, TeamIndex, SquadIndex))
    {
        if (PRI.IsLoggedInAsAdmin())
        {
            Class'DarkestHourGame'.static.BroadcastTeamLocalizedMessage(Level,
                                                                        TeamIndex,
                                                                        Class'DHAdminMessage',
                                                                        Class'UInteger'.static.FromShorts(0, SquadIndex),
                                                                        PRI,
                                                                        MemberToKick,
                                                                        self);
        }
        else
        {
            return false;
        }
    }

    LeaveSquad(MemberToKick);

    OtherPC = DHPlayer(MemberToKick.Owner);

    if (OtherPC != none)
    {
        // "You have been kicked from your squad."
        OtherPC.ReceiveLocalizedMessage(SquadMessageClass, 32);
    }

    return true;
}

//==============================================================================
// Banning
//==============================================================================

function bool IsPlayerBannedFromSquad(DHPlayerReplicationInfo PRI, int TeamIndex, int SquadIndex)
{
    local int i;
    local DHPlayer PC;

    if (PRI == none)
    {
        return false;
    }

    PC = DHPlayer(PRI.Owner);

    if (PC == none)
    {
        return false;
    }

    for (i = 0; i < SquadBans.Length; ++i)
    {
        if (SquadBans[i].TeamIndex == TeamIndex &&
            SquadBans[i].SquadIndex == SquadIndex &&
            SquadBans[i].ROID == PC.ROIDHash)
        {
            return true;
        }
    }

    return false;
}

function bool ClearSquadBan(int TeamIndex, int SquadIndex, DHPlayerReplicationInfo PRI)
{
    local int i;
    local DHPlayer PC;

    if (PRI == none)
    {
        return false;
    }

    PC = DHPlayer(PRI.Owner);

    if (PC == none)
    {
        return false;
    }

    for (i = SquadBans.Length - 1; i >= 0; --i)
    {
        if (SquadBans[i].TeamIndex == TeamIndex &&
            SquadBans[i].SquadIndex == SquadIndex &&
            SquadBans[i].ROID == PC.ROIDHash)
        {
            SquadBans.Remove(i, 1);
            return true;
        }
    }

    return false;
}

function ClearSquadBans(int TeamIndex, int SquadIndex)
{
    local int i;

    for (i = SquadBans.Length - 1; i >= 0; --i)
    {
        if (SquadBans[i].TeamIndex == TeamIndex && SquadBans[i].SquadIndex == SquadIndex)
        {
            SquadBans.Remove(i, 1);
        }
    }
}

// Kicks and bans the specified player from the squad.
// Returns true if the player was kicked and is now banned from the squad.
function bool BanFromSquad(DHPlayerReplicationInfo PRI, int TeamIndex, int SquadIndex, DHPlayerReplicationInfo PlayerToBan)
{
    local DHPlayer PC, OtherPC;
    local SquadBan Ban;
    local DHBot Bot;

    if (!KickFromSquad(PRI, TeamIndex, SquadIndex, PlayerToBan))
    {
        return false;
    }

    if (!IsPlayerBannedFromSquad(PlayerToBan, TeamIndex, SquadIndex))
    {
        OtherPC = DHPlayer(PlayerToBan.Owner);

        if (OtherPC == none)
        {
            return false;
        }

        Ban.TeamIndex = TeamIndex;
        Ban.SquadIndex = SquadIndex;
        Ban.ROID = OtherPC.ROIDHash;
        SquadBans[SquadBans.Length] = Ban;

        PC = DHPlayer(PRI.Owner);
        Bot = DHBot(PRI.Owner);

        if (PC != none)
        {
            // "{0} has been banned from the squad."
            PC.ReceiveLocalizedMessage(SquadMessageClass, 61, PlayerToBan);
        }
    }

    return true;
}

// Returns true if the specified player is a member of the specified team.
simulated function bool IsOnTeam(DHPlayerReplicationInfo PRI, int TeamIndex)
{
    return PRI != none && PRI.Team != none && PRI.Team.TeamIndex == TeamIndex;
}

// Sends an invitation to the specified recipient to join the specified squad.
// Returns true if the invitation was successfully sent.
function bool InviteToSquad(DHPlayerReplicationInfo PRI, byte TeamIndex, int SquadIndex, DHPlayerReplicationInfo Recipient)
{
    local DHPlayer PC, OtherPC;
    local DHBot Bot;

    if (Recipient == none ||
        !IsOnTeam(PRI, TeamIndex) ||
        !IsOnTeam(Recipient, TeamIndex) ||
        !IsSquadLeader(PRI, TeamIndex, SquadIndex))
    {
        return false;
    }

    PC = DHPlayer(PRI.Owner);

    if (IsSquadFull(TeamIndex, SquadIndex))
    {
        if (PC != none)
        {
            // "Invitations cannot be sent because your squad is full.";
            PC.ReceiveLocalizedMessage(SquadMessageClass, 37);
        }

        return false;
    }

    if (Recipient.IsInSquad())
    {
        if (PC != none)
        {
            // "Invitation could not be sent because {0} is already in a squad.";
            PC.ReceiveLocalizedMessage(SquadMessageClass, 36, Recipient);
        }

        return false;
    }

    //==========================================================================
    // TODO: make sure invitations are not sent too frequently
    //==========================================================================

    OtherPC = DHPlayer(Recipient.Owner);

    if (OtherPC != none)
    {
        // "{0} has been invited to your squad."
        PC.ReceiveLocalizedMessage(SquadMessageClass, 39, Recipient);

        // "{0} has invited you to join {1} squad."
        OtherPC.ClientSquadInvite(PRI.PlayerName, GetSquadName(TeamIndex, SquadIndex), TeamIndex, SquadIndex);
    }
    else
    {
        // Bots always and immediately accept squad invitations.
        Bot = DHBot(Recipient.Owner);

        if (Bot != none)
        {
            JoinSquad(Recipient, TeamIndex, SquadIndex, true);
        }
    }

    return true;
}

// Returns true if the specified squad is full.
simulated function bool IsSquadFull(int TeamIndex, int SquadIndex)
{
    return GetMemberCount(TeamIndex, SquadIndex) == GetTeamSquadSize(TeamIndex);
}

// Returns true if the specified squad is locked.
simulated function bool IsSquadLocked(int TeamIndex, int SquadIndex)
{
    if (!IsSquadActive(TeamIndex, SquadIndex))
    {
        return false;
    }

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            return AxisLocked[SquadIndex] != 0;
        case ALLIES_TEAM_INDEX:
            return AlliesLocked[SquadIndex] != 0;
        default:
            return false;
    }
}

// Attempts to lock or unlock the specified squad.
function bool SetSquadLocked(DHPlayerReplicationInfo PC, int TeamIndex, int SquadIndex, bool bLocked)
{
    if (!IsSquadLeader(PC, TeamIndex, SquadIndex))
    {
        return false;
    }

    if (SetSquadLockedInternal(TeamIndex, SquadIndex, bLocked))
    {
        if (bLocked)
        {
            // "The squad has been locked."
            BroadcastSquadLocalizedMessage(TeamIndex, SquadIndex, SquadMessageClass, 41);
        }
        else
        {
            // "The squad has been unlocked."
            BroadcastSquadLocalizedMessage(TeamIndex, SquadIndex, SquadMessageClass, 42);
        }

        return true;
    }

    return false;
}

simulated function bool CanSquadBeLocked(int TeamIndex, int SquadIndex)
{
    // Do not allow locking if the member count is below the required minimum.
    return GetMemberCount(TeamIndex, SquadIndex) >= SquadLockMemberCountMin;
}

private function bool SetSquadLockedInternal(int TeamIndex, int SquadIndex, bool bLocked)
{
    if (SquadIndex < 0 || SquadIndex >= GetTeamSquadLimit(TeamIndex))
    {
        return false;
    }

    if (bLocked && !CanSquadBeLocked(TeamIndex, SquadIndex))
    {
        return false;
    }

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            AxisLocked[SquadIndex] = byte(bLocked);
            break;
        case ALLIES_TEAM_INDEX:
            AlliesLocked[SquadIndex] = byte(bLocked);
            break;
        default:
            break;
    }

    return true;
}

function BroadcastSquadLocalizedMessage(byte TeamIndex, int SquadIndex, class<LocalMessage> MessageClass, int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local int i;
    local DHPlayer PC;
    local array<DHPlayerReplicationInfo> SquadMembers;

    GetMembers(TeamIndex, SquadIndex, SquadMembers);

    for (i = 0; i < SquadMembers.Length; ++i)
    {
        if (SquadMembers[i] == none)
        {
            continue;
        }

        PC = DHPlayer(SquadMembers[i].Owner);

        if (PC != none)
        {
            PC.ReceiveLocalizedMessage(MessageClass, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
        }
    }
}

// Returns the name of the specified squad.
// NOTE: Specifying an inactive squad will return the last name of the squad.
simulated function string GetSquadName(int TeamIndex, int SquadIndex)
{
    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            return AxisNames[SquadIndex];
        case ALLIES_TEAM_INDEX:
            return AlliesNames[SquadIndex];
    }

    return "";
}

// Returns the member of the specified squad at the specified member index.
simulated function DHPlayerReplicationInfo GetMember(int TeamIndex, int SquadIndex, int MemberIndex)
{
    local int i;

    i = SquadIndex * GetTeamSquadSize(TeamIndex) + MemberIndex;

    if (i < 0 || i >= arraycount(AxisMembers))
    {
        return none;
    }

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            return AxisMembers[i];
        case ALLIES_TEAM_INDEX:
            return AlliesMembers[i];
    }

    return none;
}

private simulated function DHGameReplicationInfo GetGameReplicationInfo()
{
    local PlayerController PC;

    if (Role == ROLE_Authority)
    {
        return GRI;
    }
    
    PC = Level.GetLocalPlayerController();

    if (PC != none)
    {
        return DHGameReplicationInfo(PC.GameReplicationInfo);
    }

    return none;
}

simulated function int GetUnassignedPlayerCount(int TeamIndex)
{
    local DHGameReplicationInfo MyGRI;
    local DHPlayerReplicationInfo PRI;
    local int i, Count;

    MyGRI = GetGameReplicationInfo();

    if (MyGRI == none)
    {
        return 0;
    }

    for (i = 0; i < MyGRI.PRIArray.Length; ++i)
    {
        PRI = DHPlayerReplicationInfo(MyGRI.PRIArray[i]);

        if (PRI != none && PRI.Team != none && PRI.Team.TeamIndex == TeamIndex && PRI.SquadIndex == -1)
        {
            ++Count;
        }
    }

    return Count;
}

simulated function GetUnassignedPlayers(int TeamIndex, out array<DHPlayerReplicationInfo> UnassignedPlayers)
{
    local DHGameReplicationInfo MyGRI;
    local DHPlayerReplicationInfo PRI;
    local int i;

    MyGRI = GetGameReplicationInfo();

    if (MyGRI == none)
    {
        return;
    }

    UnassignedPlayers.Length = 0;

    for (i = 0; i < MyGRI.PRIArray.Length; ++i)
    {
        PRI = DHPlayerReplicationInfo(MyGRI.PRIArray[i]);

        if (PRI != none && PRI.Team != none && PRI.Team.TeamIndex == TeamIndex && PRI.SquadIndex == -1)
        {
            UnassignedPlayers[UnassignedPlayers.Length] = PRI;
        }
    }
}

// Returns the number of members in the specified squad.
// TODO: Sort of inefficient. Rewrite if you're bored.
simulated function int GetMemberCount(int TeamIndex, int SquadIndex)
{
    local array<DHPlayerReplicationInfo> Members;

    GetMembers(TeamIndex, SquadIndex, Members);

    return Members.Length;
}

// Populates members with the members of the specified squad.
// NOTE: Empty slots are not added to the array.
simulated function GetMembers(int TeamIndex, int SquadIndex, out array<DHPlayerReplicationInfo> Members)
{
    local int i;
    local DHPlayerReplicationInfo PRI;

    Members.Length = 0;

    if (!IsSquadActive(TeamIndex, SquadIndex))
    {
        return;
    }

    for (i = 0; i < GetTeamSquadSize(TeamIndex); ++i)
    {
        PRI = GetMember(TeamIndex, SquadIndex, i);

        if (PRI != none)
        {
            Members[Members.Length] = PRI;
        }
    }
}

// Sets the member of the specified squad and member index to the specified player.
function SetMember(int TeamIndex, int SquadIndex, int MemberIndex, DHPlayerReplicationInfo PRI)
{
    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            AxisMembers[SquadIndex * GetTeamSquadSize(TeamIndex) + MemberIndex] = PRI;
            break;
        case ALLIES_TEAM_INDEX:
            AlliesMembers[SquadIndex * GetTeamSquadSize(TeamIndex) + MemberIndex] = PRI;
            break;
        default:
            return;
    }

    if (PRI != none)
    {
        PRI.SquadIndex = SquadIndex;
        PRI.SquadMemberIndex = MemberIndex;
    }
}

// Returns true if the specified name is already being used by another squad
// on the specified team.
simulated function bool IsSquadNameTaken(int TeamIndex, string Name, optional out int SquadIndex)
{
    local int i;

    for (i = 0; i < GetTeamSquadLimit(TeamIndex); ++i)
    {
        if (IsSquadActive(TeamIndex, i) && GetSquadName(TeamIndex, i) ~= Name)
        {
            SquadIndex = i;

            return true;
        }
    }

    return false;
}

// Sets the specified squad's name to the specified name.
function SetName(int TeamIndex, int SquadIndex, string Name)
{
    local int i;
    local int OutSquadIndex;

    if (Name != "")
    {
        // Trim whitespace from the name.
        Name = Class'UString'.static.Trim(Name);

        if (Len(Name) > SQUAD_NAME_LENGTH_MAX)
        {
            // Name is too long, truncate the name.
            Name = Left(Name, SQUAD_NAME_LENGTH_MAX);
        }

        if (Len(Name) >= SQUAD_NAME_LENGTH_MIN)
        {
            if (IsSquadNameTaken(TeamIndex, Name, OutSquadIndex) && OutSquadIndex != SquadIndex)
            {
                // Squad name is taken, defer to defaults names.
                Name = "";
            }
        }
        else
        {
            // Name is too short, do nothing.
            return;
        }
    }

    if (Name == "")
    {
        // Go through default names and choose a default squad name that hasn't yet been used.
        for (i = 0; i < GetTeamSquadLimit(TeamIndex); ++i)
        {
            if (!IsSquadNameTaken(TeamIndex, GetDefaultSquadName(TeamIndex, i)))
            {
                Name = GetDefaultSquadName(TeamIndex, i);
                break;
            }
        }
    }

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            AxisNames[SquadIndex] = Name;
            break;
        case ALLIES_TEAM_INDEX:
            AlliesNames[SquadIndex] = Name;
            break;
        default:
            break;
    }
}

//==============================================================================
// SQUAD SIGNALS
//==============================================================================

function SendSignal(DHPlayerReplicationInfo PRI, int TeamIndex, int SquadIndex, class<DHSignal> SignalClass, Vector Location, optional Object OptionalObject)
{
    local float Radius;
    local DHPlayer Sender, Recipient;
    local Pawn OtherPawn;

    if (!IsSquadLeader(PRI, TeamIndex, SquadIndex) && !IsSquadAssistant(PRI, TeamIndex, SquadIndex) && !PRI.IsPatron())
    {
        return;
    }

    Sender = DHPlayer(PRI.Owner);

    if (Sender == none || Sender.Pawn == none)
    {
        return;
    }

    Radius = Class'DHUnits'.static.MetersToUnreal(SignalClass.default.SignalRadiusInMeters);

    foreach Sender.Pawn.RadiusActors(Class'Pawn', OtherPawn, Radius)
    {
        Recipient = DHPlayer(OtherPawn.Controller);

        if (SignalClass.static.CanPlayerRecieve(Sender, Recipient))
        {
            Recipient.ClientSignal(SignalClass, Location, OptionalObject);
        }
    }

    SignalClass.static.OnSent(Sender, Location, OptionalObject);
}

function DHSpawnPoint_SquadRallyPoint GetRallyPoint(int TeamIndex, int SquadIndex)
{
    local int i;

    for (i = 0; i < arraycount(RallyPoints); ++i)
    {
        if (RallyPoints[i] != none &&
            RallyPoints[i].GetTeamIndex() == TeamIndex &&
            RallyPoints[i].SquadIndex == SquadIndex)
        {
            return RallyPoints[i];
        }
    }

    return none;
}

simulated function int GetSquadNextRallyPointTime(int TeamIndex, int SquadIndex)
{
    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            return AxisNextRallyPointTimes[SquadIndex];
        case ALLIES_TEAM_INDEX:
            return AlliesNextRallyPointTimes[SquadIndex];
        default:
            return 0;
    }
}

function SetSquadNextRallyPointTime(int TeamIndex, int SquadIndex, int ElapsedTime)
{
    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            AxisNextRallyPointTimes[SquadIndex] = ElapsedTime;
            break;
        case ALLIES_TEAM_INDEX:
            AlliesNextRallyPointTimes[SquadIndex] = ElapsedTime;
            break;
        default:
            break;
    }
}

simulated function bool SquadHasRallyPoint(int TeamIndex, int SquadIndex)
{
    return GetSquadRallyPointCount(TeamIndex, SquadIndex) > 0;
}

simulated function int GetSquadRallyPointCount(int TeamIndex, int SquadIndex)
{
    local int i, Count;

    for (i = 0; i < arraycount(RallyPoints); ++i)
    {
        if (RallyPoints[i] != none &&
            RallyPoints[i].GetTeamIndex() == TeamIndex &&
            RallyPoints[i].SquadIndex == SquadIndex &&
            !RallyPoints[i].bPendingDelete)
        {
            ++Count;
        }
    }

    return Count;
}

simulated function array<DHSpawnPoint_SquadRallyPoint> GetSquadRallyPoints(int TeamIndex, int SquadIndex)
{
    local array<DHSpawnPoint_SquadRallyPoint> SquadRallyPoints;
    local int i;

    for (i = 0; i < arraycount(RallyPoints); ++i)
    {
        if (RallyPoints[i] != none &&
            RallyPoints[i].GetTeamIndex() == TeamIndex &&
            RallyPoints[i].SquadIndex == SquadIndex)
        {
            SquadRallyPoints[SquadRallyPoints.Length] = RallyPoints[i];
        }
    }

    return SquadRallyPoints;
}

simulated function array<DHSpawnPoint_SquadRallyPoint> GetActiveSquadRallyPoints(int TeamIndex, int SquadIndex)
{
    local array<DHSpawnPoint_SquadRallyPoint> ActiveSquadRallyPoints;
    local int i;

    for (i = 0; i < arraycount(RallyPoints); ++i)
    {
        if (RallyPoints[i] != none &&
            RallyPoints[i].GetTeamIndex() == TeamIndex &&
            RallyPoints[i].SquadIndex == SquadIndex &&
            RallyPoints[i].IsActive())
        {
            ActiveSquadRallyPoints[ActiveSquadRallyPoints.Length] = RallyPoints[i];
        }
    }

    return ActiveSquadRallyPoints;
}

// TODO: Some errors are more processing intensive than others.
// Only the actionable, cheap ones should be in this check. Things like the
// the world traces etc. should be omitted.

// TODO: this check should probably only be done periodically (maybe every 0.5 seconds)
// as some of the checks can be a bit costly (distance checks etc.)
simulated function RallyPointPlacementResult GetRallyPointPlacementResult(DHPlayer PC)
{
    local DHPawn P;
    local DHGameReplicationInfo MyGRI;
    local DHPlayerReplicationInfo PRI, OtherPRI;
    local float ClosestBlockingRallyPointDistance, D;
    local int i;
    local RallyPointPlacementResult Result;
    local Pawn OtherPawn;
    local bool bIsNearSquadmate, bIsInFriendlyZone;
    local DHRestrictionVolume RV;
    local DHMineVolume MineVolume;
    local PhysicsVolume PV;
    local DHPawnCollisionTest CT;
    local DHConstructionManager CM;
    local array<DHConstruction> Constructions;
    local Vector L;

    MyGRI = GetGameReplicationInfo();

    // Rally points must be enabled.
    if (PC == none || !bAreRallyPointsEnabled)
    {
        Result.Error.Type = ERROR_Fatal;
        return Result;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    // Must be a squad leader
    if (MyGRI == none || PRI == none || !PRI.IsSquadLeader())
    {
        Result.Error.Type = ERROR_Fatal;
        return Result;
    }

    P = DHPawn(PC.Pawn);

    // Must be an infantryman.
    if (P == none)
    {
        Result.Error.Type = ERROR_NotOnFoot;
        return Result;
    }

    // Determine whether or not we are in the danger zone.
    bIsInFriendlyZone = Class'DHDangerZone'.static.IsIn(MyGRI, P.Location.X, P.Location.Y, Class'UMath'.static.SwapFirstPair(PC.GetTeamNum()));

    if (bIsInFriendlyZone)
    {
        Result.bIsInDangerZone = false;
    }
    else
    {
        Result.bIsInDangerZone = Class'DHDangerZone'.static.IsIn(MyGRI, P.Location.X, P.Location.Y, PC.GetTeamNum());

        if (!bAllowRallyPointsBehindEnemyLines &&
            Result.bIsInDangerZone)
        {
            Result.Error.Type = ERROR_BehindEnemyLines;
            return Result;
        }
    }

    // Must be on foot.
    if (P.Physics != PHYS_Walking)
    {
        Result.Error.Type = ERROR_NotOnFoot;
        return Result;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    ClosestBlockingRallyPointDistance = Class'UFloat'.static.Infinity();

    // Cannot be too close to another rally point.
    for (i = 0; i < arraycount(RallyPoints); ++i)
    {
        if (RallyPoints[i] != none &&
            RallyPoints[i].SquadIndex == PC.GetSquadIndex() &&
            RallyPoints[i].GetTeamIndex() == PC.GetTeamNum())
        {
            D = VSize(RallyPoints[i].Location - P.Location);

            if (D < Class'DHUnits'.static.MetersToUnreal(RallyPointRadiusInMeters))
            {
                if (D < ClosestBlockingRallyPointDistance)
                {
                    ClosestBlockingRallyPointDistance = D;
                }
            }
        }
    }

    if (ClosestBlockingRallyPointDistance != Class'UFloat'.static.Infinity())
    {
        Result.Error.Type = ERROR_TooCloseToOtherRallyPoint;
        Result.Error.OptionalInt = Max(1, RallyPointRadiusInMeters - Class'DHUnits'.static.UnrealToMeters(ClosestBlockingRallyPointDistance));
        return Result;
    }

    // Cannot be inside of an uncontrolled objective.
    for (i = 0; i < arraycount(MyGRI.DHObjectives); ++i)
    {
        if (MyGRI.DHObjectives[i] != none &&
            MyGRI.DHObjectives[i].ObjState != P.GetTeamNum() &&
            MyGRI.DHObjectives[i].WithinArea(P))
        {
            // "You cannot create a squad rally point inside an uncontrolled objective."
            Result.Error.Type = ERROR_InUncontrolledObjective;
            return Result;
        }
    }

    // Cannot place a rally point too soon after placing one recently.
    if (MyGRI.ElapsedTime < GetSquadNextRallyPointTime(PC.GetTeamNum(), PC.GetSquadIndex()))
    {
        Result.Error.Type = ERROR_TooSoon;
        Result.Error.OptionalInt = Max(1, GetSquadNextRallyPointTime(PC.GetTeamNum(), PC.GetSquadIndex()) - MyGRI.ElapsedTime);
        return Result;
    }

    if (Level.NetMode != NM_Standalone && !bIsInFriendlyZone)
    {
        // Must have a teammate nearby.
        // For single-player testing, we can ignore this check.
        foreach P.RadiusActors(Class'Pawn', OtherPawn, Class'DHUnits'.static.MetersToUnreal(RallyPointSquadmatePlacementRadiusInMeters))
        {
            if (OtherPawn != none && !OtherPawn.bDeleteMe && OtherPawn.Health > 0)
            {
                OtherPRI = DHPlayerReplicationInfo(OtherPawn.PlayerReplicationInfo);

                if (PRI != OtherPRI && Class'DHPlayerReplicationInfo'.static.IsInSameSquad(PRI, OtherPRI))
                {
                    bIsNearSquadmate = true;
                }
            }
        }

        if (!bIsNearSquadmate)
        {
            // "You must have at least one other squadmate nearby to establish a rally point."
            Result.Error.Type = ERROR_MissingSquadmate;
            return Result;
        }
    }

    // Must not be touching a restriction volume.
    foreach P.TouchingActors(Class'DHRestrictionVolume', RV)
    {
        if (RV != none && RV.bNoSquadRallyPoints)
        {
            // "You cannot create a squad rally point at this location."
            Result.Error.Type = ERROR_BadLocation;
            return Result;
        }
    }

    // Must be reasonably close to solid ground
    if (P.Trace(Result.HitLocation, Result.HitNormal, P.Location - vect(0, 0, 128.0), P.Location, false) == none)
    {
        // "You cannot create a squad rally point at this location."
        Result.Error.Type = ERROR_BadLocation;
        return Result;
    }

    // Make sure that we are on relatively flat ground
    if (Acos(Result.HitNormal dot vect(0.0, 0.0, 1.0)) > Class'UUnits'.static.DegreesToRadians(35))
    {
        Result.Error.Type = ERROR_BadLocation;
        return Result;
    }

    foreach P.TouchingActors(Class'DHMineVolume', MineVolume)
    {
        if (MineVolume != none && MineVolume.bActive && MineVolume.IsARelevantPawn(P))
        {
            // "You cannot create a squad rally point in a minefield."
            Result.Error.Type = ERROR_BadLocation;
            return Result;
        }
    }

    foreach P.TouchingActors(Class'PhysicsVolume', PV)
    {
        if (PV != none && (PV.bWaterVolume || PV.bPainCausing))
        {
            // "You cannot create a squad rally point in water."
            Result.Error.Type = ERROR_BadLocation;
            return Result;
        }
    }

    // Must not be near a construction that blocks the creation of squad rally points.
    CM = Class'DHConstructionManager'.static.GetInstance(Level);

    if (CM != none)
    {
        Constructions = CM.GetConstructions();

        for (i = 0; i < Constructions.Length; ++i)
        {
            if (Constructions[i] != none && Constructions[i].bShouldBlockSquadRallyPoints)
            {
                if (Class'UCollision'.static.PointInCylinder(
                        Constructions[i].Location,
                        Constructions[i].default.CollisionRadius + P.CollisionRadius,
                        Constructions[i].default.CollisionHeight,
                        Constructions[i].Rotation,
                        P.Location)
                    )
                {
                    // "You cannot create a squad rally point at this location."
                    Result.Error.Type = ERROR_BadLocation;
                    return Result;
                }
            }
        }
    }

    // Finally, do an actual pawn spawn test to ensure that spawning here would
    // in fact work.
    L = Result.HitLocation;
    L.Z += Class'DHPawn'.default.CollisionHeight / 2;

    CT = Spawn(Class'DHPawnCollisionTest',,, L);

    if (CT == none)
    {
        // "You cannot create a squad rally point at this location."
        Result.Error.Type = ERROR_BadLocation;
        return Result;
    }

    CT.Destroy();

    return Result;
}

function DHSpawnPoint_SquadRallyPoint SpawnRallyPoint(DHPlayer PC)
{
    local int i, RallyPointIndex;
    local DHSpawnPoint_SquadRallyPoint RP;
    local Vector V;
    local Rotator R;
    local DarkestHourGame G;
    local RallyPointPlacementResult Result;

    Result = GetRallyPointPlacementResult(PC);

    if (Result.Error.Type != ERROR_None)
    {
        // Display an error message to the user informing them of the error.
        switch (Result.Error.Type)
        {
            case ERROR_NotOnFoot:
                PC.ReceiveLocalizedMessage(SquadMessageClass, 52);
                break;
            case ERROR_TooCloseToOtherRallyPoint:
                PC.ReceiveLocalizedMessage(SquadMessageClass, Class'UInteger'.static.FromShorts(45, Result.Error.OptionalInt));
                break;
            case ERROR_InUncontrolledObjective:
                PC.ReceiveLocalizedMessage(SquadMessageClass, 78);
                break;
            case ERROR_TooSoon:
                PC.ReceiveLocalizedMessage(SquadMessageClass, Class'UInteger'.static.FromShorts(53, Result.Error.OptionalInt));
                break;
            case ERROR_MissingSquadmate:
                PC.ReceiveLocalizedMessage(SquadMessageClass, 47);
                break;
            case ERROR_BadLocation:
                PC.ReceiveLocalizedMessage(SquadMessageClass, 56);
                break;
            case ERROR_BehindEnemyLines:
                PC.ReceiveLocalizedMessage(SquadMessageClass, 80);
                break;
        }

        return none;
    }

    // Find an empty rally point index to use.
    RallyPointIndex = -1;

    for (i = 0; i < arraycount(RallyPoints); ++i)
    {
        if (RallyPoints[i] == none)
        {
            RallyPointIndex = i;
            break;
        }
    }

    if (RallyPointIndex == -1)
    {
        Warn("Too many rally points!");
        return none;
    }

    // Align to the ground
    R = PC.Pawn.Rotation;
    R.Pitch = 0;
    R.Roll = 0;

    V = Result.HitNormal cross Vector(R);
    V = V cross Result.HitNormal;

    R = Rotator(V);
    RP = Spawn(Class'DHSpawnPoint_SquadRallyPoint', none,, Result.HitLocation, R);

    if (RP == none)
    {
        Warn("Failed to spawn squad rally point!");
        return none;
    }

    RP.SetTeamIndex(PC.GetTeamNum());
    RP.SquadIndex = PC.GetSquadIndex();
    RP.RallyPointIndex = RallyPointIndex;
    RP.SpawnsRemaining = GetSquadRallyPointInitialSpawns(RP);
    RP.InstigatorController = PC;

    G = DarkestHourGame(Level.Game);

    if (G != none && G.Metrics != none)
    {
        G.Metrics.OnRallyPointCreated(RP);
    }

    RallyPoints[RallyPointIndex] = RP;

    // "You have create a squad rally point. Secure the area with your squad to establish this rally point."
    PC.ReceiveLocalizedMessage(SquadMessageClass, 48);

    SetSquadNextRallyPointTime(RP.GetTeamIndex(), RP.SquadIndex, Level.Game.GameReplicationInfo.ElapsedTime + default.NextRallyPointInterval);

    return RP;
}

// Returns the initial number of spawns a squad's rally point will have.
function int GetSquadRallyPointInitialSpawns(DHSpawnPoint_SquadRallyPoint RP)
{
    local bool bIsInDangerZone;
    local int InitialSpawns;

    if (RP == none || GRI == none)
    {
        return -1;
    }

    bIsInDangerZone = Class'DHDangerZone'.static.IsIn(GRI, RP.Location.X, RP.Location.Y, RP.GetTeamIndex());

    InitialSpawns = GetMemberCount(RP.GetTeamIndex(), RP.SquadIndex) * RallyPointInitialSpawnsMemberFactor;

    if (bIsInDangerZone)
    {
        InitialSpawns *= RallyPointInitialSpawnsDangerZoneFactor;
    }

    return Max(RallyPointInitialSpawnsMinimum, InitialSpawns);
}

// Function is called when a rally point is destroyed for any reason.
function OnSquadRallyPointDestroyed(DHSpawnPoint_SquadRallyPoint SRP)
{
    if (SRP != none)
    {
        UpdateSquadLeaderNoRallyPointsTime(SRP.GetTeamIndex(), SRP.SquadIndex);
    }
}

function DestroySquadRallyPoint(DHPlayerReplicationInfo PRI, DHSpawnPoint_SquadRallyPoint SRP)
{
    if (PRI == none || SRP == none || !PRI.IsSquadLeader() || PRI.Team.TeamIndex != SRP.GetTeamIndex() || PRI.SquadIndex != SRP.SquadIndex || !SRP.IsActive())
    {
        return;
    }

    // "The squad leader has forcibly destroyed a rally point."
    BroadcastSquadLocalizedMessage(SRP.GetTeamIndex(), SRP.SquadIndex, SquadMessageClass, 57);

    if (SRP.MetricsObject != none)
    {
        SRP.MetricsObject.DestroyedReason = REASON_Deleted;
    }

    SRP.Destroy();
}

function DHPlayer GetSquadLeaderPlayerController(int TeamIndex, int SquadIndex)
{
    local DHPlayerReplicationInfo PRI;

    PRI = GetSquadLeader(TeamIndex, SquadIndex);

    if (PRI == none)
    {
        return none;
    }

    return DHPlayer(PRI.Owner);
}

function UpdateSquadRallyPointInfo(int TeamIndex, int SquadIndex)
{
    local DHPlayer PC;

    PC = GetSquadLeaderPlayerController(TeamIndex, SquadIndex);

    if (PC != none)
    {
        PC.NextSquadRallyPointTime = GetSquadNextRallyPointTime(TeamIndex, SquadIndex);
        PC.SquadRallyPointCount = GetSquadRallyPointCount(TeamIndex, SquadIndex);
    }
}

function SwapRallyPoints(DHPlayerReplicationInfo PRI)
{
    local UComparator Comparator;
    local array<DHSpawnPoint_SquadRallyPoint> ActiveSquadRallyPoints;

    if (PRI != none && PRI.IsSquadLeader())
    {
        ActiveSquadRallyPoints = GetActiveSquadRallyPoints(PRI.Team.TeamIndex, PRI.SquadIndex);

        if (ActiveSquadRallyPoints.Length > 1)
        {
            // Sort active squad rally points, oldest first.
            Comparator = new Class'UComparator';
            Comparator.CompareFunction = RallyPointSortFunction;
            Class'USort'.static.Sort(ActiveSquadRallyPoints, Comparator);

            // Set the oldest squad rally point to now be the newest (block status will be updated next Timer pop!)
            ActiveSquadRallyPoints[0].CreatedTimeSeconds = Level.TimeSeconds;

            // "The squad leader has forcibly changed the currently active rally point."
            BroadcastSquadLocalizedMessage(PRI.Team.TeamIndex, PRI.SquadIndex, SquadMessageClass, 59);
        }
    }
}

function bool RallyPointSortFunction(Object LHS, Object RHS)
{
    return DHSpawnPoint_SquadRallyPoint(LHS).CreatedTimeSeconds > DHSpawnPoint_SquadRallyPoint(RHS).CreatedTimeSeconds;
}

function OnSquadRallyPointActivated(DHSpawnPoint_SquadRallyPoint SRP)
{
    if (SRP != none &&
        SRP.InstigatorController != none &&
        SRP.InstigatorController.GetTeamNum() == SRP.GetTeamIndex() &&
        SRP.InstigatorController.GetSquadIndex() == SRP.SquadIndex)
    {
        SRP.InstigatorController.ReceiveScoreEvent(Class'DHScoreEvent_SquadRallyPointEstablished'.static.Create());
    }

    // "The squad has established a new rally point."
    BroadcastSquadLocalizedMessage(SRP.GetTeamIndex(), SRP.SquadIndex, SquadMessageClass, 44);

    OnSquadRallyPointUpdated(SRP);
}

function OnSquadRallyPointUpdated(DHSpawnPoint_SquadRallyPoint SRP)
{
    if (SRP == none)
    {
        return;
    }

    // "A squad rally point has been spotted by the enemy!"
    if (SRP.bIsExposed)
    {
        BroadcastSquadLocalizedMessage(SRP.GetTeamIndex(), SRP.SquadIndex, SquadMessageClass, 79);
    }
}

function UpdateRallyPoints()
{
    local int i;

    for (i = 0; i < arraycount(RallyPoints); ++i)
    {
        if (RallyPoints[i] != none)
        {
            RallyPoints[i].OnUpdated();
        }
    }
}

function SetTeamSquadSize(int TeamIndex, int SquadSize)
{
    local int OldTeamSquadSize, i;
    local array<DHPlayerReplicationInfo> Members;

    if (SquadSize == 0)
    {
        // If a zero is passed, reset squad sizes back to the default.
        switch (TeamIndex)
        {
            case AXIS_TEAM_INDEX:
                SquadSize = default.AxisSquadSize;
                break;
            case ALLIES_TEAM_INDEX:
                SquadSize = default.AlliesSquadSize;
                break;
            default:
                break;
        }
    }

    OldTeamSquadSize = GetTeamSquadSize(TeamIndex);
    SquadSize = Clamp(SquadSize, SQUAD_SIZE_MIN, SQUAD_SIZE_MAX);

    if (SquadSize < OldTeamSquadSize)
    {
        // The squad size is now less than it was previously!
        // Let's do a check to make sure that existing squads on this team
        // do not exceed the size limit. If they do, we will kick the players
        // from the squads until they are all within the size limit.
        for (i = 0; i < GetTeamSquadLimit(TeamIndex); ++i)
        {
            GetMembers(TeamIndex, i, Members);

            while (Members.Length > SquadSize)
            {
                LeaveSquad(Members[Members.Length - 1], true);
                Members.Remove(Members.Length - 1, 1);
            }
        }
    }

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            AxisSquadSize = SquadSize;
            break;
        case ALLIES_TEAM_INDEX:
            AlliesSquadSize = SquadSize;
            break;
    }
}

// Squad leader volunteer functionality
function int GetSquadLeaderVolunteersIndex(int TeamIndex, int SquadIndex)
{
    local int i;

    for (i = 0; i < SquadLeaderVolunteers.Length; ++i)
    {
        if (SquadLeaderVolunteers[i].TeamIndex == TeamIndex &&
            SquadLeaderVolunteers[i].SquadIndex == SquadIndex)
        {
            return i;
        }
    }

    return -1;
}

function VolunteerForSquadLeader(DHPlayerReplicationInfo PRI, int TeamIndex, int SquadIndex)
{
    local int i;
    local DHPlayer PC;

    if (PRI == none || PRI.Team == none || PRI.Team.TeamIndex != TeamIndex || PRI.SquadIndex != SquadIndex)
    {
        return;
    }

    // Find the squad leader volunteers entry.
    i = GetSquadLeaderVolunteersIndex(TeamIndex, SquadIndex);

    if (i == -1)
    {
        // No entry, create one.
        i = 0;
        SquadLeaderVolunteers.Insert(0, 1);
        SquadLeaderVolunteers[0].TeamIndex = TeamIndex;
        SquadLeaderVolunteers[0].SquadIndex = SquadIndex;
    }

    // Add player to volunteer list.
    Class'UArray'.static.AddUnique(SquadLeaderVolunteers[i].Volunteers, PRI);

    PC = DHPlayer(PRI.Owner);

    if (PC != none)
    {
        // "You have volunteered to be the squad leader. The new squad leader will be selected shortly."
        PC.ReceiveLocalizedMessage(Class'DHSquadMessage', 65);
    }
}

function GetSquadLeaderVolunteers(int TeamIndex, int SquadIndex, out array<DHPlayerReplicationInfo> Volunteers)
{
    local int i, j;
    local DHPlayerReplicationInfo PRI;

    Volunteers.Length = 0;

    i = GetSquadLeaderVolunteersIndex(TeamIndex, SquadIndex);

    if (i == -1)
    {
        return;
    }

    for (j = 0; j < SquadLeaderVolunteers[i].Volunteers.Length; ++j)
    {
        PRI = SquadLeaderVolunteers[i].Volunteers[j];

        if (PRI != none &&
            PRI.Team != none &&
            PRI.Team.TeamIndex == TeamIndex &&
            PRI.SquadIndex == SquadIndex)
        {
            Volunteers[Volunteers.Length] = PRI;
        }
    }
}

function SelectNewSquadLeader(int TeamIndex, int SquadIndex, array<DHPlayerReplicationInfo> Members)
{
    local UComparator ScoreComparator;

    if (!IsSquadActive(TeamIndex, SquadIndex))
    {
        return;
    }

    ScoreComparator = new Class'UComparator';
    ScoreComparator.CompareFunction = ScoreComparatorFunction;
    Class'USort'.static.Sort(Members, ScoreComparator);
    CommandeerSquad(Members[0], TeamIndex, SquadIndex);
}

function StartSquadLeaderDraw(int TeamIndex, int SquadIndex)
{
    local int i;
    local array<DHPlayerReplicationInfo> Members;
    local DHPlayer PC;

    SquadLeaderDraws.Insert(0, 1);
    SquadLeaderDraws[0].TeamIndex = TeamIndex;
    SquadLeaderDraws[0].SquadIndex = SquadIndex;
    SquadLeaderDraws[0].ExpirationTime = Level.Game.GameReplicationInfo.ElapsedTime + SQUAD_LEADER_DRAW_DURATION_SECONDS;

    GetMembers(TeamIndex, SquadIndex, Members);

    for (i = 0; i < Members.Length; ++i)
    {
        PC = DHPlayer(Members[i].Owner);

        if (PC != none)
        {
            PC.ClientSquadLeaderVolunteerPrompt(TeamIndex, SquadIndex, SquadLeaderDraws[0].ExpirationTime);
        }
    }

    // Promotion requests are no longer valid, the vote has started.
    ClearSquadPromotionRequests(TeamIndex, SquadIndex);
}

function ClearSquadLeaderVolunteers(int TeamIndex, int SquadIndex)
{
    local int i;

    i = GetSquadLeaderVolunteersIndex(TeamIndex, SquadIndex);

    if (i != -1)
    {
        SquadLeaderVolunteers.Remove(i, 1);
    }
}

function ClearSquadLeaderVolunteer(DHPlayerReplicationInfo PRI, int TeamIndex, int SquadIndex)
{
    local int i;

    i = GetSquadLeaderVolunteersIndex(TeamIndex, SquadIndex);

    if (i != -1)
    {
        Class'UArray'.static.Erase(SquadLeaderVolunteers[i].Volunteers, PRI);
    }
}

function DisbandSquad(int TeamIndex, int SquadIndex, optional bool bIsQuiet)
{
    local int i;
    local array<DHPlayerReplicationInfo> Members;

    if (!IsSquadActive(TeamIndex, SquadIndex))
    {
        return;
    }

    // Remove all members from the squad.
    GetMembers(TeamIndex, SquadIndex, Members);

    for (i = 0; i < Members.Length; ++i)
    {
        LeaveSquad(Members[i], !bIsQuiet);
    }
}

simulated function int GetAssistantSquadLeaderMemberIndex(int TeamIndex, int SquadIndex)
{
    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            return AxisAssistantSquadLeaderMemberIndices[SquadIndex];
        case ALLIES_TEAM_INDEX:
            return AlliesAssistantSquadLeaderMemberIndices[SquadIndex];
    }

    return -1;
}

// Returns the squad's assistant squad leader, or none if one does not exist.
simulated function DHPlayerReplicationInfo GetAssistantSquadLeader(int TeamIndex, int SquadIndex)
{
    local int MemberIndex;

    if (!IsSquadActive(TeamIndex, SquadIndex))
    {
        return none;
    }

    MemberIndex = GetAssistantSquadLeaderMemberIndex(TeamIndex, SquadIndex);

    if (MemberIndex > 0)
    {
        return GetMember(TeamIndex, SquadIndex, MemberIndex);
    }

    return none;
}

function SetAssistantSquadLeader(int TeamIndex, int SquadIndex, DHPlayerReplicationInfo PRI)
{
    local DHPlayer PC;
    local DHPlayerReplicationInfo ASL;
    local int AssistantSquadLeaderMemberIndex;

    if (!IsSquadActive(TeamIndex, SquadIndex))
    {
        return;
    }

    if (PRI != none)
    {
        if (!IsInSquad(PRI, TeamIndex, SquadIndex) ||
            IsSquadLeader(PRI, TeamIndex, SquadIndex) ||
            IsSquadAssistant(PRI, TeamIndex, SquadIndex))
        {
            return;
        }

        AssistantSquadLeaderMemberIndex = PRI.SquadMemberIndex;
    }
    else
    {
        AssistantSquadLeaderMemberIndex = -1;
    }

    // Get the current assistant and send them a message that they are no longer
    // the assistant.
    ASL = GetAssistantSquadLeader(TeamIndex, SquadIndex);

    if (ASL != none)
    {
        ASL.bIsSquadAssistant = false;

        PC = DHPlayer(ASL.Owner);

        if (PC != none)
        {
            // "You are no longer the assistant squad leader."
            PC.ReceiveLocalizedMessage(Class'DHSquadMessage', 71);

            MaybeInvalidateRole(PC);
            MaybeLeaveCommandVoiceChannel(ASL);
        }
    }

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            AxisAssistantSquadLeaderMemberIndices[SquadIndex] = AssistantSquadLeaderMemberIndex;
            break;
        case ALLIES_TEAM_INDEX:
            AlliesAssistantSquadLeaderMemberIndices[SquadIndex] = AssistantSquadLeaderMemberIndex;
            break;
    }

    if (PRI != none)
    {
        PRI.bIsSquadAssistant = true;

        PC = DHPlayer(PRI.Owner);

        if (PC != none)
        {
            // "You are now the assistant squad leader."
            PC.ReceiveLocalizedMessage(Class'DHSquadMessage', 70);
        }

        // "{0} is now the assistant squad leader."
        BroadcastSquadLocalizedMessage(TeamIndex, SquadIndex, Class'DHSquadMessage', 72, PRI);
    }
}

// Sets the player's role to be the default role if they are no longer
// qualified to have their current role.
function MaybeInvalidateRole(DHPlayer PC)
{
    local DHRoleInfo RI;
    local int DefaultRoleIndex;

    if (PC == none) { return; }

    RI = DHRoleInfo(PC.GetRoleInfo());

    if (RI == none) { return; }

    if (PC.GetRoleEnabledResult(RI) != RER_Enabled)
    {
        // "You are no longer qualified to be {name}."
        PC.ReceiveLocalizedMessage(Class'DHGameMessage', 24,,, RI);

        DefaultRoleIndex = GRI.GetDefaultRoleIndexForTeam(PC.GetTeamNum());

        // Set the player's role to a default so that they don't occupy the role.abs
        // Also set the spawn paramters to be invalid so they are forced to go to
        // the deploy menu upon death.
        PC.ServerSetPlayerInfo(255, DefaultRoleIndex, -1, -1, PC.SpawnPointIndex, PC.VehiclePoolIndex);
        PC.bSpawnParametersInvalidated = true;
    }
}

function bool MaybeLeaveCommandVoiceChannel(DHPlayerReplicationInfo PRI)
{
    local DHVoiceReplicationInfo VRI;
    local DHPlayer PC;
    local VoiceChatRoom VCR;

    if (PRI == none || PRI.CanAccessCommandChannel() || PRI.Team == none)
    {
        return false;
    }

    VRI = DHVoiceReplicationInfo(PRI.VoiceInfo);
    PC = DHPlayer(PRI.Owner);

    if (VRI == none || PC == none)
    {
        return false;
    }

    VCR = VRI.GetChannel(VRI.CommandChannelName, PRI.Team.TeamIndex);

    if (VCR == none)
    {
        return false;
    }

    PC.ServerLeaveVoiceChannel(VCR.ChannelIndex);

    // Set the next channel in the hierarchy as active
    if (PRI.IsInSquad())
    {
        VRI.JoinSquadChannel(PRI, PRI.Team.TeamIndex, PRI.SquadIndex);
        PC.Speak("SQUAD");
    }
    else
    {
        PC.Speak(VRI.LocalChannelName);
    }
}

//==============================================================================
// SQUAD MERGING
//==============================================================================
simulated function bool CanMergeSquads(int TeamIndex, int SenderSquadIndex, int RecipientSquadIndex)
{
    local int TotalMemberCount;

    if (!IsSquadActive(TeamIndex, SenderSquadIndex) || !IsSquadActive(TeamIndex, RecipientSquadIndex))
    {
        // Invalid squad index(es).
        return false;
    }

    if (!HasSquadLeader(TeamIndex, SenderSquadIndex) || !HasSquadLeader(TeamIndex, RecipientSquadIndex))
    {
        // One or more squads does not have a squad leader.
        return false;
    }

    TotalMemberCount = GetMemberCount(TeamIndex, SenderSquadIndex) + GetMemberCount(TeamIndex, RecipientSquadIndex);

    if (TotalMemberCount > GetTeamSquadSize(TeamIndex))
    {
        // Merged squad would exceed the squad size limit.
        return false;
    }

    return true;
}

// Takes all of the players from the source squad and merges them into the destination squad.
function MergeSquads(int TeamIndex, int SenderSquadIndex, int RecipientSquadIndex)
{
    local int i, SwitchValue;
    local array<DHPlayerReplicationInfo> RecipientSquadMembers;

    if (!CanMergeSquads(TeamIndex, SenderSquadIndex, RecipientSquadIndex))
    {
        return;
    }

    // "Your squad has been merged into {0} squad. Your squad leader is now {1}."
    SwitchValue = Class'UInteger'.static.FromShorts(74, SenderSquadIndex);
    BroadcastSquadLocalizedMessage(TeamIndex, RecipientSquadIndex, SquadMessageClass, SwitchValue, GetSquadLeader(TeamIndex, SenderSquadIndex),, self);

    // "Another squad has been merged into your squad."
    BroadcastSquadLocalizedMessage(TeamIndex, SenderSquadIndex, SquadMessageClass, 75);

    // Fetch the list of players to be moved before disbanding the squad.
    GetMembers(TeamIndex, RecipientSquadIndex, RecipientSquadMembers);

    // Quietly disband the source squad.
    DisbandSquad(TeamIndex, RecipientSquadIndex, true);

    // Move all players from the source squad to the destination squad.
    for (i = 0; i < RecipientSquadMembers.Length; ++i)
    {
        // Quietly join the squad.
        JoinSquad(RecipientSquadMembers[i], TeamIndex, SenderSquadIndex, true, true);
    }
}

function ESquadMergeRequestResult SendSquadMergeRequest(DHPlayer SenderPC, int TeamIndex, int SenderSquadIndex, int RecipientSquadIndex)
{
    local SquadMergeRequest MR;
    local DHPlayerReplicationInfo RecipientPRI, SenderPRI;
    local DHPlayer RecipientPC;
    local int SquadMergeRequestIndex;

    if (Level.TimeSeconds < SenderPC.NextSquadMergeRequestTimeSeconds)
    {
        // TODO: send a message indicating that the player must wait to send another SMR
        return RESULT_Throttled;
    }

    // Ensure that the sender is valid.
    if (GetSquadLeader(TeamIndex, SenderSquadIndex).Owner != SenderPC)
    {
        return RESULT_Fatal;
    }

    // Ensure that the squads are actually capable of being merged.
    if (!CanMergeSquads(TeamIndex, SenderSquadIndex, RecipientSquadIndex))
    {
        return RESULT_CannotMerge;
    }

    RecipientPRI = GetSquadLeader(TeamIndex, RecipientSquadIndex);
    SenderPRI = GetSquadLeader(TeamIndex, SenderSquadIndex);

    if (RecipientPRI == none || SenderPRI == none)
    {
        return RESULT_Fatal;
    }

    RecipientPC = DHPlayer(RecipientPRI.Owner);

    if (RecipientPC == none)
    {
        return RESULT_Fatal;
    }

    // If another squad merge request already exists, just stop.
    SquadMergeRequestIndex = GetSquadMergeRequestIndex(TeamIndex, SenderSquadIndex, RecipientSquadIndex);

    if (SquadMergeRequestIndex != -1)
    {
        return RESULT_Duplicate;
    }

    MR.ID = NextSquadMergeRequestID++;
    MR.TeamIndex = TeamIndex;
    MR.SenderSquadIndex = SenderSquadIndex;
    MR.RecipientSquadIndex = RecipientSquadIndex;
    SquadMergeRequests[SquadMergeRequests.Length] = MR;

    // Send the merge request to the recipient.
    RecipientPC.ClientReceiveSquadMergeRequest(MR.ID, SenderPRI.PlayerName, GetSquadName(TeamIndex, SenderSquadIndex));

    // Set the next merge request time for the sender.
    SenderPC.NextSquadMergeRequestTimeSeconds = Level.TimeSeconds + SQUAD_MERGE_REQUEST_INTERVAL;

    return RESULT_Sent;
}

function int GetSquadMergeRequestIndex(int TeamIndex, int SenderSquadIndex, int RecipientSquadIndex)
{
    local int i;

    for (i = 0; i < SquadMergeRequests.Length; ++i)
    {
        if (SquadMergeRequests[i].TeamIndex == TeamIndex &&
            SquadMergeRequests[i].SenderSquadIndex == SenderSquadIndex &&
            SquadMergeRequests[i].RecipientSquadIndex == RecipientSquadIndex)
        {
            return i;
        }
    }

    return -1;
}

function int GetSquadMergeRequestIndexByID(int ID)
{
    local int i;

    for (i = 0; i < SquadMergeRequests.Length; ++i)
    {
        if (SquadMergeRequests[i].ID == ID)
        {
            return i;
        }
    }

    return -1;
}

function bool DenySquadMergeRequest(DHPlayer SenderPC, int SquadMergeRequestID)
{
    local int SquadMergeRequestIndex;
    local SquadMergeRequest SMR;
    local DHPlayerReplicationInfo PRI;
    local DHPlayer PC;

    SquadMergeRequestIndex = GetSquadMergeRequestIndexByID(SquadMergeRequestID);

    if (SquadMergeRequestIndex != -1)
    {
        SMR = SquadMergeRequests[SquadMergeRequestIndex];
        PRI = GetSquadLeader(SMR.TeamIndex, SMR.SenderSquadIndex);

        if (PRI != none)
        {
            PC = DHPlayer(PRI.Owner);

            if (PC != none)
            {
                // "Your squad merge request was denied by {0} squad."
                PC.ReceiveLocalizedMessage(SquadMessageClass, Class'UInteger'.static.FromShorts(76, SMR.RecipientSquadIndex), PRI,, self);
            }
        }

        SquadMergeRequests.Remove(SquadMergeRequestIndex, 1);

        return true;
    }

    return false;
}

function bool AcceptSquadMergeRequest(DHPlayer SenderPC, int SquadMergeRequestID)
{
    local int SquadMergeRequestIndex;
    local SquadMergeRequest SMR;

    SquadMergeRequestIndex = GetSquadMergeRequestIndexByID(SquadMergeRequestID);

    if (SquadMergeRequestIndex != -1)
    {
        SMR = SquadMergeRequests[SquadMergeRequestIndex];

        if (!CanMergeSquads(SMR.TeamIndex, SMR.SenderSquadIndex, SMR.RecipientSquadIndex))
        {
            // "The squad merge failed."
            SenderPC.ReceiveLocalizedMessage(SquadMessageClass, 77);

            // Clear the merge request.
            ClearSquadMergeRequests(SMR.TeamIndex, SMR.RecipientSquadIndex);

            return false;
        }

        // Merge the squads (note that this also clears the request when
        // the recipient squad disbands).
        MergeSquads(SMR.TeamIndex, SMR.SenderSquadIndex, SMR.RecipientSquadIndex);

        return true;
    }

    return false;
}

// Clears all squad merge requests related to the specified squad.
function ClearSquadMergeRequests(int TeamIndex, int SquadIndex)
{
    local int i;

    for (i = SquadMergeRequests.Length - 1; i >= 0; --i)
    {
        if (SquadMergeRequests[i].TeamIndex == TeamIndex &&
            (SquadMergeRequests[i].SenderSquadIndex == SquadIndex || SquadMergeRequests[i].RecipientSquadIndex == SquadIndex))
        {
            SquadMergeRequests.Remove(i, 1);
        }
    }
}

static function string GetSquadMergeRequestResultString(int Result)
{
    return default.SquadMergeRequestResultStrings[Result];
}

static function string GetSquadPromotionRequestResultString(int Result)
{
    return default.SquadPromotionRequestResultStrings[Result];
}

// Squad Promotion Requests
function ESquadPromotionRequestResult SendSquadPromotionRequest(DHPlayerReplicationInfo SenderPRI, DHPlayerReplicationInfo RecipientPRI, int TeamIndex, int SquadIndex)
{
    local SquadPromotionRequest PR;
    local DHPlayer SenderPC, RecipientPC;
    local int i;
    
    if (!IsSquadLeader(SenderPRI, TeamIndex, SquadIndex) || !IsInSquad(RecipientPRI, TeamIndex, SquadIndex))
    {
        return SPPR_Fatal;
    }

    SenderPC = DHPlayer(SenderPRI.Owner);
    RecipientPC = DHPlayer(RecipientPRI.Owner);

    if (DHBot(RecipientPRI.Owner) != none)
    {
        // Automatically accept the request & make the bot the squad leader.
        CommandeerSquad(RecipientPRI, TeamIndex, SquadIndex);

        return SPPR_Sent;
    }

    if (SenderPC == none || RecipientPC == none)
    {
        return SPPR_Fatal;
    }
    
    for (i = 0; i < SquadPromotionRequests.Length; ++i)
    {
        if (SquadPromotionRequests[i].TeamIndex == TeamIndex &&
            SquadPromotionRequests[i].SquadIndex == SquadIndex &&
            SquadPromotionRequests[i].Recipient == RecipientPRI)
        {
            // "You have already sent {0} a squad promotion request."
            SenderPC.ReceiveLocalizedMessage(SquadMessageClass, 85, RecipientPRI);

            // There is already an identical active promotion request.
            return SPPR_Duplicate;
        }
    }

    // Add the promotion request.
    PR.ID = NextSquadPromotionRequestID++;
    PR.TeamIndex = TeamIndex;
    PR.SquadIndex = SquadIndex;
    PR.Recipient = RecipientPRI;
    PR.Sender = SenderPRI;
    SquadPromotionRequests[SquadPromotionRequests.Length] = PR;

    // Send the promotion request to the recipient.
    RecipientPC.ClientReceiveSquadPromotionRequest(PR.ID, SenderPRI.PlayerName, GetSquadName(TeamIndex, SquadIndex));

    // Notify the sender that the request has been sent.
    SenderPC.ReceiveLocalizedMessage(SquadMessageClass, 84, RecipientPRI);

    return SPPR_Sent;
}

function ClearSquadPromotionRequests(int TeamIndex, int SquadIndex)
{
    local int i;

    for (i = SquadPromotionRequests.Length - 1; i >= 0; --i)
    {
        if (SquadPromotionRequests[i].TeamIndex == TeamIndex && SquadPromotionRequests[i].SquadIndex == SquadIndex)
        {
            SquadPromotionRequests.Remove(i, 1);
        }
    }
}

function int GetSquadPromotionRequestIndexByID(int SquadPromotionRequestID)
{
    local int i;

    for (i = 0; i < SquadPromotionRequests.Length; ++i)
    {
        if (SquadPromotionRequests[i].ID == SquadPromotionRequestID)
        {
            return i;
        }
    }

    return -1;
}

function bool IsSquadPromotionRequestValid(SquadPromotionRequest SPR)
{
    return IsSquadActive(SPR.TeamIndex, SPR.SquadIndex) &&
           IsInSquad(SPR.Recipient, SPR.TeamIndex, SPR.SquadIndex) &&
           !IsSquadLeader(SPR.Recipient, SPR.TeamIndex, SPR.SquadIndex);
}

function bool DenySquadPromotionRequest(DHPlayer SenderPC, int SquadPromotionRequestID)
{
    local int SquadPromotionRequestIndex;
    local SquadPromotionRequest SPR;
    local PlayerController PC;
    
    SquadPromotionRequestIndex = GetSquadPromotionRequestIndexByID(SquadPromotionRequestID);

    if (SquadPromotionRequestIndex == -1)
    {
        return false;
    }

    SPR = SquadPromotionRequests[SquadPromotionRequestIndex];

    // Send a message to the sender that the request has been denied (only if they are still the squad leader of this squad).
    if (IsSquadPromotionRequestValid(SPR) &&
        IsSquadLeader(SPR.Sender, SPR.TeamIndex, SPR.SquadIndex))
    {
        PC = PlayerController(SPR.Sender.Owner);

        if (PC != none)
        {
            // "Your squad promotion request has been denied by {0}."
            PC.ReceiveLocalizedMessage(SquadMessageClass, 82, SPR.Recipient);
        }
    }

    // Remove the request.
    SquadPromotionRequests.Remove(SquadPromotionRequestIndex, 1);
}

function bool AcceptSquadPromotionRequest(DHPlayer SenderPC, int SquadPromotionRequestID)
{
    local int SquadPromotionRequestIndex;
    local SquadPromotionRequest SPR;

    SquadPromotionRequestIndex = GetSquadPromotionRequestIndexByID(SquadPromotionRequestID);

    if (SquadPromotionRequestIndex == -1)
    {
        // Squad promotion request doesn't exist or has expired.
        return false;
    }

    SPR = SquadPromotionRequests[SquadPromotionRequestIndex];
    
    if (!IsSquadPromotionRequestValid(SPR))
    {
        return false;
    }

    CommandeerSquad(SPR.Recipient, SPR.TeamIndex, SPR.SquadIndex);
    ClearSquadPromotionRequests(SPR.TeamIndex, SPR.SquadIndex);

    return true;
}

simulated function array<DHPlayerReplicationInfo> GetSquadLeaders(int TeamIndex)
{
    local int i;
    local array<DHPlayerReplicationInfo> SquadLeaders;

    for (i = 0; i < TEAM_SQUADS_MAX; ++i)
    {
        if (!IsSquadActive(TeamIndex, i))
        {
            continue;
        }

        SquadLeaders[SquadLeaders.Length] = GetSquadLeader(TeamIndex, i);
    }

    return SquadLeaders;
}

// Remember the time when a squad leader loses all rally points, or joins a
// squad with no rally points.
function UpdateSquadLeaderNoRallyPointsTime(int TeamIndex, int SquadIndex)
{
    local DHPlayerReplicationInfo SL;

    if (!bAreRallyPointsEnabled)
    {
        return;
    }

    SL = GetSquadLeader(TeamIndex, SquadIndex);

    if (SL != none && GRI != none && !SquadHasRallyPoint(TeamIndex, SquadIndex))
    {
        SL.NoRallyPointsTime = GRI.ElapsedTime;
    }

}

// Returns true if SL hasn't placed any rally points in time specified by
// SquadLeaderRallyPointInactivityThreshold.
simulated function bool SquadHadNoRallyPointsInAwhile(int TeamIndex, int SquadIndex)
{
    local DHGameReplicationInfo MyGRI;
    local DHPlayerReplicationInfo SL;

    if (!bAreRallyPointsEnabled)
    {
        return false;
    }

    MyGRI = GetGameReplicationInfo();
    SL = GetSquadLeader(TeamIndex, SquadIndex);

    return SL != none &&
           MyGRI != none &&
           MyGRI.ElapsedTime >= SL.NoRallyPointsTime + SquadLeaderRallyPointInactivityThreshold &&
           !SquadHasRallyPoint(TeamIndex, SquadIndex);
}

defaultproperties
{
    AlliesSquadSize=10
    AxisSquadSize=8
    bAllowRallyPointsBehindEnemyLines=false
    RallyPointInitialDelaySeconds=15.0
    RallyPointChangeLeaderDelaySeconds=30.0
    RallyPointRadiusInMeters=100.0
    SquadMessageClass=Class'DHSquadMessage'
    NextRallyPointInterval=45
    SquadLockMemberCountMin=2
    RallyPointSquadmatePlacementRadiusInMeters=25.0
    RallyPointInitialSpawnsMinimum=10
    RallyPointInitialSpawnsMemberFactor=2.5
    RallyPointInitialSpawnsDangerZoneFactor=0.25
    SquadLeaderRallyPointInactivityThreshold=60

    SquadMergeRequestResultStrings(0)="Please wait a short time before sending another squad merge request."
    SquadMergeRequestResultStrings(1)="An error occurred while sending the squad merge request."
    SquadMergeRequestResultStrings(2)="A merge request cannot be sent to this squad."
    SquadMergeRequestResultStrings(3)="There is already an existing merge request for this squad."
    SquadMergeRequestResultStrings(4)="Squad merge request has been sent."

    SquadPromotionRequestResultStrings(0)="An error occurred while sending the squad promotion request."
    SquadPromotionRequestResultStrings(1)="There is already an existing squad leader promotion request for this player."
    SquadPromotionRequestResultStrings(2)="Squad leader promotion request has been sent."

    JoinSquadNagMessageInterval=30
}
