//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHScoreEvent_ObjectiveNeutralize extends DHScoreEvent;

static function DHScoreEvent_ObjectiveNeutralize Create()
{
    return new class'DHScoreEvent_ObjectiveNeutralize';
}

defaultproperties
{
    HumanReadableName="Objective Neutralized"
    CategoryClass=class'DHScoreCategory_Support'
    Value=250
}
