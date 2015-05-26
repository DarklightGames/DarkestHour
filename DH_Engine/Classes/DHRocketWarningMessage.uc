//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHRocketWarningMessage extends ROCriticalMessage
    abstract;

var     localized string    NoHipFire;
var     localized string    CrouchOrRestToFire;
var     localized string    ProneOrRestToFire;
var     localized string    NoProneReload;
var     localized string    ProneOrRestToReload;
var     localized string    ShoulderForAssistedReload;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string    S;
    local Inventory I;

    switch (Switch)
    {
        case 0:
            // Colin: Used to be NoProneFire, but that restriction has been lifted
            break;
        case 1:
            S = default.NoHipFire;
            break;
        case 2:
            S = default.CrouchOrRestToFire;
            break;
        case 3:
            S = default.ProneOrRestToFire;
            break;
        case 4:
            S = default.NoProneReload;
            break;
        case 5:
            S = default.ProneOrRestToReload;
            break;
        case 6:
            S = default.ShoulderForAssistedReload;
            break;
        default:
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
    NoHipFire="You cannot fire the {0} from the hip"
    CrouchOrRestToFire="You must be crouched or weapon rested to fire the {0}"
    ProneOrRestToFire="You need to be prone or weapon rested to fire the {0}"
    NoProneReload="You cannot reload the {0} while prone"
    ProneOrRestToReload="You need to be prone or weapon rested to reload the {0}"
    ShoulderForAssistedReload="You must shoulder the {0} for an assisted reload"
}
