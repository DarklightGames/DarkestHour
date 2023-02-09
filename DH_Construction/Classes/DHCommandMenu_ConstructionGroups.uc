//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHCommandMenu_ConstructionGroups extends DHCommandMenu
    dependson(DHConstruction);

var DHActorProxy.Context Context;

function Setup()
{
    local int i;
    local DHPlayer PC;
    local DHGameReplicationInfo GRI;
    local array<class<DHConstructionGroup> > Groups;
    local UComparator GroupsComparator;

    GRI = DHGameReplicationInfo(Interaction.ViewportOwner.Actor.GameReplicationInfo);
    PC = GetPlayerController();

    Context.TeamIndex = PC.GetTeamNum();
    Context.LevelInfo = class'DH_LevelInfo'.static.GetInstance(PC.Level);
    Context.PlayerController = PC;

    // Compile a list of unique groups from the constructions that can be displayed.
    for (i = 0; i < arraycount(GRI.ConstructionClasses); ++i)
    {
        if (GRI.ConstructionClasses[i] != none && GRI.ConstructionClasses[i].static.ShouldShowOnMenu(Context))
        {
            class'UArray'.static.AddUnique(Groups, GRI.ConstructionClasses[i].default.GroupClass);
        }
    }

    // Sort the groups.
    GroupsComparator = new class'UComparator';
    GroupsComparator.CompareFunction = class'DHConstructionGroup'.static.SortFunction;
    class'USort'.static.Sort(Groups, GroupsComparator);

    Options.Length = Groups.Length;

    for (i = 0; i < Groups.Length; ++i)
    {
        Options[i].OptionalObject = Groups[i];
        Options[i].ActionText = Groups[i].default.GroupName;
        Options[i].Material = Groups[i].default.MenuIcon;
    }

    super.Setup();
}

function OnSelect(int OptionIndex, vector Location)
{
    Interaction.PushMenu("DH_Construction.DHCommandMenu_ConstructionGroup", Options[OptionIndex].OptionalObject);
}
