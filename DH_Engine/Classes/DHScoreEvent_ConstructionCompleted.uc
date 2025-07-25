//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHScoreEvent_ConstructionCompleted extends DHScoreEvent;

var class<DHConstruction> ConstructionClass;

static function DHScoreEvent_ConstructionCompleted Create(class<DHConstruction> ConstructionClass)
{
    local DHScoreEvent_ConstructionCompleted ScoreEvent;

    ScoreEvent = new Class'DHScoreEvent_ConstructionCompleted';
    ScoreEvent.ConstructionClass = ConstructionClass;

    return ScoreEvent;
}

function int GetValue()
{
    return ConstructionClass.default.CompletionPointValue;
}

defaultproperties
{
    HumanReadableName="Construction Built"
    CategoryClass=Class'DHScoreCategory_Support'
}

