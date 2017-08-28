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
const TEAM_SQUADS_MAX = 8;  // SQUAD_SIZE_MIN / TEAM_SQUAD_MEMBERS_MAX

const RALLY_POINTS_MAX = 32;    // TEAM_SQUADS_MAX * SQUAD_RALLY_POINTS_MAX * 2

const SQUAD_NAME_LENGTH_MIN = 3;
const SQUAD_NAME_LENGTH_MAX = 16;

const SQUAD_LEADER_INDEX = 0;

enum ESquadOrderType
{
    ORDER_None,
    ORDER_Attack,
    ORDER_Defend,
    ORDER_Count
};

enum ESquadSignalType
{
    SIGNAL_Fire,
    SIGNAL_Move,
    SIGNAL_Count
};

// This nightmare is necessary because UnrealScript cannot replicate structs
// of any reasonable size.
var private DHPlayerReplicationInfo AxisMembers[TEAM_SQUAD_MEMBERS_MAX];
var private string                  AxisNames[TEAM_SQUADS_MAX];
var private byte                    AxisLocked[TEAM_SQUADS_MAX];
var private ESquadOrderType         AxisOrderTypes[TEAM_SQUADS_MAX];
var private vector                  AxisOrderLocations[TEAM_SQUADS_MAX];
var private float                   AxisNextRallyPointTimes[TEAM_SQUADS_MAX];   // Stores the next time (in relation to Level.TimeSeconds) that a squad can place a new rally point.

// Rally points
var DHSpawnPoint_SquadRallyPoint    RallyPoints[RALLY_POINTS_MAX];
var float                           RallyPointInitialDelaySeconds;
var float                           RallyPointChangeLeaderDelaySeconds;

var private DHPlayerReplicationInfo AlliesMembers[TEAM_SQUAD_MEMBERS_MAX];
var private string                  AlliesNames[TEAM_SQUADS_MAX];
var private byte                    AlliesLocked[TEAM_SQUADS_MAX];
var private ESquadOrderType         AlliesOrderTypes[TEAM_SQUADS_MAX];
var private vector                  AlliesOrderLocations[TEAM_SQUADS_MAX];
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

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        AxisSquadSize, AlliesSquadSize;

    reliable if (bNetDirty && Role == ROLE_Authority)
        AxisMembers, AxisNames, AxisLocked, AlliesMembers, AlliesNames,
        AlliesLocked, AxisOrderTypes, AxisOrderLocations, AlliesOrderTypes,
        AlliesOrderLocations, bAreRallyPointsEnabled, RallyPoints;
}

