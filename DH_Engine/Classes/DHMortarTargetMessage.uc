//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHMortarTargetMessage extends ROCriticalMessage
    abstract;

var localized string TargetInvalid;
var localized string NoMortarOperators;
var localized string TargetMarkedHE;
var localized string TargetMarkedSmoke;
var localized string CannotMarkTargetYet;
var localized string TooManyMortarTargets;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string S;

    switch (Switch)
    {
        case 0:
            S = default.TargetInvalid;
            break;
        case 1:
            S = default.NoMortarOperators;
            break;
        case 2:
            S = default.TargetMarkedHE;
            break;
        case 3:
            S = default.TargetMarkedSmoke;
            break;
        case 4:
            S = default.CannotMarkTargetYet;
            break;
        case 6:
            S = default.TooManyMortarTargets;
            break;
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
        case 2:     // TargetMarkedHE
            return 14;
        case 3:     // TargetMarkedSmoke
            return 15;
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
    TargetMarkedHE="{0} has marked a mortar high-explosive target"
    TargetMarkedSmoke="{0} has marked a mortar smoke target"
    CannotMarkTargetYet="You cannot mark another mortar target marker yet"
    TooManyMortarTargets="There are too many active mortar targets"
    iconTexture=material'DH_GUI_tex.GUI.criticalmessages_icons'
}
