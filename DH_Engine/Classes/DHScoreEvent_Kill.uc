//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHScoreEvent_Kill extends DHScoreEvent;

var Pawn Killer;
var Pawn Victim;

static function DHScoreEvent_Kill Create(Pawn Killer, Pawn Victim)
{
    local DHScoreEvent_Kill ScoreEvent;

    ScoreEvent = new class'DHScoreEvent_Kill';
    ScoreEvent.Killer = Killer;
    ScoreEvent.Victim = Victim;

    return ScoreEvent;
}

defaultproperties
{
    HumanReadableName="Kill"
    Value=100
    CategoryClass=class'DHScoreCategory_Combat'
}

