//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMortarTargetMessage extends ROCriticalMessage
    abstract;

var localized string TargetInvalid;
var localized string NoMortarOperators;
var localized string TargetMarked;
var localized string TargetCancelled;
var localized string CannotMarkTargetYet;
var localized string CannotCancelTargetYet;
var localized string TooManyMortarTargets;
var localized string NoTargetToCancel;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string S;

    switch (Switch)
    {
        case 0:
            S = default.TargetInvalid;
        case 1:
            S = default.NoMortarOperators;
        case 2:
            S = default.TargetMarked;
        case 3:
            S = default.TargetCancelled;
        case 4:
            S = default.CannotMarkTargetYet;
        case 5:
            S = default.CannotCancelTargetYet;
        case 6:
            S = default.TooManyMortarTargets;
        case 7:
            S = default.NoTargetToCancel;
        default:
            return default.TargetInvalid;
    }

    if (RelatedPRI_1 != none)
    {
        S = Repl(S, "{0}", RelatedPRI_1.PlayerName);
    }

    return S;
}

static function int getIconID(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch (Switch)
    {
        case 0:     // TargetInvalid
            return 11;
        case 1:     // NoMortarOperators
            return 11;
        case 2:     // TargetMarked
            return 3;
        case 4:     // CannotMarkTargetYet
            return 11;
        default:
            return super.getIconID(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    }
}

defaultproperties
{
    TargetInvalid="Invalid mortar target"
    NoMortarOperators="There are no mortar operators available"
    TargetMarked="{0} has marked a mortar target"
    TargetCancelled="{0} has cancelled a mortar target marker"
    CannotMarkTargetYet="You cannot mark another mortar target marker yet"
    CannotCancelTargetYet="You cannot cancel your mortar target yet"
    TooManyMortarTargets="There are too many active mortar targets"
    NoTargetToCancel="You have no mortar target to cancel"
}
