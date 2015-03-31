//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHResupplyMessage extends ROCriticalMessage
    abstract;

var localized string ResuppliedMortar;
var localized string ResuppliedNoOperator;
var localized string BeenResupplied;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string S;

    switch (Switch)
    {
        case 0:
            S = default.ResuppliedNoOperator;
        case 1:
            S = default.ResuppliedMortar;
        case 2:
            S = default.BeenResupplied;
        default:
            S = default.ResuppliedNoOperator;
    }

    if (RelatedPRI_1 != none)
    {
        S = Repl(S, "{0}", RelatedPRI_1.PlayerName);
    }

    return S;
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
    ResuppliedMortar="You have resupplied {0}"
    ResuppliedNoOperator="You have resupplied a friendly mortar"
    BeenResupplied="You have received ammo from {0}"
    iconID=4
    altIconID=5
}
