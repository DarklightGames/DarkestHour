//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
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

function GetOptionText(int OptionIndex, out string ActionText, out string SubjectText, optional out color TextColor)
{
    local DHPawn OtherPawn;

    OtherPawn = DHPawn(MenuObject);

    super.GetOptionText(OptionIndex, ActionText, SubjectText, TextColor);

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
    local DHGameReplicationInfo GRI;

    PC = DHPlayer(Interaction.ViewportOwner.Actor);

    if (PC == none)
    {
        return true;
    }

    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

    switch (OptionIndex)
    {
    case 1: // Rally Point
        return DHPawn(PC.Pawn) == none || PC.SquadReplicationInfo == none || !PC.SquadReplicationInfo.bAreRallyPointsEnabled;
    case 2: // Construction
        return DHPawn(PC.Pawn) == none || GRI == none || !GRI.bAreConstructionsEnabled;
    case 4:
        return DHPawn(MenuObject) == none || DHPawn(MenuObject).Health <= 0 || PC.GetTeamNum() != DHPawn(MenuObject).GetTeamNum();
    default:
        return false;
    }
}

defaultproperties
{
    Options(0)=(ActionText="Fire",Material=Material'DH_InterfaceArt_tex.HUD.squad_signal_fire')
    Options(1)=(ActionText="Create Rally Point",Material=Material'DH_GUI_Tex.DeployMenu.RallyPointDiffuse')
    Options(2)=(ActionText="Construction",Material=Material'DH_InterfaceArt_tex.HUD.supplies',Type=TYPE_Submenu)
    Options(3)=(ActionText="Move",Material=Material'DH_InterfaceArt_tex.HUD.squad_signal_move')
    Options(4)=(ActionText="...",Type=TYPE_Submenu)
}
