//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVoiceChatRoom extends UnrealChatRoom;

// Called after LeaveChannel, or when player exits the server
// NOTE: overridden to eliminate "has left channel" chat messages
function RemoveMember(PlayerReplicationInfo PRI)
{
    if (PRI != none && IsMember(PRI, true))
    {
        SetMask(GetMask() & ~(1 << PRI.VoiceID));
    }
}

function AddMember(PlayerReplicationInfo PRI)
{
    if (IsMember(PRI) || PRI == none)
    {
        return;
    }

    SetMask(GetMask() | (1 << PRI.VoiceID));

    /*
    if (Level.NetMode != NM_Client)
    {
        // Notify all members of this channel that the player has joined the channel
        Members = GetMembers();
        for ( i = 0; i < Members.Length; i++ )
        {
            if ( Members[i] != None && PlayerController(Members[i].Owner) != None )
                PlayerController(Members[i].Owner).ChatRoomMessage( 11, ChannelIndex, PRI );
        }
    }
    */
}

simulated function int Count()
{
    local int i, x;
    local int MemberMask;

    if ( !ValidMask() )
        return 0;

    MemberMask = GetMask();
    for ( i = 0; i < 254; i++ )
    {
        if ( bool(MemberMask & ( 1 << i )) )
            x++;
    }

    return x;
}

defaultproperties
{
}
