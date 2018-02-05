//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHCommandMenu_Radio extends DHCommandMenu
    dependson(DHGameReplicationInfo);

var DHRadio Radio;
var Sound   OnActiveSound;

var localized string UnavailableText;
var localized string ExhaustedText;
var localized string UnqualifiedText;
var localized string OngoingText;
var localized string AvailableText;

function Setup()
{
    local int i;
    local DH_LevelInfo LI;
    local Option O;
    local DHPlayer PC;

    PC = GetPlayerController();
    Radio = DHRadio(MenuObject);
    LI = class'DH_LevelInfo'.static.GetInstance(Interaction.ViewportOwner.Actor.Level);

    if (PC == none || Radio == none || LI == none)
    {
        return;
    }

    for (i = 0; i < LI.ArtilleryTypes.Length; ++i)
    {
        if (LI.ArtilleryTypes[i].TeamIndex == PC.GetTeamNum())
        {
            O.OptionalObject = LI.ArtilleryTypes[i].ArtilleryClass;
            O.SubjectText = LI.ArtilleryTypes[i].ArtilleryClass.static.GetMenuName();
            O.Material = LI.ArtilleryTypes[i].ArtilleryClass.default.MenuIcon;
            O.ActionText = Interaction.GRI.ArtilleryTypeInfos[i].UsedCount $ "/" $ Interaction.GRI.ArtilleryTypeInfos[i].Limit;
            O.OptionalInteger = i;
            Options[Options.Length] = O;
        }
    }

    super.Setup();
}

function GetOptionRenderInfo(int OptionIndex, out OptionRenderInfo ORI)
{
    local DHGameReplicationInfo.EArtilleryTypeError Error;
    local int Index;
    local int CooldownTimeSeconds;

    ORI.OptionName = Options[OptionIndex].SubjectText;

    Index = Options[OptionIndex].OptionalInteger;
    Error = Interaction.GRI.GetArtilleryTypeError(GetPlayerController(), Index);

    if (Error == ERROR_None)
    {
        ORI.InfoColor = class'UColor'.default.White;
        ORI.InfoText = default.AvailableText @ "(" $ Interaction.GRI.ArtilleryTypeInfos[Index].Limit - Interaction.GRI.ArtilleryTypeInfos[Index].UsedCount $ ")";
    }
    else
    {
        ORI.InfoColor = class'UColor'.default.Red;

        switch (Error)
        {
            case ERROR_Exhausted:
                ORI.InfoIcon = Texture'DH_GUI_tex.DeployMenu.spawn_point_disabled';
                ORI.InfoText = default.ExhaustedText;
                break;
            case ERROR_Unqualified:
                ORI.InfoIcon = Texture'DH_GUI_tex.DeployMenu.spawn_point_disabled';
                ORI.InfoText = default.UnqualifiedText;
                break;
            case ERROR_Cooldown:
                ORI.InfoIcon = Texture'DH_GUI_tex.DeployMenu.StopWatch';
                CooldownTimeSeconds = Interaction.GRI.ArtilleryTypeInfos[Index].NextConfirmElapsedTime - Interaction.GRI.ElapsedTime;
                ORI.InfoText = class'TimeSpan'.static.ToString(CooldownTimeSeconds);
                break;
            case ERROR_Ongoing:
                ORI.InfoIcon = Texture'DH_GUI_tex.DeployMenu.StopWatch';
                ORI.InfoText = default.OngoingText;
                break;
            default:
                ORI.InfoIcon = Texture'DH_GUI_tex.DeployMenu.spawn_point_disabled';
                ORI.InfoText = default.UnavailableText;
                break;
        }
    }
}

function OnActive()
{
    if (Interaction != none &&
        Interaction.ViewportOwner != none &&
        Interaction.ViewportOwner.Actor != none &&
        Interaction.ViewportOwner.Actor.Pawn != none)
    {
        Interaction.ViewportOwner.Actor.Pawn.PlayOwnedSound(OnActiveSound, SLOT_Interface, 1.0);
    }
}

function OnSelect(int OptionIndex, vector Location)
{
    local DHPlayer PC;

    PC = GetPlayerController();

    if (PC != none && Radio != none)
    {
        PC.ServerRequestArtillery(Radio, Options[OptionIndex].OptionalInteger);

        Interaction.Hide();
    }
}

function bool IsOptionDisabled(int OptionIndex)
{
    return Interaction.GRI.GetArtilleryTypeError(GetPlayerController(), Options[OptionIndex].OptionalInteger) != ERROR_None;
}

function bool ShouldHideMenu()
{
    local DHPlayer PC;

    PC = GetPlayerController();

    return Radio == none || PC == none || Radio.GetRadioUsageError(PC.Pawn) != ERROR_None;
}

defaultproperties
{
    SlotCountOverride=4
    OnActiveSound=Sound'DH_SundrySounds.Radio.RadioClick'

    UnavailableText="Unavailable"
    ExhaustedText="Exhausted"
    UnqualifiedText="Unqualified"
    AvailableText="Available"
    OngoingText="Ongoing"
}

