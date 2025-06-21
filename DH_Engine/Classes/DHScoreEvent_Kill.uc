//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHScoreEvent_Kill extends DHScoreEvent;

static function DHScoreEvent_Kill Create()
{
    local DHScoreEvent_Kill ScoreEvent;

    ScoreEvent = new Class'DHScoreEvent_Kill';

    return ScoreEvent;
}

defaultproperties
{
    HumanReadableName="Kill"
    Value=100
    CategoryClass=Class'DHScoreCategory_Combat'
}

