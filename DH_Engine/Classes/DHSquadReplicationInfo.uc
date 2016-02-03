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

struct Squad
{
    var DHPlayer Members[SQUAD_MEMBER_COUNT];
    var string Name;
    var byte LeaderMemberIndex;
    var bool bLocked;
};

var Squad AlliesSquads[TEAM_SQUAD_COUNT];
var Squad AxisSquads[TEAM_SQUAD_COUNT];

var string AlliesDefaultSquadNames[8];
var string AxisDefaultSquadNames[8];

var class<LocalMessage> SquadMessageClass;

replication
{
    reliable if (Role == ROLE_Authority)
        AxisSquads, AlliesSquads;
}

function bool IsSquadActive(byte TeamIndex, int SquadIndex)
{
    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            if (SquadIndex < arraycount(AxisSquads))
            {
                return AxisSquads[SquadIndex].Members[AxisSquads[SquadIndex].LeaderMemberIndex] != none;
            }
            break;
        case ALLIES_TEAM_INDEX:
            if (SquadIndex < arraycount(AlliesSquads))
            {
                return AlliesSquads[SquadIndex].Members[AlliesSquads[SquadIndex].LeaderMemberIndex] != none;
            }
            break;
        default:
            return false;
    }

    return false;
}

function bool IsSquadLeader(DHPlayer PC, int TeamIndex, int SquadIndex)
{
    if (PC == none || PC.SquadIndex == -1 || PC.GetTeamNum() != TeamIndex || PC.SquadIndex != SquadIndex)
    {
        return false;
    }

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            return AxisSquads[PC.SquadIndex].LeaderMemberIndex == PC.SquadMemberIndex;
        case ALLIES_TEAM_INDEX:
            return AlliesSquads[PC.SquadIndex].LeaderMemberIndex == PC.SquadMemberIndex;
        default:
            return false;
    }
}

function bool SwapSquadMembers(DHPlayer A, DHPlayer B)
{
    local int T;

    if (A == none || B == none || A == B ||
        (A.GetTeamNum() != AXIS_TEAM_INDEX && A.GetTeamNum() != ALLIES_TEAM_INDEX) ||   //On a team
        A.GetTeamNum() != B.GetTeamNum() ||                                             //On the same team
        A.SquadIndex != B.SquadIndex)                                                   //In the same squad
    {
        return false;
    }

    T = B.SquadMemberIndex;

    switch (A.GetTeamNum())
    {
        case AXIS_TEAM_INDEX:
            AxisSquads[A.SquadIndex].Members[T] = A;
            AxisSquads[A.SquadIndex].Members[A.SquadIndex] = B;

            B.SquadMemberIndex = A.SquadMemberIndex;
            A.SquadMemberIndex = T;

            return true;
        case ALLIES_TEAM_INDEX:
            AlliesSquads[A.SquadIndex].Members[T] = A;
            AlliesSquads[A.SquadIndex].Members[A.SquadIndex] = B;

            B.SquadMemberIndex = A.SquadMemberIndex;
            A.SquadMemberIndex = T;

            return true;
        default:
            return false;
    }
}

function DebugLog(string S)
{
    if (DEBUG)
    {
        Log(S);
    }
}

// Returns the index of the newly created squad, or -1 if there was an error.
function byte CreateSquad(DHPlayer PC, optional string Name)
{
    local int i;
    local int TeamIndex;

    if (PC.SquadIndex != -1)
    {
        PC.ClientCreateSquadResult(SE_AlreadyInSquad);

        DebugLog(PC.PlayerReplicationInfo.PlayerName @ "is already in a squad (" $ PC.SquadIndex $ ")");

        return -1;
    }

    TeamIndex = PC.GetTeamNum();

    if (Name != "" && (Len(Name) < SQUAD_NAME_LENGTH_MIN || Len(Name) > SQUAD_NAME_LENGTH_MAX))
    {
        PC.ClientCreateSquadResult(SE_InvalidName);

        DebugLog("Squad name is invalid (" $ Name $ ")");

        return -1;
    }

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            for (i = 0; i < arraycount(AxisSquads); ++i)
            {
                if (!IsSquadActive(TeamIndex, i))
                {
                    if (Name == "")
                    {
                        Name = default.AxisDefaultSquadNames[i];
                    }

                    AxisSquads[i].Members[AxisSquads[i].LeaderMemberIndex] = PC;
                    AxisSquads[i].Name = Name;

                    PC.SquadIndex = i;
                    PC.SquadMemberIndex = AxisSquads[i].LeaderMemberIndex;
                    PC.ClientCreateSquadResult(SE_None);

                    DebugLog("Squad '" $ Name $ "' created successfully at index " $ i);

                    return i;
                }
            }

            PC.ClientCreateSquadResult(SE_TooManySquads);
            break;
        case ALLIES_TEAM_INDEX:
            for (i = 0; i < arraycount(AlliesSquads); ++i)
            {
                if (!IsSquadActive(TeamIndex, i))
                {
                    if (Name == "")
                    {
                        Name = default.AlliesDefaultSquadNames[i];
                    }

                    AlliesSquads[i].Members[AlliesSquads[i].LeaderMemberIndex] = PC;
                    AlliesSquads[i].Name = Name;

                    PC.SquadIndex = i;
                    PC.SquadMemberIndex = AlliesSquads[i].LeaderMemberIndex;
                    PC.ClientCreateSquadResult(SE_None);

                    DebugLog("Squad '" $ Name $ "' created successfully at index " $ i);

                    return i;
                }
            }

            PC.ClientCreateSquadResult(SE_TooManySquads);
            break;
        default:
            PC.ClientCreateSquadResult(SE_MustBeOnTeam);

            DebugLog("Player is not on a team");

            break;
    }

    return -1;
}

