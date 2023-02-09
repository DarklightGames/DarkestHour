//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHScoreEvent extends Object
    abstract;

var localized string            HumanReadableName;
var class<DHScoreCategory>      CategoryClass;
var int                         Value;
var int                         LimitPerDuration;
var int                         LimitDurationSeconds;

function int GetValue()
{
    return default.Value + GetBonusValue();
}

function int GetBonusValue()
{
    return 0;
}

defaultproperties
{
    LimitDurationSeconds=60
}
