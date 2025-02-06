//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
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
    local class<DHConstruction> ConstructionClass;

    GRI = DHGameReplicationInfo(Interaction.ViewportOwner.Actor.GameReplicationInfo);
    PC = GetPlayerController();

    Context.TeamIndex = PC.GetTeamNum();
    Context.LevelInfo = class'DH_LevelInfo'.static.GetInstance(PC.Level);
    Context.PlayerController = PC;

    // Compile a list of unique groups from the constructions that can be displayed.
    for (i = 0; i < Context.LevelInfo.ConstructionsEvaluated.Length; ++i)
    {
        ConstructionClass = Context.LevelInfo.ConstructionsEvaluated[i].ConstructionClass;

        if (ConstructionClass != none && ConstructionClass.static.ShouldShowOnMenu(Context))
        {
            class'UArray'.static.AddUnique(Groups, ConstructionClass.default.GroupClass);
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

function OnSelect(int OptionIndex, vector Location, optional vector HitNormal)
{
    Interaction.PushMenu("DH_Construction.DHCommandMenu_ConstructionGroup", Options[OptionIndex].OptionalObject);
}
