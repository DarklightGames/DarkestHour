//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHCommandMenu_SquadManageMember extends DHCommandMenu;

function OnActive()
{
    local DHPlayer PC;

    PC = GetPlayerController();

    if (PC != none)
    {
        PC.LookTarget = Pawn(MenuObject);
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
    local DHPlayerReplicationInfo PRI, OtherPRI;
    local Pawn P;

    if (OptionIndex < 0 || OptionIndex >= Options.Length)
    {
        return;
    }

    PC = GetPlayerController();
    P = Pawn(MenuObject);

    if (PC != none && P != none)
    {
        PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
        OtherPRI = DHPlayerReplicationInfo(P.PlayerReplicationInfo);

        if (PRI != none)
        {
            switch (OptionIndex)
            {
                case 0: // Kick
                    PC.ServerSquadKick(OtherPRI);
                    break;
                case 1: // Promote to leader
                    PC.ServerSquadPromote(OtherPRI);
                    break;
                case 2: // Ban
                    PC.ServerSquadBan(OtherPRI);
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

    if (OptionIndex < 0 || OptionIndex >= Options.Length)
    {
        return true;
    }

    PC = GetPlayerController();

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
        case 0: // Kick from squad
        case 1: // Promote to squad leader
        case 2: // Ban from squad
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
    Options(0)=(SubjectText="Kick from squad",Material=Material'DH_GUI_Tex.ConstructionMenu.kick_icon')
    Options(1)=(SubjectText="Promote to squad leader",Material=Material'DH_InterfaceArt_tex.HUD.squad_signal_fire') // TODO: use squad leader icon
    Options(2)=(SubjectText="Ban from squad",Material=Material'DH_GUI_Tex.ConstructionMenu.ban_icon')
}

