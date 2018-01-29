//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHSquadReplicationInfo extends ReplicationInfo;

const SQUAD_SIZE_MIN = 8;
const SQUAD_SIZE_MAX = 12;
const SQUAD_RALLY_POINTS_MAX = 2;           // The number of squad rally points that can be exist at one time.
const SQUAD_RALLY_POINTS_ACTIVE_MAX = 1;    // The number of squad rally points that are "active" at one time.
const TEAM_SQUAD_MEMBERS_MAX = 64;
const TEAM_SQUADS_MAX = 8;                  // SQUAD_SIZE_MIN / TEAM_SQUAD_MEMBERS_MAX

const RALLY_POINTS_MAX = 32;                // TEAM_SQUADS_MAX * SQUAD_RALLY_POINTS_MAX * 2

const SQUAD_NAME_LENGTH_MIN = 3;
const SQUAD_NAME_LENGTH_MAX = 16;

const SQUAD_LEADER_INDEX = 0;

const SQUAD_DISBAND_THRESHOLD = 2;
const SQUAD_LEADER_DRAW_DURATION_SECONDS = 15;

// This nightmare is necessary because UnrealScript cannot replicate large
// arrays of structs.
var private DHPlayerReplicationInfo AxisMembers[TEAM_SQUAD_MEMBERS_MAX];
var private string                  AxisNames[TEAM_SQUADS_MAX];
var private byte                    AxisLocked[TEAM_SQUADS_MAX];
var private float                   AxisNextRallyPointTimes[TEAM_SQUADS_MAX];   // Stores the next time (in relation to Level.TimeSeconds) that a squad can place a new rally point.

// Rally points
var DHSpawnPoint_SquadRallyPoint    RallyPoints[RALLY_POINTS_MAX];
var float                           RallyPointInitialDelaySeconds;
var float                           RallyPointChangeLeaderDelaySeconds;
var float                           RallyPointRadiusInMeters;
var float                           RallyPointSquadmatePlacementRadiusInMeters;
var int                             RallyPointInitialSpawnsMinimum;
var float                           RallyPointInitialSpawnsMemberMultiplier;

var private DHPlayerReplicationInfo AlliesMembers[TEAM_SQUAD_MEMBERS_MAX];
var private string                  AlliesNames[TEAM_SQUADS_MAX];
var private byte                    AlliesLocked[TEAM_SQUADS_MAX];
var private float                   AlliesNextRallyPointTimes[TEAM_SQUADS_MAX]; // Stores the next time (in relation to Level.TimeSeconds) that a squad can place a new rally point.

var private array<string>           AlliesDefaultSquadNames;
var private array<string>           AxisDefaultSquadNames;

var globalconfig private int        AxisSquadSize;
var globalconfig private int        AlliesSquadSize;

var class<LocalMessage>             SquadMessageClass;

var TreeMap_string_int              InvitationExpirations;

var int                             NextRallyPointInterval;
var bool                            bAreRallyPointsEnabled;

var int                             SquadLockMemberCountMin;    // The amount of squad member required to be able to lock a squad and keep it locked.

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

struct SquadBan
{
    var int TeamIndex;
    var int SquadIndex;
    var string ROID;
};
var array<SquadBan>                 SquadBans;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        AxisSquadSize, AlliesSquadSize;

    reliable if (bNetDirty && Role == ROLE_Authority)
        AxisMembers, AxisNames, AxisLocked, AlliesMembers, AlliesNames,
        AlliesLocked, bAreRallyPointsEnabled, RallyPoints;
}

