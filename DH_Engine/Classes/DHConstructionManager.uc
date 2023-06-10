//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstructionManager extends Actor
    notplaceable;

var private array<DHConstruction> Constructions;

simulated static function DHConstructionManager GetInstance(LevelInfo Level)
{
    local DarkestHourGame G;
    local DHPlayer PC;

    if (Level == none)
    {
        return none;
    }

    if (Level.Role == ROLE_Authority)
    {
        G = DarkestHourGame(Level.Game);

        if (G != none)
        {
            if (G.ConstructionManager == none)
            {
                G.ConstructionManager = G.Spawn(class'DHConstructionManager', G);
            }

            return G.ConstructionManager;
        }
    }
    else
    {
        PC = DHPlayer(Level.GetLocalPlayerController());

        if (PC != none)
        {
            if (PC.ConstructionManager == none)
            {
                PC.ConstructionManager = PC.Spawn(class'DHConstructionManager', PC);
            }

            return PC.ConstructionManager;
        }
    }

    return none;
}

function Register(DHConstruction C)
{
    local int i;

    if (C == none)
    {
        return;
    }

    for (i = 0; i < Constructions.Length; ++i)
    {
        if (Constructions[i] == C)
        {
            return;
        }
    }

    Constructions[Constructions.Length] = C;
}

function Unregister(DHConstruction C)
{
    local int i;

    if (C == none)
    {
        return;
    }

    for (i = Constructions.Length - 1; i >= 0; --i)
    {
        if (Constructions[i] == C)
        {
            Constructions.Remove(i, 1);
        }
    }
}

function int CountOf(int TeamIndex, class<DHConstruction> ConstructionClass)
{
    local int i;
    local int Count;

    for (i = 0; i < Constructions.Length; ++i)
    {
        if (Constructions[i] != none &&
            Constructions[i].GetTeamIndex() == TeamIndex &&
            (Constructions[i].Class == ConstructionClass ||
            ClassIsChildOf(Constructions[i].Class, ConstructionClass)))
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
    bHidden=true
}
