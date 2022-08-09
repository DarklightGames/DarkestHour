//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHShovelWarningMessage extends ROCriticalMessage
    abstract;

var localized string CannotBeCrawling;
var localized string NeedMoreFriendliesToBuildMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string S;

    switch (Switch)
    {
        case 0:
            S = default.CannotBeCrawling;
        case 1:
            S = default.NeedMoreFriendliesToBuildMessage;
        default:
            break;
    }

    return S;
}

defaultproperties
{
    CannotBeCrawling="You cannot dig while crawling."
    NeedMoreFriendliesToBuildMessage="You must have another squadmate nearby to use your shovel to build!"
}

