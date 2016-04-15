//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVoiceChatRoom extends UnrealChatRoom;

var int SquadIndex;

// Called after LeaveChannel, or when player exits the server
// NOTE: overridden to eliminate "has left channel" chat messages
function RemoveMember(PlayerReplicationInfo PRI)
{
    if (PRI != none && PRI.VoiceID < 32 && IsMember(PRI, true))
    {
        SetMask(GetMask() & ~(1 << PRI.VoiceID));
    }
}

simulated function bool IsSquadChannel()
{
    return SquadIndex >= 0;
}

simulated event bool IsMember(PlayerReplicationInfo PRI, optional bool bNoCascade)
{
    local DHPlayerReplicationInfo MyPRI;

    MyPRI = DHPlayerReplicationInfo(PRI);

    if (Level.Game != none)
    {
        if (PRI.Team != none && PRI.Team.TeamIndex == GetTeam())
        {
            //Log("We are getting in the IsMember Team checking stuff");

            if (IsSquadChannel())
            {
                Log("Squad index:" @ SquadIndex);

                Log("Returning:" @ (MyPRI != none && MyPRI.SquadIndex == SquadIndex) @ "In squad check");

                return MyPRI != none && MyPRI.SquadIndex == SquadIndex;
            }

            Log("Returning true in team check");
            return true;
        }
    }

    if (super(VoiceChatRoom).IsMember(PRI, bNoCascade))
    {
        Log("Returning true in super");
        return true;
    }

    if (!ValidMask() || PRI == None || PRI.VoiceID == 255)
    {
        Log("Returning false in mask check");
        return false;
    }

    Log("Returning:" @ bool(GetMask() & (1 << PRI.VoiceID)) @ "PlayerName:" @ PRI.GetHumanReadableName());
    return bool(GetMask() & (1 << PRI.VoiceID));
}

defaultproperties
{
    SquadIndex=-1
}
