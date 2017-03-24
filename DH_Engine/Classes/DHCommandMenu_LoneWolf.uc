//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHCommandMenu_LoneWolf extends DHCommandMenu;

function OnSelect(int OptionIndex, vector Location)
{
    local DHPlayer PC;

    if (Interaction == none || Interaction.ViewportOwner == none || Interaction.ViewportOwner.Actor == none)
    {
        return;
    }

    PC = DHPlayer(Interaction.ViewportOwner.Actor);

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

    if (Interaction == none || Interaction.ViewportOwner == none || Interaction.ViewportOwner.Actor == none)
    {
        return true;
    }

    PC = DHPlayer(Interaction.ViewportOwner.Actor);

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
    // TODO: hide if no longer in a squad!
    local DHPlayerReplicationInfo PRI;

    if (Interaction == none || Interaction.ViewportOwner == none || Interaction.ViewportOwner.Actor == none)
    {
        return true;
    }

    PRI = DHPlayerReplicationInfo(Interaction.ViewportOwner.Actor.PlayerReplicationInfo);

    return PRI == none || PRI.IsInSquad();
}

defaultproperties
{
    Options(0)=(ActionText="Auto-Join Squad")
    Options(1)=(ActionText="Create Squad")
}
