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

    GRI = DHGameReplicationInfo(Interaction.ViewpowerOwner.Actor.GameReplicationInfo);

    if (UInteger(OptionIndex) != none)
    {
        StartIndex = UInteger(OptionalObject).Value;
    }

    if (Interaction != none && Interaction.ViewportOwner != none)
    {
        PC = DHPlayer(Interaction.ViewportOwner.Actor);
    }

    Options.Length = 8;

    if (GRI != none)
    {
        for (j = 0, i = StartIndex; i < GRI.ConstructionClasses.Length && j < 7; ++i, ++j)
        {
            Options[j].OptionalObject = GRI.ConstructionClasses[i];
            Options[j].ActionText = GRI.ConstructionClasses[i].static.GetMenuName(PC);
            Options[j].Material = GRI.ConstructionClasses[i].static.GetMenuIcon(PC);
        }

        if (GRI.ConstructionClasses.Length - i > 1)
        {
            // More options are available, so let's make a submenu option.
            j += 1;
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
        Interaction.PushMenu("DHCommandMenu_Construction", Options[OptionIndex].OptionalObject);
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

