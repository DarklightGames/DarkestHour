//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHScoreEvent_Suicide extends DHScoreEvent;

static function DHScoreEvent_Suicide Create()
{
    return new class'DHScoreEvent_Suicide';
}

defaultproperties
{
    HumanReadableName="Suicide"
    Value=-50
    CategoryClass=class'DHScoreCategory_Combat'
}

