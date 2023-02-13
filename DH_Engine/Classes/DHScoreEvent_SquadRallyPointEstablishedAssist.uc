//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// Score awarded to squad members near the rally point when it establishes.
//==============================================================================

class DHScoreEvent_SquadRallyPointEstablishedAssist extends DHScoreEvent;

static function DHScoreEvent_SquadRallyPointEstablishedAssist Create()
{
    return new class'DHScoreEvent_SquadRallyPointEstablishedAssist';
}

defaultproperties
{
    HumanReadableName="Squad Rally Point Established (Assist)"
    CategoryClass=class'DHScoreCategory_Support'
    Value=250
}
