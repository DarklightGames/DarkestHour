//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHShovelWarningMessage extends ROCriticalMessage
    abstract;

var localized string CannotBeCrawling;
var localized string NeedMoreFriendliesToBuildMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch (Switch)
    {
        case 0:
            return default.CannotBeCrawling;
        case 1:
            return default.NeedMoreFriendliesToBuildMessage;
        default:
            return "";
    }
}

defaultproperties
{
    CannotBeCrawling="You cannot dig while crawling."
    NeedMoreFriendliesToBuildMessage="You must have another squadmate nearby to use your shovel to build!"
}

