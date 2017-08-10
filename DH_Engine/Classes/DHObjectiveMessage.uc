//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHObjectiveMessage extends ROObjectiveMsg
    abstract;

var Sound   EnemyTeamObjectiveSounds[2];
var Sound   YourTeamObjectiveSounds[2];

var(Messages) localized string AxisObjectiveMessage[2];
var(Messages) localized string AlliesObjectiveMessage[2];

var(Messages) localized string AxisNeutralized;
var(Messages) localized string AlliesNeutralized;


var(Messages) localized string AxisSecured;
var(Messages) localized string AlliesSecured;

// Modified to handle more sounds (ran by client)
static simulated function ClientReceive(
    PlayerController P,
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    local DHObjective Obj;

    super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

    Obj = DHObjective(OptionalObject);

    if (Obj == none)
    {
        return;
    }

    if (P.PlayerReplicationInfo.Team != none && P.PlayerReplicationInfo.Team.TeamIndex == GetTeam(Switch))
    {
        P.PlayAnnouncement(default.EnemyTeamObjectiveSounds[int(Obj.IsActive())],1,true);
    }
    else
    {
        P.PlayAnnouncement(default.YourTeamObjectiveSounds[int(Obj.IsActive())],1,true);
    }
}

// Override to handle more messages
static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local DHObjective Obj;

    Obj = DHObjective(OptionalObject);

    if (Obj != none)
    {
        switch (Switch)
        {
            case 0:
                return default.AxisObjectiveMessage[int(Obj.IsActive())] $ Obj.ObjName;
            case 1:
                return default.AlliesObjectiveMessage[int(Obj.IsActive())] $ Obj.ObjName;
            case 2:
                return default.AxisTriggeredMessage $ Obj.ObjName;
            case 3:
                return default.AlliesTriggeredMessage $ Obj.ObjName;
            case 4:
                return default.AxisNeutralized $ Obj.ObjName;
            case 5:
                return default.AlliesNeutralized $ Obj.ObjName;
        }
    }

    return "";
}

defaultproperties
{
    IconTexture=texture'DH_GUI_Tex.GUI.criticalmessages_icons'
    AxisNeutralized="The Axis forces have neutralized "
    AlliesNeutralized="The Allied forces have neutralized "

    AxisObjectiveMessage(0)="The Axis forces have secured "
    AxisObjectiveMessage(1)="The Axis forces have captured "

    AlliesObjectiveMessage(0)="The Allied forces have secured "
    AlliesObjectiveMessage(1)="The Allied forces have captured "

    YourTeamObjectiveSounds(0)=Sound'DH_SundrySounds.Objective.your_team_secured'
    YourTeamObjectiveSounds(1)=sound'DH_SundrySounds.Objective.your_team_captured'

    EnemyTeamObjectiveSounds(0)=Sound'DH_SundrySounds.Objective.enemy_team_secured'
    EnemyTeamObjectiveSounds(1)=sound'DH_SundrySounds.Objective.enemy_team_captured'

    //ObjectiveNeutralized=sound'Miscsounds.Music.notify_drum' // no implement yet
}
