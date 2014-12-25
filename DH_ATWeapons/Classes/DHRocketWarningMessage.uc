//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHRocketWarningMessage extends ROCriticalMessage
    abstract;

var class<Inventory> WeaponClass;

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
    local string S;

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

    return Repl(S, "%w", default.WeaponClass.default.ItemName);
}

defaultproperties
{
    NoProneFire="You cannot fire the %w while prone"
    NeedSupport="You must be crouched or weapon rested to fire the %w"
    NoHipFire="You cannot fire the %w from the hip"
    NotInIS="You must shoulder the %w for an assisted reload"
    NoProneReload="You cannot reload the %w while prone"
}
