//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
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
                case 0: // Kick
                    PC.ServerSquadKick(OtherPRI);
                    break;
                case 1: // Promote to leader
                    PC.ServerSquadPromote(OtherPRI);
                    break;
                case 2: // Ban
                    // TODO: we don't have banning yet!
                    break;
                default:
                    break;
            }
        }
    }

    Interaction.Hide();
}

function GetOptionText(int OptionIndex, out string ActionText, out string SubjectText)
{
    local DHPlayerReplicationInfo OtherPRI;
    local Pawn P;

    super.GetOptionText(OptionIndex, ActionText, SubjectText);

    P = Pawn(MenuObject);

    if (P != none)
    {
        OtherPRI = DHPlayerReplicationInfo(P.PlayerReplicationInfo);

        if (OtherPRI != none)
        {
            SubjectText = OtherPRI.PlayerName;
        }
    }
}

defaultproperties
{
    Options(0)=(ActionText="Kick from squad",Material=Material'DH_InterfaceArt_tex.HUD.squad_signal_fire')
    Options(1)=(ActionText="Promote to squad leader",Material=Material'DH_InterfaceArt_tex.HUD.squad_signal_fire')
    Options(2)=(ActionText="Ban from squad",Material=Material'DH_InterfaceArt_tex.HUD.squad_signal_fire')
}

