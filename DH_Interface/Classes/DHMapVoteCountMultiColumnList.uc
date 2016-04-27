//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMapVoteCountMultiColumnList extends MapVoteCountMultiColumnList;

function DrawItem(Canvas Canvas, int i, float X, float Y, float W, float H, bool bSelected, bool bPending)
{
    local float CellLeft, CellWidth;
    local GUIStyles DrawStyle;
    local string RawMapName;

    if (VRI == none)
    {
        return;
    }

    // Theel: Stop levels from being drawn that failed quality assurance

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
    RawMapName = Repl(VRI.MapList[VRI.MapVoteCount[SortData[i].SortItem].MapIndex].MapName, "DH-", ""); // Remove DH- prefix
    RawMapName = Repl(RawMapName, ".rom", ""); // Remove .rom if it exists
    RawMapName = Repl(RawMapName, "_", " "); // Remove _ for space
    DrawStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Left, RawMapName, FontScale);

    GetCellLeftWidth(1, CellLeft, CellWidth);
    DrawStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Left, string(VRI.MapVoteCount[SortData[i].SortItem].VoteCount), FontScale);

    // Theel: Make this text red if the map's recommended players do not encompass the current # of players
    GetCellLeftWidth(2, CellLeft, CellWidth);
    DrawStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Left, "Test", FontScale);
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
    ColumnHeadings(2)="Player Range"
    InitColumnPerc(0)=0.3
    InitColumnPerc(1)=0.5
    InitColumnPerc(2)=0.2
    ColumnHeadingHints(0)="The map's name."
    ColumnHeadingHints(1)="Number of votes registered for this map."
    ColumnHeadingHints(2)="Recommended players for the map."
    SortColumn=1
}
