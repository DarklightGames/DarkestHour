//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstructionManager extends Actor
    notplaceable;

var private array<DHConstruction> Constructions;

function PostBeginPlay()
{
    super.PostBeginPlay();
}

function Register(DHConstruction C)
{
    Constructions[Constructions.Length] = C;
}

function Unregister(DHConstruction C)
{
    class'UArray'.static.Erase(Constructions, C);
}

function int CountOf(class<DHConstruction> ConstructionClass)
{
    local int i;
    local int Count;

    for (i = 0; i < Constructions.Length; ++i)
    {
        if (Constructions[i].Class == ConstructionClass || ClassIsChildOf(Constructions[i].Class, ConstructionClass))
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

defaultproperties
{
    RemoteRole=ROLE_None
}