function PostBeginPlay()
{
    local DH_LevelInfo LI;

    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        // TODO: make sure invitations can't be sent so damned frequently!
        InvitationExpirations = new class'TreeMap_string_int';

        SetTeamSquadSize(AXIS_TEAM_INDEX, AxisSquadSize);
        SetTeamSquadSize(ALLIES_TEAM_INDEX, AlliesSquadSize);

        foreach AllActors(class'DH_LevelInfo', LI)
        {
            bAreRallyPointsEnabled = LI.bAreRallyPointsEnabled;
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

function Timer()
{
    local DHPlayer PC;
    local Controller OtherController;
    local DHPlayerReplicationInfo PRI, OtherPRI;
    local Controller C;
    local int i, TeamIndex, SquadIndex, UnblockedCount;
    local array<DHSpawnPoint_SquadRallyPoint> SquadRallyPoints, ActiveSquadRallyPoints;
    local UComparator Comparator;
    local array<DHPlayerReplicationInfo> Volunteers;

    // We want our player to know where his squadmates are at all times by
    // looking at the situation map. However, since the player may not have
    // all squadmates replicated on his machine, he needs another way to know
    // his squadmates' locations and rotations.
    //
    // The method below sends the position (X, Y) and rotation (Z) of each
    // member in the players' squad every 2 seconds.
    for (C = Level.ControllerList; C != none; C = C.nextController)
    {
        PC = DHPlayer(C);

        if (PC == none)
        {
            continue;
        }

        PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

        if (PRI == none || !PRI.IsInSquad())
        {
            continue;
        }

        for (i = 0; i < GetTeamSquadSize(PC.GetTeamNum()); ++i)
        {
            OtherPRI = GetMember(PC.GetTeamNum(), PRI.SquadIndex, i);

            if (OtherPRI != none)
            {
                OtherController = Controller(OtherPRI.Owner);

                if (OtherController != none && OtherController.Pawn != none)
                {
                    PC.SquadMemberLocations[i].X = OtherController.Pawn.Location.X;
                    PC.SquadMemberLocations[i].Y = OtherController.Pawn.Location.Y;
                    PC.SquadMemberLocations[i].Z = OtherController.Pawn.Rotation.Yaw;
                    continue;
                }
            }

            PC.SquadMemberLocations[i] = vect(0, 0, 0);
        }
    }

    // Rally point logic.
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
                SquadRallyPoints[i].Step();
            }

            // Sort active rally point list by creation time, oldest first.
            ActiveSquadRallyPoints = GetActiveSquadRallyPoints(TeamIndex, SquadIndex);
            Comparator = new class'UComparator';
            Comparator.CompareFunction = RallyPointSortFunction;
            class'USort'.static.Sort(ActiveSquadRallyPoints, Comparator);

            // Check if this squad already has more than the maximum rally points.
            // If so, forcibly delete the oldest ones.
            while (ActiveSquadRallyPoints.Length > SQUAD_RALLY_POINTS_MAX)
            {
                RallyPoints[ActiveSquadRallyPoints[0].RallyPointIndex].Destroy();
                ActiveSquadRallyPoints.Remove(0, 1);
            }

            // Count how many active are non-blocked, if it's more than
            // the maximum allowed, block the oldest ones (their block-state
            // will be overwritten by Step on the next timer pop)
            UnblockedCount = 0;

            for (i = ActiveSquadRallyPoints.Length - 1; i >= 0; --i)
            {
                if (!ActiveSquadRallyPoints[i].IsBlocked())
                {
                    ++UnblockedCount;
                }

                if (UnblockedCount > SQUAD_RALLY_POINTS_ACTIVE_MAX)
                {
                    ActiveSquadRallyPoints[i].BlockReason = SPBR_Full;

                    // If a squad rally point is blocked because it isn't the
                    // primary squad rally point at the moment, let's award an
                    // additional spawn every 30 seconds.
                    ActiveSquadRallyPoints[i].SpawnAccrualTimer += 1;

                    if (ActiveSquadRallyPoints[i].SpawnAccrualTimer >= ActiveSquadRallyPoints[i].SpawnAccrualThreshold)
                    {
                        ActiveSquadRallyPoints[i].SpawnAccrualTimer = 0;
                        ActiveSquadRallyPoints[i].SpawnsRemaining = Min(ActiveSquadRallyPoints[i].SpawnsRemaining + 1, GetSquadRallyPointInitialSpawns(TeamIndex, SquadIndex));
                    }
                }
                else
                {
                    ActiveSquadRallyPoints[i].SpawnAccrualTimer = 0;
                }
            }
        }
    }

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
            // Draw ended! Let's see who the new squad leader is.
            GetSquadLeaderVolunteers(TeamIndex, SquadIndex, Volunteers);

            if (Volunteers.Length == 0)
            {
                if (GetMemberCount(TeamIndex, SquadIndex) <= SQUAD_DISBAND_THRESHOLD)
                {
                    // "Your squad has been disbanded because the squad is too
                    // small and no members volunteered to be squad leader."
                    BroadcastSquadLocalizedMessage(TeamIndex, SquadIndex, SquadMessageClass, 67);
                    DisbandSquad(TeamIndex, SquadIndex);
                }
                else
                {
                    // No volunteers, but the squad is big enough to not be
                    // disbanded, so someone in the squad is going to randomly
                    // be assigned the squad leader.
                    BroadcastSquadLocalizedMessage(TeamIndex, SquadIndex, SquadMessageClass, 66);
                    GetMembers(TeamIndex, SquadIndex, Volunteers);
                }
            }

            if (IsSquadActive(TeamIndex, SquadIndex))
            {
                SelectNewSquadLeader(TeamIndex, SquadIndex, Volunteers);
            }

            // New squad leader has been selected, remove draw from the list.
            SquadLeaderDraws.Remove(i, 1);
        }
    }
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

    return TEAM_SQUAD_MEMBERS_MAX / GetTeamSquadSize(TeamIndex);
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

