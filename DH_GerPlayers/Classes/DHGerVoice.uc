class DHGerVoice extends ROGerman1Voice;

static function xPlayerSpeech(name Type, int Index, PlayerReplicationInfo SquadLeader, Actor PackOwner)
{
    local name broadcasttype;
    local vector myLoc;
	//Log("ROVoicePack::PlayerSpeech() Type = "$Type$" Index = "$Index);
	    broadcasttype = 'GLOBAL';
    if (Controller(PackOwner).Pawn == none)
        myLoc = PackOwner.Location;
    else
        myLoc = Controller(PackOwner).Pawn.Location;

    Controller(PackOwner).SendVoiceMessage(Controller(PackOwner).PlayerReplicationInfo, SquadLeader, Type, Index, broadcasttype, Controller(PackOwner).Pawn, myLoc);
}

defaultproperties
{
     SupportStringAxis(5)="We need a Panzerschreck!"
     SupportAbbrevAxis(5)="Need a Panzerschreck"
     ExtraSound(2)=SoundGroup'DH_Ger_Voice_Infantry.insults.insult'
     ShoutRadius=1024.000000
     WhisperRadius=128.000000
     bUseLocationalVoice=true
}
