//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHShovelWarningMessage extends ROCriticalMessage
    abstract;

var localized string CannotBeCrawling;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string S;

    switch (Switch)
    {
        case 0:
            S = default.CannotBeCrawling;
        default:
            break;
    }

    return S;
}

defaultproperties
{
    CannotBeCrawling="You cannot dig while crawling."
}