// Returns true if the specified player is the squad leader of the specified squad.
simulated function bool IsSquadLeader(DHPlayerReplicationInfo PRI, int TeamIndex, int SquadIndex)
{
    if (PRI == none || PRI.SquadIndex == -1 || PRI.Team == none || PRI.Team.TeamIndex != TeamIndex || PRI.SquadIndex != SquadIndex)
    {
        return false;
    }

    return PRI.SquadMemberIndex == SQUAD_LEADER_INDEX;
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

    if (A == B || !class'DHPlayerReplicationInfo'.static.IsInSameSquad(A, B))
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
    if (SquadIndex < 0 || SquadIndex > GetTeamSquadLimit(TeamIndex))
    {
        return "";
    }

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            return default.AxisDefaultSquadNames[SquadIndex];
        default:
            return default.AlliesDefaultSquadNames[SquadIndex];
    }
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
            SetSquadNextRallyPointTime(TeamIndex, i, Level.TimeSeconds + RallyPointInitialDelaySeconds);

            return i;
        }
    }

    return -1;
}

// Changes the squad leader. Returns true if the squad leader was successfully changed.
function bool ChangeSquadLeader(DHPlayerReplicationInfo PRI, int TeamIndex, int SquadIndex, DHPlayerReplicationInfo NewSquadLeader)
{
    local DHPlayer PC;
    local DHPlayer OtherPC;

    if (PRI == none)
    {
        return false;
    }

    PC = DHPlayer(PRI.Owner);

    if (PC == none)
    {
        return false;
    }

    if (!IsSquadLeader(PRI, TeamIndex, SquadIndex))
    {
        // Player is not a squad leader.
        return false;
    }

    if (PRI == NewSquadLeader || !class'DHPlayerReplicationInfo'.static.IsInSameSquad(PRI, NewSquadLeader))
    {
        return false;
    }

    // Rescind squad leader volunteer application.
    ClearSquadLeaderVolunteer(PRI, TeamIndex, SquadIndex);

    if (!SwapSquadMembers(PRI, NewSquadLeader))
    {
        return false;
    }

    // "You are no longer the squad leader"
    PC.ReceiveLocalizedMessage(SquadMessageClass, 33);

    OtherPC = DHPlayer(NewSquadLeader.Owner);

    if (OtherPC != none)
    {
        // "You are now the squad leader"
        OtherPC.ReceiveLocalizedMessage(SquadMessageClass, 34);
    }

    // "{0} has become the squad leader"
    BroadcastSquadLocalizedMessage(PRI.Team.TeamIndex, PRI.SquadIndex, SquadMessageClass, 35, NewSquadLeader);

    // Have a slight delay in placing rally points to dissuade players
    // from trying to exploit the system.
    SetSquadNextRallyPointTime(TeamIndex, SquadIndex, Level.TimeSeconds + RallyPointChangeLeaderDelaySeconds);

    return true;
}

