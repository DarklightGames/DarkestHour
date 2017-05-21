//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHCommandMenu_SquadManageNonMember extends DHCommandMenu;

function OnActive()
{
    local DHPlayer PC;

    if (Interaction != none && Interaction.ViewportOwner != none)
    {
        PC = DHPlayer(Interaction.ViewportOwner.Actor);

        if (PC != none)
        {
            PC.LookTarget = Actor(MenuObject);
        }
    }
}

function OnPop()
{
    local DHPlayer PC;

    if (Interaction != none && Interaction.ViewportOwner != none)
    {
        PC = DHPlayer(Interaction.ViewportOwner.Actor);

        if (PC != none)
        {
            PC.LookTarget = none;
        }
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

    if (Interaction == none || Interaction.ViewportOwner == none || OptionIndex < 0 || OptionIndex >= Options.Length)
    {
        return;
    }

    P = Pawn(MenuObject);

    if (P != none)
    {
        OtherPRI = DHPlayerReplicationInfo(P.PlayerReplicationInfo);
    }

    PC = DHPlayer(Interaction.ViewportOwner.Actor);

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

function GetOptionText(int OptionIndex, out string ActionText, out string SubjectText)
{
    local DHPlayerReplicationInfo OtherPRI;

    super.GetOptionText(OptionIndex, ActionText, SubjectText);

    OtherPRI = DHPlayerReplicationInfo(MenuObject);

    if (OtherPRI != none)
    {
        SubjectText = OtherPRI.PlayerName;
    }
}

defaultproperties
{
    Options(0)=(ActionText="Invite to squad",Material=Material'DH_InterfaceArt_tex.HUD.squad_signal_fire')
}

