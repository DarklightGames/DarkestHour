//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHVoicePack extends ROVoicePack
    abstract;

static function xPlayerSpeech(name Type, int Index, PlayerReplicationInfo SquadLeader, Actor PackOwner)
{
    local name BroadcastType;
    local vector MyLocation;

    BroadcastType = 'GLOBAL';

    if (Controller(PackOwner).Pawn == none)
    {
        MyLocation = PackOwner.Location;
    }
    else
    {
        MyLocation = Controller(PackOwner).Pawn.Location;
    }

    Controller(PackOwner).SendVoiceMessage(Controller(PackOwner).PlayerReplicationInfo, SquadLeader, Type, Index, broadcasttype, Controller(PackOwner).Pawn, MyLocation);
}

defaultproperties
{
    ShoutRadius=1024.000000
    WhisperRadius=128.000000
    bUseLocationalVoice=true
}

