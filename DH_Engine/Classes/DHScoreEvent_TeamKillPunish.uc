//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHScoreEvent_TeamKillPunish extends DHScoreEvent;

static function DHScoreEvent_TeamKillPunish Create()
{
    return new Class'DHScoreEvent_TeamKillPunish';
}

defaultproperties
{
    HumanReadableName="Team Kill Punish"
    CategoryClass=Class'DHScoreCategory_Combat'
    Value=-250
}

