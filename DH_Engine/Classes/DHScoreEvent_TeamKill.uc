//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHScoreEvent_TeamKill extends DHScoreEvent;

static function DHScoreEvent_TeamKill Create()
{
    return new class'DHScoreEvent_TeamKill';
}

defaultproperties
{
    HumanReadableName="Team Kill"
    CategoryClass=class'DHScoreCategory_Combat'
    Value=-250
}

