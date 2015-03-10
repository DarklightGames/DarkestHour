//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_MortarTargetMessage extends ROCriticalMessage
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
    switch (Switch)
    {
        case 0:
            return default.TargetInvalid;
        case 1:
            return default.NoMortarOperators;
        case 2:
            return RelatedPRI_1.PlayerName @ default.TargetMarked;
        case 3:
            return RelatedPRI_1.PlayerName @ default.TargetCancelled;
        case 4:
            return default.CannotMarkTargetYet;
        case 5:
            return default.CannotCancelTargetYet;
        case 6:
            return default.TooManyMortarTargets;
        case 7:
            return default.NoTargetToCancel;
        default:
            return default.TargetInvalid;
    }
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
//      case 3:     //TargetCancelled
//          return 3;
        case 4:     // CannotMarkTargetYet
            return 11;
        default:
            return super.getIconID(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    }
}

defaultproperties
{
    TargetInvalid="Invalid mortar target."
    NoMortarOperators="There are no mortar operators available."
    TargetMarked="has marked a mortar target."
    TargetCancelled="has cancelled a mortar target marker."
    CannotMarkTargetYet="You cannot mark another mortar target marker yet."
    CannotCancelTargetYet="You cannot cancel your mortar target yet."
    TooManyMortarTargets="There are too many active mortar targets."
    NoTargetToCancel="You have no mortar target to cancel."
}
