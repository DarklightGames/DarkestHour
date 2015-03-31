//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVoiceChatRoom extends UnrealChatRoom;

// Called after LeaveChannel, or when player exits the server
// NOTE: overridden to eliminate "has left channel" chat messages
function RemoveMember(PlayerReplicationInfo PRI)
{
    if (PRI != none && PRI.VoiceID < 32 && IsMember(PRI, true))
    {
        SetMask(GetMask() & ~(1<<PRI.VoiceID));
    }
}

defaultproperties
{
}
