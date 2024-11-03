//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMapVoteMultiColumnListBox extends MapVoteMultiColumnListBox;

function InternalOnClick(GUIContextMenu Sender, int Index)
{
	local string MapName;

    if (Sender == none || NotifyContextSelect(Sender, Index))
    {
        return;
    }

    if (Index == 0 && DHMapVotingPage(MenuOwner) != none)
    {
        DHMapVotingPage(MenuOwner).ForceMapVote(self);
    }
}

function bool InternalOnOpen(GUIContextMenu Sender)
{
    local DHPlayer PC;
    local DHPlayerReplicationInfo PRI;

    PC = DHPlayer(PlayerOwner());

    if (PC == none)
    {
        return false;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    return PRI != none && PRI.IsAdmin();
}

function LoadList(VotingReplicationInfo LoadVRI)
{
    local int i, g;

    ListArray.Length = LoadVRI.GameConfig.Length;

    for (i = 0; i < LoadVRI.GameConfig.Length; ++i)
    {
        ListArray[i] = new class'DHMapVoteMultiColumnList';
        ListArray[i].LoadList(LoadVRI, i);

        DHMapVoteMultiColumnList(ListArray[i]).GameTypeIndex = i;

        if (LoadVRI.GameConfig[i].GameClass ~= PlayerOwner().GameReplicationInfo.GameClass)
        {
            g = i;
        }
    }

    ChangeGameType(g);
}

defaultproperties
{
    Begin Object Class=GUIContextMenu Name=AdminMapContextMenu
		ContextItems(0)="ADMIN: Force map to this"
        OnSelect=InternalOnClick
        OnOpen=InternalOnOpen
    End Object

    ContextMenu=AdminMapContextMenu
}
