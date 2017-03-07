//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHCommandMenu_Construction extends DHCommandMenu;

var array<class<DHConstruction> > ConstructionClasses;

function Setup()
{
    local int i;

    Options.Length = ConstructionClasses.Length;

    // TODO: if there's more than 8

    for (i = 0; i < ConstructionClasses.Length; ++i)
    {
        Options[i].ActionText = ConstructionClasses[i].default.MenuName;
        Options[i].Material = ConstructionClasses[i].default.MenuMaterial;
        Options[i].OptionalObject = ConstructionClasses[i];
    }
}

function bool OnSelect(DHCommandInteraction Interaction, int Index, vector Location)
{
    local DHPlayer PC;
    local DHPawn P;
    local class<DHConstruction> ConstructionClass;

    if (Interaction == none || Interaction.ViewportOwner == none || Index < 0 || Index >= Options.Length)
    {
        return false;
    }

    PC = DHPlayer(Interaction.ViewportOwner.Actor);

    // TODO: possibly move speech commands out of the menu, since it's not
    // really it's responsbility.
    P = DHPawn(PC.Pawn);

    if (P != none)
    {
        ConstructionClass = class<DHConstruction>(Options[Index].OptionalObject);

        P.SetConstructionProxy(ConstructionClass);
    }

    Log("say what");

    Interaction.Hide();

    return true;
}

function bool ShouldHideMenu()
{
    local DHPlayer PC;

    if (Interaction == none || Interaction.ViewportOwner == none)
    {
        return true;
    }

    PC = DHPlayer(Interaction.ViewportOwner.Actor);

    if (PC == none || DHPawn(PC.Pawn) == none)
    {
        return true;
    }

    return false;
}

defaultproperties
{
    ConstructionClasses(0)=class'DHConstruction_Hedgehog'
    ConstructionClasses(1)=class'DHConstruction_ConcertinaWire'
    ConstructionClasses(2)=class'DHConstruction_Resupply'
    ConstructionClasses(3)=class'DHConstruction_Sandbags'
}

