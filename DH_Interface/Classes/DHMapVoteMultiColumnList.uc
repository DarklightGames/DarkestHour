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
    local string RawMapName;

    if( VRI == none )
        return;

    // Draw the drag-n-drop outline
    if (bPending && OutlineStyle != None && (bDropSource || bDropTarget) )
    {
        if ( OutlineStyle.Images[MenuState] != None )
        {
            OutlineStyle.Draw(Canvas, MenuState, ClientBounds[0], Y, ClientBounds[2] - ClientBounds[0], ItemHeight);
            if (DropState == DRP_Source && i != DropIndex)
                OutlineStyle.Draw(Canvas, MenuState, Controller.MouseX - MouseOffset[0], Controller.MouseY - MouseOffset[1] + Y - ClientBounds[1], MouseOffset[2] + MouseOffset[0], ItemHeight);
        }
    }

    // Draw the selection border
    if( bSelected )
    {
        SelectedStyle.Draw(Canvas,MenuState, X, Y-2, W, H+2 );
        DrawStyle = SelectedStyle;
    }
    else
        DrawStyle = Style;

    if( !VRI.MapList[MapVoteData[SortData[i].SortItem]].bEnabled )
        MState = MSAT_Disabled;
    else
        MState = MenuState;

    GetCellLeftWidth(0, CellLeft, CellWidth);
    RawMapName = Repl(VRI.MapList[MapVoteData[SortData[i].SortItem]].MapName, "DH-", ""); // Remove DH- prefix
    RawMapName = Repl(RawMapName, ".rom", ""); // Remove .rom if it exists
    RawMapName = Repl(RawMapName, "_", " "); // Remove _ for space
    DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, RawMapName, FontScale);

    GetCellLeftWidth(1, CellLeft, CellWidth);
    DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, string(VRI.MapList[MapVoteData[SortData[i].SortItem]].PlayCount), FontScale);

    GetCellLeftWidth(2, CellLeft, CellWidth);
    DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, string(VRI.MapList[MapVoteData[SortData[i].SortItem]].Sequence), FontScale);
}

defaultproperties
{

}