//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHLastObjectiveMsg extends ROCriticalMessage;

var(Messages) localized string AboutToWin;
var(Messages) localized string AboutToLose;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    switch (Switch)
    {
        case 0: // axis about to win
        case 2: // allies about to win
            return default.AboutToLose;
        case 1: // axis about to win (player is therefore allies)
        case 3: // allies about to win (player is therefore axis)
            return default.AboutToWin;
        default:
            return "INVALID MESSAGE TYPE: " $ switch;
    }

}

static function int getIconID(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject)
{
    switch (Switch)
    {
        case 0: // axis about to win
        case 1: // axis about to win (player is therefore allies)
            return default.altIconID;
        case 2: // allies about to win
        case 3: // allies about to win (player is therefore axis)
            return default.IconID;
        default:
            return default.errorIconID;
    }
}

defaultproperties
{
    AboutToWin="Last objective -- we have almost won the battle!"
    AboutToLose="Last objective -- we have almost lost the battle!"
    iconID=12
    altIconID=13
    iconTexture=Texture'DH_GUI_Tex.GUI.criticalmessages_icons'
}
