//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstructionManager extends Object;

var private array<DHConstruction> Constructions;

function Register(DHConstruction C)
{
    Constructions[Constructions.Length] = C;
}

function Unregister(DHConstruction C)
{
    class'UArray'.static.Erase(Constructions, C);
}

function int CountOf(int TeamIndex, class<DHConstruction> ConstructionClass)
{
    local int i;
    local int Count;

    for (i = 0; i < Constructions.Length; ++i)
    {
        if (Constructions[i] != none &&
            Constructions[i].GetTeamIndex() == TeamIndex &&
            Constructions[i].Class == ConstructionClass ||
            ClassIsChildOf(Constructions[i].Class, ConstructionClass))
        {
            ++Count;
        }
    }

    return Count;
}

function array<DHConstruction> GetConstructions()
{
    return Constructions;
}


