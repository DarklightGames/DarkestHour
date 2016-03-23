//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVoiceReplicationInfo extends TeamVoiceReplicationInfo;

var VoiceChatRoom AxisSquadChannels[8];
var VoiceChatRoom AlliesSquadChannels[8];

replication
{
    reliable if ((bNetDirty || bNetInitial) && Role == ROLE_Authority)
        AxisSquadChannels, AlliesSquadChannels;
}

simulated function VoiceChatRoom GetSquadChannel(int TeamIndex, int SquadIndex)
{
    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            return AxisSquadChannels[SquadIndex];
        case ALLIES_TEAM_INDEX:
            return AlliesSquadChannels[SquadIndex];
    }

    return none;
}

simulated event InitChannels()
{
    local int i;

    super.InitChannels();

    for (i = 0; i < arraycount(AxisSquadChannels); ++i)
    {
        Log("Adding German squad" @ i);

        AddSquadChannel(AXIS_TEAM_INDEX, i);

        Log("VCR=" @ GetSquadChannel(AXIS_TEAM_INDEX, i));
    }

    for (i = 0; i < arraycount(AlliesSquadChannels); ++i)
    {
        Log("Adding Allied squad" @ i);

        AddSquadChannel(ALLIES_TEAM_INDEX, i);

        Log("VCR=" @ GetSquadChannel(ALLIES_TEAM_INDEX, i));
    }
}

simulated function VoiceChatRoom AddSquadChannel(int TeamIndex, int SquadIndex)
{
    local VoiceChatRoom VCR;

    if (GetSquadChannel(TeamIndex, SquadIndex) != none)
    {
        return none;
    }

    VCR = AddVoiceChannel();

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            AxisSquadChannels[SquadIndex] = VCR;
            break;
        case ALLIES_TEAM_INDEX:
            AlliesSquadChannels[SquadIndex] = VCR;
            break;
    }

    return VCR;
}

function LeaveSquadChannel(PlayerReplicationInfo PRI, int TeamIndex, int SquadIndex)
{
    local VoiceChatRoom VCR;

    VCR = GetSquadChannel(TeamIndex, SquadIndex);
    VCR.RemoveMember(PRI);
}

function JoinSquadChannel(PlayerReplicationInfo PRI, int TeamIndex, int SquadIndex)
{
    local VoiceChatRoom VCR;

    VCR = GetSquadChannel(TeamIndex, SquadIndex);

    if (VCR != none)
    {
        VCR.AddMember(PRI);
    }
}

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
}

