//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHVoiceReplicationInfo extends TeamVoiceReplicationInfo;

// Colin: Modified to remove the annoying log that would be called whenever
// a player changed teams.
function VerifyTeamChatters()
{
    local Controller P;
    local VoiceChatRoom ChatChannel, FixedChannel;
    local int OpposingIndex;
    local PlayerController PC;

    for (P = Level.ControllerList; P != none; P = P.NextController)
    {
        PC = PlayerController(P);

        if (PC != none && P.PlayerReplicationInfo != none && P.PlayerReplicationInfo.Team != none)
        {
            if (P.PlayerReplicationInfo.Team.TeamIndex == ALLIES_TEAM_INDEX)
            {
                OpposingIndex = AXIS_TEAM_INDEX;
            }
            else if (P.PlayerReplicationInfo.Team.TeamIndex == AXIS_TEAM_INDEX)
            {
                OpposingIndex = ALLIES_TEAM_INDEX;
            }
            else
            {
                continue;
            }

            ChatChannel = GetChannel("Team", OpposingIndex);

            if (ChatChannel.IsMember(P.PlayerReplicationInfo))
            {
                FixedChannel = GetChannel("Team", P.PlayerReplicationInfo.Team.TeamIndex);

                Level.Game.ChangeVoiceChannel(P.PlayerReplicationInfo, FixedChannel.ChannelIndex, ChatChannel.ChannelIndex);

                if (P.PlayerReplicationInfo != none)
                {
                    P.PlayerReplicationinfo.ActiveChannel = FixedChannel.ChannelIndex;
                }

                PC.ActiveRoom = FixedChannel;
                PC.ClientSetActiveRoom(FixedChannel.ChannelIndex);
            }
        }
    }
}

defaultproperties
{
    ChatRoomClass=class'DH_Engine.DHVoiceChatRoom'
    ChatBroadcastClass=class'DH_Engine.DHChatHandler'
}
