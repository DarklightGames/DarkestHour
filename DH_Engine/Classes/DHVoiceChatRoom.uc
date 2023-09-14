//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVoiceChatRoom extends UnrealChatRoom;

var     int     SquadIndex;
var     float   LocalBroadcastRangeSquared;

// Called after LeaveChannel, or when player exits the server
// NOTE: overridden to eliminate "has left channel" chat messages, & also to allow more than 32 VoiceIDs
function RemoveMember(PlayerReplicationInfo PRI)
{
    if (PRI != none && PRI.VoiceID != 255 && IsMember(PRI, true))
    {
        SetMask(GetMask() & ~(1 << PRI.VoiceID));
    }
}

// I think I may have fixed the >64 players voice chat bug!!! (allow more than 32 VoiceIDs)
function AddMember(PlayerReplicationInfo PRI)
{
    local array<PlayerReplicationInfo> Members;
    local int                          i;

    if (PRI == none || PRI.VoiceID == 255 || IsMember(PRI))
    {
        return;
    }

    if (Level.NetMode != NM_Client)
    {
        // Notify all members of this channel that the player has joined the channel
        Members = GetMembers();

        for (i = 0; i < Members.Length; ++i)
        {
            if (Members[i] != none && PlayerController(Members[i].Owner) != none)
            {
                PlayerController(Members[i].Owner).ChatRoomMessage(11, ChannelIndex, PRI);
            }
        }
    }

    SetMask(GetMask() | (1 << PRI.VoiceID));

    super(VoiceChatRoom).AddMember(PRI);
}

simulated function bool IsSquadChannel()
{
    return SquadIndex >= 0;
}

simulated function bool IsAxisCommandChannel()
{
    return ChannelIndex == 0;
}

simulated function bool IsAlliesCommandChannel()
{
    return ChannelIndex == 1;
}

simulated function bool IsUnassignedChannel()
{
    return ChannelIndex == 2 || ChannelIndex == 3;
}

simulated event bool IsMember(PlayerReplicationInfo PRI, optional bool bNoCascade)
{
    local DHPlayerReplicationInfo MyPRI;
    local PlayerReplicationInfo   OwnerPRI;
    local PlayerController        OwnerPC;
    local Pawn                    OwnerPawn, CheckPawn;

    MyPRI = DHPlayerReplicationInfo(PRI);

    if (MyPRI != none && MyPRI.Team != none && MyPRI.Team.TeamIndex == GetTeam())
    {
        if (IsSquadChannel() &&
            MyPRI.SquadIndex == SquadIndex)
        {
            return true;
        }
        else if (((IsAlliesCommandChannel() && MyPRI.Team.TeamIndex == ALLIES_TEAM_INDEX) ||
                  (IsAxisCommandChannel() && MyPRI.Team.TeamIndex == AXIS_TEAM_INDEX)) &&
                 MyPRI.CanAccessCommandChannel())
        {
            return true;
        }
        else if (IsPrivateChannel())
        {
            // Okay this channel is a private channel, which means it has an owner, which then we can compare team with
            // Then we can compare distance between pawns (and that they have pawns)

            // Begin establishing the Owner variables and exit if we can't get them
            OwnerPRI = PlayerReplicationInfo(Owner);

            if (OwnerPRI != none)
            {
                OwnerPC = PlayerController(OwnerPRI.Owner);

                if (OwnerPC != none)
                {
                    OwnerPawn = OwnerPC.Pawn;
                }
            }

            if (OwnerPawn == none)
            {
                return false;
            }

            // Get the checked player's pawn
            if (PlayerController(MyPRI.Owner) != none)
            {
                CheckPawn = PlayerController(MyPRI.Owner).Pawn;
            }

            // Now do a check on the pawn distance and return results
            return CheckPawn != none && VSizeSquared(OwnerPawn.Location - CheckPawn.Location) < LocalBroadcastRangeSquared;
        }
        else if (IsUnassignedChannel() && !MyPRI.IsInSquad())
        {
            // If this is an unassigned channel and we are NOT in a squad, then return true
            return true;
        }
    }

    // Any other case, return false
    return false;
}

simulated function array<PlayerReplicationInfo> GetMembers()
{
    local array<PlayerReplicationInfo> PRIArray;
    local int                          i;

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
    LocalBroadcastRangeSquared=4000000.0
}
