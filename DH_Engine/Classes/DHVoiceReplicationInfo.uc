//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHVoiceReplicationInfo extends TeamVoiceReplicationInfo;

const SQUAD_CHANNELS_MAX = 8;

var     VoiceChatRoom   AxisSquadChannels[SQUAD_CHANNELS_MAX];
var     VoiceChatRoom   AlliesSquadChannels[SQUAD_CHANNELS_MAX];

replication
{
    reliable if ((bNetDirty || bNetInitial) && Role == ROLE_Authority)
        AxisSquadChannels, AlliesSquadChannels;
}

simulated function VoiceChatRoom GetSquadChannel(int TeamIndex, int SquadIndex)
{
    if (SquadIndex < 0 || SquadIndex >= SQUAD_CHANNELS_MAX)
    {
        return none;
    }

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
        AddSquadChannel(AXIS_TEAM_INDEX, i);
    }

    for (i = 0; i < arraycount(AlliesSquadChannels); ++i)
    {
        AddSquadChannel(ALLIES_TEAM_INDEX, i);
    }
}

simulated function bool ValidRoom(VoiceChatRoom Room)
{
    return bEnableVoiceChat && Room != none && Room.ChannelIndex < 20 && Room.Owner == self;
}

simulated function VoiceChatRoom AddSquadChannel(int TeamIndex, int SquadIndex)
{
    local DHVoiceChatRoom VCR;

    if (GetSquadChannel(TeamIndex, SquadIndex) != none)
    {
        return none;
    }

    VCR = DHVoiceChatRoom(AddVoiceChannel());

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            AxisSquadChannels[SquadIndex] = VCR;
            break;
        case ALLIES_TEAM_INDEX:
            AlliesSquadChannels[SquadIndex] = VCR;
            break;
    }

    VCR.SetTeam(TeamIndex);
    VCR.SquadIndex = SquadIndex;

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
    ChatBroadcastClass=class'DH_Engine.DHChatHandler'
    PublicChannelNames(3)="Team"
    PublicChannelNames(4)="Squad"
    PublicChannelNames(5)="Squad"
    PublicChannelNames(6)="Squad"
    PublicChannelNames(7)="Squad"
    PublicChannelNames(8)="Squad"
    PublicChannelNames(9)="Squad"
    PublicChannelNames(10)="Squad"
    PublicChannelNames(11)="Squad"
    PublicChannelNames(12)="Squad"
    PublicChannelNames(13)="Squad"
    PublicChannelNames(14)="Squad"
    PublicChannelNames(15)="Squad"
    PublicChannelNames(16)="Squad"
    PublicChannelNames(17)="Squad"
    PublicChannelNames(18)="Squad"
    PublicChannelNames(19)="Squad"
}
