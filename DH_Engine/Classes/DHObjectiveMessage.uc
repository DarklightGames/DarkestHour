//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHObjectiveMessage extends ROObjectiveMsg
    abstract;

var Sound   EnemyObjectiveSounds[3];
var Sound   TeamObjectiveSounds[3];

var(Messages) localized string TeamStrings[2];
var(Messages) localized string NotificationTypes[3];
var(Messages) localized string  NotificationMessage;

// Modified for DH msg background image
/*
static function RenderComplexMessageExtra(
    Canvas Canvas,
    out float XL,
    out float YL,
    out float YL_temp,
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject,
    optional array<string> lines,
    optional int background_type
    )
{
    local color oldColor;
    local float totalXL;
    local float tileX, tileY, tileXL, tileYL, iconSize;
    local float textX, textY;
    local float myXL, myYL;
    local int i, iconID;

    oldColor = Canvas.DrawColor;
    iconSize = YL / lines.length;
    totalXL = XL + (iconSize * 1.4);

    tileX = Canvas.CurX;
    tileY = Canvas.CurY;
    tileXL = totalXL * (float(512) / (512 - 60));
    tileYL = YL * (float(128) / (128 - 40));
    textX = tileX + totalXL * (float(30) / (512 - 60));
    textY = tileY + YL * (float(20) / (128 - 40));

    Canvas.SetPos(tileX, tileY);
    Canvas.Style =  ERenderStyle.STY_Normal;
    Canvas.SetDrawColor(255, 255, 255, oldColor.A);
    if (oldColor.A != 0) // fix: for some reason, alpha of 0 is considered the same as alpha of 255 for images
    {
        // Draw background
        Canvas.DrawTile(Texture'DH_GUI_Tex.GUI.ObjectiveMsgBackground',
            tileXL, tileYL, 0, background_type * 128, 512, 128);

        // Draw icon
        if (lines.length == 1)
            Canvas.SetPos(textX, textY);
        else
            Canvas.SetPos(textX, textY + iconSize / 2);

        iconID = GetIconID(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

        Canvas.DrawTile(default.iconTexture, iconSize, iconSize, (iconID % 4) * 64, (iconID / 4) * 64, 64, 64);
    }

    // Draw all lines of text iteratively
    Canvas.DrawColor = oldColor;
    Canvas.DrawColor.A = float(Canvas.DrawColor.A) * default.TextAlpha;
    for (i = 0; i < lines.length; i++)
    {
        Canvas.SetPos(textX + totalXL - XL, textY);
        Canvas.DrawText(lines[i]);
        Canvas.TextSize(lines[i], myXL, myYL);
        textY += myYL;
    }

    // To let ROHud how large a gap it should give between messages
    YL_temp = (tileYL + iconSize * 0.2) / Canvas.ClipY;
}*/

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
            P.PlayAnnouncement(default.TeamObjectiveSounds[Type],1,true);
        }
    }
    else
    {
        if (Type >= 0 && Type < arraycount(default.EnemyObjectiveSounds))
        {
            P.PlayAnnouncement(default.EnemyObjectiveSounds[Type],1,true);
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

defaultproperties
{
    IconTexture=texture'DH_GUI_Tex.GUI.criticalmessages_icons'

    TeamStrings(0)="Axis"
    TeamStrings(1)="Allies"

    NotificationTypes(0)="neutralized"
    NotificationTypes(1)="captured"
    NotificationTypes(2)="secured"

    NotificationMessage="The {0} have {1} {2}"

    EnemyObjectiveSounds(0)=Sound'Miscsounds.Music.notify_drum'                     //neutralized
    EnemyObjectiveSounds(1)=Sound'DH_SundrySounds.Objective.enemy_team_captured'    //captured
    EnemyObjectiveSounds(2)=Sound'DH_SundrySounds.Objective.enemy_team_secured'     //secured


    TeamObjectiveSounds(0)=Sound'Miscsounds.Music.notify_drum'                      //neutralized
    TeamObjectiveSounds(1)=Sound'DH_SundrySounds.Objective.your_team_captured'      //captured
    TeamObjectiveSounds(2)=Sound'DH_SundrySounds.Objective.your_team_secured'       //secured
}
