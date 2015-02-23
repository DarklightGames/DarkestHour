//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHMapVoteCountMultiColumnList extends MapVoteCountMultiColumnList;

function DrawItem(Canvas Canvas, int i, float X, float Y, float W, float H, bool bSelected, bool bPending)
{
    local float CellLeft, CellWidth;
    local GUIStyles DrawStyle;

    if (VRI == none)
    {
        return;
    }

    // Draw the selection border
    if (bSelected)
    {
        SelectedStyle.Draw(Canvas,MenuState, X, Y - 2, W, H + 2);
        DrawStyle = SelectedStyle;
    }
    else
    {
        DrawStyle = Style;
    }

    GetCellLeftWidth(0, CellLeft, CellWidth);

    DrawStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Left, VRI.MapList[VRI.MapVoteCount[SortData[i].SortItem].MapIndex].MapName, FontScale);

    GetCellLeftWidth(1, CellLeft, CellWidth);

    DrawStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Left, string(VRI.MapVoteCount[SortData[i].SortItem].VoteCount), FontScale);
}

function string GetSortString(int i)
{
    local string ColumnData[5];

    ColumnData[0] = Left(Caps(VRI.MapList[VRI.MapVoteCount[i].MapIndex].MapName), 20);
    ColumnData[1] = Right("0000" $ VRI.MapVoteCount[i].VoteCount, 4);

    return ColumnData[SortColumn] $ ColumnData[PrevSortColumn];
}

defaultproperties
{
    ColumnHeadings(0)="MapName"
    ColumnHeadings(1)="Votes"
    ColumnHeadings(2)="none"
    InitColumnPerc(0)=0.7
    InitColumnPerc(1)=0.3
    InitColumnPerc(2)=0.0
    ColumnHeadingHints(0)="Map Name"
    ColumnHeadingHints(1)="Number of votes registered for this map."
    ColumnHeadingHints(2)="none"
    SortColumn=1
}
