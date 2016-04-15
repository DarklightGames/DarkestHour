//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHSquadReplicationInfo extends ReplicationInfo;

const SQUAD_SIZE_MIN = 8;
const SQUAD_SIZE_MAX = 12;
const TEAM_SQUAD_MEMBERS_MAX = 64;
const TEAM_SQUADS_MAX = 8;  // SQUAD_SIZE_MIN / TEAM_SQUAD_MEMBERS_MAX

const SQUAD_NAME_LENGTH_MIN = 3;
const SQUAD_NAME_LENGTH_MAX = 16;

const SQUAD_LEADER_INDEX = 0;

const DEBUG = true;

// TODO: remove once we have sufficiently debugged the system.
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
    SE_Locked,
    SE_InvalidState
};

enum ESquadOrder
{
    SO_Attack,
    SO_Defend,
    SO_Move,
    SO_Fire
};

// This nightmare is necessary because UnrealScript cannot replicate structs.
var private DHPlayerReplicationInfo AxisMembers[TEAM_SQUAD_MEMBERS_MAX];
var private string                  AxisNames[TEAM_SQUADS_MAX];
var private byte                    AxisLocked[TEAM_SQUADS_MAX];

var private DHPlayerReplicationInfo AlliesMembers[TEAM_SQUAD_MEMBERS_MAX];
var private string                  AlliesNames[TEAM_SQUADS_MAX];
var private byte                    AlliesLocked[TEAM_SQUADS_MAX];

var private array<string>           AlliesDefaultSquadNames;
var private array<string>           AxisDefaultSquadNames;

var globalconfig private int        AxisSquadSize;
var globalconfig private int        AlliesSquadSize;

var class<LocalMessage>             SquadMessageClass;

var TreeMap_Object_float            InvitationExpirations;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        AxisSquadSize, AlliesSquadSize;

    reliable if (bNetDirty && Role == ROLE_Authority)
        AxisMembers, AxisNames, AxisLocked,
        AlliesMembers, AlliesNames, AlliesLocked;
}

function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        InvitationExpirations = new class'TreeMap_Object_float';

        AxisSquadSize = Clamp(AxisSquadSize, SQUAD_SIZE_MIN, SQUAD_SIZE_MAX);
        AlliesSquadSize = Clamp(AlliesSquadSize, SQUAD_SIZE_MIN, SQUAD_SIZE_MAX);
    }
}

function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if (Role == ROLE_Authority)
    {
        SetTimer(2.0, true);
    }
}

function Timer()
{
    local DHPlayer PC;
    local DHPlayer OtherPC;
    local DHPlayerReplicationInfo PRI, OtherPRI;
    local Controller C;
    local int i;

    // We want our player to know where his squadmates are at all times by
    // looking at the situation map. However, since the player may not have
    // all squadmates replicated on his machine, he needs another way to know
    // his squadmates' locations and rotations.
    //
    // The method below sends the position (X, Y) and rotation (Z) of each
    // member in the players' squad every two seconds.
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

        for (i = 0; i < GetTeamSquadSize(C.GetTeamNum()); ++i)
        {
            OtherPRI = GetMember(PC.GetTeamNum(), PRI.SquadIndex, i);

            if (OtherPRI != none)
            {
                OtherPC = DHPlayer(OtherPRI.Owner);

                if (OtherPC != none && OtherPC.Pawn != none)
                {
                    PC.SquadMemberPositions[i].X = OtherPC.Pawn.Location.X;
                    PC.SquadMemberPositions[i].Y = OtherPC.Pawn.Location.Y;
                    PC.SquadMemberPositions[i].Z = OtherPC.Pawn.Rotation.Yaw;

                    continue;
                }
            }

            PC.SquadMemberPositions[i] = vect(0, 0, 0);
        }
    }
}

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

