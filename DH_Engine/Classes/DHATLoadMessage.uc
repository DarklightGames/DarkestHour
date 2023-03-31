//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHATLoadMessage extends ROCriticalMessage
    abstract;

var localized string LoadedGunner;
var localized string BeenLoaded;
var localized string UnLoaded;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string S;

    switch (Switch)
    {
        case 0:
            S = default.LoadedGunner;
            break;
        case 1:
            S = default.BeenLoaded;
            break;
        case 2:
            S = default.UnLoaded;
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
    LoadedGunner="You have reloaded {0}"
    BeenLoaded="You have been reloaded by {0}"
    UnLoaded="Rocket has been unloaded"
    iconID=4
    altIconID=5
}
