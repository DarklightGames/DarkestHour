//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHCommandMenu_Radio extends DHCommandMenu
    dependson(DHGameReplicationInfo);

var DH_LevelInfo LevelInfo;
var DHRadio Radio;
var Sound   OnActiveSound;

var localized string UnavailableText;
var localized string ExhaustedText;
var localized string UnqualifiedText;
var localized string OngoingText;
var localized string AvailableText;
var localized string CancelText;

function Setup()
{
    local int i;
    local Option O;
    local DHPlayer PC;

    PC = GetPlayerController();
    Radio = DHRadio(MenuObject);
    LevelInfo = class'DH_LevelInfo'.static.GetInstance(Interaction.ViewportOwner.Actor.Level);

    if (PC == none || Radio == none || LevelInfo == none)
    {
        return;
    }

    for (i = 0; i < LevelInfo.ArtilleryTypes.Length; ++i)
    {
        if (LevelInfo.ArtilleryTypes[i].TeamIndex == PC.GetTeamNum())
        {
            O.OptionalObject = LevelInfo.ArtilleryTypes[i].ArtilleryClass;
            O.SubjectText = LevelInfo.ArtilleryTypes[i].ArtilleryClass.static.GetMenuName();
            O.Material = LevelInfo.ArtilleryTypes[i].ArtilleryClass.default.MenuIcon;
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
    local int Index, CooldownTimeSeconds;
    local DHPlayer PC;
    local class<DHArtillery> ArtilleryClass;

    PC = GetPlayerController();

    ORI.OptionName = Options[OptionIndex].SubjectText;

    Index = Options[OptionIndex].OptionalInteger;
    Error = Interaction.GRI.GetArtilleryTypeError(PC, Index);

    if (Error == ERROR_None)
    {
        ORI.InfoColor = class'UColor'.default.White;
        ORI.InfoText[0] = default.AvailableText @ "(" $ Interaction.GRI.ArtilleryTypeInfos[Index].Limit - Interaction.GRI.ArtilleryTypeInfos[Index].UsedCount $ ")";
    }
    else if (Error == ERROR_Cancellable)
    {
        ORI.InfoColor = class'UColor'.default.Yellow;
        ORI.InfoText[0] = default.CancelText;
    }
    else
    {
        ORI.InfoColor = class'UColor'.default.Red;

        switch (Error)
        {
            case ERROR_Exhausted:
                ORI.InfoIcon = Texture'DH_GUI_tex.DeployMenu.spawn_point_disabled';
                ORI.InfoText[0] = default.ExhaustedText;
                break;
            case ERROR_Unqualified:
                ORI.InfoIcon = Texture'DH_GUI_tex.DeployMenu.spawn_point_disabled';
                ORI.InfoText[0] = default.UnqualifiedText;
                break;
            case ERROR_NotEnoughSquadMembers:
                ORI.InfoIcon = Texture'DH_InterfaceArt2_tex.Icons.squad';

                if (LevelInfo != none && PC != none && PC.SquadReplicationInfo != none)
                {
                    ArtilleryClass = LevelInfo.GetArtilleryClass(OptionIndex);

                    if (ArtilleryClass != none)
                    {
                        ORI.InfoText[0] = PC.SquadReplicationInfo.GetMemberCount(PC.GetTeamNum(), PC.GetSquadIndex()) $
                                          "/" $
                                          ArtilleryClass.default.RequiredSquadMemberCount;
                        break;
                    }
                }

                ORI.InfoText[0] = "?/?";
                break;
            case ERROR_Cooldown:
                ORI.InfoIcon = Texture'DH_GUI_tex.DeployMenu.StopWatch';
                CooldownTimeSeconds = Interaction.GRI.ArtilleryTypeInfos[Index].NextConfirmElapsedTime - Interaction.GRI.ElapsedTime;
                ORI.InfoText[0] = class'TimeSpan'.static.ToString(CooldownTimeSeconds);
                break;
            case ERROR_Ongoing:
                ORI.InfoIcon = Texture'DH_GUI_tex.DeployMenu.StopWatch';
                ORI.InfoText[0] = default.OngoingText;
                break;
            default:
                ORI.InfoIcon = Texture'DH_GUI_tex.DeployMenu.spawn_point_disabled';
                ORI.InfoText[0] = default.UnavailableText;
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
    local int Index;
    local DHGameReplicationInfo.EArtilleryTypeError Error;

    PC = GetPlayerController();

    if (PC != none && Radio != none)
    {
        Index = Options[OptionIndex].OptionalInteger;
        Error = Interaction.GRI.GetArtilleryTypeError(GetPlayerController(), Index);

        if (Error == ERROR_None)
        {
            PC.ServerRequestArtillery(Radio, Options[OptionIndex].OptionalInteger);
            Interaction.Hide();
        }
        else if (Error == ERROR_Cancellable)
        {
            PC.ServerCancelArtillery(Radio, Options[OptionIndex].OptionalInteger);
            Interaction.Hide();
        }
    }
}

function bool IsOptionDisabled(int OptionIndex)
{
    local DHGameReplicationInfo.EArtilleryTypeError Error;

    Error = Interaction.GRI.GetArtilleryTypeError(GetPlayerController(), Options[OptionIndex].OptionalInteger);

    return Error != ERROR_None && Error != ERROR_Cancellable;
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
    CancelText="Ongoing (Cancel)"
}
