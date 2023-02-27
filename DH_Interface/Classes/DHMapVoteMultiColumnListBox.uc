//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMapVoteMultiColumnListBox extends MapVoteMultiColumnListBox;

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
    ContextMenu=none
}
