//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVoicePack extends ROVoicePack
    abstract;

static function xPlayerSpeech(name Type, int Index, PlayerReplicationInfo SquadLeader, Actor PackOwner)
{
    local vector MyLocation;

    if (Controller(PackOwner).Pawn == none)
    {
        MyLocation = PackOwner.Location;
    }
    else
    {
        MyLocation = Controller(PackOwner).Pawn.Location;
    }

    Controller(PackOwner).SendVoiceMessage(Controller(PackOwner).PlayerReplicationInfo, SquadLeader, Type, Index, 'GLOBAL', Controller(PackOwner).Pawn, MyLocation);
}

defaultproperties
{
    ShoutRadius=1024.0
    WhisperRadius=128.0
    bUseLocationalVoice=true
}

