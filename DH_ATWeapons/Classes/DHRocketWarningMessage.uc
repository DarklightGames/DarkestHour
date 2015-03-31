//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHRocketWarningMessage extends ROCriticalMessage
    abstract;

var localized string NoProneFire;
var localized string NeedSupport;
var localized string NoHipFire;
var localized string NotInIS;
var localized string NoProneReload;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string S;
    local Inventory I;

    switch (Switch)
    {
        case 0:
            S = default.NoProneFire;
            break;
        case 1:
            S = default.NeedSupport;
            break;
        case 2:
            S = default.NoHipFire;
            break;
        case 3:
            S = default.NotInIS;
            break;
        case 4:
            S = default.NoProneReload;
            break;
    }

    I = Inventory(OptionalObject);

    if (I != none)
    {
        S = Repl(S, "{0}", I.default.ItemName);
    }

    return S;
}

defaultproperties
{
    NoProneFire="You cannot fire the {0} while prone"
    NeedSupport="You must be crouched or weapon rested to fire the {0}"
    NoHipFire="You cannot fire the {0} from the hip"
    NotInIS="You must shoulder the {0} for an assisted reload"
    NoProneReload="You cannot reload the {0} while prone"
}
