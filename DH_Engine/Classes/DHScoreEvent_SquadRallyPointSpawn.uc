//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
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
    Value=50
    LimitPerMinute=10
}