// Gets whether or not there are any members in the squad.
simulated function bool IsSquadActive(byte TeamIndex, int SquadIndex)
{
    local int i;

    for (i = 0; i < GetTeamSquadSize(TeamIndex); ++i)
    {
        if (GetMember(TeamIndex, SquadIndex, i) != none)
        {
            return true;
        }
    }

    return false;
}

simulated function bool IsASquadLeader(DHPlayerReplicationInfo PRI)
{
    return PRI != none && PRI.Team != none && PRI == GetSquadLeader(PRI.Team.TeamIndex, PRI.SquadIndex);
}

simulated function DHPlayerReplicationInfo GetSquadLeader(int TeamIndex, int SquadIndex)
{
    return GetMember(TeamIndex, SquadIndex, SQUAD_LEADER_INDEX);
}

simulated function bool HasSquadLeader(int TeamIndex, int SquadIndex)
{
    return GetSquadLeader(TeamIndex, SquadIndex) != none;
}

simulated function bool IsSquadLeader(DHPlayerReplicationInfo PRI, int TeamIndex, int SquadIndex)
{
    if (PRI == none || PRI.SquadIndex == -1 || PRI.Team == none || PRI.Team.TeamIndex != TeamIndex || PRI.SquadIndex != SquadIndex)
    {
        return false;
    }

    return PRI.SquadMemberIndex == SQUAD_LEADER_INDEX;
}

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

function bool SwapSquadMembers(DHPlayerReplicationInfo A, DHPlayerReplicationInfo B)
{
    local int T, U;

    if (!class'DHPlayerReplicationInfo'.static.IsInSameSquad(A, B))
    {
        return false;
    }

    T = A.SquadMemberIndex;
    U = B.SquadMemberIndex;

    SetMember(A.Team.TeamIndex, A.SquadIndex, T, B);
    SetMember(A.Team.TeamIndex, A.SquadIndex, U, A);

    return true;
}

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

