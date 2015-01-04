//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHResupplyMessage extends ROCriticalMessage;

var localized string  ResuppliedMortar;
var localized string  ResuppliedNoOperator;
var localized string  BeenResupplied;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch (Switch)
    {
        case 0:
            return default.ResuppliedNoOperator;
        case 1:
            return default.ResuppliedMortar @ RelatedPRI_1.PlayerName;
        case 2:
            return default.BeenResupplied @ RelatedPRI_1.PlayerName;
        default:
            return default.ResuppliedNoOperator;
    }
}

static function int getIconID(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
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
    ResuppliedMortar="Successfully resupplied"
    ResuppliedNoOperator="Successfully resupplied mortar."
    BeenResupplied="You have received ammo from"
    iconID=4
    altIconID=5
}
