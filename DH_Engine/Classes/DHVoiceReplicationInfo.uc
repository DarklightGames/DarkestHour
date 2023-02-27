//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVoiceReplicationInfo extends TeamVoiceReplicationInfo;

const SQUAD_CHANNELS_MAX = 8;

var VoiceChatRoom               AxisSquadChannels[SQUAD_CHANNELS_MAX];
var VoiceChatRoom               AlliesSquadChannels[SQUAD_CHANNELS_MAX];

var localized string            LocalChannelText;

var string                      UnassignedChannelName;
var string                      LocalChannelName;
var string                      SquadChannelName;
var string                      CommandChannelName;

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
    local VoiceChatRoom VCR;

    // Axis Command Channel
    VCR = AddVoiceChannel();
    if (VCR != none)
    {
        VCR.SetTeam(AXIS_TEAM_INDEX);
    }

    // Allied Command Channel
    VCR = AddVoiceChannel();
    if (VCR != none)
    {
        VCR.SetTeam(ALLIES_TEAM_INDEX);
    }

    // Axis Unassigned Channel
    VCR = AddVoiceChannel();
    if (VCR != none)
    {
        VCR.SetTeam(AXIS_TEAM_INDEX);
    }

    // Allied Unassigned Channel
    VCR = AddVoiceChannel();
    if (VCR != none)
    {
        VCR.SetTeam(ALLIES_TEAM_INDEX);
    }

    // Squad Channels
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

function LeaveUnassignedChannel(PlayerReplicationInfo PRI, int TeamIndex)
{
    local VoiceChatRoom VCR;

    VCR = GetChannel(UnassignedChannelName, TeamIndex);

    if (VCR != none)
    {
        VCR.RemoveMember(PRI);
    }
}

function JoinSquadChannel(PlayerReplicationInfo PRI, int TeamIndex, int SquadIndex)
{
    local VoiceChatRoom VCR;

    VCR = GetSquadChannel(TeamIndex, SquadIndex);

    if (VCR != none)
    {
        VCR.AddMember(PRI);
    }

    LeaveUnassignedChannel(PRI, TeamIndex);
}

// Modified to remove the annoying log that would be called whenever a player
// changed teams.
function VerifyTeamChatters()
{
    local Controller P;
    local VoiceChatRoom ChatChannel, FixedChannel;
    local int OpposingIndex;
    local PlayerController PC;
    local DHPlayerReplicationInfo PRI;

    for (P = Level.ControllerList; P != none; P = P.NextController)
    {
        PC = PlayerController(P);

        if (PC != none)
        {
            PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
        }

        if (PRI != none && P.PlayerReplicationInfo != none && P.PlayerReplicationInfo.Team != none)
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

            ChatChannel = GetChannel(UnassignedChannelName, OpposingIndex);

            // If player is already in a squad, then ignore
            if (PRI.IsInSquad())
            {
                continue;
            }

            if (ChatChannel.IsMember(P.PlayerReplicationInfo))
            {
                FixedChannel = GetChannel(UnassignedChannelName, P.PlayerReplicationInfo.Team.TeamIndex);

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
    LocalChannelText="Local"
    PublicChannelNames(0)="Command" //Axis
    PublicChannelNames(1)="Command" //Allies
    PublicChannelNames(2)="Unassigned" //Axis
    PublicChannelNames(3)="Unassigned" //Allies
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

    InstalledCodec[0]=(Codec="CODEC_96WB",CodecName="Better Quality",CodecDescription="(9.6kbps) - Uses more bandwidth, but sound is much clearer.")
    InstalledCodec[1]=(Codec="CODEC_96WB",CodecName="Better Quality",CodecDescription="(9.6kbps) - Uses more bandwidth, but sound is much clearer.")
    VoIPInternetCodecs[0]="CODEC_96WB"
    VoIPInternetCodecs[1]="CODEC_96WB"
    VoIPLANCodecs[0]="CODEC_96WB"
    VoIPLANCodecs[1]="CODEC_96WB"

    UnassignedChannelName="Unassigned"
    LocalChannelName="Local"
    SquadChannelName="Squad"
    CommandChannelName="Command"
}

