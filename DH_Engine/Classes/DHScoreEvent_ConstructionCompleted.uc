//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHScoreEvent_ConstructionCompleted extends DHScoreEvent;

var class<DHConstruction> ConstructionClass;

static function DHScoreEvent_ConstructionCompleted Create(class<DHConstruction> ConstructionClass)
{
    local DHScoreEvent_ConstructionCompleted ScoreEvent;

    ScoreEvent = new class'DHScoreEvent_ConstructionCompleted';
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
    CategoryClass=class'DHScoreCategory_Support'
}

