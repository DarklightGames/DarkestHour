//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHCommandMenu_SquadManageNonMember extends DHCommandMenu;

var localized string AlreadyInASquad;

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
    local DHPlayerReplicationInfo OtherPRI;

    P = DHPawn(MenuObject);

    if (P != none)
    {
        OtherPRI = DHPlayerReplicationInfo(P.PlayerReplicationInfo);
    }

    return OtherPRI == none || OtherPRI.IsInSquad();
}

function GetOptionRenderInfo(int OptionIndex, out OptionRenderInfo ORI)
{
    local DHPawn P;
    local DHPlayerReplicationInfo OtherPRI;

    super.GetOptionRenderInfo(OptionIndex, ORI);

    P = DHPawn(MenuObject);

    if (P != none)
    {
        OtherPRI = DHPlayerReplicationInfo(P.PlayerReplicationInfo);
    }

    if (OtherPRI != none && OtherPRI.IsInSquad() && Interaction != none && !Interaction.IsFadingOut())
    {
        ORI.InfoText = AlreadyInASquad;
        ORI.InfoColor = class'UColor'.default.Red;
    }
}

defaultproperties
{
    AlreadyInASquad="Already in a squad"
    Options(0)=(ActionText="Invite to Squad",Material=Material'DH_GUI_Tex.ConstructionMenu.invite_icon')
}

