//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHCommandMenu_Construction extends DHCommandMenu
    dependson(DHConstruction);

var Material SuppliesIcon;

var localized string NotAvailableText;
var localized string TeamLimitText;

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
            GRI.ConstructionClasses[i].static.ShouldShowOnMenu(PC))
        {
            ConstructionClasses[ConstructionClasses.Length] = GRI.ConstructionClasses[i];
        }
    }

    Options.Length = 8;

    if (GRI != none)
    {
        for (i = StartIndex; i < ConstructionClasses.Length && j < Options.Length; ++i)
        {
            Options[j].OptionalObject = ConstructionClasses[i];
            Options[j].ActionText = ConstructionClasses[i].static.GetMenuName(PC);
            Options[j].Material = ConstructionClasses[i].static.GetMenuIcon(PC);
            Options[j].ActionIcon = SuppliesIcon;
            ++j;
        }

        if (ConstructionClasses.Length - i >= 1)
        {
            // More options are available, so let's make a submenu option.
            // Insert the "more options" option in the first position.
            Options.Length = Options.Length - 1;
            Options.Insert(0, 1);
            Options[0].OptionalObject = class'UInteger'.static.Create(i - 1);
            Options[0].ActionText = "...";
            Options[0].Material = none; // TODO: some sort of ellipses icon?
        }
    }
}

function OnSelect(int OptionIndex, vector Location)
{
    local DHPawn P;

    if (Interaction == none || Interaction.ViewportOwner == none || OptionIndex < 0 || OptionIndex >= Options.Length || Options[OptionIndex].OptionalObject == none)
    {
        return;
    }

    if (Options[OptionIndex].OptionalObject.IsA('UInteger'))
    {
        Interaction.PushMenu("DH_Engine.DHCommandMenu_Construction", Options[OptionIndex].OptionalObject);
    }
    else if (Options[OptionIndex].OptionalObject.IsA('Class'))
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
    local class<DHConstruction> C;

    if (Options[OptionIndex].OptionalObject == none)
    {
        return true;
    }

    C = class<DHConstruction>(Options[OptionIndex].OptionalObject);

    if (C != none)
    {
        return C.static.GetPlayerError(DHPlayer(Interaction.ViewportOwner.Actor)) != ERROR_None;
    }

    return false;
}

function GetOptionRenderInfo(int OptionIndex, out OptionRenderInfo ORI)
{
    local class<DHConstruction> ConstructionClass;
    local DHConstruction.EConstructionError Error;
    local DHPlayer PC;
    local int SquadMemberCount;

    super.GetOptionRenderInfo(OptionIndex, ORI);

    ConstructionClass = class<DHConstruction>(Options[OptionIndex].OptionalObject);

    if (ConstructionClass != none)
    {
        Error = ConstructionClass.static.GetPlayerError(DHPlayer(Interaction.ViewportOwner.Actor));

        ORI.OptionName = ConstructionClass.default.MenuName;

        if (Error != ERROR_None)
        {
            ORI.InfoColor = class'UColor'.default.Red;
        }
        else
        {
            ORI.InfoColor = class'UColor'.default.White;
        }

        switch (Error)
        {
            case ERROR_RestrictedType:
            case ERROR_Fatal:
                ORI.InfoIcon = texture'DH_GUI_tex.DeployMenu.spawn_point_disabled';
                ORI.InfoText = default.NotAvailableText;
                break;
            case ERROR_TeamLimit:
                ORI.InfoIcon = texture'DH_GUI_tex.DeployMenu.spawn_point_disabled';
                ORI.InfoText = default.TeamLimitText;
                break;
            case ERROR_SquadTooSmall:
                PC = DHPlayer(Interaction.ViewportOwner.Actor);

                if (PC != none && PC.SquadReplicationInfo != none)
                {
                    SquadMemberCount = PC.SquadReplicationInfo.GetMemberCount(PC.GetTeamNum(), PC.GetSquadIndex());
                }

                ORI.InfoIcon = texture'DH_GUI_Tex.DeployMenu.Squads';
                ORI.InfoText = string(SquadMemberCount) $ "/" $ string(ConstructionClass.default.SquadMemberCountMinimum);
                break;
            default:
                ORI.InfoIcon = texture'DH_InterfaceArt_tex.HUD.supplies';
                ORI.InfoText = string(ConstructionClass.default.SupplyCost);
                break;
        }
    }
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
    SuppliesIcon=Texture'DH_InterfaceArt_tex.HUD.supplies'
    NotAvailableText="Not Available"
    TeamLimitText="Limit Reached"
}

