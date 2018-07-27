//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHScoreEvent extends Object;

var localized string            HumanReadableName;
var class<DHScoreCategory>      CategoryClass;
var int                         Value;
var int                         LimitPerMinute; // TODO: would be more intensive to keep track of this!

function int GetValue()
{
    return default.Value + GetBonusValue();
}

function int GetBonusValue()
{
    return 0;
}

