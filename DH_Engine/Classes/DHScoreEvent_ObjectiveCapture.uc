//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHScoreEvent_ObjectiveCapture extends DHScoreEvent;

static function DHScoreEvent_ObjectiveCapture Create()
{
    return new class'DHScoreEvent_ObjectiveCapture';
}

defaultproperties
{
    HumanReadableName="Objective Captured"
    CategoryClass=class'DHScoreCategory_Support'
    Value=250
}
