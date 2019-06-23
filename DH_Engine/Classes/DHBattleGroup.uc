//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHBattleGroup extends Object
    abstract;

struct SquadInfo
{
    var class<DHSquad> Class;
    var int Limit;
};

var int TeamIndex;
var array<SquadInfo> Squads;

static function int GetSquadIndex(class<DHSquad> SquadClass)
{
    local int i;

    for (i = 0; i < default.Squads.Length; ++i)
    {
        if (default.Squads[i].Class == SquadClass)
        {
            return i;
        }
    }

    return -1;
}

// Return the number of squads that can be created of the specified type.
static function int GetSquadLimit(class<DHSquad> Type)
{
    local int SquadIndex;

    SquadIndex = GetSquadIndex(Type);

    if (SquadIndex == -1)
    {
        return 0;
    }

    return default.Squads[SquadIndex].Limit;
}

defaultproperties
{
    TeamIndex=-1
}

