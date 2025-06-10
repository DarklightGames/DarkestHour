//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// This is the command menu for listing the construction options in a group
// (e.g., defenses, guns etc.)
//==============================================================================

class DHCommandMenu_ConstructionGroup extends DHCommandMenu
    dependson(DHConstruction);

const MORE_BUTTON_FLAG = 1;

var Material SuppliesIcon;
var Material SquadIcon;
var Material DisabledIcon;
var Material MoreIcon;

var localized string NotAvailableText;
var localized string TeamLimitText;
var localized string BusyText;
var localized string ExhaustedText;
var localized string RemainingText;
var localized string MaxActiveText;
var localized string MoreText;

var class<DHConstructionGroup> GroupClass;
var DHActorProxy.Context Context;

function Setup()
{
    local int i, j, PageCount, PageIndex;
    local DHPlayer PC;
    local DHGameReplicationInfo GRI;
    local class<DHConstruction> ConstructionClass;

    PC = GetPlayerController();
    GRI = DHGameReplicationInfo(Interaction.ViewportOwner.Actor.GameReplicationInfo);
    GroupClass = class<DHConstructionGroup>(MenuObject);

    if (PC == none || GRI == none || GroupClass == none)
    {
        return;
    }

    // Establish context
    Context.TeamIndex = PC.GetTeamNum();
    Context.LevelInfo = Class'DH_LevelInfo'.static.GetInstance(PC.Level);
    Context.PlayerController = PC;

    // For simplicity's sake, we'll map the static array to a dynamic array so
    // we can know how many classes we have to deal upfront and not have to deal
    // with handling null values during iteration.
    for (i = 0; i < Context.LevelInfo.ConstructionsEvaluated.Length; ++i)
    {
        if (Context.LevelInfo.ConstructionsEvaluated[i].TeamIndex != Context.TeamIndex)
        {
            continue;
        }

        ConstructionClass = Context.LevelInfo.ConstructionsEvaluated[i].ConstructionClass;

        if (ConstructionClass != none &&
            ConstructionClass.default.GroupClass == GroupClass &&
            ConstructionClass.static.ShouldShowOnMenu(Context))
        {
            Options.Insert(j, 1);
            Options[j].OptionalObject = ConstructionClass;
            Options[j].ActionText = ConstructionClass.static.GetMenuName(Context);
            Options[j].Material = ConstructionClass.static.GetMenuIcon(Context);
            Options[j].ActionIcon = SuppliesIcon;
            ++j;
        }
    }

    // If we are overrunning the limit, add a "more" button, then use the
    // MenuInteger as the page number.
    PageCount = Max(1, Ceil(float(Options.Length) / (SlotCountOverride - 1)));
    PageIndex = Max(0, MenuInteger % PageCount);

    if (PageCount > 1)
    {
        // Remove all options before this page.
        Options.Remove(0, PageIndex * (SlotCountOverride - 1));

        // Add the "More" button.
        Options.Insert(0, 1);
        Options[0].ActionText = MoreText;
        Options[0].OptionalInteger = MORE_BUTTON_FLAG;
        Options[0].Material = MoreIcon;
    }

    Options.Length = Min(Options.Length, SlotCountOverride);

    super.Setup();
}

function OnSelect(int OptionIndex, Vector Location, optional Vector HitNormal)
{
    local DHPawn P;
    local DH_ConstructionWeapon CW;
    local class<DHWeapon> WeaponClass;
    local class<DHConstruction> ConstructionClass;

    P = DHPawn(Interaction.ViewportOwner.Actor.Pawn);

    if (P == none ||
        Interaction == none ||
        Interaction.ViewportOwner == none ||
        OptionIndex < 0 ||
        OptionIndex >= Options.Length)
    {
        return;
    }

    if (Options[OptionIndex].OptionalInteger == MORE_BUTTON_FLAG)
    {
        // More button.
        Interaction.PopMenu();
        Interaction.PushMenu(string(Class), MenuObject, MenuInteger + 1);
        return;
    }

    if (Options[OptionIndex].OptionalObject == none)
    {
        return;
    }

    if (Options[OptionIndex].OptionalObject.IsA('UInteger'))
    {
        Interaction.PushMenu(string(Class), Options[OptionIndex].OptionalObject);
    }
    else if (Options[OptionIndex].OptionalObject.IsA('Class'))
    {
        ConstructionClass = class<DHConstruction>(Options[OptionIndex].OptionalObject);

        CW = DH_ConstructionWeapon(P.FindInventoryType(Class'DH_ConstructionWeapon'.default.Class));

        if (CW != none)
        {
            CW.SetConstructionClass(ConstructionClass);
        }
        else
        {
            if (P.Weapon != none)
            {
                P.Weapon.PutDown();
            }

            P.PendingWeapon = none;

            // This call prepares the construction weapon with the correct
            // construction class on the client upon instantiation.
            Class'DH_ConstructionWeapon'.default.ConstructionClass = ConstructionClass;

            WeaponClass = class<DHWeapon>(DynamicLoadObject("DH_Construction.DH_ConstructionWeapon", Class'Class'));

            // Tell the server to give us the construction weapon.
            P.ServerGiveWeapon("DH_Construction.DH_ConstructionWeapon", WeaponClass, true);
        }

        Interaction.Hide();
    }
}

