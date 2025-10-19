//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHScoreEvent_TeamKill extends DHScoreEvent;

static function DHScoreEvent_TeamKill Create()
{
    return new Class'DHScoreEvent_TeamKill';
}

defaultproperties
{
    HumanReadableName="Team Kill"
    CategoryClass=Class'DHScoreCategory_Combat'
    Value=-250
}

