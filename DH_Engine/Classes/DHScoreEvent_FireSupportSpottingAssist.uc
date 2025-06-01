//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
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

