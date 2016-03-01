//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHSquadReplicationInfo extends ReplicationInfo;

const SQUAD_MEMBER_COUNT = 8;
const TEAM_SQUAD_COUNT = 8;

const SQUAD_NAME_LENGTH_MIN = 3;
const SQUAD_NAME_LENGTH_MAX = 16;

const DEBUG = true;

enum ESquadError
{
    SE_None,
    SE_AlreadyInSquad,
    SE_InvalidName,
    SE_TooManySquads,
    SE_MustBeOnTeam,
    SE_NotSquadLeader,
    SE_NotInSquad,
    SE_InvalidArgument,
    SE_BadSquad,
    SE_InvalidState
};

// This nightmare is necessary because UnrealScript cannot replicate
// structs.
var DHPlayerReplicationInfo AxisMembers[64];
var string                  AxisNames[TEAM_SQUAD_COUNT];
var byte                    AxisLeaderMemberIndices[TEAM_SQUAD_COUNT];
var byte                    AxisLocked[TEAM_SQUAD_COUNT];

var DHPlayerReplicationInfo AlliesMembers[64];
var string                  AlliesNames[TEAM_SQUAD_COUNT];
var byte                    AlliesLeaderMemberIndices[TEAM_SQUAD_COUNT];
var byte                    AlliesLocked[TEAM_SQUAD_COUNT];

var string AlliesDefaultSquadNames[TEAM_SQUAD_COUNT];
var string AxisDefaultSquadNames[TEAM_SQUAD_COUNT];

var class<LocalMessage> SquadMessageClass;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        AxisMembers, AxisNames, AxisLeaderMemberIndices, AxisLocked,
        AlliesMembers, AlliesNames, AlliesLeaderMemberIndices, AlliesLocked;
}

function bool IsSquadActive(byte TeamIndex, int SquadIndex)
{
    return GetMember(TeamIndex, SquadIndex, GetLeaderMemberIndex(TeamIndex, SquadIndex)) != none;
}

function bool IsSquadLeader(DHPlayerReplicationInfo PRI, int TeamIndex, int SquadIndex)
{
    if (PRI == none || PRI.SquadIndex == -1 || PRI.Team.TeamIndex != TeamIndex || PRI.SquadIndex != SquadIndex)
    {
        return false;
    }

    return GetLeaderMemberIndex(TeamIndex, PRI.SquadIndex) == PRI.SquadMemberIndex;
}

function bool SwapSquadMembers(DHPlayerReplicationInfo A, DHPlayerReplicationInfo B)
{
    local int T;

    if (A == none || B == none || A == B ||
        (A.Team.TeamIndex != AXIS_TEAM_INDEX && A.Team.TeamIndex != ALLIES_TEAM_INDEX) ||   //On a team
        A.Team.TeamIndex != B.Team.TeamIndex ||                                             //On the same team
        A.SquadIndex != B.SquadIndex)                                                       //In the same squad
    {
        return false;
    }

    T = B.SquadMemberIndex;

    SetMember(A.Team.TeamIndex, A.SquadIndex, T, A);
    SetMember(A.Team.TeamIndex, A.SquadIndex, A.SquadMemberIndex, B);

    B.SquadMemberIndex = A.SquadMemberIndex;
    A.SquadMemberIndex = T;

    return true;
}

function DebugLog(string S)
{
    if (DEBUG)
    {
        Log(S);
    }
}

// Returns the index of the newly created squad, or -1 if there was an error.
function byte CreateSquad(DHPlayerReplicationInfo PRI, optional string Name)
{
    local int i;
    local int TeamIndex;
    local DHPlayer PC;

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
        PC.ClientCreateSquadResult(SE_AlreadyInSquad);

        DebugLog(PRI.PlayerName @ "is already in a squad (" $ PRI.SquadIndex $ ")");

        return -1;
    }

    TeamIndex = PC.GetTeamNum();

    if (Name != "" && (Len(Name) < SQUAD_NAME_LENGTH_MIN || Len(Name) > SQUAD_NAME_LENGTH_MAX))
    {
        PC.ClientCreateSquadResult(SE_InvalidName);

        DebugLog("Squad name is invalid (" $ Name $ ")");

        return -1;
    }

    for (i = 0; i < SQUAD_MEMBER_COUNT; ++i)
    {
        if (!IsSquadActive(TeamIndex, i))
        {
            if (Name == "")
            {
                Name = default.AxisDefaultSquadNames[i];
            }

            SetMember(TeamIndex, i, GetLeaderMemberIndex(TeamIndex, i), PRI);
            SetName(TeamIndex, i, Name);

            PRI.SquadIndex = i;
            PRI.SquadMemberIndex = GetLeaderMemberIndex(TeamIndex, i);

            PC.ClientCreateSquadResult(SE_None);

            DebugLog("Squad '" $ Name $ "' created successfully at index " $ i);

            return i;
        }
    }

    PC.ClientCreateSquadResult(SE_TooManySquads);

    return -1;
}

