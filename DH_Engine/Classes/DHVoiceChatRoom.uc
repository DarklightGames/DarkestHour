//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHVoiceChatRoom extends UnrealChatRoom;

var int SquadIndex;
var float LocalBroadcastRangeSquared;


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
    local DHPlayerReplicationInfo   MyPRI;
    local Pawn                      OwnerPawn, CheckPawn;
    local PlayerController          OwnerPC;
    local PlayerReplicationInfo     OwnerPRI;

    if (PRI != none)
    {
        MyPRI = DHPlayerReplicationInfo(PRI);
    }

    if (MyPRI != none && MyPRI.Team != none && MyPRI.Team.TeamIndex == GetTeam())
    {
        if (IsSquadChannel() && MyPRI.SquadIndex == SquadIndex)
        {
            // If the channel is squad and is the right squad index, then return true
            return true;
        }
        else if (IsAlliesCommandChannel() && MyPRI.IsSquadLeader() && MyPRI.Team.TeamIndex == ALLIES_TEAM_INDEX)
        {
            // If its the Allied command channel and player is a SL and player is on Allies, then return true
            return true;
        }
        else if (IsAxisCommandChannel() && MyPRI.IsSquadLeader() && MyPRI.Team.TeamIndex == AXIS_TEAM_INDEX)
        {
            // If its the Axis command channel and player is a SL and player is on Axis, then return true
            return true;
        }
        else if (IsPrivateChannel())
        {
            // Okay this channel is a private channel, which means it has an owner, which then we can compare team with
            // Then we can compare distance between pawns (and that they have pawns)

            // Begin establishing the Owner variables and do null checks
            OwnerPRI = PlayerReplicationInfo(Owner);

            if (OwnerPRI != none && PlayerController(OwnerPRI.Owner) != none)
            {
                OwnerPC = PlayerController(OwnerPRI.Owner);
            }

            if (OwnerPC != none)
            {
                OwnerPawn = OwnerPC.Pawn;
            }

            // Check for null variables
            if (OwnerPRI == none || OwnerPC == none || OwnerPawn == none)
            {
                return false;
            }

            // Get the checked player's pawn
            if (MyPRI != none && PlayerController(MyPRI.Owner) != none)
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
    bLocal=true
    SquadIndex=-1
    LocalBroadcastRangeSquared=4000000.0
}

