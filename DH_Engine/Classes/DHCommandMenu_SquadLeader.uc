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

    switch (Index)
    {
        case 0: // Fire
            PC.ConsoleCommand("SPEECH ALERT 6");
            PC.ServerSquadSignal(SIGNAL_Fire, Location);
            break;
        case 1: // Attack
            PC.ServerSquadOrder(ORDER_Attack, Location);
            break;
        case 2: // Defend
            PC.ServerSquadOrder(ORDER_Defend, Location);
            break;
        case 3: // Move
            PC.ServerSquadSignal(SIGNAL_Move, Location);
            break;
        case 4: // Smoke
            PC.ServerSquadSignal(SIGNAL_Smoke, Location);
            break;
        default:
            break;
    }

    Interaction.Hide();

    return true;
}

defaultproperties
{
    Options(0)=(Text="Fire")
    Options(1)=(Text="Attack")
    Options(2)=(Text="Defend")
    Options(3)=(Text="Move")
    Options(4)=(Text="Smoke")
}


