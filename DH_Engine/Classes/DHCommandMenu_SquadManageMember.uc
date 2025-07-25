//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
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

function OnSelect(int OptionIndex, Vector Location, optional Vector HitNormal)
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
                case 0: // Kick from squad
                    PC.ServerSquadKick(OtherPRI);
                    break;
                case 1: // Promote to leader
                    PC.ServerSendSquadPromotionRequest(OtherPRI);
                    break;
                case 2: // Ban from squad
                    PC.ServerSquadBan(OtherPRI);
                    break;
                case 3: // Make assistant
                    PC.ServerSquadMakeAssistant(OtherPRI);
                    break;
                case 4: // Remove assistant
                    PC.ServerSquadMakeAssistant(none);
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

    if (OtherPRI == none || !OtherPRI.IsInSameSquad(PRI, OtherPRI))
    {
        return true;
    }

    return false;
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

function bool IsOptionHidden(int OptionIndex)
{
    local Pawn P;
    local DHPlayerReplicationInfo OtherPRI;

    P = Pawn(MenuObject);

    if (P != none)
    {
        OtherPRI = DHPlayerReplicationInfo(P.PlayerReplicationInfo);
    }

    if (OtherPRI != none)
    {
        switch (OptionIndex)
        {
            case 3: // Make assistant
                return OtherPRI.bIsSquadAssistant;
            case 4: // Remove assistant
                return !OtherPRI.bIsSquadAssistant;
            default:
                break;
        }
    }

    return false;
}

defaultproperties
{
    Options(0)=(SubjectText="Kick from squad",Material=Material'DH_InterfaceArt2_tex.squad_kick')
    Options(1)=(SubjectText="Promote to squad leader",Material=Material'DH_InterfaceArt2_tex.squad_leader')
    Options(2)=(SubjectText="Ban from squad",Material=Material'DH_InterfaceArt2_tex.squad_ban')
    Options(3)=(SubjectText="Make assistant",Material=Texture'DH_InterfaceArt2_tex.assistant')
    Options(4)=(SubjectText="Remove assistant",Material=Texture'DH_InterfaceArt2_tex.assistant')
}

