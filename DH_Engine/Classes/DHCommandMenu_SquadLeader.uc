//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHCommandMenu_SquadLeader extends DHCommandMenu;

function bool OnSelect(DHCommandInteraction Interaction, int Index, vector Location)
{
    local DHPlayer PC;

    if (Interaction == none || Interaction.ViewportOwner == none || Index < 0 || Index >= Options.Length)
    {
        return false;
    }

    PC = DHPlayer(Interaction.ViewportOwner.Actor);

    // TODO: possibly move speech commands out of the menu, since it's not
    // really it's responsbility.

    switch (Index)
    {
        case 0: // Fire
            if (Rand(2) == 0)
            {
                PC.ConsoleCommand("SPEECH ORDER 6");
            }
            else
            {
                PC.ConsoleCommand("SPEECH ALERT 6");
            }

            PC.ServerSquadSignal(SIGNAL_Fire, Location);
            break;
        case 1: // Attack
            PC.ConsoleCommand("SPEECH ORDER 0");
            PC.ServerSquadOrder(ORDER_Attack, Location);
            break;
        case 2: // Defend
            PC.ConsoleCommand("SPEECH ORDER 1");
            PC.ServerSquadOrder(ORDER_Defend, Location);
            break;
        case 3: // Move
            PC.ConsoleCommand("SPEECH ALERT 1");
            PC.ServerSquadSignal(SIGNAL_Move, Location);
            break;
        default:
            break;
    }

    Interaction.Hide();

    return true;
}

defaultproperties
{
    Options(0)=(Text="Fire",Material=Material'DH_InterfaceArt_tex.HUD.squad_signal_fire')
    Options(1)=(Text="Attack",Material=Material'DH_InterfaceArt_tex.HUD.squad_order_attack')
    Options(2)=(Text="Defend",Material=Material'DH_InterfaceArt_tex.HUD.squad_order_defend')
    Options(3)=(Text="Move",Material=Material'DH_InterfaceArt_tex.HUD.squad_signal_move')
}
