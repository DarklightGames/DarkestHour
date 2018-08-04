//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

// Score awarded to squad members near the RP when it establishes

class DHScoreEvent_SquadRallyPointEstablishment extends DHScoreEvent;

static function DHScoreEvent_SquadRallyPointEstablishment Create()
{
    return new class'DHScoreEvent_SquadRallyPointEstablishment';
}

defaultproperties
{
    HumanReadableName="Squad Rally Point Establishment"
    CategoryClass=class'DHScoreCategory_Support'
    Value=250
    LimitPerMinute=1
}
