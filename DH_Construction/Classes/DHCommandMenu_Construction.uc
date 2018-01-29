//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHCommandMenu_Construction extends DHCommandMenu
    dependson(DHConstruction);

#exec OBJ LOAD FILE=..\Textures\DH_InterfaceArt2_tex.utx

var Material SuppliesIcon;

var localized string NotAvailableText;
var localized string TeamLimitText;
var localized string MoreText;

var DHConstruction.Context Context;

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

    PC = GetPlayerController();

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

    // Establish context
    Context.TeamIndex = PC.GetTeamNum();
    Context.LevelInfo = class'DH_LevelInfo'.static.GetInstance(PC.Level);
    Context.PlayerController = PC;

    if (GRI != none)
    {
        // TODO: magic number
        for (i = StartIndex; i < ConstructionClasses.Length && j < 8; ++i)
        {
            Options.Insert(j, 1);
            Options[j].OptionalObject = ConstructionClasses[i];
            Options[j].ActionText = ConstructionClasses[i].static.GetMenuName(Context);
            Options[j].Material = ConstructionClasses[i].static.GetMenuIcon(Context);
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
            Options[0].ActionText = MoreText;
            Options[0].Material = Texture'DH_InterfaceArt2_tex.Icons.ellipses';
        }
    }

    super.Setup();
}

function OnSelect(int OptionIndex, vector Location)
{
    local DHPawn P;
    local DH_ConstructionWeapon CW;
    local class<DHConstruction> ConstructionClass;

    P = DHPawn(Interaction.ViewportOwner.Actor.Pawn);

    if (Interaction == none || Interaction.ViewportOwner == none || OptionIndex < 0 || OptionIndex >= Options.Length || Options[OptionIndex].OptionalObject == none || P == none)
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
        class'DH_ConstructionWeapon'.default.ConstructionClass = ConstructionClass;
        CW = DH_ConstructionWeapon(P.FindInventoryType(class'DH_ConstructionWeapon'.default.Class));

        if (CW != none)
        {
            if (CW.Proxy != none)
            {
                CW.Proxy.SetConstructionClass(ConstructionClass);
            }
        }
        else
        {
            if (P.Weapon != none)
            {
                P.Weapon.PutDown();
            }

            P.PendingWeapon = none;
            P.ServerGiveConstructionWeapon();
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
    local int SquadMemberCount;

    super.GetOptionRenderInfo(OptionIndex, ORI);

    ConstructionClass = class<DHConstruction>(Options[OptionIndex].OptionalObject);
    PC = GetPlayerController();

    if (ConstructionClass != none && PC != none)
    {
        E = ConstructionClass.static.GetPlayerError(Context);

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
                ORI.InfoText = default.NotAvailableText;
                break;
            case ERROR_TeamLimit:
                ORI.InfoIcon = Texture'DH_GUI_tex.DeployMenu.spawn_point_disabled';
                ORI.InfoText = default.TeamLimitText;
                break;
            case ERROR_SquadTooSmall:
                if (PC != none && PC.SquadReplicationInfo != none)
                {
                    SquadMemberCount = PC.SquadReplicationInfo.GetMemberCount(PC.GetTeamNum(), PC.GetSquadIndex());
                }

                ORI.InfoIcon = Texture'DH_InterfaceArt2_tex.Icons.squad';
                ORI.InfoText = string(SquadMemberCount) $ "/" $ string(ConstructionClass.default.SquadMemberCountMinimum);
                break;
            default:
                ORI.InfoIcon = SuppliesIcon;
                ORI.InfoText = string(ConstructionClass.static.GetSupplyCost(Context));
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
    SuppliesIcon=Texture'DH_InterfaceArt2_tex.Icons.supply_cache'
    NotAvailableText="Not Available"
    TeamLimitText="Limit Reached"
    MoreText="More..."
    SlotCountOverride=8
}

