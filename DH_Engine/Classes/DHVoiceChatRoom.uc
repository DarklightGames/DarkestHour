//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHVoiceChatRoom extends UnrealChatRoom;

var int SquadIndex;

// Called after LeaveChannel, or when player exits the server
// NOTE: overridden to eliminate "has left channel" chat messages
function RemoveMember(PlayerReplicationInfo PRI)
{
    if (PRI != none && PRI.VoiceID < 255 && IsMember(PRI, true))
    {
        SetMask(GetMask() & ~(1 << PRI.VoiceID));
    }
}

simulated function bool IsSquadChannel()
{
    return SquadIndex >= 0;
}

simulated function bool IsCommandChannel()
{
    return ChannelIndex == 0;
}

simulated event bool IsMember(PlayerReplicationInfo PRI, optional bool bNoCascade)
{
    local DHPlayerReplicationInfo   MyPRI;
    local Pawn                      OwnerPawn, CheckPawn;
    //local DHPlayer                  PC;

    MyPRI = DHPlayerReplicationInfo(PRI);

    if (PRI.Team != none && PRI.Team.TeamIndex == GetTeam())
    {
        if (IsSquadChannel())
        {
            return MyPRI != none && MyPRI.SquadIndex == SquadIndex;
        }
        else if (IsCommandChannel() && MyPRI.IsSquadLeader())
        {
            return true;
        }
        else if (!IsSquadChannel() && MyPRI.IsInSquad())
        {
            return false;
        }
        else if (IsPrivateChannel())
        {
            // Get owner pawn
            if (PlayerReplicationInfo(Owner) != none && PlayerReplicationInfo(Owner).Owner != none && PlayerController(PlayerReplicationInfo(Owner).Owner).Pawn != none)
            {
                OwnerPawn = PlayerController(PlayerReplicationInfo(Owner).Owner).Pawn;
            }

            // Get CheckPawn
            if (MyPRI != none && MyPRI.Owner != none && PlayerController(MyPRI.Owner).Pawn != none)
            {
                CheckPawn = PlayerController(MyPRI.Owner).Pawn;
            }

            if (OwnerPawn != none && CheckPawn != none && VSizeSquared(OwnerPawn.Location - CheckPawn.Location) < Square(class'DHVoiceReplicationInfo'.default.LocalBroadcastRange))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        else
        {
            return true;
        }
    }

    if (super(VoiceChatRoom).IsMember(PRI, bNoCascade))
    {
        return true;
    }

    if (!ValidMask() || PRI == none || PRI.VoiceID == 255)
    {
        return false;
    }

    return bool(GetMask() & (1 << PRI.VoiceID));
}

simulated function array<PlayerReplicationInfo> GetMembers()
{
    local array<PlayerReplicationInfo>      PRIArray;
    local int                               i;

    if (GRI != none)
    {
        for (i = 0; i < GRI.PRIArray.Length; ++i)
        {
            if (IsMember(GRI.PRIArray[i]) || (IsPrivateChannel() && GRI.PRIArray[i].Team != none && GRI.PRIArray[i].Team.TeamIndex == GetTeam()))
            {
                PRIArray[PRIArray.Length] = GRI.PRIArray[i];
            }
        }
    }

    return PRIArray;
}

defaultproperties
{
    SquadIndex=-1
}

