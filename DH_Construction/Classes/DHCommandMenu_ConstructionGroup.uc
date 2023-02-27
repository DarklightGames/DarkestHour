//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHCommandMenu_ConstructionGroup extends DHCommandMenu
    dependson(DHConstruction);

#exec OBJ LOAD FILE=..\Textures\DH_InterfaceArt2_tex.utx

var Material SuppliesIcon;

var localized string NotAvailableText;
var localized string TeamLimitText;
var localized string BusyText;
var localized string ExhaustedText;
var localized string RemainingText;

var class<DHConstructionGroup> GroupClass;
var DHActorProxy.Context Context;

function Setup()
{
    local int i, j;
    local DHPlayer PC;
    local DHGameReplicationInfo GRI;

    PC = GetPlayerController();
    GRI = DHGameReplicationInfo(Interaction.ViewportOwner.Actor.GameReplicationInfo);
    GroupClass = class<DHConstructionGroup>(MenuObject);

    if (PC == none || GRI == none || GroupClass == none)
    {
        return;
    }

    // Establish context
    Context.TeamIndex = PC.GetTeamNum();
    Context.LevelInfo = class'DH_LevelInfo'.static.GetInstance(PC.Level);
    Context.PlayerController = PC;

    // For simplicity's sake, we'll map the static array to a dynamic array so
    // we can know how many classes we have to deal upfront and not have to deal
    // with handling null values during iteration.
    for (i = 0; i < arraycount(GRI.ConstructionClasses); ++i)
    {
        if (GRI.ConstructionClasses[i] != none &&
            GRI.ConstructionClasses[i].default.GroupClass == GroupClass &&
            GRI.ConstructionClasses[i].static.ShouldShowOnMenu(Context))
        {
            Options.Insert(j, 1);
            Options[j].OptionalObject = GRI.ConstructionClasses[i];
            Options[j].ActionText = GRI.ConstructionClasses[i].static.GetMenuName(Context);
            Options[j].Material = GRI.ConstructionClasses[i].static.GetMenuIcon(Context);
            Options[j].ActionIcon = SuppliesIcon;
            ++j;
        }
    }

    super.Setup();
}

function OnSelect(int OptionIndex, vector Location)
{
    local DHPawn P;
    local DH_ConstructionWeapon CW;
    local class<DHConstruction> ConstructionClass;
    local DHConstructionProxy CP;

    P = DHPawn(Interaction.ViewportOwner.Actor.Pawn);

    if (P == none ||
        Interaction == none ||
        Interaction.ViewportOwner == none ||
        OptionIndex < 0 ||
        OptionIndex >= Options.Length ||
        Options[OptionIndex].OptionalObject == none)
    {
        return;
    }

    if (Options[OptionIndex].OptionalObject.IsA('UInteger'))
    {
        Interaction.PushMenu("DH_Construction.DHCommandMenu_Construction", Options[OptionIndex].OptionalObject);
    }
    else if (Options[OptionIndex].OptionalObject.IsA('Class'))
    {
        ConstructionClass = class<DHConstruction>(Options[OptionIndex].OptionalObject);

        CW = DH_ConstructionWeapon(P.FindInventoryType(class'DH_ConstructionWeapon'.default.Class));

        if (CW != none)
        {
            // We already have the construction weapon in our inventory, so let's
            // simply update the construction class of the existing proxy cursor.
            CP = DHConstructionProxy(CW.ProxyCursor);

            if (CP != none)
            {
                CP.SetConstructionClass(ConstructionClass);
            }
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
            class'DH_ConstructionWeapon'.default.ConstructionClass = ConstructionClass;

            // Tell the server to give us the construction weapon.
            P.ServerGiveWeapon("DH_Construction.DH_ConstructionWeapon");
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
        return C.static.GetPlayerError(Context).Type != ERROR_None;
    }

    return false;
}

function GetOptionRenderInfo(int OptionIndex, out OptionRenderInfo ORI)
{
    local class<DHConstruction> ConstructionClass;
    local DHConstruction.ConstructionError E;
    local DHPlayer PC;
    local int SquadMemberCount, Remaining;
    local DHGameReplicationInfo GRI;

    super.GetOptionRenderInfo(OptionIndex, ORI);

    ConstructionClass = class<DHConstruction>(Options[OptionIndex].OptionalObject);
    PC = GetPlayerController();

    if (ConstructionClass != none && PC != none)
    {
        E = ConstructionClass.static.GetPlayerError(Context);
        GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

        ORI.OptionName = ConstructionClass.static.GetMenuName(Context);

        if (E.Type != ERROR_None)
        {
            ORI.InfoColor = class'UColor'.default.Red;
        }
        else
        {
            ORI.InfoColor = class'UColor'.default.White;
        }

        switch (E.Type)
        {
            case ERROR_RestrictedType:
            case ERROR_Fatal:
                ORI.InfoIcon = Texture'DH_GUI_tex.DeployMenu.spawn_point_disabled';
                ORI.InfoText[0] = default.NotAvailableText;
                break;
            case ERROR_PlayerBusy:
                ORI.InfoIcon = Texture'DH_GUI_tex.DeployMenu.spawn_point_disabled';
                ORI.InfoText[0] = default.BusyText;
                break;
            case ERROR_TeamLimit:
                ORI.InfoIcon = Texture'DH_GUI_tex.DeployMenu.spawn_point_disabled';
                ORI.InfoText[0] = default.TeamLimitText;
                break;
            case ERROR_Exhausted:
                ORI.InfoIcon = Texture'DH_GUI_tex.DeployMenu.spawn_point_disabled';
                ORI.InfoText[0] = default.ExhaustedText;
                if (E.OptionalInteger >= 0)
                {
                    ORI.InfoText[0] @= "(" $ class'TimeSpan'.static.ToString(E.OptionalInteger - GRI.ElapsedTime) $ ")";
                }
                break;
            case ERROR_SquadTooSmall:
                if (PC != none && PC.SquadReplicationInfo != none)
                {
                    SquadMemberCount = PC.SquadReplicationInfo.GetMemberCount(PC.GetTeamNum(), PC.GetSquadIndex());
                }

                ORI.InfoIcon = Texture'DH_InterfaceArt2_tex.Icons.squad';
                ORI.InfoText[0] = string(SquadMemberCount) $ "/" $ string(ConstructionClass.default.SquadMemberCountMinimum);
                break;
            default:
                ORI.InfoIcon = SuppliesIcon;
                ORI.InfoText[0] = string(ConstructionClass.static.GetSupplyCost(Context));
                break;
        }

        ORI.DescriptionText = ConstructionClass.default.MenuDescription;

        if (GRI != none && ORI.DescriptionText == "")
        {
            Remaining = GRI.GetTeamConstructionRemaining(PC.GetTeamNum(), ConstructionClass);

            // GetTeamConstructionRemaining returns -1 if it can't find anything
            if (Remaining != -1)
            {
                ORI.DescriptionText = string(Remaining) @ default.RemainingText;
            }
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
    NotAvailableText="Not Available"
    TeamLimitText="Limit Reached"
    ExhaustedText="Exhausted"
    RemainingText="Remaining"
    BusyText="Busy"
    SlotCountOverride=8
}

