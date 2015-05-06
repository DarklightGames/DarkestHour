//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVoicePack extends ROVoicePack
    abstract;

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

function SetClientDefendMessage(int messageIndex, PlayerReplicationInfo Recipient, out Sound MessageSound)
{
    local DHGameReplicationInfo DHGRI;
    local DHPlayer DHP;

    DHP = DHPlayer(Owner);

    if(DHP != none)
       DHGRI = DHGameReplicationInfo(DHP.GameReplicationInfo);

    MessageSound = OrderSound[1];
    MessageString = OrderString[1]@DHGRI.DHObjectives[messageIndex].ObjName;
    MessageAnim = DefendAnim;
}

function SetClientHelpAtMessage(int messageIndex, PlayerReplicationInfo Recipient, out Sound MessageSound)
{
    local DHGameReplicationInfo DHGRI;
    local DHPlayer DHP;

    DHP = DHPlayer(Owner);

    if(DHP != none)
       DHGRI = DHGameReplicationInfo(DHP.GameReplicationInfo);

    MessageSound = SupportSound[1];
    MessageString = SupportString[1]@DHGRI.DHObjectives[messageIndex].ObjName;
    MessageAnim = DefendAnim;
}

function SetClientUnderAttackAtMessage(int messageIndex, PlayerReplicationInfo Recipient, out Sound MessageSound)
{
    local DHGameReplicationInfo DHGRI;
    local DHPlayer DHP;

    DHP = DHPlayer(Owner);

    if(DHP != none)
       DHGRI = DHGameReplicationInfo(DHP.GameReplicationInfo);

    MessageSound = AlertSound[8];
    MessageString = AlertString[8]@DHGRI.DHObjectives[messageIndex].ObjName;
    MessageAnim = DefendAnim;
}

function SetClientGotoMessage(int messageIndex, PlayerReplicationInfo Recipient, out Sound MessageSound)
{
    local DHGameReplicationInfo DHGRI;
    local DHPlayer DHP;

    DHP = DHPlayer(Owner);

    if(DHP != none)
       DHGRI = DHGameReplicationInfo(DHP.GameReplicationInfo);

    MessageSound = VehicleDirectionSound[0];
    MessageString = vehicleDirectionString[0]@DHGRI.DHObjectives[messageIndex].ObjName;
    MessageAnim = '';
}

function SetClientAttackMessage(int messageIndex,
                                 PlayerReplicationInfo Recipient,
                                 out Sound MessageSound)
{
    local DHGameReplicationInfo DHGRI;
    local DHPlayer DHP;

    DHP = DHPlayer(Owner);

    if(DHP != none)
       DHGRI = DHGameReplicationInfo(DHP.GameReplicationInfo);

    MessageSound = OrderSound[0];
    MessageString = OrderString[0]@DHGRI.DHObjectives[messageIndex].ObjName;

    MessageAnim = AttackAnim;

}

defaultproperties
{
    ShoutRadius=1024.0
    WhisperRadius=128.0
    bUseLocationalVoice=true
    EnemyAbbrevAxis(3)="Pioneer"
}
