//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVoicePack extends ROVoicePack
    abstract;

var SoundGroup RadioRequestSound;
var SoundGroup RadioResponseConfirmSound;
var SoundGroup RadioResponseDenySound;

static function xPlayerSpeech(name Type, int Index, PlayerReplicationInfo SquadLeader, Actor PackOwner)
{
    local vector MyLocation;
    local Controller C;

    C = Controller(PackOwner);

    if (C == none)
    {
        return;
    }

    if (C.Pawn == none)
    {
        MyLocation = PackOwner.Location;
    }
    else
    {
        MyLocation = C.Pawn.Location;
    }

    C.SendVoiceMessage(C.PlayerReplicationInfo, SquadLeader, Type, Index, 'GLOBAL', C.Pawn, MyLocation);
}

function SetClientDefendMessage(int MessageIndex, PlayerReplicationInfo Recipient, out sound MessageSound)
{
    local DHGameReplicationInfo GRI;
    local DHPlayer PC;

    PC = DHPlayer(Owner);

    if (PC != none)
    {
       GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    }

    MessageSound = OrderSound[1];
    MessageString = Repl(OrderString[1], "{objective}", GRI.DHObjectives[MessageIndex].ObjName);
    MessageAnim = DefendAnim;
}

function SetClientHelpAtMessage(int MessageIndex, PlayerReplicationInfo Recipient, out sound MessageSound)
{
    local DHGameReplicationInfo GRI;
    local DHPlayer PC;

    PC = DHPlayer(Owner);

    if (PC != none)
    {
       GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    }

    MessageSound = SupportSound[1];
    MessageString = Repl(SupportString[1], "{objective}", GRI.DHObjectives[MessageIndex].ObjName);
    MessageAnim = DefendAnim;
}

function SetClientUnderAttackAtMessage(int MessageIndex, PlayerReplicationInfo Recipient, out sound MessageSound)
{
    local DHGameReplicationInfo GRI;
    local DHPlayer PC;

    PC = DHPlayer(Owner);

    if (PC != none)
    {
       GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    }

    MessageSound = AlertSound[8];
    MessageString = Repl(AlertString[8], "{objective}", GRI.DHObjectives[MessageIndex].ObjName);
    MessageAnim = DefendAnim;
}

function SetClientGotoMessage(int MessageIndex, PlayerReplicationInfo Recipient, out sound MessageSound)
{
    local DHGameReplicationInfo GRI;
    local DHPlayer PC;

    PC = DHPlayer(Owner);

    if (PC != none)
    {
       GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    }

    MessageSound = VehicleDirectionSound[0];
    MessageString = Repl(VehicleDirectionString[0], "{objective}", GRI.DHObjectives[MessageIndex].ObjName);
    MessageAnim = '';
}

function SetClientAttackMessage(int MessageIndex, PlayerReplicationInfo Recipient, out sound MessageSound)
{
    local DHGameReplicationInfo GRI;
    local DHPlayer PC;

    PC = DHPlayer(Owner);

    if (PC != none)
    {
       GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    }

    MessageSound = OrderSound[0];
    MessageString = Repl(OrderString[0], "{objective}", GRI.DHObjectives[MessageIndex].ObjName);
    MessageAnim = AttackAnim;
}

function Timer()
{
    local PlayerController PlayerOwner;
    local Actor SoundPlayer;
    CONST VOICEREPEATTIME = 0.0;

    PlayerOwner = PlayerController(Owner);

    if (bDisplayPortrait && (PhraseNum == 0) && !(bIsFromDifferentTeam && bUseAxisStrings))
    {
        PlayerController(Owner).myHUD.DisplayPortrait(PortraitPRI);
    }

    if ((Phrase[PhraseNum] != none) && ((Level.TimeSeconds - PlayerOwner.LastPlaySpeech > VOICEREPEATTIME) || (PhraseNum > 0)))
    {
        PlayerOwner.LastPlaySpeech = Level.TimeSeconds;

        if (bUseLocationalVoice)
        {
            if (PawnSender != none)
            {
                PawnSender.PlaySound(Phrase[PhraseNum], SLOT_None, ShoutVolume,, ShoutRadius, 1.0, true);
            }
            else
            {
                SoundPlayer = Spawn(class'ROVoiceMessageEffect',,, senderLoc);

                if (SoundPlayer != none)
                {
                    SoundPlayer.PlaySound(Phrase[PhraseNum], SLOT_None, ShoutVolume,, ShoutRadius, 1.0, true);
                }
                else
                {
                    Warn("Unable to spawn ROVoiceMessageEffect at " $ senderLoc $ "!");
                }
            }
        }
        else
        {
            if (PlayerOwner.ViewTarget != none)
            {
                PlayerOwner.ViewTarget.PlaySound(Phrase[PhraseNum], SLOT_Interface, ShoutVolume,, ShoutRadius, 1.0, true);
            }
            else
            {
                PlayerOwner.PlaySound(Phrase[PhraseNum], SLOT_Interface, ShoutVolume,, ShoutRadius, 1.0, true);
            }
        }

        if (MessageAnim != '')
        {
            UnrealPlayer(PlayerOwner).Taunt(MessageAnim);
        }

        if (Phrase[PhraseNum + 1] == none)
        {
            Destroy();
        }
        else
        {
            if (GetSoundDuration(Phrase[PhraseNum]) == 0)
            {
                Log("ROVoicePack Setting the timer for a sound to zero");
            }

            SetTimer(FMax(0.1, GetSoundDuration(Phrase[PhraseNum])), false);
            PhraseNum++;
        }
    }
    else
    {
        Destroy();
    }
}

defaultproperties
{
    bUseLocationalVoice=true

    AlertString(8)="Under attack at {objective}"
    OrderString(0)="Attack {objective}"
    OrderString(1)="Defend {objective}"
    EnemyAbbrevAxis(3)="Pioneer"
    SupportString(1)="Need help at {objective}"
    VehicleDirectionString(0)="Go to {objective}"

    unitWhisperDistance=512.0
    unitShoutDistance=2048.0
    ShoutRadius=204.8
    WhisperRadius=25.6
    ShoutVolume=10.0
}

