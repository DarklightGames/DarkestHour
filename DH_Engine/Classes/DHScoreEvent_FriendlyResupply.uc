//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHScoreEvent_FriendlyResupply extends DHScoreEvent;

static function DHScoreEvent_FriendlyResupply Create()
{
    return new class'DHScoreEvent_FriendlyResupply';
}

defaultproperties
{
    HumanReadableName="Friendly Resupply"
    Value=50
    CategoryClass=class'DHScoreCategory_Support'
}

