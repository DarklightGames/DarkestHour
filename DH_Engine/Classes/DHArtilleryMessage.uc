//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHArtilleryMessage extends ROCriticalMessage;

var localized string RequestText;
var localized string ConfirmText;
var localized string DenyText;
var localized string TooSoonText;
var localized string ExhaustedText;
var localized string UnavailableText;
var localized string BadLocationText;
var localized string NoTargetText;
var localized string NotQualifiedText;
var localized string CancelledText;
var localized string ActiveTargetChosen;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    local class<DHArtillery> ArtilleryClass;
    local string S;

    ArtilleryClass = class<DHArtillery>(OptionalObject);

    if (ArtilleryClass == none)
    {
        return "";
    }

    switch (Switch)
    {
        case 0:
            S = default.RequestText;
            break;
        case 1:
            S = default.ConfirmText;
            break;
        case 2:
            S = default.DenyText;
            break;
        case 3:
            S = default.TooSoonText;
            break;
        case 4:
            S = default.ExhaustedText;
            break;
        case 5:
            S = default.UnavailableText;
            break;
        case 6:
            S = default.BadLocationText;
            break;
        case 7:
            S = default.NotQualifiedText;
            break;
        case 8:
            S = default.CancelledText;
            break;
        case 9:
            S = default.NoTargetText;
            break;
        case 10:
            S = default.ActiveTargetChosen;
            break;
    }

    return Repl(S, "{name}", ArtilleryClass.static.GetMenuName());
}

defaultproperties
{
    RequestText="Requesting {name}."
    ConfirmText="{name} confirmed."
    DenyText="{name} denied."
    TooSoonText="{name} is currently in use. Try again soon."
    ExhaustedText="{name} has been exhausted."
    UnavailableText="{name} is unavailable at this time."
    BadLocationText="Invalid target location for {name}."
    NoTargetText="No target location."
    NotQualifiedText="You are not qualified to request a {name}."
    CancelledText="{name} has been cancelled."
    ActiveTargetChosen="Fire support target selected."
}

