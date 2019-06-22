//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHCommunicationMessage extends LocalMessage
    abstract;

var localized string        AllChatDisabledMessage,
                            RapidAttemptsMessage,
                            GaggedMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch (Switch)
    {
        case 0:
            return "";
        case 1:
            return default.AllChatDisabledMessage;
        case 2:
            return default.RapidAttemptsMessage;
        case 3:
            return default.GaggedMessage;
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
    AllChatDisabledMessage="[ALL] chat is currently restricted to Patrons only. Type /patron for more info!"
    RapidAttemptsMessage="You tried to send another message too soon."
    GaggedMessage="You are gagged and cannot send public messages."
}
