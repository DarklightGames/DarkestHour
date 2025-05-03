//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHCommandMenu_SquadLogisticCrew extends DHCommandMenu;

function OnSelect(int OptionIndex, vector Location, optional vector HitNormal)
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
    Options(0)=(ActionText="Construction",Material=Texture'DH_InterfaceArt2_tex.Icons.construction')
}
