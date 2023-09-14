//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHRadioTouchMessage extends ROTouchMessagePlus
    abstract;

var localized string RequestMessage;
var localized string NotQualifiedMessage;
var localized string NoTargetMessage;
var localized string NotOwnedMessage;
var localized string BusyMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local PlayerController PC;

    PC = PlayerController(OptionalObject);

    switch (Switch)
    {
        case 0:
            return class'DarkestHourGame'.static.ParseLoadingHintNoColor(default.RequestMessage, PC);
        case 1:
            return default.NotQualifiedMessage;
        case 2:
            return default.NoTargetMessage;
        case 3:
            return default.NotOwnedMessage;
        case 4:
            return default.BusyMessage;
        default:
            break;
    }

    return "";
}

defaultproperties
{
    RequestMessage="Hold [%SHOWORDERMENU | ONRELEASE HIDEORDERMENU%] to request artillery"
    NotQualifiedMessage="You are not qualified to use this radio"
    NoTargetMessage="No artillery target marked"
    NotOwnedMessage="You cannot use enemy radios"
    BusyMessage="Radio is currently in use"
}