function PostBeginPlay()
{
    local DH_LevelInfo LI;

    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        // TODO: make sure invitations can't be sent so damned frequently!
        InvitationExpirations = new class'TreeMap_string_int';

        AxisSquadSize = Clamp(AxisSquadSize, SQUAD_SIZE_MIN, SQUAD_SIZE_MAX);
        AlliesSquadSize = Clamp(AlliesSquadSize, SQUAD_SIZE_MIN, SQUAD_SIZE_MAX);

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
    local DHPlayer OtherPC;
    local DHPlayerReplicationInfo PRI, OtherPRI;
    local Controller C;
    local int i, TeamIndex, SquadIndex, UnblockedCount;
    local array<DHSpawnPoint_SquadRallyPoint> SquadRallyPoints, ActiveSquadRallyPoints;
    local UComparator Comparator;

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
                OtherPC = DHPlayer(OtherPRI.Owner);

                if (OtherPC != none && OtherPC.Pawn != none)
                {
                    PC.SquadMemberLocations[i].X = OtherPC.Pawn.Location.X;
                    PC.SquadMemberLocations[i].Y = OtherPC.Pawn.Location.Y;
                    PC.SquadMemberLocations[i].Z = OtherPC.Pawn.Rotation.Yaw;

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
                        ActiveSquadRallyPoints[i].SpawnsRemaining = Min(ActiveSquadRallyPoints[i].SpawnsRemaining + 1, class'DHSpawnPoint_SquadRallyPoint'.default.SpawnsRemaining);
                    }
                }
                else
                {
                    ActiveSquadRallyPoints[i].SpawnAccrualTimer = 0;
                }
            }
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
function bool LeaveSquad(DHPlayerReplicationInfo PRI)
{
    local int TeamIndex, SquadIndex, SquadMemberIndex;
    local DHPlayer PC;
    local DHBot Bot;
    local DHVoiceReplicationInfo VRI;
    local VoiceChatRoom SquadVCR, TeamVCR;
    local int i;
    local array<DHPlayerReplicationInfo> Members;
    local UComparator ScoreComparator;

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

    TeamIndex = PRI.Team.TeamIndex;
    SquadIndex = PRI.SquadIndex;
    SquadMemberIndex = PRI.SquadMemberIndex;

    if (GetMember(TeamIndex, SquadIndex, SquadMemberIndex) != PRI)
    {
        return false;
    }

    // Remove squad member.
    SetMember(TeamIndex, SquadIndex, SquadMemberIndex, none);

    // "{0} has left the squad."
    BroadcastSquadLocalizedMessage(TeamIndex, SquadIndex, SquadMessageClass, 31, PRI);

    if (SquadMemberIndex == SQUAD_LEADER_INDEX)
    {
        // "The leader has left the squad."
        BroadcastSquadLocalizedMessage(TeamIndex, SquadIndex, SquadMessageClass, 40);

        // Squad no longer has a leader. Automatically set a new based on who has the highest score.
        GetMembers(TeamIndex, SquadIndex, Members);
        ScoreComparator = new class'UComparator';
        ScoreComparator.CompareFunction = ScoreComparatorFunction;
        class'USort'.static.Sort(Members, ScoreComparator);

        if (Members.Length > 0)
        {
            CommandeerSquad(Members[0], TeamIndex, SquadIndex);
        }
    }

    // Leave the squad voice channel
    VRI = DHVoiceReplicationInfo(PRI.VoiceInfo);

    if (VRI != none)
    {
        SquadVCR = VRI.GetSquadChannel(TeamIndex, SquadIndex);

        if (SquadVCR != none)
        {
            TeamVCR = VRI.GetChannel("Unassigned", TeamIndex);

            // Change the player's voice channel to the "team" channel.
            Level.Game.ChangeVoiceChannel(PRI, TeamVCR.ChannelIndex, SquadVCR.ChannelIndex);

            if (PC != none && TeamVCR != none && TeamVCR.IsMember(PRI))
            {
                PC.ClientSetActiveRoom(TeamVCR.ChannelIndex);
            }

            if (PC != none)
            {
                PC.ServerLeaveVoiceChannel(SquadVCR.ChannelIndex);
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
        // Squad is now empty, so clear the orders so that if the squad becomes
        // active again, there aren't leftover orders sitting around.
        InternalSetSquadOrder(TeamIndex, SquadIndex, ORDER_None, vect(0, 0, 0));

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
    }

    PRI.SquadIndex = -1;
    PRI.SquadMemberIndex = -1;

    return true;
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
    return IsSquadActive(TeamIndex, SquadIndex) && !IsSquadFull(TeamIndex, SquadIndex) && !IsSquadLocked(TeamIndex, SquadIndex);
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

    if (PRI == none || PRI.Team == none || PRI.IsInSquad())
    {
        return -1;
    }

    SquadIndex = -1;

    for (i = 0; i < GetTeamSquadLimit(PRI.Team.TeamIndex); ++i)
    {
        if (!IsSquadJoinable(PRI.Team.TeamIndex, i))
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

    if (!IsSquadActive(TeamIndex, SquadIndex) || IsInSquad(PRI, TeamIndex, SquadIndex))
    {
        return -1;
    }

    if (!bWasInvited && IsSquadLocked(TeamIndex, SquadIndex))
    {
        return -1;
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
                PC.Speak("SQUAD");
            }
        }
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
// SQUAD ORDERS
//==============================================================================

simulated function bool GetSquadOrder(int TeamIndex, int SquadIndex, out ESquadOrderType Type, out vector Location)
{
    if (!IsSquadActive(TeamIndex, SquadIndex))
    {
        return false;
    }

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            Type = AxisOrderTypes[SquadIndex];
            Location = AxisOrderLocations[SquadIndex];
            break;
        case ALLIES_TEAM_INDEX:
            Type = AlliesOrderTypes[SquadIndex];
            Location = AlliesOrderLocations[SquadIndex];
            break;
        default:
            return false;
    }

    return true;
}

function SetSquadOrder(DHPlayerReplicationInfo PRI, int TeamIndex, int SquadIndex, ESquadOrderType Type, vector Location)
{
    local Controller C;

    if (!IsSquadLeader(PRI, TeamIndex, SquadIndex))
    {
        return;
    }

    if (Level.TimeSeconds - GetSquadOrderTime(TeamIndex, SquadIndex) < 2)
    {
        // "Please wait before making a new order"
        for (C = Level.ControllerList; C != none; C = C.nextController)
        {
            if (C.PlayerReplicationInfo == PRI && C.Pawn != none)
            {
                C.Pawn.ReceiveLocalizedMessage(class'DHSquadOrderMessage', 0);

                break;
            }
        }

        return;
    }

    InternalSetSquadOrder(TeamIndex, SquadIndex, Type, Location);
}

function float GetSquadOrderTime(int TeamIndex, int SquadIndex)
{
    local ESquadOrderType Type;
    local vector L;

    GetSquadOrder(TeamIndex, SquadIndex, Type, L);

    return L.Z;
}

function SendSquadSignal(DHPlayerReplicationInfo PRI, int TeamIndex, int SquadIndex, ESquadSignalType Type, vector Location)
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

    // TODO: make sure there's no spam?

    GetMembers(TeamIndex, SquadIndex, Members);

    for (i = 0; i < Members.Length; ++i)
    {
        OtherPC = DHPlayer(Members[i].Owner);

        if (OtherPC != none &&
            OtherPC.Pawn != none &&
            VSize(OtherPC.Pawn.Location - MyPC.Pawn.Location) < class'DHUnits'.static.MetersToUnreal(50))
        {
            OtherPC.ClientSquadSignal(Type, Location);
        }
    }
}

private function InternalSetSquadOrder(int TeamIndex, int SquadIndex, ESquadOrderType Type, optional vector Location)
{
    local ESquadOrderType CurrentType;
    local vector CurrentLocation;

    if (!IsSquadActive(TeamIndex, SquadIndex))
    {
        return;
    }

    GetSquadOrder(TeamIndex, SquadIndex, CurrentType, CurrentLocation);

    if (CurrentType == ORDER_None && Type == ORDER_None)
    {
        // If an order is already cleared, don't bother continuing.
        return;
    }

    if (CurrentType == Type && CurrentLocation == Location)
    {
        // The type and location are the same, so don't bother continuing.
        return;
    }

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            AxisOrderTypes[SquadIndex] = Type;
            AxisOrderLocations[SquadIndex] = Location;
            AxisOrderLocations[SquadIndex].Z = Level.TimeSeconds;
            break;
        case ALLIES_TEAM_INDEX:
            AlliesOrderTypes[SquadIndex] = Type;
            AlliesOrderLocations[SquadIndex] = Location;
            AlliesOrderLocations[SquadIndex].Z = Level.TimeSeconds;
            break;
        default:
            return;
    }

    switch (Type)
    {
        case ORDER_Attack:
            BroadcastSquadLocalizedMessage(TeamIndex, SquadIndex, class'DHSquadOrderMessage', 1);
            break;
        case ORDER_Defend:
            BroadcastSquadLocalizedMessage(TeamIndex, SquadIndex, class'DHSquadOrderMessage', 2);
            break;
        default:
            break;
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
        case ALLIES_TEAM_INDEX:
            AlliesNextRallyPointTimes[SquadIndex] = TimeSeconds;
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

const RALLY_POINT_RADIUS_IN_METERS = 100;

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

            if (D < class'DHUnits'.static.MetersToUnreal(RALLY_POINT_RADIUS_IN_METERS))
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
        PC.ReceiveLocalizedMessage(SquadMessageClass, class'UInteger'.static.FromShorts(45, Max(1, RALLY_POINT_RADIUS_IN_METERS - class'DHUnits'.static.UnrealToMeters(ClosestBlockingRallyPointDistance))));

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
        foreach P.RadiusActors(class'Pawn', OtherPawn, class'DHUnits'.static.MetersToUnreal(10))
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

    if (RP != none)
    {
        RP.SetTeamIndex(P.GetTeamNum());
        RP.SquadIndex = PRI.SquadIndex;
        RP.RallyPointIndex = RallyPointIndex;
    }

    RallyPoints[RallyPointIndex] = RP;

    // "You have create a squad rally point. Secure the area with your squad to establish this rally point."
    PC.ReceiveLocalizedMessage(SquadMessageClass, 48);

    SetSquadNextRallyPointTime(RP.GetTeamIndex(), RP.SquadIndex, Level.TimeSeconds + default.NextRallyPointInterval);

    return RP;
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

            // "The squad leader has forcibly changes the currently active rally point."
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

defaultproperties
{
    AlliesSquadSize=12
    AxisSquadSize=9
    RallyPointInitialDelaySeconds=15.0
    RallyPointChangeLeaderDelaySeconds=30.0
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
}
