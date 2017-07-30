//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHCommandMenu_SquadManageMember extends DHCommandMenu;

function OnActive()
{
    local DHPlayer PC;

    if (Interaction != none && Interaction.ViewportOwner != none)
    {
        PC = DHPlayer(Interaction.ViewportOwner.Actor);

        if (PC != none)
        {
            PC.LookTarget = Pawn(MenuObject);
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
    local DHPlayerReplicationInfo PRI, OtherPRI;
    local Pawn P;

    if (Interaction == none || Interaction.ViewportOwner == none || OptionIndex < 0 || OptionIndex >= Options.Length)
    {
        return;
    }

    PC = DHPlayer(Interaction.ViewportOwner.Actor);
    P = Pawn(MenuObject);

    if (PC != none && P != none)
    {
        PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
        OtherPRI = DHPlayerReplicationInfo(P.PlayerReplicationInfo);

        if (PRI != none)
        {
            switch (OptionIndex)
            {
                case 0: // Invite
                    PC.ServerSquadInvite(OtherPRI);
                    break;
                case 1: // Kick
                    PC.ServerSquadKick(OtherPRI);
                    break;
                case 2: // Promote to leader
                    PC.ServerSquadPromote(OtherPRI);
                    break;
                case 3: // Ban
                    // TODO: we don't have banning yet!
                    break;
                default:
                    break;
            }
        }
    }

    Interaction.Hide();
}

function bool IsOptionDisabled(int OptionIndex)
{
    local DHPlayer PC;
    local DHPlayerReplicationInfo PRI, OtherPRI;
    local Pawn P;

    if (Interaction == none || Interaction.ViewportOwner == none || OptionIndex < 0 || OptionIndex >= Options.Length)
    {
        return true;
    }

    PC = DHPlayer(Interaction.ViewportOwner.Actor);

    if (PC != none)
    {
        PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
    }

    P = Pawn(MenuObject);

    if (P != none)
    {
        OtherPRI = DHPlayerReplicationInfo(P.PlayerReplicationInfo);
    }

    if (OtherPRI == none)
    {
        return true;
    }

    switch (OptionIndex)
    {
        case 0: // Invite
            return OtherPRI.IsInSquad();
        case 1: // Kick from squad
        case 2: // Promote to squad leader
        case 3: // Ban from squad
            return !OtherPRI.IsInSameSquad(PRI, OtherPRI);
        default:
            return true;
    }
}

function GetOptionRenderInfo(int OptionIndex, out OptionRenderInfo ORI)
{
    local DHPlayerReplicationInfo OtherPRI;
    local Pawn P;

    super.GetOptionRenderInfo(OptionIndex, ORI);

    P = Pawn(MenuObject);

    if (P != none)
    {
        OtherPRI = DHPlayerReplicationInfo(P.PlayerReplicationInfo);

        if (OtherPRI != none)
        {
            ORI.OptionName = OtherPRI.PlayerName;
        }
    }
}

defaultproperties
{
    Options(0)=(SubjectText="Invite to squad",Material=Material'DH_InterfaceArt_tex.HUD.squad_signal_fire')
    Options(1)=(SubjectText="Kick from squad",Material=Material'DH_InterfaceArt_tex.HUD.squad_signal_fire')
    Options(2)=(SubjectText="Promote to squad leader",Material=Material'DH_InterfaceArt_tex.HUD.squad_signal_fire')
    Options(3)=(SubjectText="Ban from squad",Material=Material'DH_InterfaceArt_tex.HUD.squad_signal_fire')
}

