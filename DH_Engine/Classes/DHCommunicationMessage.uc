//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHCommunicationMessage extends LocalMessage
    abstract;

var localized string AllChatDisabledMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch (Switch)
    {
        case 0:
            return default.AllChatDisabledMessage;
        default:
            return "";
    }

    return "";
}

defaultproperties
{
    bIsSpecial=false
    bIsConsoleMessage=false
    LifeTime=8.0
    AllChatDisabledMessage="Public all chat is currently disabled."
}