function bool ScoreComparatorFunction(Object LHS, Object RHS)
{
    return DHPlayerReplicationInfo(LHS).Score < DHPlayerReplicationInfo(RHS).Score;
}

// Makes the specified player leave their squad, if it exists.
// Returns true if player successfully leaves his squad.
// The player is guaranteed to not be a member of a squad after this
// call, regardless of the return value.
function bool LeaveSquad(DHPlayerReplicationInfo PRI, optional bool bShouldShowLeftMessage)
{
    local int TeamIndex, SquadIndex, SquadMemberIndex;
    local DHPlayer PC;
    local DHBot Bot;
    local DHVoiceReplicationInfo VRI;
    local DHGameReplicationInfo GRI;
    local VoiceChatRoom SquadVCR;
    local int i;
    local array<DHPlayerReplicationInfo> Volunteers;

    if (PRI == none || PRI.Team == none)
    {
        return false;
    }

    PC = DHPlayer(PRI.Owner);
    Bot = DHBot(PRI.Owner);

    if (PC == none && Bot == none)
    {
        return false;
    }

    if (PC != none)
    {
        GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    }

    TeamIndex = PRI.Team.TeamIndex;
    SquadIndex = PRI.SquadIndex;
    SquadMemberIndex = PRI.SquadMemberIndex;

    if (GetMember(TeamIndex, SquadIndex, SquadMemberIndex) != PRI)
    {
        return false;
    }

    // Remove squad member.
    SetMember(TeamIndex, SquadIndex, SquadMemberIndex, none);
    PRI.SquadIndex = -1;
    PRI.SquadMemberIndex = -1;

    // Unreserve squad-only vehicle selection
    UnreserveSquadVehicle(PC);

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
        // "The leader has left the squad."
        BroadcastSquadLocalizedMessage(TeamIndex, SquadIndex, SquadMessageClass, 40);

        GetSquadLeaderVolunteers(TeamIndex, SquadIndex, Volunteers);

        if (Volunteers.Length > 0)
        {
            // There are no volunteers, so let's make one of them the new
            // squad leader without delay.
            SelectNewSquadLeader(TeamIndex, SquadIndex, Volunteers);
        }
        else
        {
            // No volunteers, start a new squad leader draw.
            StartSquadLeaderDraw(TeamIndex, SquadIndex);
        }
    }

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

            // Set active channel to the local channel
            PC.Speak(VRI.LocalChannelName);
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
        // Squad is now empty, so clear any squad-specific map markers so that
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

        SetSquadNextRallyPointTime(TeamIndex, SquadIndex, 0.0);
        ClearSquadBans(TeamIndex, SquadIndex);
        ClearSquadLeaderVolunteers(TeamIndex, SquadIndex);
    }

    return true;
}

// HACK: If the player had a squad-only vehicle reserved, unreserve it and
// mark his spawn settings as invalid. I don't particularly like this. In future
// it would be nice to have some sort of "verify spawn settings" thing we can
// run elsewhere instead, since the SRI shouldn't have to care or know about
// the vehicle reservation system.
function UnreserveSquadVehicle(DHPlayer PC)
{
    local DHGameReplicationInfo GRI;
    local class<DHVehicle> VC;

    if (PC != none)
    {
        GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    }

    if (GRI == none)
    {
        return;
    }

    VC = class<DHVehicle>(GRI.GetVehiclePoolVehicleClass(PC.VehiclePoolIndex));

    if (VC != none && VC.default.bMustBeInSquadToSpawn)
    {
        GRI.UnreserveVehicle(PC);
        PC.SpawnPointIndex = 900;   // HACK: this forces the user into the deploy menu
        PC.bSpawnPointInvalidated = true;
    }
}

