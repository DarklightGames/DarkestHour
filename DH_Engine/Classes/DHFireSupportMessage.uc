//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DHFireSupportMessage extends ROCriticalMessage;

var localized string RequestConfirmedText;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    local class<DHMapMarker_FireSupport> MapMarkerClass;

    MapMarkerClass = class<DHMapMarker_FireSupport>(OptionalObject);

    if (MapMarkerClass == none)
    {
        return "";
    }

    switch (Switch)
    {
        case 0:
            return Repl(default.RequestConfirmedText, "{type}", MapMarkerClass.default.TypeName);
        default:
            return "";
    }
}

defaultproperties
{
    RequestConfirmedText="Artillery request ({type}) has been sent"
}

