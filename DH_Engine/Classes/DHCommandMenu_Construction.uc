//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHCommandMenu_Construction extends DHCommandMenu;

var array<class<DHConstruction> > ConstructionClasses;

function Setup()
{
    local int i;
    local int TeamIndex;

    TeamIndex = -1;

    if (Interaction != none &&
        Interaction.ViewportOwner != none &&
        Interaction.ViewportOwner.Actor != none)
    {
        TeamIndex = Interaction.ViewportOwner.Actor.GetTeamNum();
    }

    Options.Length = ConstructionClasses.Length;

    // TODO: if there's more than 8, make submenus programmatically

    for (i = 0; i < ConstructionClasses.Length; ++i)
    {
        Options[i].ActionText = ConstructionClasses[i].static.GetMenuName(TeamIndex);
        Options[i].Material = ConstructionClasses[i].default.MenuMaterial;
        Options[i].OptionalObject = ConstructionClasses[i];
    }
}

function bool OnSelect(DHCommandInteraction Interaction, int Index, vector Location)
{
    local DHPawn P;

    if (Interaction == none || Interaction.ViewportOwner == none || Index < 0 || Index >= Options.Length)
    {
        return false;
    }

    P = DHPawn(Interaction.ViewportOwner.Actor.Pawn);

    if (P != none)
    {
        P.SetConstructionProxy(class<DHConstruction>(Options[Index].OptionalObject));
    }

    Interaction.Hide();

    return true;
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

