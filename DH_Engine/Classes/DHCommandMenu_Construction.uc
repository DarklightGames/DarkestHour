//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHCommandMenu_Construction extends DHCommandMenu;

var array<class<DHConstruction> > ConstructionClasses;

function Setup()
{
    local int i;
    local DHPlayer PC;

    if (Interaction != none && Interaction.ViewportOwner != none)
    {
        PC = DHPlayer(Interaction.ViewportOwner.Actor);
    }

    Options.Length = ConstructionClasses.Length;

    // TODO: if there's more than 8, make submenus programmatically

    for (i = 0; i < ConstructionClasses.Length; ++i)
    {
        Options[i].OptionalObject = ConstructionClasses[i];
        Options[i].ActionText = ConstructionClasses[i].static.GetMenuName(PC);
        Options[i].Material = ConstructionClasses[i].static.GetMenuIcon(PC);
    }
}

function OnSelect(int OptionIndex, vector Location)
{
    local DHPawn P;

    if (Interaction == none || Interaction.ViewportOwner == none || OptionIndex < 0 || OptionIndex >= Options.Length)
    {
        return;
    }

    P = DHPawn(Interaction.ViewportOwner.Actor.Pawn);

    if (P != none)
    {
        P.SetConstructionProxy(class<DHConstruction>(Options[OptionIndex].OptionalObject));
    }

    Interaction.Hide();
}

function bool ShouldHideMenu()
{
    return Interaction == none ||
           Interaction.ViewportOwner == none ||
           Interaction.ViewportOwner.Actor == none ||
           DHPawn(Interaction.ViewportOwner.Actor.Pawn) == none;
}

defaultproperties
{
    ConstructionClasses(0)=class'DHConstruction_Hedgehog'
    ConstructionClasses(1)=class'DHConstruction_ConcertinaWire'
    ConstructionClasses(2)=class'DHConstruction_Resupply'
    ConstructionClasses(3)=class'DHConstruction_Sandbags'
    ConstructionClasses(4)=class'DHConstruction_PlatoonHQ'
}

