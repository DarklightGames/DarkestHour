//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
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
