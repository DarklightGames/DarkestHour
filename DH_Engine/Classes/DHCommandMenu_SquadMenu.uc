//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// Menu to display while you are in a squad.
//==============================================================================

class DHCommandMenu_SquadMenu extends DHCommandMenu;

function bool ShouldHideMenu()
{
    local DHPlayer PC;
    local DHPlayerReplicationInfo PRI;

    PC = GetPlayerController();
    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    return PC == none || PC.Pawn == none || PC.Pawn.Health <= 0 || PRI == none || !PRI.IsInSquad();
}

function OnSelect(int OptionIndex, vector Location)
{
    local DHPlayer PC;

    PC = GetPlayerController();

    if (PC == none)
    {
        return;
    }

    switch (OptionIndex)
    {
        case 0: // Leave Squad
            PC.ServerSquadLeave();
        default:
            break;
    }
}

defaultproperties
{
    Options(0)=(ActionText="Leave Squad",Material=Texture'DH_InterfaceArt2_tex.Icons.squad_leave')
    SlotCountOverride=4
}
