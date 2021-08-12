//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHScoreEvent_Suicide extends DHScoreEvent;

static function DHScoreEvent_Suicide Create()
{
    return new class'DHScoreEvent_Suicide';
}

defaultproperties
{
    HumanReadableName="Suicide"
    Value=-100
    CategoryClass=class'DHScoreCategory_Combat'
}

