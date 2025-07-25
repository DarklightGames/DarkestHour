//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCommandMenu_SquadAssistant extends DHCommandMenu;

function OnSelect(int OptionIndex, Vector Location, optional Vector HitNormal)
{
    local DHPlayer PC;
    local DHPlayerReplicationInfo PRI;

    PC = GetPlayerController();

    if (PC == none || OptionIndex < 0 || OptionIndex >= Options.Length)
    {
        return;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    switch (OptionIndex)
    {
        case 0: // Construction
            Interaction.PushMenu("DH_Construction.DHCommandMenu_ConstructionGroups");
            return;
        case 1: // Spotting
            Interaction.PushMenu("DH_Engine.DHCommandMenu_Spotting");
            return;
        default:
            break;
    }

    Interaction.Hide();
}

function bool IsOptionDisabled(int OptionIndex)
{
    local DHPlayer PC;
    local DHGameReplicationInfo GRI;

    PC = GetPlayerController();

    if (PC == none)
    {
        return true;
    }

    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

    switch (OptionIndex)
    {
    case 0: // Construction
        return DHPawn(PC.Pawn) == none || GRI == none || !GRI.bAreConstructionsEnabled;
    default:
        return false;
    }
}

defaultproperties
{
//    NoPlayerInLineOfSight="No player in sights"
    Options(0)=(ActionText="Construction",Material=Texture'DH_InterfaceArt2_tex.construction')
    Options(1)=(ActionText="Spotting",Material=Texture'DH_InterfaceArt2_tex.binoculars')
}
