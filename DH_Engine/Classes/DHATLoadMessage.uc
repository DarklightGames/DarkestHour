//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHATLoadMessage extends ROCriticalMessage;

var localized string        LoadedGunner;
var localized string        BeenLoaded;
var localized string        UnLoaded;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    switch (Switch)
    {
        case 0:
            return default.LoadedGunner $ RelatedPRI_1.PlayerName;
        case 1:
            return default.BeenLoaded $ RelatedPRI_1.PlayerName;
        case 2:
            return default.UnLoaded;
        default:
            return default.LoadedGunner;
    }

}

static function int getIconID(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject)
{
    if (RelatedPRI_1 != none && RelatedPRI_1.Team != none)
    {
        if (RelatedPRI_1.Team.TeamIndex == AXIS_TEAM_INDEX)
        {
            return default.iconID;
        }
        else
        {
            return default.altIconID;
        }
    }
    else
    {
        return default.iconID;
    }
}

defaultproperties
{
    LoadedGunner="Successfully reloaded "
    BeenLoaded="You have been reloaded by "
    UnLoaded="Rocket has been unloaded"
    iconID=4
    altIconID=5
}
