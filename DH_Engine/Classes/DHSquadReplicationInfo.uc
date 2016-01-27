//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHSquadReplicationInfo extends ReplicationInfo;

const SQUAD_MEMBER_COUNT = 8;
const TEAM_SQUAD_COUNT = 8;

const SQUAD_NAME_LENGTH_MIN = 3;
const SQUAD_NAME_LENGTH_MAX = 16;

const SQUAD_ERROR_NONE = 0;
const SQUAD_ERROR_ALREADY_IN_SQUAD = 1;
const SQUAD_ERROR_INVALID_NAME = 2;
const SQUAD_ERROR_TOO_MANY_SQUADS = 3;
const SQUAD_ERROR_MUST_BE_ON_TEAM = 4;
const SQUAD_ERROR_NOT_SQUAD_LEADER = 5;
const SQUAD_ERROR_NOT_IN_SQUAD = 6;


struct Squad
{
    var DHPlayer Members[8];
    var string Name;
    var byte LeaderMemberIndex;
    var bool bLocked;
};

var Squad AlliesSquads[8];
var Squad AxisSquads[8];

var string AlliesDefaultSquadNames[8];
var string AxisDefaultSquadNames[8];

var class<LocalMessage> SquadMessageClass;

replication
{
    reliable if (Role == ROLE_Authority)
        AxisSquads, AlliesSquads;
}

function bool IsSquadActive(byte TeamIndex, byte SquadIndex)
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

function bool IsSquadLeader(DHPlayer PC)
{
    local int TeamIndex;

    if (PC == none || PC.SquadIndex == -1)
    {
        return false;
    }

    TeamIndex = PC.GetTeamNum();

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

// Returns the index of the newly created squad, or -1 if there was an error.
function byte ServerCreateSquad(DHPlayer PC, optional string Name)
{
    local int i;
    local int TeamIndex;

    if (PC.SquadIndex != -1)
    {
        PC.ClientCreateSquadResult(SQUAD_ERROR_ALREADY_IN_SQUAD);

        return -1;
    }

    TeamIndex = PC.GetTeamNum();

    if (Name != "" && (Len(Name) < SQUAD_NAME_LENGTH_MIN || Len(Name) > SQUAD_NAME_LENGTH_MAX))
    {
        PC.ClientCreateSquadResult(SQUAD_ERROR_INVALID_NAME);

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
                    PC.ClientCreateSquadResult(SQUAD_ERROR_NONE);

                    return i;
                }
            }

            PC.ClientCreateSquadResult(SQUAD_ERROR_TOO_MANY_SQUADS);
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
                    PC.ClientCreateSquadResult(SQUAD_ERROR_NONE);

                    return i;
                }
            }
            break;
        default:
            PC.ClientCreateSquadResult(SQUAD_ERROR_MUST_BE_ON_TEAM);
            break;
    }

    return -1;
}

function bool ServerChangeSquadLeader(DHPlayer PC, DHPlayer NewSquadLeader)
{
    if (PC == none || NewSquadLeader == none || PC == NewSquadLeader ||
        PC.GetTeamNum() != NewSquadLeader.GetTeamNum() ||
        PC.SquadIndex != NewSquadLeader.SquadIndex)
    {
        PC.ClientChangeSquadLeaderResult(1);
        return false;
    }

    if (!IsSquadLeader(PC))
    {
        // Player is not a squad leader.
        PC.ClientChangeSquadLeaderResult(SQUAD_ERROR_NOT_SQUAD_LEADER);
        return false;
    }

    if (!SwapSquadMembers(PC, NewSquadLeader))
    {
        PC.ClientChangeSquadLeaderResult(3);

        return;
    }

    // "You are no longer the squad leader"
    PC.ReceiveLocalizedMessage(MessageClass, 0);

    // "You are now the squad leader"
    NewSquadLeader.ReceiveLocalizedMessage(MessageClass, 1);

    // "{0} has become the squad leader"
    BroadcastSquadLocalizedMessage(PC.GetTeamNum(), PC.SquadIndex, MessageClass, 0, NewSquadLeader.PlayerReplicationInfo);

    PC.ClientChangeSquadLeaderResult(0);
}

function bool ServerLeaveSquad(DHPlayer PC)
{
    local int i, j;
    local int TeamIndex;
    local DHPlayer NewSquadLeader;

    if (PC == none)
    {
        return SQUAD_ERROR_INVALID_ARGUMENT;
    }

    TeamIndex = PC.GetTeamNum();

    if (PC.SquadIndex == -1)
    {
        PC.ClientLeaveSquadResult(SQUAD_ERROR_NOT_IN_SQUAD);

        return false;
    }

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            if (AxisSquads[PC.SquadIndex].Members[PC.SquadMemberIndex] != PC)
            {
                // Invalid state (should never happen)
                PC.ClientLeaveSquadResult(SQUAD_ERROR_FATAL);
                return;
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
                        NewSquadLeader.ReceiveLocalizedMessage(MessageClass, 1);

                        // "{0} has become the squad leader"
                        BroadcastSquadLocalizedMessage(TeamIndex, PC.SquadIndex, MessageClass, 0, NewSquadLeader.PlayerReplicationInfo);

                        AxisSquads[PC.SquadIndex].LeaderMemberIndex = j;

                        break;
                    }
                }
            }

            PC.SquadIndex = -1;
            PC.SquadMemberIndex = -1;

            break;
        case ALLIES_TEAM_INDEX:
        default:
            PC.ClientLeaveSquadResult(3);
            return;
    }

    PC.ClientLeaveSquadResult(SQUAD_ERROR_NONE);

    return true;
}

function ServerJoinSquad(DHPlayer PC, byte TeamIndex, byte SquadIndex)
{
    local bool bDidJoinSquad;
    local int i, j;

    // This check is to guard against the rare case where a player could
    // request to join a squad on Team 1, but actually switch to Team 2 before
    // this function ever reaches the server.
    if (PC == none || PC.GetTeamNum() == TeamIndex)
    {
        PC.ClientJoinSquadResult(SQUAD_ERROR_INVALID_ARGUMENT);
        return;
    }

    if (!IsSquadActive(TeamIndex, SquadIndex))
    {
        PC.ClientJoinSquadResult(SQUAD_ERROR_BAD_SQUAD);
        return;
    }

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            for (i = 0; i < SQUAD_MEMBER_COUNT; ++i)
            {
                j = (AxisSquads[SquadIndex].LeaderMemberIndex + i) % SQUAD_MEMBER_COUNT;

                if (AxisSquads[SquadIndex].Members[j] == none)
                {
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
        BroadcastSquadLocalizedMessage(TeamIndex, SquadIndex, class'DHGameMessage', 30, PC.PlayerReplicationInfo);
    }
}

function ServerKickFromSquad(DHPlayer PC, byte TeamIndex, byte SquadIndex, DHPlayer MemberToKick)
{
    if (PC == none || PC.GetTeamNum() != TeamIndex || PC.SquadIndex != SquadIndex || !IsSquadLeader(PC) || PC == MemberToKick)
    {
        //PC.ClientKickFromSquadResult(1);
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
    MemberToKick.ReceiveLocalizedMessage(class'DHGameMessage', 32);
}

function BroadcastSquadLocalizedMessage(byte TeamIndex, byte SquadIndex, class<LocalMessage> MessageClass, int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
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
