//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHCommandMenu_SquadLeader extends DHCommandMenu;

function OnSelect(int Index, vector Location)
{
    local DHPlayer PC;

    if (Interaction == none || Interaction.ViewportOwner == none || Index < 0 || Index >= Options.Length)
    {
        return;
    }

    PC = DHPlayer(Interaction.ViewportOwner.Actor);

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
        case 1: // Rally Point
            PC.ServerSquadSpawnRallyPoint();
            break;
        case 2: // Construction
            Interaction.PushMenu("DH_Engine.DHCommandMenu_Construction");
            return;
        case 3: // Move
            PC.ConsoleCommand("SPEECH ALERT 1");
            PC.ServerSquadSignal(SIGNAL_Move, Location);
            break;
        case 4:
            Interaction.PushMenu("DH_Engine.DHCommandMenu_SquadManageMember", MenuObject);
            return;
        default:
            break;
    }

    Interaction.Hide();
}

function GetOptionText(int OptionIndex, out string ActionText, out string SubjectText)
{
    local DHPawn OtherPawn;

    OtherPawn = DHPawn(MenuObject);

    super.GetOptionText(OptionIndex, ActionText, SubjectText);

    switch (OptionIndex)
    {
        case 4:
            if (OtherPawn != none && OtherPawn.PlayerReplicationInfo != none)
            {
                SubjectText = OtherPawn.PlayerReplicationInfo.PlayerName;
            }
        default:
            break;
    }
}

function bool IsOptionDisabled(int OptionIndex)
{
    local DHPlayer PC;

    PC = DHPlayer(Interaction.ViewportOwner.Actor);

    switch (OptionIndex)
    {
    case 1: // Rally Point
        return PC == none || DHPawn(Pc.Pawn) == none || !PC.GetLevelInfo().bAreRallyPointsEnabled;
    case 2: // Construction
        return PC == none || DHPawn(PC.Pawn) == none || !PC.GetLevelInfo().bAreConstructionsEnabled;
    case 4:
        return PC == none || DHPawn(MenuObject) == none || DHPawn(MenuObject).Health <= 0 || PC.GetTeamNum() != DHPawn(MenuObject).GetTeamNum();
    default:
        return false;
    }
}

defaultproperties
{
    Options(0)=(ActionText="Fire",Material=Material'DH_InterfaceArt_tex.HUD.squad_signal_fire')
    Options(1)=(ActionText="Create Rally Point",Material=Material'DH_GUI_Tex.DeployMenu.RallyPointDiffuse')
    Options(2)=(ActionText="Construction",Material=Material'DH_InterfaceArt_tex.HUD.squad_order_defend',Type=TYPE_Submenu)
    Options(3)=(ActionText="Move",Material=Material'DH_InterfaceArt_tex.HUD.squad_signal_move')
    Options(4)=(ActionText="...",Type=TYPE_Submenu)
}
