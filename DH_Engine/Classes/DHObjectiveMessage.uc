//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHObjectiveMessage extends ROObjectiveMsg
    abstract;

var Sound   EnemyObjectiveSounds[3];
var Sound   TeamObjectiveSounds[3];

var(Messages) localized string TeamStrings[2];
var(Messages) localized string NotificationTypes[3];
var(Messages) localized string  NotificationMessage;

// Modified to handle more sounds (ran by client)
simulated static function ClientReceive(
    PlayerController P,
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    local DHObjective Obj;
    local int Type, Team;

    super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

    Obj = DHObjective(OptionalObject);

    if (Obj == none)
    {
        return;
    }

    class'UInteger'.static.ToShorts(Switch, Type, Team);

    if (P.PlayerReplicationInfo.Team != none && P.PlayerReplicationInfo.Team.TeamIndex == Team)
    {
        if (Type >= 0 && Type < arraycount(default.TeamObjectiveSounds))
        {
            P.PlayAnnouncement(default.TeamObjectiveSounds[Type], 1, true);
        }
    }
    else
    {
        if (Type >= 0 && Type < arraycount(default.EnemyObjectiveSounds))
        {
            P.PlayAnnouncement(default.EnemyObjectiveSounds[Type], 1, true);
        }
    }
}

// Override to handle more messages
static function string GetString(optional int Type, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local DHObjective Obj;
    local int Team;
    local string Message;

    class'UInteger'.static.ToShorts(Type, Type, Team);

    Obj = DHObjective(OptionalObject);

    // If everything is legal, then construct and return the message ex- "The Axis have captured Church"
    if (Obj != none &&
        Type >= 0 && Type < arraycount(default.NotificationTypes) &&
        Team >= 0 && Team < arraycount(default.TeamStrings))
    {
        Message = Repl(default.NotificationMessage, "{0}", default.TeamStrings[Team]);
        Message = Repl(Message, "{1}", default.NotificationTypes[Type]);
        return Repl(Message, "{2}", Obj.ObjName);
    }

    return "";
}

// Todo will need to override the draw function and setup flag stuff
static function int getIconID(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject)
{
    local int Type, Team;

    class'UInteger'.static.ToShorts(Switch, Type, Team);

    switch (Team)
    {
        case 0:
            return default.iconID; // Axis
        case 1:
            return default.altIconID; // Allies
        case 2:
            return default.iconID; // Axis
        case 3:
            return default.altIconID; // Allies
        default:
            return default.errorIconID; // Error
    }
}

defaultproperties
{
    IconTexture=Texture'DH_GUI_Tex.GUI.criticalmessages_icons'

    TeamStrings(0)="Axis"
    TeamStrings(1)="Allies"

    NotificationTypes(0)="neutralized"
    NotificationTypes(1)="captured"
    NotificationTypes(2)="secured"

    NotificationMessage="The {0} have {1} {2}"

    EnemyObjectiveSounds(0)=Sound'DH_SundrySounds.Objective.Enemy_Neutralized_Obj'
    EnemyObjectiveSounds(1)=Sound'DH_SundrySounds.Objective.Enemy_Captured_Obj'
    EnemyObjectiveSounds(2)=Sound'DH_SundrySounds.Objective.Enemy_Secured_Obj'

    TeamObjectiveSounds(0)=Sound'DH_SundrySounds.Objective.Team_Neutralized_Obj'
    TeamObjectiveSounds(1)=Sound'DH_SundrySounds.Objective.Team_Captured_Obj'
    TeamObjectiveSounds(2)=Sound'DH_SundrySounds.Objective.Team_Secured_Obj'
}
