//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Score awarded to Squad Leader for establishing a rally point.
//==============================================================================

class DHScoreEvent_SquadRallyPointEstablished extends DHScoreEvent;

static function DHScoreEvent_SquadRallyPointEstablished Create()
{
    local DHScoreEvent_SquadRallyPointEstablished ScoreEvent;

    ScoreEvent = new class'DHScoreEvent_SquadRallyPointEstablished';

    return ScoreEvent;
}

defaultproperties
{
    HumanReadableName="Squad Rally Point Established"
    CategoryClass=class'DHScoreCategory_Support'
    Value=500
}

