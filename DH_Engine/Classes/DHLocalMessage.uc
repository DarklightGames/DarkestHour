//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHLocalMessage extends LocalMessage
    abstract;

var localized string MessagePrefix;
var localized string SpecPrefix;

static function string AssembleString(HUD myHUD, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional string MessageString)
{
    return MessageString;
}

static function Color GetDHConsoleColor(PlayerReplicationInfo RelatedPRI_1, int AlliedNationID, bool bSimpleColours)
{
    if (RelatedPRI_1 != none &&
        RelatedPRI_1.Team != none &&
        RelatedPRI_1.Team.TeamIndex >= 0 &&
        RelatedPRI_1.Team.TeamIndex < arraycount(class'DHColor'.default.TeamColors))
    {
        return class'DHColor'.default.TeamColors[RelatedPRI_1.Team.TeamIndex];
    }

    return default.DrawColor;
}

defaultproperties
{
    bIsSpecial=false
    LifeTime=8
    PosY=0.7
}
