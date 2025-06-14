//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHScoreEvent_ObjectiveNeutralize extends DHScoreEvent;

static function DHScoreEvent_ObjectiveNeutralize Create()
{
    return new Class'DHScoreEvent_ObjectiveNeutralize';
}

defaultproperties
{
    HumanReadableName="Objective Neutralized"
    CategoryClass=Class'DHScoreCategory_Support'
    Value=250
}