// Attempts to make the specified player the leader of the specified squad.
// Returns true if the specified player is now the new squad leader.
function bool CommandeerSquad(DHPlayerReplicationInfo PRI, int TeamIndex, int SquadIndex)
{
    local DHPlayer PC;
    local bool bResult;

    if (!IsInSquad(PRI, TeamIndex, SquadIndex) ||
        HasSquadLeader(TeamIndex, SquadIndex))
    {
        return false;
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

    if (PRI == none || PRI.Team == none || PRI.IsInSquad())
    {
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

    PC = DHPlayer(PRI.Owner);

    if (PC != none)
    {
        // "There are no squads that you are eligible to join."
        PC.ReceiveLocalizedMessage(SquadMessageClass, 63);
    }

    return -1;
}

// Attempts to make the specified player join the specified squad.
// Returns the index of the player's new SquadMemberIndex or -1 if
// they were unable to join the squad.
function int JoinSquad(DHPlayerReplicationInfo PRI, byte TeamIndex, int SquadIndex, optional bool bWasInvited)
{
    local bool bDidJoinSquad;
    local int i;
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
            PC.ReceiveLocalizedMessage(class'DHSquadMessage', 62);
            return -1;
        }

        if (IsSquadLocked(TeamIndex, SquadIndex))
        {
            return -1;
        }
    }

    for (i = 0; i < GetTeamSquadSize(TeamIndex); ++i)
    {
        if (GetMember(TeamIndex, SquadIndex, i) == none)
        {
            LeaveSquad(PRI);

            SetMember(TeamIndex, SquadIndex, i, PRI);

            bDidJoinSquad = true;

            break;
        }
    }

    if (bDidJoinSquad)
    {
        // "{0} has joined the squad"
        BroadcastSquadLocalizedMessage(TeamIndex, SquadIndex, SquadMessageClass, 30, PRI);

        if (PC != none)
        {
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
        return false;
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
        Name = class'UString'.static.Trim(Name);

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

function SendSquadSignal(DHPlayerReplicationInfo PRI, int TeamIndex, int SquadIndex, class<DHSquadSignal> SignalClass, vector Location)
{
    local int i;
    local array<DHPlayerReplicationInfo> Members;
    local DHPlayer MyPC, OtherPC;

    if (!IsSquadLeader(PRI, TeamIndex, SquadIndex))
    {
        return;
    }

    MyPC = DHPlayer(PRI.Owner);

    if (MyPC == none || MyPC.Pawn == none)
    {
        return;
    }

    GetMembers(TeamIndex, SquadIndex, Members);

    for (i = 0; i < Members.Length; ++i)
    {
        OtherPC = DHPlayer(Members[i].Owner);

        if (OtherPC != none &&
            OtherPC.Pawn != none &&
            VSize(OtherPC.Pawn.Location - MyPC.Pawn.Location) < class'DHUnits'.static.MetersToUnreal(50))
        {
            OtherPC.ClientSquadSignal(SignalClass, Location);
        }
    }
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

function float GetSquadNextRallyPointTime(int TeamIndex, int SquadIndex)
{
    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            return AxisNextRallyPointTimes[SquadIndex];
        case ALLIES_TEAM_INDEX:
            return AlliesNextRallyPointTimes[SquadIndex];
        default:
            return 0.0;
    }
}

function SetSquadNextRallyPointTime(int TeamIndex, int SquadIndex, float TimeSeconds)
{
    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            AxisNextRallyPointTimes[SquadIndex] = TimeSeconds;
            break;
        case ALLIES_TEAM_INDEX:
            AlliesNextRallyPointTimes[SquadIndex] = TimeSeconds;
            break;
        default:
            break;
    }
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

function DHSpawnPoint_SquadRallyPoint SpawnRallyPoint(DHPlayer PC)
{
    local DHSpawnPoint_SquadRallyPoint RP;
    local Pawn OtherPawn;
    local DHPawn P;
    local DHPlayerReplicationInfo PRI, OtherPRI;
    local vector HitLocation, HitNormal, V;
    local int i, RallyPointIndex;
    local bool bIsNearSquadmate;
    local rotator R;
    local DHMineVolume MineVolume;
    local PhysicsVolume PV;
    local int SecondsToWait;
    local DHPawnCollisionTest CT;
    local vector L;
    local DHRestrictionVolume RV;
    local float D, ClosestBlockingRallyPointDistance;
    local DHConstructionManager CM;
    local array<DHConstruction> Constructions;

    if (PC == none || !bAreRallyPointsEnabled)
    {
        return none;
    }

    P = DHPawn(PC.Pawn);

    // Must be on foot as an infantryman
    if (P == none || P.Physics != PHYS_Walking)
    {
        // "You must be on foot to create a rally point."
        PC.ReceiveLocalizedMessage(SquadMessageClass, 52);

        return none;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    // Must be a squad leader
    if (PRI == none || !PRI.IsSquadLeader())
    {
        return none;
    }

    ClosestBlockingRallyPointDistance = class'UFloat'.static.Infinity();

    // Cannot be too close to another rally point.
    for (i = 0; i < arraycount(RallyPoints); ++i)
    {
        if (RallyPoints[i] != none && RallyPoints[i].GetTeamIndex() == PC.GetTeamNum() && RallyPoints[i].SquadIndex == PC.GetSquadIndex())
        {
            D = VSize(RallyPoints[i].Location - P.Location);

            if (D < class'DHUnits'.static.MetersToUnreal(RallyPointRadiusInMeters))
            {
                if (D < ClosestBlockingRallyPointDistance)
                {
                    ClosestBlockingRallyPointDistance = D;
                }
            }
        }
    }

    if (ClosestBlockingRallyPointDistance != class'UFloat'.static.Infinity())
    {
        // "You must be an additional {0} meters away from your squad's other rally point."
        PC.ReceiveLocalizedMessage(SquadMessageClass, class'UInteger'.static.FromShorts(45, Max(1, RallyPointRadiusInMeters - class'DHUnits'.static.UnrealToMeters(ClosestBlockingRallyPointDistance))));

        return none;
    }

    // Cannot place a rally point too soon after placing one recently.
    if (Level.TimeSeconds < GetSquadNextRallyPointTime(PC.GetTeamNum(), PC.GetSquadIndex()))
    {
        SecondsToWait = Max(1, int(GetSquadNextRallyPointTime(PC.GetTeamNum(), PC.GetSquadIndex()) - Level.TimeSeconds));

        // "You must wait {0} seconds before creating a new squad rally point."
        PC.ReceiveLocalizedMessage(SquadMessageClass, class'UInteger'.static.FromShorts(53, SecondsToWait));

        return none;
    }

    if (Level.NetMode != NM_Standalone)
    {
        // Must have a teammate nearby
        foreach P.RadiusActors(class'Pawn', OtherPawn, class'DHUnits'.static.MetersToUnreal(RallyPointSquadmatePlacementRadiusInMeters))
        {
            if (OtherPawn != none && !OtherPawn.bDeleteMe && OtherPawn.Health > 0)
            {
                OtherPRI = DHPlayerReplicationInfo(OtherPawn.PlayerReplicationInfo);

                if (PRI != OtherPRI && class'DHPlayerReplicationInfo'.static.IsInSameSquad(PRI, OtherPRI))
                {
                    bIsNearSquadmate = true;
                }
            }
        }

        if (!bIsNearSquadmate)
        {
            // "You must have at least one other squadmate nearby to establish a rally point."
            PC.ReceiveLocalizedMessage(SquadMessageClass, 47);

            return none;
        }
    }

    // Must not be touching a restriction volume.
    foreach P.TouchingActors(class'DHRestrictionVolume', RV)
    {
        if (RV != none && RV.bNoSquadRallyPoints)
        {
            // "You cannot create a squad rally point at this location."
            PC.ReceiveLocalizedMessage(SquadMessageClass, 56);

            return none;
        }
    }

    // Must not be near a construction that blocks the creation of squad rally points.
    CM = class'DHConstructionManager'.static.GetInstance(Level);

    if (CM != none)
    {
        Constructions = CM.GetConstructions();

        for (i = 0; i < Constructions.Length; ++i)
        {
            if (Constructions[i] != none && Constructions[i].bShouldBlockSquadRallyPoints)
            {
                if (VSize(P.Location - Constructions[i].Location) - P.CollisionRadius - Constructions[i].default.CollisionRadius < 0.0)
                {
                    // "You cannot create a squad rally point at this location."
                    PC.ReceiveLocalizedMessage(SquadMessageClass, 60,,, Constructions[i]);

                    return none;
                }
            }
        }
    }

    // Must be reasonably close to solid ground
    if (P.Trace(HitLocation, HitNormal, P.Location - vect(0, 0, 128.0), P.Location, false) == none)
    {
        // "You cannot create a squad rally point at this location."
        PC.ReceiveLocalizedMessage(SquadMessageClass, 56);

        return none;
    }

    L = HitLocation;
    L.Z += class'DHPawn'.default.CollisionHeight / 2;

    CT = Spawn(class'DHPawnCollisionTest',,, L);

    if (CT == none)
    {
        // "You cannot create a squad rally point at this location."
        PC.ReceiveLocalizedMessage(SquadMessageClass, 56);

        return none;
    }

    CT.Destroy();

    foreach P.TouchingActors(class'DHMineVolume', MineVolume)
    {
        if (MineVolume != none && MineVolume.bActive && MineVolume.IsARelevantPawn(P))
        {
            // "You cannot create a squad rally point in a minefield."
            PC.ReceiveLocalizedMessage(SquadMessageClass, 50);

            return none;
        }
    }

    foreach P.TouchingActors(class'PhysicsVolume', PV)
    {
        if (PV == none)
        {
            continue;
        }

        if (PV.bWaterVolume)
        {
            // "You cannot create a squad rally point in water."
            PC.ReceiveLocalizedMessage(SquadMessageClass, 51);

            return none;
        }
        else if (PV.bPainCausing)
        {
            return none;
        }
    }

    // Make sure that we are on relatively flat ground
    if (Acos(HitNormal dot vect(0.0, 0.0, 1.0)) > class'UUnits'.static.DegreesToRadians(35))
    {
        PC.ReceiveLocalizedMessage(SquadMessageClass, 49);

        return none;
    }

    // Found an empty rally point index to use.
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
    R = P.Rotation;
    R.Pitch = 0;
    R.Roll = 0;

    V = HitNormal cross vector(R);
    V = V cross HitNormal;

    R = rotator(V);

    RP = Spawn(class'DHSpawnPoint_SquadRallyPoint', none,, HitLocation, R);

    if (RP == none)
    {
        Warn("Failed to spawn squad rally point!");
        return none;
    }

    RP.SetTeamIndex(P.GetTeamNum());
    RP.SquadIndex = PRI.SquadIndex;
    RP.RallyPointIndex = RallyPointIndex;
    RP.SpawnsRemaining = GetSquadRallyPointInitialSpawns(P.GetTeamNum(), PRI.SquadIndex);

    RallyPoints[RallyPointIndex] = RP;

    // "You have create a squad rally point. Secure the area with your squad to establish this rally point."
    PC.ReceiveLocalizedMessage(SquadMessageClass, 48);

    SetSquadNextRallyPointTime(RP.GetTeamIndex(), RP.SquadIndex, Level.TimeSeconds + default.NextRallyPointInterval);

    return RP;
}

// Returns the initial number of spawns a squad's rally point will have.
function int GetSquadRallyPointInitialSpawns(int TeamIndex, int SquadIndex)
{
    return Max(RallyPointInitialSpawnsMinimum, GetMemberCount(TeamIndex, SquadIndex) * RallyPointInitialSpawnsMemberMultiplier);
}

function DestroySquadRallyPoint(DHPlayerReplicationInfo PRI, DHSpawnPoint_SquadRallyPoint SRP)
{
    if (PRI == none || SRP == none || !PRI.IsSquadLeader() || PRI.Team.TeamIndex != SRP.GetTeamIndex() || PRI.SquadIndex != SRP.SquadIndex || !SRP.IsActive())
    {
        return;
    }

    // "The squad leader has forcibly destroyed a rally point."
    BroadcastSquadLocalizedMessage(SRP.GetTeamIndex(), SRP.SquadIndex, SquadMessageClass, 57);

    SRP.Destroy();
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
            Comparator = new class'UComparator';
            Comparator.CompareFunction = RallyPointSortFunction;
            class'USort'.static.Sort(ActiveSquadRallyPoints, Comparator);

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
    // "The squad has established a new rally point."
    BroadcastSquadLocalizedMessage(SRP.GetTeamIndex(), SRP.SquadIndex, SquadMessageClass, 44);
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
    class'UArray'.static.AddUnique(SquadLeaderVolunteers[i].Volunteers, PRI);

    PC = DHPlayer(PRI.Owner);

    if (PC != none)
    {
        // "You have volunteered to be the squad leader. The new squad leader will be selected shortly."
        PC.ReceiveLocalizedMessage(class'DHSquadMessage', 65);
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

    ScoreComparator = new class'UComparator';
    ScoreComparator.CompareFunction = ScoreComparatorFunction;
    class'USort'.static.Sort(Members, ScoreComparator);
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
        class'UArray'.static.Erase(SquadLeaderVolunteers[i].Volunteers, PRI);
    }
}

function DisbandSquad(int TeamIndex, int SquadIndex)
{
    local int i;
    local array<DHPlayerReplicationInfo> Members;

    if (!IsSquadActive(TeamIndex, SquadIndex))
    {
        return;
    }

    GetMembers(TeamIndex, SquadIndex, Members);

    for (i = 0; i < Members.Length; ++i)
    {
        LeaveSquad(Members[i]);
    }
}

defaultproperties
{
    AlliesSquadSize=10
    AxisSquadSize=8
    RallyPointInitialDelaySeconds=15.0
    RallyPointChangeLeaderDelaySeconds=30.0
    RallyPointRadiusInMeters=100.0
    AlliesDefaultSquadNames(0)="Able"
    AlliesDefaultSquadNames(1)="Baker"
    AlliesDefaultSquadNames(2)="Charlie"
    AlliesDefaultSquadNames(3)="Dog"
    AlliesDefaultSquadNames(4)="Easy"
    AlliesDefaultSquadNames(5)="Fox"
    AlliesDefaultSquadNames(6)="George"
    AlliesDefaultSquadNames(7)="How"
    AxisDefaultSquadNames(0)="Anton"
    AxisDefaultSquadNames(1)="Berta"
    AxisDefaultSquadNames(2)="Caesar"
    AxisDefaultSquadNames(3)="Dora"
    AxisDefaultSquadNames(4)="Emil"
    AxisDefaultSquadNames(5)="Fritz"
    AxisDefaultSquadNames(6)="Gustav"
    AxisDefaultSquadNames(7)="Heinrich"
    SquadMessageClass=class'DHSquadMessage'
    NextRallyPointInterval=60
    SquadLockMemberCountMin=3
    RallyPointSquadmatePlacementRadiusInMeters=15.0
    RallyPointInitialSpawnsMinimum=10
    RallyPointInitialSpawnsMemberMultiplier=2.5
}