// Returns the index of the newly created squad, or -1 if there was an error.
function byte CreateSquad(DHPlayerReplicationInfo PRI, optional string Name)
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
        PC.ClientCreateSquadResult(SE_AlreadyInSquad);

        return -1;
    }

    TeamIndex = PC.GetTeamNum();

    for (i = 0; i < GetTeamSquadLimit(TeamIndex); ++i)
    {
        if (!IsSquadActive(TeamIndex, i))
        {
            SetMember(TeamIndex, i, SQUAD_LEADER_INDEX, PRI);
            SetName(TeamIndex, i, Name);

            PC.ClientCreateSquadResult(SE_None);

            VRI = DHVoiceReplicationInfo(PC.VoiceReplicationInfo);

            if (VRI != none)
            {
                VRI.JoinSquadChannel(PRI, TeamIndex, i);
            }

            PC.ReceiveLocalizedMessage(SquadMessageClass, 43);

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

    if (!class'DHPlayerReplicationInfo'.static.IsInSameSquad(PRI, NewSquadLeader))
    {
        PC.ClientChangeSquadLeaderResult(SE_InvalidArgument);
        return false;
    }

    if (!SwapSquadMembers(PRI, NewSquadLeader))
    {
        PC.ClientChangeSquadLeaderResult(SE_InvalidArgument);
        return false;
    }

    // "You are no longer the squad leader"
    PC.ReceiveLocalizedMessage(SquadMessageClass, 33);

    PC.ClientChangeSquadLeaderResult(SE_None);

    OtherPC = DHPlayer(NewSquadLeader.Owner);

    if (OtherPC != none)
    {
        // "You are now the squad leader"
        OtherPC.ReceiveLocalizedMessage(SquadMessageClass, 34);
    }

    // "{0} has become the squad leader"
    BroadcastSquadLocalizedMessage(PRI.Team.TeamIndex, PRI.SquadIndex, SquadMessageClass, 35, NewSquadLeader);

    return true;
}

// Returns true if player successfully leaves a squad. The player is guaranteed
// to not be a member of a squad after this call, regardless of the return value.
function bool LeaveSquad(DHPlayerReplicationInfo PRI)
{
    local int TeamIndex;
    local DHPlayer PC;
    local DHVoiceReplicationInfo VRI;
    local VoiceChatRoom SquadVCR, TeamVCR;

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

    // "{0} has left the squad."
    BroadcastSquadLocalizedMessage(TeamIndex, PRI.SquadMemberIndex, SquadMessageClass, 31, PRI);

    if (PRI.SquadMemberIndex == SQUAD_LEADER_INDEX)
    {
        // "The leader has left the squad."
        BroadcastSquadLocalizedMessage(TeamIndex, PRI.SquadMemberIndex, SquadMessageClass, 40);
    }

    SetMember(TeamIndex, PRI.SquadIndex, PRI.SquadMemberIndex, none);

    // Leave the squad voice channel
    VRI = DHVoiceReplicationInfo(PRI.VoiceInfo);

    if (VRI != none)
    {
        SquadVCR = VRI.GetSquadChannel(TeamIndex, PRI.SquadIndex);

        if (SquadVCR != none)
        {
            TeamVCR = VRI.GetChannel("Team", TeamIndex);

            Level.Game.ChangeVoiceChannel(PRI, TeamVCR.ChannelIndex, SquadVCR.ChannelIndex);

            if (TeamVCR != none && TeamVCR.IsMember(PRI))
            {
                PC.ClientSetActiveRoom(TeamVCR.ChannelIndex);
            }

            PC.ServerLeaveVoiceChannel(SquadVCR.ChannelIndex);
        }
    }

    PRI.SquadIndex = -1;
    PRI.SquadMemberIndex = -1;

    PC.ClientLeaveSquadResult(SE_None);

    return true;
}

function bool CommandeerSquad(DHPlayerReplicationInfo PRI, int TeamIndex, int SquadIndex)
{
    local DHPlayer PC;
    local bool bResult;

    if (!IsInSquad(PRI, TeamIndex, SquadIndex) ||
        IsSquadLeader(PRI, TeamIndex, SquadIndex) ||
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

simulated function bool IsInSquad(DHPlayerReplicationInfo PRI, byte TeamIndex, int SquadIndex)
{
    return PRI != none && PRI.Team.TeamIndex == TeamIndex && PRI.SquadIndex == SquadIndex;
}

// Will attempt to join the most populous open squad.
function int JoinSquadAuto(DHPlayerReplicationInfo PRI)
{
    local int i, SquadIndex, MaxMemberCount, MemberCount;

    // TODO: make sure player is not already in a squad
    if (PRI == none || PRI.Team == none || PRI.IsInSquad())
    {
        return -1;
    }

    SquadIndex = -1;

    for (i = 0; i < GetTeamSquadLimit(PRI.Team.TeamIndex); ++i)
    {
        if (IsSquadLocked(PRI.Team.TeamIndex, i))
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

// Returns the index of the new SquadMemberIndex of the player or -1 if
// joining a squad failed.
function int JoinSquad(DHPlayerReplicationInfo PRI, byte TeamIndex, int SquadIndex, optional bool bWasInvited)
{
    local bool bDidJoinSquad;
    local int i;
    local DHPlayer PC;
    local DHVoiceReplicationInfo VRI;

    if (PRI == none || PRI.Team == none || PRI.Team.TeamIndex != TeamIndex)
    {
        return -1;
    }

    PC = DHPlayer(PRI.Owner);

    if (PC == none)
    {
        return -1;
    }

    if (!IsSquadActive(TeamIndex, SquadIndex) || IsInSquad(PRI, TeamIndex, SquadIndex))
    {
        PC.ClientJoinSquadResult(SE_BadSquad);

        return -1;
    }

    if (!bWasInvited && IsSquadLocked(TeamIndex, SquadIndex))
    {
        PC.ClientJoinSquadResult(SE_Locked);

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
        VRI = DHVoiceReplicationInfo(PC.VoiceReplicationInfo);

        if (VRI != none)
        {
            VRI.JoinSquadChannel(PRI, TeamIndex, SquadIndex);
        }

        // "{0} has joined the squad"
        BroadcastSquadLocalizedMessage(TeamIndex, SquadIndex, SquadMessageClass, 30, PRI);

        PC.ClientJoinSquadResult(SE_None);
    }
}

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

simulated function bool IsOnTeam(DHPlayerReplicationInfo PRI, int TeamIndex)
{
    return PRI != none && PRI.Team != none && PRI.Team.TeamIndex == TeamIndex;
}

function bool InviteToSquad(DHPlayerReplicationInfo PRI, byte TeamIndex, int SquadIndex, DHPlayerReplicationInfo Recipient)
{
    local DHPlayer PC, OtherPC;

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

    return true;
}

simulated function bool IsSquadFull(int TeamIndex, int SquadIndex)
{
    return GetMemberCount(TeamIndex, SquadIndex) == GetTeamSquadSize(TeamIndex);
}

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

function bool SetSquadLocked(DHPlayerReplicationInfo PC, int TeamIndex, int SquadIndex, bool bLocked)
{
    if (!IsSquadLeader(PC, TeamIndex, SquadIndex))
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

    if (bLocked)
    {
        BroadcastSquadLocalizedMessage(TeamIndex, SquadIndex, SquadMessageClass, 41);
    }
    else
    {
        BroadcastSquadLocalizedMessage(TeamIndex, SquadIndex, SquadMessageClass, 42);
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

simulated function DHPlayerReplicationInfo GetMember(int TeamIndex, int SquadIndex, int MemberIndex)
{
    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            return AxisMembers[SquadIndex * GetTeamSquadSize(TeamIndex) + MemberIndex];
        case ALLIES_TEAM_INDEX:
            return AlliesMembers[SquadIndex * GetTeamSquadSize(TeamIndex) + MemberIndex];
    }

    return none;
}

// TODO: Sort of inefficient. Rewrite if you're bored.
simulated function int GetMemberCount(int TeamIndex, int SquadIndex)
{
    local array<DHPlayerReplicationInfo> Members;

    GetMembers(TeamIndex, SquadIndex, Members);

    return Members.Length;
}

// Gets a list of all the members in a squad.
simulated function GetMembers(int TeamIndex, int SquadIndex, out array<DHPlayerReplicationInfo> Members)
{
    local int i;
    local DHPlayerReplicationInfo PRI;

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

simulated function bool IsSquadNameTaken(int TeamIndex, string Name)
{
    local int i;

    for (i = 0; i < GetTeamSquadLimit(TeamIndex); ++i)
    {
        if (IsSquadActive(TeamIndex, i) && GetSquadName(TeamIndex, i) ~= Name)
        {
            return true;
        }
    }

    return false;
}

function SetName(int TeamIndex, int SquadIndex, string Name)
{
    local int i;

    if (Name != "")
    {
        if (Len(Name) > SQUAD_NAME_LENGTH_MAX)
        {
            // Name is too long, truncate the name.
            Name = Left(Name, SQUAD_NAME_LENGTH_MAX);
        }

        if (Len(Name) >= SQUAD_NAME_LENGTH_MIN)
        {
            for (i = 0; i < GetTeamSquadLimit(TeamIndex); ++i)
            {
                if (IsSquadNameTaken(TeamIndex, Name))
                {
                    // Squad name is taken, defer to defaults names.
                    Name = "";
                    break;
                }
            }
        }
        else
        {
            // Name is too short, defer to default names.
            Name = "";
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

defaultproperties
{
    AlliesSquadSize=12
    AxisSquadSize=9
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
    SquadMessageClass=class'DHGameMessage'
}
