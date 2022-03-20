//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHScoreEvent_FireSupportSpottingAssist extends DHScoreEvent;

static function DHScoreEvent_FireSupportSpottingAssist Create()
{
    return new class'DHScoreEvent_FireSupportSpottingAssist';
}

defaultproperties
{
    HumanReadableName="Fire Support Spotting Assist"
    CategoryClass=class'DHScoreCategory_Support'
    Value=25
}