// Returns true if the squad leader was successfully changed.
function bool ChangeSquadLeader(DHPlayer PC, int TeamIndex, int SquadIndex, DHPlayer NewSquadLeader)
{
    if (PC == none)
    {
        return false;
    }

    if (!IsSquadLeader(PC, TeamIndex, SquadIndex))
    {
        // Player is not a squad leader.
        PC.ClientChangeSquadLeaderResult(SE_NotSquadLeader);
        return false;
    }

    if (NewSquadLeader == none || PC == NewSquadLeader ||
        PC.GetTeamNum() != NewSquadLeader.GetTeamNum() ||
        PC.SquadIndex != NewSquadLeader.SquadIndex)
    {
        PC.ClientChangeSquadLeaderResult(SE_InvalidArgument);

        return false;
    }

    // To change the squad leader, instead of changing the LeaderMemberIndex,
    // we simply swap the new leader with the old one. This preserves the
    // "leader inheritance" order.
    if (!SwapSquadMembers(PC, NewSquadLeader))
    {
        PC.ClientChangeSquadLeaderResult(SE_InvalidArgument);

        return false;
    }

    // "You are no longer the squad leader"
    PC.ReceiveLocalizedMessage(MessageClass, 33);

    // "You are now the squad leader"
    NewSquadLeader.ReceiveLocalizedMessage(MessageClass, 34);

    // "{0} has become the squad leader"
    BroadcastSquadLocalizedMessage(PC.GetTeamNum(), PC.SquadIndex, MessageClass, 35, NewSquadLeader.PlayerReplicationInfo);

    PC.ClientChangeSquadLeaderResult(SE_None);

    return true;
}

// Returns true if player successfully leaves a squad. The player is guaranteed
// to not be a member of a squad after this call, regardless of the return value.
function bool LeaveSquad(DHPlayer PC)
{
    local int i, j;
    local int TeamIndex;
    local DHPlayer NewSquadLeader;

    if (PC == none)
    {
        return false;
    }

    TeamIndex = PC.GetTeamNum();

    if (PC.SquadIndex == -1)
    {
        PC.ClientLeaveSquadResult(SE_NotInSquad);

        return false;
    }

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            if (AxisSquads[PC.SquadIndex].Members[PC.SquadMemberIndex] != PC)
            {
                // Invalid state (should never happen)
                PC.ClientLeaveSquadResult(SE_InvalidState);

                return false;
            }

            AxisSquads[PC.SquadIndex].Members[PC.SquadMemberIndex] = none;

            if (PC.SquadMemberIndex == AxisSquads[PC.SquadIndex].LeaderMemberIndex)
            {
                // Player was squad leader, transfer leadership to next in the list
                for (i = 1; i < arraycount(AxisSquads[PC.SquadIndex].Members); ++i)
                {
                    j = (AxisSquads[PC.SquadIndex].LeaderMemberIndex + i) % SQUAD_MEMBER_COUNT;

                    if (AxisSquads[PC.SquadIndex].Members[j] != none)
                    {
                        NewSquadLeader = AxisSquads[PC.SquadIndex].Members[j];

                        // "You are now the squad leader"
                        NewSquadLeader.ReceiveLocalizedMessage(MessageClass, 34);

                        // "{0} has become the squad leader"
                        BroadcastSquadLocalizedMessage(TeamIndex, PC.SquadIndex, MessageClass, 35, NewSquadLeader.PlayerReplicationInfo);

                        AxisSquads[PC.SquadIndex].LeaderMemberIndex = j;

                        break;
                    }
                }
            }

            break;
        case ALLIES_TEAM_INDEX:
            if (AlliesSquads[PC.SquadIndex].Members[PC.SquadMemberIndex] != PC)
            {
                // Invalid state (should never happen)
                PC.ClientLeaveSquadResult(SE_InvalidState);

                return false;
            }

            AlliesSquads[PC.SquadIndex].Members[PC.SquadMemberIndex] = none;

            if (PC.SquadMemberIndex == AlliesSquads[PC.SquadIndex].LeaderMemberIndex)
            {
                // Player was squad leader, transfer leadership to next in the list
                for (i = 1; i < arraycount(AlliesSquads[PC.SquadIndex].Members); ++i)
                {
                    j = (AlliesSquads[PC.SquadIndex].LeaderMemberIndex + i) % SQUAD_MEMBER_COUNT;

                    if (AlliesSquads[PC.SquadIndex].Members[j] != none)
                    {
                        NewSquadLeader = AlliesSquads[PC.SquadIndex].Members[j];

                        // "You are now the squad leader"
                        NewSquadLeader.ReceiveLocalizedMessage(MessageClass, 34);

                        // "{0} has become the squad leader"
                        BroadcastSquadLocalizedMessage(TeamIndex, PC.SquadIndex, MessageClass, 35, NewSquadLeader.PlayerReplicationInfo);

                        AlliesSquads[PC.SquadIndex].LeaderMemberIndex = j;

                        break;
                    }
                }
            }
            break;
        default:
            PC.ClientLeaveSquadResult(SE_InvalidArgument);
            return false;
    }

    PC.SquadIndex = -1;
    PC.SquadMemberIndex = -1;

    PC.ClientLeaveSquadResult(SE_None);

    return true;
}

