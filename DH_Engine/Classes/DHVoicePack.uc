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

function SetClientDefendMessage(int MessageIndex, PlayerReplicationInfo Recipient, out Sound MessageSound)
{
    local DHGameReplicationInfo GRI;
    local DHPlayer PC;

    PC = DHPlayer(Owner);

    if (PC != none)
    {
       GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    }

    MessageSound = OrderSound[1];
    MessageString = OrderString[1] @ GRI.DHObjectives[MessageIndex].ObjName;
    MessageAnim = DefendAnim;
}

function SetClientHelpAtMessage(int MessageIndex, PlayerReplicationInfo Recipient, out Sound MessageSound)
{
    local DHGameReplicationInfo GRI;
    local DHPlayer PC;

    PC = DHPlayer(Owner);

    if (PC != none)
    {
       GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    }

    MessageSound = SupportSound[1];
    MessageString = SupportString[1] @ GRI.DHObjectives[MessageIndex].ObjName;
    MessageAnim = DefendAnim;
}

function SetClientUnderAttackAtMessage(int MessageIndex, PlayerReplicationInfo Recipient, out Sound MessageSound)
{
    local DHGameReplicationInfo GRI;
    local DHPlayer PC;

    PC = DHPlayer(Owner);

    if (PC != none)
    {
       GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    }

    MessageSound = AlertSound[8];
    MessageString = AlertString[8] @ GRI.DHObjectives[MessageIndex].ObjName;
    MessageAnim = DefendAnim;
}

function SetClientGotoMessage(int MessageIndex, PlayerReplicationInfo Recipient, out Sound MessageSound)
{
    local DHGameReplicationInfo GRI;
    local DHPlayer PC;

    PC = DHPlayer(Owner);

    if (PC != none)
    {
       GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    }

    MessageSound = VehicleDirectionSound[0];
    MessageString = VehicleDirectionString[0] @ GRI.DHObjectives[MessageIndex].ObjName;
    MessageAnim = '';
}

function SetClientAttackMessage(int MessageIndex, PlayerReplicationInfo Recipient, out Sound MessageSound)
{
    local DHGameReplicationInfo GRI;
    local DHPlayer PC;

    PC = DHPlayer(Owner);

    if (PC != none)
    {
       GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    }

    MessageSound = OrderSound[0];
    MessageString = OrderString[0] @ GRI.DHObjectives[MessageIndex].ObjName;
    MessageAnim = AttackAnim;
}

defaultproperties
{
    bUseLocationalVoice=true
    EnemyAbbrevAxis(3)="Pioneer"
}

