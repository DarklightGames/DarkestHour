//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHSquad extends Actor
    notplaceable;

const SQUAD_LEADER_MEMBER_INDEX = 0;
const SQUAD_MEMBERS_MAX = 16;

var private byte                    TeamIndex;
var private byte                    SquadIndex;

var string                          SquadName;
var private DHPlayerReplicationInfo Members[SQUAD_MEMBERS_MAX];
var private byte                    MembersMax;
var int                             NextRallyPointTime;
var bool                            bIsLocked;
var byte                            AssistantSquadLeaderMemberIndex;

var array<string>                   Bans;  // List of ROIDs that are banned from the squad.

var array<DHPlayerReplicationInfo>  SquadLeaderVolunteers;

// TODO: we also manage the rallies in here??

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        TeamIndex, SquadIndex, MembersMax;

    reliable if (bNetDirty && Role == ROLE_Authority)
        SquadName, AssistantSquadLeaderMemberIndex, Members, NextRallyPointTime, bIsLocked;
}

function Setup(byte TeamIndex, byte SquadIndex)
{
    self.TeamIndex = TeamIndex;
    self.SquadIndex = SquadIndex;
}

simulated function byte GetTeamIndex()
{
    return TeamIndex;
}

simulated function byte GetSquadIndex()
{
    return SquadIndex;
}

simulated function byte GetMembersMax()
{
    return Clamp(MembersMax, 1, SQUAD_MEMBERS_MAX);
}

simulated function DHPlayerReplicationInfo GetSquadLeader()
{
    return Members[SQUAD_LEADER_MEMBER_INDEX];
}

simulated function DHPlayerReplicationInfo GetAssistantSquadLeader()
{
    if (AssistantSquadLeaderMemberIndex == -1)
    {
        return none;
    }

    return Members[AssistantSquadLeaderMemberIndex];
}

simulated function Destroyed()
{
    if (Role == ROLE_Authority)
    {
        RemoveAllMembers();
    }

    super.Destroyed();
}

//==============================================================================
// MEMBERS
//==============================================================================

private function RemoveAllMembers()
{
    local int i;

    for (i = 0; i < arraycount(Members); ++i)
    {
        SetMember(i, none);
    }
}

simulated function bool IsMemberIndexValid(int MemberIndex)
{
    return MemberIndex >= 0 && MemberIndex < arraycount(Members);
}

function bool RemoveMember(DHPlayerReplicationInfo Member)
{
    local int MemberIndex;
    
    MemberIndex = GetMemberIndex(Member);

    if (MemberIndex == -1)
    {
        return false;
    }

    SetMember(MemberIndex, none);
}

function SetMember(int MemberIndex, DHPlayerReplicationInfo PRI)
{
    local DHPlayerReplicationInfo OldMember;

    if (!IsMemberIndexValid(MemberIndex))
    {
        return;
    }

    OldMember = Members[MemberIndex];

    if (OldMember == PRI)
    {
        // No change.
        return;
    }

    Members[MemberIndex] = PRI;

    if (PRI != none)
    {
        PRI.SquadIndex = SquadIndex;
        PRI.SquadMemberIndex = MemberIndex;
    }

    if (OldMember != none)
    {
        OldMember.SquadIndex = OldMember.default.SquadIndex;
        OldMember.SquadMemberIndex = OldMember.default.SquadMemberIndex;

        // TODO: remove from the squad volunteer list.
    }
    
    if (!bDeleteMe)
    {
        if (GetMemberCount() == 0)
        {
            // No members left, destroy the squad.
            Destroy();
        }
    }
}

simulated function DHPlayerReplicationInfo GetMember(int MemberIndex)
{
    if (!IsMemberIndexValid(MemberIndex))
    {
        return none;
    }

    return Members[MemberIndex];
}

simulated function int GetMemberIndex(DHPlayerReplicationInfo PRI)
{
    local int i;

    if (PRI == none)
    {
        return -1;
    }

    for (i = 0; i < arraycount(Members); ++i)
    {
        if (Members[i] == PRI)
        {
            return i;
        }
    }

    return -1;
}

simulated function array<DHPlayerReplicationInfo> GetMembers()
{
    local int i;
    local array<DHPlayerReplicationInfo> Members;

    for (i = 0; i < arraycount(self.Members); ++i)
    {
        if (self.Members[i] != none)
        {
            Members[Members.Length] = self.Members[i];
        }
    }

    return Members;
}


simulated function int GetMemberCount()
{
    local int i, Count;

    for (i = 0; i < arraycount(Members); ++i)
    {
        if (Members[i] != none)
        {
            ++Count;
        }
    }
    
    return Count;
}

simulated function bool HasMember(DHPlayerReplicationInfo PRI)
{
    return GetMemberIndex(PRI) >= 0;
}

simulated function bool HasMembers()
{
    return GetMemberCount() > 0;
}

//==============================================================================
// BANS
//==============================================================================

function bool IsPlayerBanned(string ROID)
{
    local int i;

    for (i = 0; i < Bans.Length; ++i)
    {
        if (Bans[i] == ROID)
        {
            return true;
        }
    }

    return false;
}

function BanPlayer(string ROID)
{
    class'UArray'.static.SAddUnique(Bans, ROID);
}

function bool UnbanPlayer(string ROID)
{
    local int i;

    for (i = 0; i < Bans.Length; ++i)
    {
        if (Bans[i] == ROID)
        {
            Bans.Remove(i, 1);
            return true;
        }
    }

    return false;
}

function ClearBans()
{
    Bans.Length = 0;
}

//==============================================================================
// SQUAD LEADER VOLUNTEERS
//==============================================================================

function array<DHPlayerReplicationInfo> GetSquadLeaderVolunteers()
{
    return SquadLeaderVolunteers;
}

function ClearSquadLeaderVolunteers()
{
    SquadLeaderVolunteers.Length = 0;
}

function RemoveSquadLeaderVolunteer(DHPlayerReplicationInfo PRI)
{
    Class'UArray'.static.Erase(SquadLeaderVolunteers, PRI);
}

function bool AddSquadLeaderVolunteer(DHPlayerReplicationInfo PRI)
{
    if (HasMember(PRI))
    {
        Class'UArray'.static.AddUnique(SquadLeaderVolunteers, PRI);

        return true;
    }

    return false;
}

defaultproperties
{
    RemoteRole=ROLE_DumbProxy
    bReplicateMovement=false
    bAlwaysRelevant=true
    bHidden=true
    DrawType=DT_None
    AssistantSquadLeaderMemberIndex=-1

    MembersMax=20
}
