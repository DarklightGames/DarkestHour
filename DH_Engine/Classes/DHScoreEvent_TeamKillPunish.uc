//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHScoreEvent_TeamKillPunish extends DHScoreEvent;

static function DHScoreEvent_TeamKillPunish Create()
{
    return new class'DHScoreEvent_TeamKillPunish';
}

defaultproperties
{
    HumanReadableName="Team Kill Punish"
    CategoryClass=class'DHScoreCategory_Combat'
    Value=-250
}