// Returns true if the squad leader was successfully changed.
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
        PC.ClientChangeSquadLeaderResult(SE_NotSquadLeader);
        return false;
    }

    if (NewSquadLeader == none || PRI == NewSquadLeader ||
        PRI.Team.TeamIndex != NewSquadLeader.Team.TeamIndex ||
        PRI.SquadIndex != NewSquadLeader.SquadIndex)
    {
        PC.ClientChangeSquadLeaderResult(SE_InvalidArgument);

        return false;
    }

    // To change the squad leader, instead of changing the LeaderMemberIndex,
    // we simply swap the new leader with the old one. This preserves the
    // "leader inheritance" order.
    if (!SwapSquadMembers(PRI, NewSquadLeader))
    {
        PC.ClientChangeSquadLeaderResult(SE_InvalidArgument);

        return false;
    }

    // "You are no longer the squad leader"
    PC.ReceiveLocalizedMessage(MessageClass, 33);

    PC.ClientChangeSquadLeaderResult(SE_None);

    OtherPC = DHPlayer(NewSquadLeader.Owner);

    if (OtherPC != none)
    {
        // "You are now the squad leader"
        OtherPC.ReceiveLocalizedMessage(MessageClass, 34);
    }

    // "{0} has become the squad leader"
    BroadcastSquadLocalizedMessage(PRI.Team.TeamIndex, PRI.SquadIndex, MessageClass, 35, NewSquadLeader);

    return true;
}

// Returns true if player successfully leaves a squad. The player is guaranteed
// to not be a member of a squad after this call, regardless of the return value.
function bool LeaveSquad(DHPlayerReplicationInfo PRI)
{
    local int i, j;
    local int TeamIndex;
    local DHPlayer PC;
    local DHPlayerReplicationInfo NewSquadLeader;
    local DHPlayer NewSquadLeaderPC;

    if (PRI == none)
    {
        return false;
    }

    PC = DHPlayer(PRI.Owner);

    if (PC == none)
    {
        return false;
    }

    TeamIndex = PC.GetTeamNum();

    if (PRI.SquadIndex == -1)
    {
        PC.ClientLeaveSquadResult(SE_NotInSquad);

        return false;
    }

    if (GetMember(TeamIndex, PRI.SquadIndex, PRI.SquadMemberIndex) != PRI)
    {
        // Invalid state (should never happen)
        PC.ClientLeaveSquadResult(SE_InvalidState);

        return false;
    }

    SetMember(TeamIndex, PRI.SquadIndex, PRI.SquadMemberIndex, none);

    if (PRI.SquadMemberIndex == GetLeaderMemberIndex(TeamIndex, PRI.SquadMemberIndex))
    {
        // Player was squad leader, transfer leadership to next in the list
        for (i = 1; i < SQUAD_MEMBER_COUNT; ++i)
        {
            j = (GetLeaderMemberIndex(TeamIndex, PRI.SquadIndex) + i) % SQUAD_MEMBER_COUNT;

            if (GetMember(TeamIndex, PRI.SquadIndex, j) != none)
            {
                NewSquadLeader = GetMember(TeamIndex, PRI.SquadIndex, j);
                NewSquadLeaderPC = DHPlayer(NewSquadLeader.Owner);

                if (NewSquadLeaderPC != none)
                {
                    // "You are now the squad leader"
                    NewSquadLeaderPC.ReceiveLocalizedMessage(MessageClass, 34);
                }

                // "{0} has become the squad leader"
                BroadcastSquadLocalizedMessage(TeamIndex, PRI.SquadIndex, MessageClass, 35, NewSquadLeader);

                SetLeaderMemberIndex(TeamIndex, PRI.SquadIndex, j);

                break;
            }
        }
    }

    PRI.SquadIndex = -1;
    PRI.SquadMemberIndex = -1;

    PC.ClientLeaveSquadResult(SE_None);

    return true;
}

function bool IsInSquad(DHPlayerReplicationInfo PRI, byte TeamIndex, int SquadIndex)
{
    return PRI != none && PRI.Team.TeamIndex == TeamIndex && PRI.SquadIndex == SquadIndex;
}

