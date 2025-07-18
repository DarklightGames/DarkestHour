//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Used for storing the range values for the optics. This is more ergonomic than
// declaring it in the optics class as a nested array and makes it easier to
// edit in the defaultproperties section.
//==============================================================================

class DHGunOpticsRangeTable extends Object;

struct RangeValue
{
    var int Range;    // The range in the distance unit (i.e., meters, yards etc.)
    var float Value;    // The "value" to use for this optical range (can be rotation, offset etc., depending on the type of optics)
};

var array<RangeValue> RangeValues;

function float GetRangeValue(int Range)
{
    local int i;

    for (i = 0; i < RangeValues.Length; ++i)
    {
        if (RangeValues[i].Range >= Range)
        {
            return RangeValues[i].Value;
        }
    }

    return 0.0;
}
