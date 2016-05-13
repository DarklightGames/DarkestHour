//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHMapVoteCountMultiColumnList extends MapVoteCountMultiColumnList;

var(Style) string                RedListStyleName; // Name of the style to use for when current player is out of recommended player range
var(Style) noexport GUIStyles    RedListStyle;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.InitComponent(MyController,MyOwner);

    if (RedListStyleName != "" && RedListStyle == None)
        RedListStyle = MyController.GetStyle(RedListStyleName,FontScale);
}

function DrawItem(Canvas Canvas, int i, float X, float Y, float W, float H, bool bSelected, bool bPending)
{
    local float CellLeft, CellWidth;
    local GUIStyles DrawStyle, OldDrawTyle;
    local array<string> Parts;

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

    // Split the mapname string, which may be consolitated with other variables
    Split(VRI.MapList[VRI.MapVoteCount[SortData[i].SortItem].MapIndex].MapName, ";", Parts);

    // Map Name
    GetCellLeftWidth(0, CellLeft, CellWidth);
    DrawStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Left, class'DHMapList'.static.GetPrettyName(Parts[0]), FontScale);

    // Vote Count
    GetCellLeftWidth(1, CellLeft, CellWidth);
    DrawStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Left, string(VRI.MapVoteCount[SortData[i].SortItem].VoteCount), FontScale);

    // Player Range
    if (Parts.Length >= 4)
    {
        GetCellLeftWidth(2, CellLeft, CellWidth);

        // Do a check if the current player count is in bounds of recommended range
        if ((DHGameReplicationInfo(PlayerOwner().GameReplicationInfo).PRIArray.Length < int(Parts[2]) ||
            DHGameReplicationInfo(PlayerOwner().GameReplicationInfo).PRIArray.Length > int(Parts[3])) &&
            MenuState != MSAT_Disabled)
        {
            OldDrawTyle = DrawStyle;
            DrawStyle = RedListStyle;

            DrawStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Center, Parts[2] $ "-" $ Parts[3], FontScale);

            DrawStyle = OldDrawTyle;
        }
        else
        {
            DrawStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Center, Parts[2] $ "-" $ Parts[3], FontScale);
        }
    }

    // Quality Control
    if (Parts.Length >= 5)
    {
        GetCellLeftWidth(3, CellLeft, CellWidth);

        if (Parts[4] ~= "Failed" && MenuState != MSAT_Disabled)
        {
            OldDrawTyle = DrawStyle;
            DrawStyle = RedListStyle;

            DrawStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Left, Parts[4], FontScale);

            DrawStyle = OldDrawTyle;
        }
        else
        {
            DrawStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Left, Parts[4], FontScale);
        }
    }
    else
    {
        GetCellLeftWidth(3, CellLeft, CellWidth);
        DrawStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Left, "Pending", FontScale);
    }
}

function string GetSortString(int i)
{
    local string ColumnData[5];

    ColumnData[0] = Left(Caps(VRI.MapList[VRI.MapVoteCount[i].MapIndex].MapName), 20);
    ColumnData[1] = Right("0000" $ VRI.MapVoteCount[i].VoteCount, 4);
    ColumnData[2] = Right("0000" $ VRI.MapVoteCount[i].VoteCount, 4);
    ColumnData[3] = Right("0000" $ VRI.MapVoteCount[i].VoteCount, 4);

    return ColumnData[SortColumn] $ ColumnData[PrevSortColumn];
}

defaultproperties
{
    ColumnHeadings(0)="Nominated Maps"
    ColumnHeadings(1)="Votes"
    ColumnHeadings(2)="Player Range"
    ColumnHeadings(3)="Quality Control"
    InitColumnPerc(0)=0.3
    InitColumnPerc(1)=0.2
    InitColumnPerc(2)=0.2
    InitColumnPerc(3)=0.3
    ColumnHeadingHints(0)="The map's name."
    ColumnHeadingHints(1)="Number of votes registered for this map."
    ColumnHeadingHints(2)="Recommended players for the map."
    ColumnHeadingHints(3)="Whether or not the level has passed official quality control."
    SortColumn=1
    RedListStyleName="DHListRed"
}
