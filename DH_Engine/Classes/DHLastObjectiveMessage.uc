//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHLastObjectiveMessage extends ROCriticalMessage
    abstract;

var localized string AxisAboutToWinMessage;
var localized string AlliesAboutToWinMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch (Switch)
    {
        case AXIS_TEAM_INDEX: // axis about to win
            return default.AxisAboutToWinMessage;
        case ALLIES_TEAM_INDEX: // axis about to win (player is therefore allies)
            return default.AlliesAboutToWinMessage;
        default:
            return "INVALID MESSAGE TYPE:" @ Switch;
    }
}

static function int getIconID(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch (Switch)
    {
        case AXIS_TEAM_INDEX: // axis about to win
            return default.altIconID;
        case ALLIES_TEAM_INDEX: // allies about to win
            return default.IconID;
        default:
            return default.errorIconID;
    }
}

defaultproperties
{
    AxisAboutToWinMessage="Last objective -- the Axis have almost won the battle!"
    AlliesAboutToWinMessage="Last objective -- the Allies have almost won the battle!"
    iconID=12
    altIconID=13
    iconTexture=Texture'DH_GUI_Tex.GUI.criticalmessages_icons'
}
