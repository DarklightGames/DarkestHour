class DHVoiceChatRoom extends UnrealChatRoom;

// Called after LeaveChannel, or when player exits the server
// NOTE: Overriden to eliminate "has left channel" chat messages
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