function bool IsOptionDisabled(int OptionIndex)
{
    local class<DHConstruction> C;

    if (Options[OptionIndex].OptionalInteger != MORE_BUTTON_FLAG &&
        Options[OptionIndex].OptionalObject == none)
    {
        return true;
    }

    C = class<DHConstruction>(Options[OptionIndex].OptionalObject);

    if (C != none)
    {
        return C.static.GetPlayerError(Context).Type != ERROR_None;
    }

    return false;
}

function GetOptionRenderInfo(int OptionIndex, out OptionRenderInfo ORI)
{
    local class<DHConstruction> ConstructionClass;
    local DHConstruction.ConstructionError E;
    local DHPlayer PC;
    local int SquadMemberCount, Remaining, Active, MaxActive, InfoTextIndex;
    local DHGameReplicationInfo GRI;

    super.GetOptionRenderInfo(OptionIndex, ORI);

    ConstructionClass = class<DHConstruction>(Options[OptionIndex].OptionalObject);
    PC = GetPlayerController();

    if (ConstructionClass == none || PC == none)
    {
        return;
    }

    E = ConstructionClass.static.GetPlayerError(Context);
    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

    ORI.OptionName = ConstructionClass.static.GetMenuName(Context);

    if (E.Type != ERROR_None)
    {
        ORI.InfoColor = Class'UColor'.default.Red;
    }
    else
    {
        ORI.InfoColor = Class'UColor'.default.White;
    }

    switch (E.Type)
    {
        case ERROR_RestrictedType:
        case ERROR_Fatal:
            ORI.InfoIcon = default.DisabledIcon;
            ORI.InfoText[0] = default.NotAvailableText;
            break;
        case ERROR_PlayerBusy:
            ORI.InfoIcon = default.DisabledIcon;
            ORI.InfoText[0] = default.BusyText;
            break;
        case ERROR_MaxActive:
            ORI.InfoIcon = default.DisabledIcon;
            ORI.InfoText[0] = default.TeamLimitText;
            break;
        case ERROR_Exhausted:
            ORI.InfoIcon = default.DisabledIcon;
            ORI.InfoText[0] = default.ExhaustedText;
            break;
        case ERROR_SquadTooSmall:
            if (PC != none && PC.SquadReplicationInfo != none)
            {
                SquadMemberCount = PC.SquadReplicationInfo.GetMemberCount(PC.GetTeamNum(), PC.GetSquadIndex());
            }

            ORI.InfoIcon = default.SquadIcon;
            ORI.InfoText[0] = string(SquadMemberCount) $ "/" $ string(ConstructionClass.default.SquadMemberCountMinimum);
            break;
        default:
            ORI.InfoIcon = SuppliesIcon;
            ORI.InfoText[0] = string(ConstructionClass.static.GetSupplyCost(Context));
            break;
    }

    ORI.DescriptionText = ConstructionClass.default.MenuDescription;

    if (GRI != none)
    {
        Remaining = GRI.GetTeamConstructionRemaining(PC.GetTeamNum(), ConstructionClass);

        InfoTextIndex = 1;

        if (Remaining != -1)
        {
            ORI.InfoText[InfoTextIndex] = Repl(default.RemainingText, "{0}", string(Remaining));
            ++InfoTextIndex;
        }

        MaxActive = Context.LevelInfo.GetConstructionMaxActive(PC.GetTeamNum(), ConstructionClass);

        if (MaxActive != -1)
        {
            Active = GRI.GetTeamConstructionActive(PC.GetTeamNum(), ConstructionClass);
            ORI.InfoText[InfoTextIndex] = Repl(Repl(default.MaxActiveText, "{0}", string(Active)), "{1}", string(MaxActive));
            ++InfoTextIndex;
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
    SuppliesIcon=Texture'DH_InterfaceArt2_tex.Icons.supply_cache'
    SquadIcon=Texture'DH_InterfaceArt2_tex.Icons.squad'
    DisabledIcon=Texture'DH_GUI_tex.DeployMenu.spawn_point_disabled'
    MoreIcon=Texture'DH_InterfaceArt2_tex.ellipses'
    NotAvailableText="Not Available"
    TeamLimitText="Limit Reached"
    ExhaustedText="Exhausted"
    RemainingText="{0} Remaining"
    MaxActiveText="{0}/{1} Active"
    BusyText="Busy"
    MoreText="More"
    SlotCountOverride=8
}
