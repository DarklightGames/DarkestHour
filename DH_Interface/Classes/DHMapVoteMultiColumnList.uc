//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMapVoteMultiColumnList extends MapVoteMultiColumnList;

// Override to remove any prefix from lists
function DrawItem(Canvas Canvas, int i, float X, float Y, float W, float H, bool bSelected, bool bPending)
{
    local float CellLeft, CellWidth;
    local eMenuState MState;
    local GUIStyles DrawStyle;
    local array<string> Parts;

    if (VRI == none)
        return;

    // Draw the drag-n-drop outline
    if (bPending && OutlineStyle != None && (bDropSource || bDropTarget))
    {
        if (OutlineStyle.Images[MenuState] != None)
        {
            OutlineStyle.Draw(Canvas, MenuState, ClientBounds[0], Y, ClientBounds[2] - ClientBounds[0], ItemHeight);
            if (DropState == DRP_Source && i != DropIndex)
            {
                OutlineStyle.Draw(Canvas, MenuState, Controller.MouseX - MouseOffset[0], Controller.MouseY - MouseOffset[1] + Y - ClientBounds[1], MouseOffset[2] + MouseOffset[0], ItemHeight);
            }
        }
    }

    // Draw the selection border
    if (bSelected)
    {
        SelectedStyle.Draw(Canvas,MenuState, X, Y-2, W, H+2 );
        DrawStyle = SelectedStyle;
    }
    else
    {
        DrawStyle = Style;
    }

    if (!VRI.MapList[MapVoteData[SortData[i].SortItem]].bEnabled)
    {
        MState = MSAT_Disabled;
    }
    else
    {
        MState = MenuState;
    }

    Split(VRI.MapList[MapVoteData[SortData[i].SortItem]].MapName, ";", Parts);

    GetCellLeftWidth(0, CellLeft, CellWidth);
    DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, Parts[0], FontScale);

    GetCellLeftWidth(1, CellLeft, CellWidth);
    DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, Parts[1], FontScale);

    GetCellLeftWidth(2, CellLeft, CellWidth);
    DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, Parts[2], FontScale);

    GetCellLeftWidth(3, CellLeft, CellWidth);
    DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Center, Parts[3], FontScale);

    GetCellLeftWidth(4, CellLeft, CellWidth);
    DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, Parts[4], FontScale);

    GetCellLeftWidth(5, CellLeft, CellWidth);
    DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, Parts[5], FontScale);
}

//will need a way to sort stuff
function string GetSortString( int i )
{
    local string ColumnData[5];

    ColumnData[0] = left(Caps(VRI.MapList[MapVoteData[i]].MapName),20);
    ColumnData[1] = right("000000" $ VRI.MapList[MapVoteData[i]].PlayCount,6);
    ColumnData[2] = right("000000" $ VRI.MapList[MapVoteData[i]].Sequence,6);
    ColumnData[3] = right("000000" $ VRI.MapList[MapVoteData[i]].Sequence,6);
    ColumnData[4] = right("000000" $ VRI.MapList[MapVoteData[i]].Sequence,6);
    ColumnData[5] = right("000000" $ VRI.MapList[MapVoteData[i]].Sequence,6);

    return ColumnData[SortColumn] $ ColumnData[PrevSortColumn];
}

defaultproperties
{
    //Map Name | Source | Type | Player Range | Quality Control | Author
    ColumnHeadings(0)="Map Name"
    ColumnHeadings(1)="Source"
    ColumnHeadings(2)="Type"
    ColumnHeadings(3)="Player Range"
    ColumnHeadings(4)="Quality Control"
    ColumnHeadings(5)="Author"

    InitColumnPerc(0)=0.2
    InitColumnPerc(1)=0.15
    InitColumnPerc(2)=0.15
    InitColumnPerc(3)=0.15
    InitColumnPerc(4)=0.2
    InitColumnPerc(5)=0.15

    ColumnHeadingHints(0)="The map's name."
    ColumnHeadingHints(1)="Current domain of the level, community, legacy, or official."
    ColumnHeadingHints(2)="What type of game or battle for the map."
    ColumnHeadingHints(3)="Recommended players for the map."
    ColumnHeadingHints(4)="Whether or not the level has passed official quality control."
    ColumnHeadingHints(5)="The map's creator(s)."
}