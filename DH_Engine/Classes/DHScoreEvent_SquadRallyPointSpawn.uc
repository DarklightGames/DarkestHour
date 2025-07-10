//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHScoreEvent_SquadRallyPointSpawn extends DHScoreEvent;

static function DHScoreEvent_SquadRallyPointSpawn Create()
{
    return new Class'DHScoreEvent_SquadRallyPointSpawn';
}

defaultproperties
{
    HumanReadableName="Squad Rally Point Spawn"
    CategoryClass=Class'DHScoreCategory_Support'
    Value=25
    LimitPerDuration=10
}