// Returns the index of the new SquadMemberIndex of the player or -1 if
// joining a squad failed.
function int JoinSquad(DHPlayerReplicationInfo PRI, byte TeamIndex, int SquadIndex)
{
    local bool bDidJoinSquad;
    local int i, j;
    local DHPlayer PC;

    if (PRI == none)
    {
        return -1;
    }

    PC = DHPlayer(PRI.Owner);

    if (PC == none)
    {
        return -1;
    }

    if (!IsSquadActive(TeamIndex, SquadIndex))
    {
        PC.ClientJoinSquadResult(SE_BadSquad);

        return -1;
    }

    if (IsInSquad(PRI, TeamIndex, SquadIndex))
    {
        PC.ClientJoinSquadResult(SE_BadSquad);

        return -1;
    }

    for (i = 0; i < SQUAD_MEMBER_COUNT; ++i)
    {
        j = (GetLeaderMemberIndex(TeamIndex, SquadIndex) + i) % SQUAD_MEMBER_COUNT;

        if (GetMember(TeamIndex, SquadIndex, j) == none)
        {
            // We don't care about the result of ServerLeaveSquad;
            // whatever the result, the player is not in a squad and
            // can join another one.
            LeaveSquad(PRI);

            SetMember(TeamIndex, SquadIndex, j, PRI);

            bDidJoinSquad = true;

            break;
        }
    }

    if (bDidJoinSquad)
    {
        // "{0} has joined the squad"
        BroadcastSquadLocalizedMessage(TeamIndex, SquadIndex, MessageClass, 30, PRI);

        PC.ClientJoinSquadResult(SE_None);
    }
}

// Returns true if the the player was successfully kicked from a squad.
function bool KickFromSquad(DHPlayerReplicationInfo PRI, byte TeamIndex, int SquadIndex, DHPlayerReplicationInfo MemberToKick)
{
    local DHPlayer PC, OtherPC;

    if (PRI == none)
    {
        return false;
    }

    PC = DHPlayer(PRI.Owner);

    if (PC != none)
    {
        return false;
    }

    if (IsSquadLeader(PRI, TeamIndex, SquadIndex) || PRI == MemberToKick)
    {
        //PC.ClientKickFromSquadResult(SE_InvalidArgument);

        return false;
    }

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            AxisMembers[SquadIndex * SQUAD_MEMBER_COUNT + MemberToKick.SquadMemberIndex] = none;
            break;
        case ALLIES_TEAM_INDEX:
            AlliesMembers[SquadIndex * SQUAD_MEMBER_COUNT + MemberToKick.SquadMemberIndex] = none;
            break;
    }

    OtherPC = DHPlayer(MemberToKick.Owner);

    if (OtherPC != none)
    {
        // "You have been kicked from your squad."
        OtherPC.ReceiveLocalizedMessage(MessageClass, 32);
    }

    return true;
}

function bool SetSquadLocked(DHPlayerReplicationInfo PC, int TeamIndex, int SquadIndex, bool bLocked)
{
    if (PC == none || !IsSquadLeader(PC, TeamIndex, SquadIndex))
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
    local DHPlayerReplicationInfo PRI;
    local DHPlayer PC;

    if (IsSquadActive(TeamIndex, SquadIndex))
    {
        return;
    }

    for (i = 0; i < SQUAD_MEMBER_COUNT; ++i)
    {
        PRI = GetMember(TeamIndex, SquadIndex, i);
        PC = DHPlayer(PRI.Owner);

        if (PC != none)
        {
            PC.ReceiveLocalizedMessage(MessageClass, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
        }
    }
}

function string GetSquadName(int TeamIndex, int SquadIndex)
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

function int GetLeaderMemberIndex(int TeamIndex, int SquadIndex)
{
    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            return AxisLeaderMemberIndices[SquadIndex];
        case ALLIES_TEAM_INDEX:
            return AlliesLeaderMemberIndices[SquadIndex];
    }

    return 0;
}

function SetLeaderMemberIndex(int TeamIndex, int SquadIndex, int LeaderMemberIndex)
{
    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            AxisLeaderMemberIndices[SquadIndex] = LeaderMemberIndex;
            break;
        case ALLIES_TEAM_INDEX:
            AlliesLeaderMemberIndices[SquadIndex] = LeaderMemberIndex;
            break;
        default:
            break;
    }
}

function DHPlayerReplicationInfo GetMember(int TeamIndex, int SquadIndex, int MemberIndex)
{
    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            return AxisMembers[SquadIndex * SQUAD_MEMBER_COUNT + MemberIndex];
        case ALLIES_TEAM_INDEX:
            return AxisMembers[SquadIndex * SQUAD_MEMBER_COUNT + MemberIndex];
    }

    return none;
}

function SetMember(int TeamIndex, int SquadIndex, int MemberIndex, DHPlayerReplicationInfo PRI)
{
    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            AxisMembers[SquadIndex * SQUAD_MEMBER_COUNT + MemberIndex] = PRI;
            break;
        case ALLIES_TEAM_INDEX:
            AxisMembers[SquadIndex * SQUAD_MEMBER_COUNT + MemberIndex] = PRI;
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

function SetName(int TeamIndex, int SquadIndex, string Name)
{
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

defaultproperties
{
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
    AxisDefaultSquadNames(2)="Caeser"
    AxisDefaultSquadNames(3)="Dora"
    AxisDefaultSquadNames(4)="Emil"
    AxisDefaultSquadNames(5)="Fritz"
    AxisDefaultSquadNames(6)="Gustav"
    AxisDefaultSquadNames(7)="Heinrich"
    SquadMessageClass=class'DHGameMessage'
}