function bool IsInSquad(DHPlayer PC, byte TeamIndex, int SquadIndex)
{
    return PC != none && PC.GetTeamNum() == TeamIndex && PC.SquadIndex == SquadIndex;
}

// Returns the index of the new SquadMemberIndex of the player or -1 if
// joining a squad failed.
function int JoinSquad(DHPlayer PC, byte TeamIndex, int SquadIndex)
{
    local bool bDidJoinSquad;
    local int i, j;

    if (PC == none)
    {
        return -1;
    }

    if (!IsSquadActive(TeamIndex, SquadIndex))
    {
        PC.ClientJoinSquadResult(SE_BadSquad);

        return -1;
    }

    if (IsInSquad(PC, TeamIndex, SquadIndex))
    {
        PC.ClientJoinSquadResult(SE_InvalidState);

        return - 1;
    }

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            for (i = 0; i < SQUAD_MEMBER_COUNT; ++i)
            {
                j = (AxisSquads[SquadIndex].LeaderMemberIndex + i) % SQUAD_MEMBER_COUNT;

                if (AxisSquads[SquadIndex].Members[j] == none)
                {
                    // We don't care about the result of ServerLeaveSquad;
                    // whatever the result, the player is not in a squad and
                    // can join another one.
                    LeaveSquad(PC);

                    AxisSquads[SquadIndex].Members[j] = PC;

                    bDidJoinSquad = true;

                    break;
                }
            }

            break;
        case ALLIES_TEAM_INDEX:
            for (i = 0; i < SQUAD_MEMBER_COUNT; ++i)
            {
                j = (AlliesSquads[SquadIndex].LeaderMemberIndex + i) % SQUAD_MEMBER_COUNT;

                if (AlliesSquads[SquadIndex].Members[j] == none)
                {
                    // We don't care about the result of ServerLeaveSquad;
                    // whatever the result, the player is not in a squad and
                    // can join another one.
                    LeaveSquad(PC);

                    AlliesSquads[SquadIndex].Members[j] = PC;

                    bDidJoinSquad = true;

                    break;
                }
            }

            break;
    }

    if (bDidJoinSquad)
    {
        // "{0} has joined the squad"
        BroadcastSquadLocalizedMessage(TeamIndex, SquadIndex, MessageClass, 30, PC.PlayerReplicationInfo);
    }
}

// Returns true if the the player was successfully kicked from a squad.
function bool KickFromSquad(DHPlayer PC, byte TeamIndex, int SquadIndex, DHPlayer MemberToKick)
{
    if (PC == none)
    {
        return false;
    }

    if (IsSquadLeader(PC, TeamIndex, SquadIndex) || PC == MemberToKick)
    {
        //PC.ClientKickFromSquadResult(SE_InvalidArgument);

        return false;
    }

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            AxisSquads[SquadIndex].Members[MemberToKick.SquadMemberIndex] = none;
            break;
        case ALLIES_TEAM_INDEX:
            AxisSquads[SquadIndex].Members[MemberToKick.SquadMemberIndex] = none;
            break;
    }

    // "You have been kicked from your squad."
    MemberToKick.ReceiveLocalizedMessage(MessageClass, 32);

    return true;
}

function bool SetSquadLocked(DHPlayer PC, int TeamIndex, int SquadIndex, bool bLocked)
{
    if (PC == none || !IsSquadLeader(PC, TeamIndex, SquadIndex))
    {
        return false;
    }

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            AxisSquads[SquadIndex].bLocked = bLocked;
            break;
        case ALLIES_TEAM_INDEX:
            AlliesSquads[SquadIndex].bLocked = bLocked;
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

    if (IsSquadActive(TeamIndex, SquadIndex))
    {
        return;
    }

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            for (i = 0; i < SQUAD_MEMBER_COUNT; ++i)
            {
                PC = AxisSquads[SquadIndex].Members[i];

                if (PC != none)
                {
                    PC.ReceiveLocalizedMessage(MessageClass, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                }
            }
            break;
        case ALLIES_TEAM_INDEX:
            for (i = 0; i < SQUAD_MEMBER_COUNT; ++i)
            {
                PC = AlliesSquads[SquadIndex].Members[i];

                if (PC != none)
                {
                    PC.ReceiveLocalizedMessage(MessageClass, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                }
            }
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
