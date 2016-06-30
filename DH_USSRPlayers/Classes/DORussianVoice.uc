//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DORussianVoice extends RORussian1Voice;

static function xPlayerSpeech(name Type, int Index, PlayerReplicationInfo SquadLeader, Actor PackOwner)
{
    local name broadcasttype;
    local vector myLoc;

    broadcasttype = 'GLOBAL';

    if (Controller(PackOwner).Pawn == none)
    {
        myLoc = PackOwner.Location;
    }
    else
    {
        myLoc = Controller(PackOwner).Pawn.Location;
    }

    Controller(PackOwner).SendVoiceMessage( Controller(PackOwner).PlayerReplicationInfo, SquadLeader, Type, Index, broadcasttype, Controller(PackOwner).Pawn, myLoc);
}

defaultproperties
{
    ShoutRadius=1024.000000
    WhisperRadius=128.000000
    bUseLocationalVoice=True
}
