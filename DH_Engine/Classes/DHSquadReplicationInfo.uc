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

simulated function bool IsSquadActive(byte TeamIndex, int SquadIndex)
{
    return GetMember(TeamIndex, SquadIndex, 0) != none;
}

simulated function bool IsASquadLeader(DHPlayerReplicationInfo PRI)
{
    return PRI != none && PRI.Team != none && PRI == GetSquadLeader(PRI.Team.TeamIndex, PRI.SquadIndex);
}

simulated function DHPlayerReplicationInfo GetSquadLeader(int TeamIndex, int SquadIndex)
{
    return GetMember(TeamIndex, SquadIndex, 0);
}

simulated function bool IsSquadLeader(DHPlayerReplicationInfo PRI, int TeamIndex, int SquadIndex)
{
    if (PRI == none || PRI.SquadIndex == -1 || PRI.Team == none || PRI.Team.TeamIndex != TeamIndex || PRI.SquadIndex != SquadIndex)
    {
        return false;
    }

    return PRI.SquadMemberIndex == 0;
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

function DebugLog(string S)
{
    if (DEBUG)
    {
        Log(S);
    }
}

simulated function bool IsDefaultSquadName(string SquadName, int TeamIndex)
{
    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            return class'UArray'.static.SIndexOf(AxisDefaultSquadNames, SquadName) >= 0;
        default:
            return class'UArray'.static.SIndexOf(AlliesDefaultSquadNames, SquadName) >= 0;
    }
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

        DebugLog(PRI.PlayerName @ "is already in a squad (" $ PRI.SquadIndex $ ")");

        return -1;
    }

    TeamIndex = PC.GetTeamNum();

    for (i = 0; i < GetTeamSquadLimit(TeamIndex); ++i)
    {
        if (!IsSquadActive(TeamIndex, i))
        {
            SetMember(TeamIndex, i, 0, PRI);
            SetName(TeamIndex, i, Name);

            PC.ClientCreateSquadResult(SE_None);

            VRI = DHVoiceReplicationInfo(PC.VoiceReplicationInfo);

            if (VRI != none)
            {
                VRI.JoinSquadChannel(PRI, TeamIndex, i);
            }

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
    local int i;
    local int TeamIndex;
    local DHPlayer PC;
    local DHPlayerReplicationInfo NewSquadLeader;
    local DHPlayer NewSquadLeaderPC;
    local DHVoiceReplicationInfo VRI;

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

    if (PRI.SquadMemberIndex == 0)
    {
        // Player was squad leader, transfer leadership to next in the list
        for (i = 1; i < GetTeamSquadSize(TeamIndex); ++i)
        {
            if (GetMember(TeamIndex, PRI.SquadIndex, i) != none)
            {
                NewSquadLeader = GetMember(TeamIndex, PRI.SquadIndex, i);
                NewSquadLeaderPC = DHPlayer(NewSquadLeader.Owner);

                if (NewSquadLeaderPC != none)
                {
                    // "You are now the squad leader"
                    NewSquadLeaderPC.ReceiveLocalizedMessage(SquadMessageClass, 34);
                }

                // "{0} has become the squad leader"
                BroadcastSquadLocalizedMessage(TeamIndex, PRI.SquadIndex, SquadMessageClass, 35, NewSquadLeader);

                SwapSquadMembers(PRI, NewSquadLeader);

                break;
            }
        }
    }

    SetMember(TeamIndex, PRI.SquadIndex, PRI.SquadMemberIndex, none);

    PRI.SquadIndex = -1;
    PRI.SquadMemberIndex = -1;

    // voice replication info stuff
    VRI = DHVoiceReplicationInfo(PRI.VoiceInfo);

    if (VRI != none)
    {
        VRI.LeaveSquadChannel(PRI, PRI.SquadIndex, PRI.SquadMemberIndex);
    }

    PC.ClientLeaveSquadResult(SE_None);

    return true;
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

simulated function CanJoinSquad(DHPlayerReplicationInfo PRI)
{
}

// Returns the index of the new SquadMemberIndex of the player or -1 if
// joining a squad failed.
function int JoinSquad(DHPlayerReplicationInfo PRI, byte TeamIndex, int SquadIndex)
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

    for (i = 0; i < GetTeamSquadSize(TeamIndex); ++i)
    {
        if (GetMember(TeamIndex, SquadIndex, i) == none)
        {
            // We don't care about the result of ServerLeaveSquad;
            // whatever the result, the player is not in a squad and
            // can join another one.
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

    if (!IsSquadLeader(PRI, TeamIndex, SquadIndex) || PRI == MemberToKick)
    {
        //PC.ClientKickFromSquadResult(SE_InvalidArgument);

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

    // TODO: make sure invitations are not sent super frequently
    OtherPC = DHPlayer(Recipient.Owner);

    if (OtherPC != none)
    {
        // "{0} has been invited to your squad."
        PC.ReceiveLocalizedMessage(SquadMessageClass, 39, Recipient);

        // "{0} has invited you to join {1} squad."
        OtherPC.ClientSquadInvite(PRI.PlayerName, GetSquadName(TeamIndex, SquadIndex), TeamIndex, SquadIndex);

        Level.Game.Broadcast(self, "OtherPC.ClientSquadInvite(GetSquadName("$TeamIndex$", "$SquadIndex$"), "$PRI.PlayerName$", "$TeamIndex$", "$SquadIndex$");");
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

// Gets a list of all the members in a squad. The first entry in the array will always be the squad leader.
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
    AlliesDefaultSquadNames(0)="ABLE"
    AlliesDefaultSquadNames(1)="BAKER"
    AlliesDefaultSquadNames(2)="CHARLIE"
    AlliesDefaultSquadNames(3)="DOG"
    AlliesDefaultSquadNames(4)="EASY"
    AlliesDefaultSquadNames(5)="FOX"
    AlliesDefaultSquadNames(6)="GEORGE"
    AlliesDefaultSquadNames(7)="HOW"
    AxisDefaultSquadNames(0)="ANTON"
    AxisDefaultSquadNames(1)="BERTA"
    AxisDefaultSquadNames(2)="CAESAR"
    AxisDefaultSquadNames(3)="DORA"
    AxisDefaultSquadNames(4)="EMIL"
    AxisDefaultSquadNames(5)="FRITZ"
    AxisDefaultSquadNames(6)="GUSTAV"
    AxisDefaultSquadNames(7)="HEINRICH"
    SquadMessageClass=class'DHGameMessage'
}
