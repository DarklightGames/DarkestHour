//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHCommandMenu_SquadManageNonMember extends DHCommandMenu;

var localized string AlreadyInASquadText;
var localized string SquadIsFullText;

function OnActive()
{
    local DHPlayer PC;

    PC = GetPlayerController();

    if (PC != none)
    {
        PC.LookTarget = Actor(MenuObject);
    }
}

function OnPop()
{
    local DHPlayer PC;

    PC = GetPlayerController();

    if (PC != none)
    {
        PC.LookTarget = none;
    }
}

function bool ShouldHideMenu()
{
    local Pawn P;

    P = Pawn(MenuObject);

    return P == none || P.bDeleteMe || P.Health <= 0;
}

function OnSelect(int OptionIndex, vector Location)
{
    local DHPlayer PC;
    local Pawn P;
    local DHPlayerReplicationInfo OtherPRI;

    if (OptionIndex < 0 || OptionIndex >= Options.Length)
    {
        return;
    }

    P = Pawn(MenuObject);

    if (P != none)
    {
        OtherPRI = DHPlayerReplicationInfo(P.PlayerReplicationInfo);
    }

    PC = GetPlayerController();

    if (PC != none && OtherPRI != none)
    {
        switch (OptionIndex)
        {
            case 0: // Invite
                PC.ServerSquadInvite(OtherPRI);
                break;
            default:
                break;
        }
    }

    Interaction.Hide();
}

function bool IsOptionDisabled(int OptionIndex)
{
    local DHPawn P;
    local DHPlayer PC;
    local DHPlayerReplicationInfo OtherPRI;

    PC = GetPlayerController();

    if (PC == none)
    {
        return true;
    }

    P = DHPawn(MenuObject);

    if (P != none)
    {
        OtherPRI = DHPlayerReplicationInfo(P.PlayerReplicationInfo);
    }

    return OtherPRI == none || OtherPRI.IsInSquad() || PC.SquadReplicationInfo == none || PC.SquadReplicationInfo.IsSquadFull(PC.GetTeamNum(), PC.GetSquadIndex());
}

function GetOptionRenderInfo(int OptionIndex, out OptionRenderInfo ORI)
{
    local DHPawn P;
    local DHPlayerReplicationInfo OtherPRI;
    local DHPlayer PC;

    super.GetOptionRenderInfo(OptionIndex, ORI);

    P = DHPawn(MenuObject);
    PC = GetPlayerController();

    if (P != none)
    {
        OtherPRI = DHPlayerReplicationInfo(P.PlayerReplicationInfo);
    }

    if (OtherPRI != none && Interaction != none && !Interaction.IsFadingOut())
    {
        if (OtherPRI.IsInSquad())
        {
            ORI.InfoText[0] = default.AlreadyInASquadText;
            ORI.InfoColor = class'UColor'.default.Red;
        }
        else if (PC != none && PC.SquadReplicationInfo != none && PC.SquadReplicationInfo.IsSquadFull(PC.GetTeamNum(), PC.GetSquadIndex()))
        {
            ORI.InfoText[0] = default.SquadIsFullText;
            ORI.InfoColor = class'UColor'.default.Red;
        }
    }
}

defaultproperties
{
    AlreadyInASquadText="Already in a squad"
    SquadIsFullText="Squad is full"
    Options(0)=(ActionText="Invite to Squad",Material=Material'DH_InterfaceArt2_tex.Icons.squad_invite')
    SlotCountOverride=4
}

