//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHCommandMenu_LoneWolf extends DHCommandMenu;

var localized string AutoJoinSquadDisabledText;

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
        case 0:
            PC.ServerSquadJoinAuto();
            break;
        case 1:
            PC.ServerSquadCreate();
            break;
    }

    Interaction.Hide();
}

function bool IsOptionDisabled(int OptionIndex)
{
    local DHPlayer PC;

    PC = GetPlayerController();

    switch (OptionIndex)
    {
        case 0:
            return PC == none || PC.SquadReplicationInfo == none || !PC.SquadReplicationInfo.IsAnySquadJoinable(PC.GetTeamNum());
        default:
            break;
    }

    return false;
}

function bool ShouldHideMenu()
{
    local DHPlayerReplicationInfo PRI;

    if (Interaction == none || Interaction.ViewportOwner == none || Interaction.ViewportOwner.Actor == none)
    {
        return true;
    }

    PRI = DHPlayerReplicationInfo(Interaction.ViewportOwner.Actor.PlayerReplicationInfo);

    return PRI == none || PRI.IsInSquad();
}

function GetOptionRenderInfo(int OptionIndex, out OptionRenderInfo ORI)
{
    super.GetOptionRenderInfo(OptionIndex, ORI);

    switch (OptionIndex)
    {
        case 0: // Auto-Join Squad
            if (IsOptionDisabled(OptionIndex))
            {
                ORI.InfoText[0] = default.AutoJoinSquadDisabledText;
                ORI.InfoColor = class'UColor'.default.Red;
            }
            break;
        default:
            break;
    }
}

defaultproperties
{
    AutoJoinSquadDisabledText="No eligible squads"
    Options(0)=(ActionText="Auto-Join Squad",Material=Texture'DH_InterfaceArt2_tex.Icons.squad')
    Options(1)=(ActionText="Create Squad",Material=Texture'DH_InterfaceArt2_tex.Icons.squad_leader')
}

