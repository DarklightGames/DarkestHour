//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHCommandMenu_Patron extends DHCommandMenu;

function OnSelect(int Index, vector Location)
{
    local DHPlayer PC;
    local DHPlayerReplicationInfo PRI;

    PC = GetPlayerController();

    if (PC == none || Index < 0 || Index >= Options.Length)
    {
        return;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    switch (Index)
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
        case 1: // Spotting
            return DHPawn(PC.Pawn) == none || GRI == none;
        default:
            return false;
    }
}

defaultproperties
{
    Options(0)=(ActionText="Construction",Material=Texture'DH_InterfaceArt2_tex.Icons.construction')
    Options(1)=(ActionText="Spotting",Material=Texture'DH_InterfaceArt2_tex.Icons.binoculars')
}
