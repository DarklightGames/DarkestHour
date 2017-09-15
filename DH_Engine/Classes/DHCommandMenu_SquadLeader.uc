//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHCommandMenu_SquadLeader extends DHCommandMenu;

var localized string NoPlayerInLineOfSight;

function OnSelect(int Index, vector Location)
{
    local DHPlayer PC;
    local DHPawn P;
    local DHPlayerReplicationInfo PRI, OtherPRI;

    PC = GetPlayerController();

    if (PC == none || Index < 0 || Index >= Options.Length)
    {
        return;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    switch (Index)
    {
        case 0: // Rally Point
            PC.ServerSquadSpawnRallyPoint();
            break;
        case 1: // Fire
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
        case 2: // Construction
            Interaction.PushMenu("DH_Engine.DHCommandMenu_Construction");
            return;
        case 3:
            P = DHPawn(MenuObject);

            if (P != none)
            {
                OtherPRI = DHPlayerReplicationInfo(P.PlayerReplicationInfo);

                if (class'DHPlayerReplicationInfo'.static.IsInSameSquad(PRI, OtherPRI))
                {
                    Interaction.PushMenu("DH_Engine.DHCommandMenu_SquadManageMember", MenuObject);
                }
                else
                {
                    Interaction.PushMenu("DH_Engine.DHCommandMenu_SquadManageNonMember", MenuObject);
                }
            }
            return;
        case 4:
            Interaction.PushMenu("DH_Engine.DHCommandMenu_SquadMenu", MenuObject);
            return;
        case 5: // Move
            PC.ConsoleCommand("SPEECH ALERT 1");
            PC.ServerSquadSignal(SIGNAL_Move, Location);
            break;
        default:
            break;
    }

    Interaction.Hide();
}

function GetOptionRenderInfo(int OptionIndex, out OptionRenderInfo ORI)
{
    local DHPawn OtherPawn;
    local DHPlayer PC;

    OtherPawn = DHPawn(MenuObject);
    PC = GetPlayerController();

    super.GetOptionRenderInfo(OptionIndex, ORI);

    switch (OptionIndex)
    {
        case 3: // Player Menu
            if (OtherPawn != none && OtherPawn.PlayerReplicationInfo != none)
            {
                ORI.OptionName = OtherPawn.PlayerReplicationInfo.PlayerName;
            }
            else
            {
                ORI.OptionName = "";
                ORI.InfoText = default.NoPlayerInLineOfSight;
                ORI.InfoColor = class'UColor'.default.Yellow;
            }
        default:
            break;
    }
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
    case 0: // Rally Point
        return DHPawn(PC.Pawn) == none || PC.SquadReplicationInfo == none || !PC.SquadReplicationInfo.bAreRallyPointsEnabled;
    case 2: // Construction
        return DHPawn(PC.Pawn) == none || GRI == none || !GRI.bAreConstructionsEnabled;
    case 3:
        return DHPawn(MenuObject) == none || DHPawn(MenuObject).Health <= 0 || PC.GetTeamNum() != DHPawn(MenuObject).GetTeamNum();
    default:
        return false;
    }
}

defaultproperties
{
    NoPlayerInLineOfSight="No player in sights"
    Options(0)=(ActionText="Create Rally Point",Material=texture'DH_GUI_Tex.DeployMenu.RallyPointDiffuse')
    Options(1)=(ActionText="Fire",Material=texture'DH_InterfaceArt_tex.HUD.squad_signal_fire')
    Options(2)=(ActionText="Construction",Material=texture'DH_InterfaceArt_tex.HUD.supplies')
    Options(3)=(ActionText="No Player ",Material=texture'DH_GUI_tex.DeployMenu.reinforcements')
    Options(4)=(ActionText="Squad",Material=texture'DH_GUI_tex.DeployMenu.squads')
    Options(5)=(ActionText="Move",Material=texture'DH_InterfaceArt_tex.HUD.squad_signal_move')
}

