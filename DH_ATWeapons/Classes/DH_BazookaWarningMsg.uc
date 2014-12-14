//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BazookaWarningMsg extends ROCriticalMessage;

var(Messages) localized string NoProneFire;
var(Messages) localized string NeedSupport;
var(Messages) localized string NoHipFire;
var(Messages) localized string NotInIS;
var(Messages) localized string NoProneReload;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )

{
    switch(Switch)
    {
        case 0:
            return default.NoProneFire;
        case 1:
            return default.NeedSupport;
        case 2:
            return default.NoHipFire;
        case 3:
            return default.NotInIS;
        case 4:
            return default.NoProneReload;
        default:
            return default.NeedSupport;
    }
}

defaultproperties
{
    NoProneFire="You cannot fire the Bazooka while prone"
    NeedSupport="You must be crouched or weapon rested to fire the Bazooka"
    NoHipFire="You cannot fire the Bazooka from the hip"
    NotInIS="You must shoulder the Bazooka for an assisted reload"
    NoProneReload="You cannot reload the Bazooka while prone"
}
