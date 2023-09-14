//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHResupplyMessage extends ROCriticalMessage
    abstract;

var localized string HaveResupplied;
var localized string BeenResupplied;
var localized string HaveResuppliedFriendlyMortar;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string S;

    switch (Switch)
    {
        case 0:
            S = default.HaveResupplied;
            break;
        case 1:
            S = default.BeenResupplied;
            break;
        case 2:
            S = default.HaveResuppliedFriendlyMortar;
            break;
        default:
            break;
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
    HaveResupplied="You have resupplied {0}"
    BeenResupplied="You have been resupplied by {0}"
    HaveResuppliedFriendlyMortar="You have resupplied a friendly mortar"
    iconID=4
    altIconID=5
}
