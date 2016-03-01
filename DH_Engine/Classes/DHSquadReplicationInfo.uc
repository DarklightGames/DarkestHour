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
    var DHPlayerReplicationInfo Members[SQUAD_MEMBER_COUNT];
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

function bool IsSquadLeader(DHPlayerReplicationInfo PRI, int TeamIndex, int SquadIndex)
{
    if (PRI == none || PRI.SquadIndex == -1 || PRI.Team.TeamIndex != TeamIndex || PRI.SquadIndex != SquadIndex)
    {
        return false;
    }

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            return AxisSquads[PRI.SquadIndex].LeaderMemberIndex == PRI.SquadMemberIndex;
        case ALLIES_TEAM_INDEX:
            return AlliesSquads[PRI.SquadIndex].LeaderMemberIndex == PRI.SquadMemberIndex;
        default:
            return false;
    }
}

function bool SwapSquadMembers(DHPlayerReplicationInfo A, DHPlayerReplicationInfo B)
{
    local int T;

    if (A == none || B == none || A == B ||
        (A.Team.TeamIndex != AXIS_TEAM_INDEX && A.Team.TeamIndex != ALLIES_TEAM_INDEX) ||   //On a team
        A.Team.TeamIndex != B.Team.TeamIndex ||                                           //On the same team
        A.SquadIndex != B.SquadIndex)                                                       //In the same squad
    {
        return false;
    }

    T = B.SquadMemberIndex;

    switch (A.Team.TeamIndex)
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

                    AxisSquads[i].Members[AxisSquads[i].LeaderMemberIndex] = PRI;
                    AxisSquads[i].Name = Name;

                    PRI.SquadIndex = i;
                    PRI.SquadMemberIndex = AxisSquads[i].LeaderMemberIndex;
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

                    AlliesSquads[i].Members[AlliesSquads[i].LeaderMemberIndex] = PRI;
                    AlliesSquads[i].Name = Name;

                    PRI.SquadIndex = i;
                    PRI.SquadMemberIndex = AlliesSquads[i].LeaderMemberIndex;
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

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            if (AxisSquads[PRI.SquadIndex].Members[PRI.SquadMemberIndex] != PC)
            {
                // Invalid state (should never happen)
                PC.ClientLeaveSquadResult(SE_InvalidState);

                return false;
            }

            AxisSquads[PRI.SquadIndex].Members[PRI.SquadMemberIndex] = none;

            if (PRI.SquadMemberIndex == AxisSquads[PRI.SquadIndex].LeaderMemberIndex)
            {
                // Player was squad leader, transfer leadership to next in the list
                for (i = 1; i < arraycount(AxisSquads[PRI.SquadIndex].Members); ++i)
                {
                    j = (AxisSquads[PRI.SquadIndex].LeaderMemberIndex + i) % SQUAD_MEMBER_COUNT;

                    if (AxisSquads[PRI.SquadIndex].Members[j] != none)
                    {
                        NewSquadLeader = AxisSquads[PRI.SquadIndex].Members[j];

                        NewSquadLeaderPC = DHPlayer(NewSquadLeader.Owner);

                        if (NewSquadLeaderPC != none)
                        {
                            // "You are now the squad leader"
                            NewSquadLeaderPC.ReceiveLocalizedMessage(MessageClass, 34);
                        }

                        // "{0} has become the squad leader"
                        BroadcastSquadLocalizedMessage(TeamIndex, PRI.SquadIndex, MessageClass, 35, NewSquadLeader);

                        AxisSquads[PRI.SquadIndex].LeaderMemberIndex = j;

                        break;
                    }
                }
            }

            break;
        case ALLIES_TEAM_INDEX:
            if (AlliesSquads[PRI.SquadIndex].Members[PRI.SquadMemberIndex] != PC)
            {
                // Invalid state (should never happen)
                PC.ClientLeaveSquadResult(SE_InvalidState);

                return false;
            }

            AlliesSquads[PRI.SquadIndex].Members[PRI.SquadMemberIndex] = none;

            if (PRI.SquadMemberIndex == AlliesSquads[PRI.SquadIndex].LeaderMemberIndex)
            {
                // Player was squad leader, transfer leadership to next in the list
                for (i = 1; i < arraycount(AlliesSquads[PRI.SquadIndex].Members); ++i)
                {
                    j = (AlliesSquads[PRI.SquadIndex].LeaderMemberIndex + i) % SQUAD_MEMBER_COUNT;

                    if (AlliesSquads[PRI.SquadIndex].Members[j] != none)
                    {
                        NewSquadLeader = AlliesSquads[PRI.SquadIndex].Members[j];
                        NewSquadLeaderPC = DHPlayer(NewSquadLeader.Owner);

                        if (NewSquadLeaderPC != none)
                        {
                            // "You are now the squad leader"
                            NewSquadLeaderPC.ReceiveLocalizedMessage(MessageClass, 34);
                        }

                        // "{0} has become the squad leader"
                        BroadcastSquadLocalizedMessage(TeamIndex, PRI.SquadIndex, MessageClass, 35, NewSquadLeader);

                        AlliesSquads[PRI.SquadIndex].LeaderMemberIndex = j;

                        break;
                    }
                }
            }
            break;
        default:
            PC.ClientLeaveSquadResult(SE_InvalidArgument);
            return false;
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
                    LeaveSquad(PRI);

                    AxisSquads[SquadIndex].Members[j] = PRI;

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
                    LeaveSquad(PRI);

                    AlliesSquads[SquadIndex].Members[j] = PRI;

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

        PC.ClientJoinSquadResult(SE_None);
    }
}

// Returns true if the the player was successfully kicked from a squad.
function bool KickFromSquad(DHPlayerReplicationInfo PRI, byte TeamIndex, int SquadIndex, DHPlayerReplicationInfo MemberToKick)
{
    local PlayerController PC;

    if (PRI == none)
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
            AxisSquads[SquadIndex].Members[MemberToKick.SquadMemberIndex] = none;
            break;
        case ALLIES_TEAM_INDEX:
            AxisSquads[SquadIndex].Members[MemberToKick.SquadMemberIndex] = none;
            break;
    }

    PC = PlayerController(MemberToKick.Owner);

    if (PC != none)
    {
        // "You have been kicked from your squad."
        PC.ReceiveLocalizedMessage(MessageClass, 32);
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
    local DHPlayerReplicationInfo PRI;
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
                PRI = AxisSquads[SquadIndex].Members[i];
                PC = DHPlayer(PRI.Owner);

                if (PC != none)
                {
                    PC.ReceiveLocalizedMessage(MessageClass, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
                }
            }
            break;
        case ALLIES_TEAM_INDEX:
            for (i = 0; i < SQUAD_MEMBER_COUNT; ++i)
            {
                PRI = AlliesSquads[SquadIndex].Members[i];
                PC = DHPlayer(PRI.Owner);

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
