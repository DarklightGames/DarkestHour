//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHCommandMenu_SquadLeader extends DHCommandMenu;

var localized string   InEnemyTerritory;

function bool IsPlayerInSight()
{
    local DHPlayer PC;
    local DHPawn P;

    PC = GetPlayerController();
    P = DHPawn(MenuObject);

    return PC != none && P != none && P != PC.Pawn && P.Health > 0 && PC.GetTeamNum() == P.GetTeamNum();
}

function Setup()
{
    super.Setup();
}

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
            // TODO: make signals classes have a bit of logic that gets run when sent!
            if (Rand(2) == 0)
            {
                PC.ConsoleCommand("SPEECH ORDER 6");
            }
            else
            {
                PC.ConsoleCommand("SPEECH ALERT 6");
            }

            PC.ServerSignal(class'DHSignal_Fire', Location);  // TODO: project off of the location a bit
            break;
        case 2:
            Interaction.PushMenu("DH_Construction.DHCommandMenu_ConstructionGroups");
            return;
        case 3:
            P = DHPawn(MenuObject);

            if (P != none && P.PlayerReplicationInfo != none)
            {
                // Player Menu
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
            Interaction.PushMenu("DH_Engine.DHCommandMenu_Spotting", MenuObject);
            return;
        case 5: // Move
            PC.ConsoleCommand("SPEECH ALERT 1");
            PC.ServerSignal(class'DHSignal_Move', Location);
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
    local DHGameReplicationInfo GRI;

    OtherPawn = DHPawn(MenuObject);
    PC = GetPlayerController();

    if (PC != none)
    {
        GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    }

    super.GetOptionRenderInfo(OptionIndex, ORI);

    switch (OptionIndex)
    {
        case 0: // Rally Point
            if (PC.SquadReplicationInfo != none &&
                PC.SquadReplicationInfo.bAreRallyPointsEnabled &&
                GRI != none &&
                GRI.IsInDangerZone(PC.Pawn.Location.X, PC.Pawn.Location.Y, PC.GetTeamNum()))
            {
                ORI.InfoText[0] = default.InEnemyTerritory;

                if (PC.SquadReplicationInfo.bAllowRallyPointsBehindEnemyLines)
                {
                    ORI.InfoColor = class'UColor'.default.Yellow;
                }
                else
                {
                    ORI.InfoColor = class'UColor'.default.Red;
                }
            }
            break;
        case 3: // Player Menu
            if (OtherPawn != none && OtherPawn.PlayerReplicationInfo != none)
            {
                ORI.OptionName = OtherPawn.PlayerReplicationInfo.PlayerName;
            }
            break;
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
    case 3: // Player
        return DHPawn(MenuObject) == none || DHPawn(MenuObject) == PC.Pawn || DHPawn(MenuObject).Health <= 0 || PC.GetTeamNum() != DHPawn(MenuObject).GetTeamNum();
    default:
        return false;
    }
}

defaultproperties
{
    InEnemyTerritory="In enemy territory"
    Options(0)=(ActionText="Create Rally Point",Material=Texture'DH_InterfaceArt2_tex.Icons.rally_point')
    Options(1)=(ActionText="Fire",Material=Texture'DH_InterfaceArt2_tex.Icons.fire')
    Options(2)=(ActionText="Construction",Material=Texture'DH_InterfaceArt2_tex.Icons.construction')
    Options(3)=(ActionText="No Player ",Material=Texture'DH_InterfaceArt2_tex.Icons.infantry')
    Options(4)=(ActionText="Spotting",Material=Texture'DH_InterfaceArt2_tex.Icons.binoculars')
    Options(5)=(ActionText="Move",Material=Texture'DH_InterfaceArt2_tex.Icons.move')
}
