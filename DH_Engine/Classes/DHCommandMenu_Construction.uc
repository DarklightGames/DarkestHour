//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHCommandMenu_Construction extends DHCommandMenu;

function Setup()
{
    local int i, j, StartIndex;
    local DHPlayer PC;
    local DHGameReplicationInfo GRI;
    local array<class<DHConstruction> > ConstructionClasses;

    GRI = DHGameReplicationInfo(Interaction.ViewportOwner.Actor.GameReplicationInfo);

    if (UInteger(MenuObject) != none)
    {
        StartIndex = UInteger(MenuObject).Value;
    }

    if (Interaction != none && Interaction.ViewportOwner != none)
    {
        PC = DHPlayer(Interaction.ViewportOwner.Actor);
    }

    // For simplicity's sake, we'll map the static array to a dynamic array so
    // we can know how many classes we have to deal upfront and not have to deal
    // with handling null values during iteration.
    for (i = 0; i < arraycount(GRI.ConstructionClasses); ++i)
    {
        if (GRI.ConstructionClasses[i] != none &&
            GRI.ConstructionClasses[i].static.CanPlayerBuild(PC))
        {
            ConstructionClasses[ConstructionClasses.Length] = GRI.ConstructionClasses[i];
        }
    }

    Options.Length = 8;

    if (GRI != none)
    {
        for (i = StartIndex; i < ConstructionClasses.Length && j < Options.Length - 1; ++i)
        {
            Options[j].OptionalObject = ConstructionClasses[i];
            Options[j].ActionText = ConstructionClasses[i].static.GetMenuName(PC);
            Options[j].Material = ConstructionClasses[i].static.GetMenuIcon(PC);
            ++j;
        }

        Log(ConstructionClasses.Length);
        Log(i);
        Log(ConstructionClasses.Length - i);

        if (ConstructionClasses.Length - i > 1)
        {
            // More options are available, so let's make a submenu option.
            Options[j].OptionalObject = class'UInteger'.static.Create(i);
            Options[j].ActionText = "...";
            Options[j].Material = none; // TODO: some sort of ellipses icon?
        }
    }
}

function OnSelect(int OptionIndex, vector Location)
{
    local DHPawn P;

    if (Interaction == none || Interaction.ViewportOwner == none || OptionIndex < 0 || OptionIndex >= Options.Length)
    {
        return;
    }

    if (OptionIndex == Options.Length - 1)
    {
        Interaction.PushMenu("DH_Engine.DHCommandMenu_Construction", Options[OptionIndex].OptionalObject);
    }
    else
    {
        P = DHPawn(Interaction.ViewportOwner.Actor.Pawn);

        if (P != none)
        {
            P.SetConstructionProxy(class<DHConstruction>(Options[OptionIndex].OptionalObject));
        }

        Interaction.Hide();
    }
}

function bool IsOptionDisabled(int OptionIndex)
{
    return Options[OptionIndex].OptionalObject == none;
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
}

