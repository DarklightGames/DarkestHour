//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHScoreEvent_FriendlyReload extends DHScoreEvent;

static function DHScoreEvent_FriendlyReload Create()
{
    return new class'DHScoreEvent_FriendlyReload';
}

defaultproperties
{
    HumanReadableName="Friendly Reload"
    Value=50
    CategoryClass=class'DHScoreCategory_Support'
}

