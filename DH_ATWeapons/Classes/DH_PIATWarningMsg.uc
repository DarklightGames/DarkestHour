//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PIATWarningMsg extends ROCriticalMessage
    abstract;

var localized string NoHipFire;
var localized string ReloadWarning;
var localized string NeedSupport;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch (Switch)
    {
        case 0:
            return default.NoHipFire;
        case 1:
            return default.NeedSupport;
        case 2:
            return default.ReloadWarning;
        default:
            return default.NeedSupport;
    }
}

defaultproperties
{
    NoHipFire="You cannot fire the PIAT from the hip"
    ReloadWarning="You need to be prone or weapon rested to reload the PIAT"
    NeedSupport="You need to be prone or weapon rested to fire the PIAT"
}
