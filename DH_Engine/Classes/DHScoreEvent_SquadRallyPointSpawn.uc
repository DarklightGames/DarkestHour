//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHScoreEvent_SquadRallyPointSpawn extends DHScoreEvent;

static function DHScoreEvent_SquadRallyPointSpawn Create()
{
    return new class'DHScoreEvent_SquadRallyPointSpawn';
}

defaultproperties
{
    HumanReadableName="Squad Rally Point Spawn"
    CategoryClass=class'DHScoreCategory_Support'
    Value=25
    LimitPerDuration=10
}

