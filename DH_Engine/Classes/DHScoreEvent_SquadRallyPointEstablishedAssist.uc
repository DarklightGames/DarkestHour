//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Score awarded to squad members near the rally point when it establishes.
//==============================================================================

class DHScoreEvent_SquadRallyPointEstablishedAssist extends DHScoreEvent;

static function DHScoreEvent_SquadRallyPointEstablishedAssist Create()
{
    return new Class'DHScoreEvent_SquadRallyPointEstablishedAssist';
}

defaultproperties
{
    HumanReadableName="Squad Rally Point Established (Assist)"
    CategoryClass=Class'DHScoreCategory_Support'
    Value=250
}
