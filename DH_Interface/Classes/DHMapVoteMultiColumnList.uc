//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHMapVoteMultiColumnList extends MapVoteMultiColumnList;

var(Style) string                RedListStyleName; // name of the style to use for when current player is out of recommended player range
var(Style) noexport GUIStyles    RedListStyle;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.InitComponent(MyController,MyOwner);

    if (RedListStyleName != "" && RedListStyle == none)
    {
        RedListStyle = MyController.GetStyle(RedListStyleName, FontScale);
    }
}

// Override to remove any prefix from lists and handle new features
function DrawItem(Canvas Canvas, int i, float X, float Y, float W, float H, bool bSelected, bool bPending)
{
    local float CellLeft, CellWidth;
    local eMenuState MState;
    local GUIStyles DrawStyle, OldDrawTyle;
    local array<string> Parts;
    local DHGameReplicationInfo GRI;
    local int Min, Max;
    local string PlayerRangeString;

    GRI = DHGameReplicationInfo(PlayerOwner().GameReplicationInfo);

    if (VRI == none || GRI == none)
    {
        return;
    }

    // Draw the drag-n-drop outline
    if (bPending && OutlineStyle != none && (bDropSource || bDropTarget))
    {
        if (OutlineStyle.Images[MenuState] != none)
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
        SelectedStyle.Draw(Canvas, MenuState, X, Y-2, W, H + 2);
        DrawStyle = SelectedStyle;
    }
    else
    {
        DrawStyle = Style;
    }

    // Draw disabled state
    if (!VRI.MapList[MapVoteData[SortData[i].SortItem]].bEnabled)
    {
        MState = MSAT_Disabled;
    }
    else
    {
        MState = MenuState;
    }

    // Split the mapname string, which may be consolitated with other variables
    Split(VRI.MapList[MapVoteData[SortData[i].SortItem]].MapName, ";", Parts);

    // Begin Drawing!
    // Map Name
    GetCellLeftWidth(0, CellLeft, CellWidth);
    DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, class'DHMapList'.static.GetPrettyName(Parts[0]), FontScale);

    // Source
    GetCellLeftWidth(1, CellLeft, CellWidth);
    DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, class'DHMapList'.static.GetMapSource(Parts[0]), FontScale);

    // Type
    if (Parts.Length >= 2)
    {
        GetCellLeftWidth(2, CellLeft, CellWidth);
        DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, Parts[1], FontScale);
    }

    // Player Range
    if (Parts.Length >= 4)
    {
        GetCellLeftWidth(3, CellLeft, CellWidth);
        OldDrawTyle = DrawStyle;
        Min = int(Parts[2]);
        Max = int(Parts[3]);

        if (Min > 0 && Max >= GRI.MaxPlayers)
        {
            if (Min >= GRI.MaxPlayers)
            {
                PlayerRangeString = "(" $ Min $ "+" $ ")";
            }
            else if (Max > GRI.MaxPlayers)
            {
                PlayerRangeString = "(" $ Min $ "-" $ GRI.MaxPlayers $ ")";
            }
            else
            {
                PlayerRangeString = "(" $ Min $ "-" $ Max $ ")";
            }

            // Do a check if the current player count is in bounds of recommended range
            if ((GRI.PRIArray.Length < Min || GRI.PRIArray.Length > Max) && MenuState != MSAT_Disabled)
            {
                DrawStyle = RedListStyle;
            }

            DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Center, PlayerRangeString, FontScale);
            DrawStyle = OldDrawTyle;
        }
    }

    // Quality Control
    if (Parts.Length >= 5)
    {
        GetCellLeftWidth(4, CellLeft, CellWidth);

        if (Parts[4] ~= "Failed" && MState != MSAT_Disabled)
        {
            OldDrawTyle = DrawStyle;
            DrawStyle = RedListStyle;

            DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, Parts[4], FontScale);

            DrawStyle = OldDrawTyle;
        }
        else
        {
            DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, Parts[4], FontScale);
        }
    }
    else
    {
        GetCellLeftWidth(4, CellLeft, CellWidth);
        DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, "Pending", FontScale);
    }

    // Author
    if (Parts.Length >= 6)
    {
        GetCellLeftWidth(5, CellLeft, CellWidth);
        DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, Parts[5], FontScale);
    }
}

// Theel: will need a way to sort stuff
function string GetSortString(int i)
{
    local string ColumnData[6];

    ColumnData[0] = left(Caps(VRI.MapList[MapVoteData[i]].MapName),20);
    ColumnData[1] = left(Caps(VRI.MapList[MapVoteData[i]].MapName),20);
    ColumnData[2] = left(Caps(VRI.MapList[MapVoteData[i]].MapName),20);
    ColumnData[3] = left(Caps(VRI.MapList[MapVoteData[i]].MapName),20);
    ColumnData[4] = left(Caps(VRI.MapList[MapVoteData[i]].MapName),20);
    ColumnData[5] = left(Caps(VRI.MapList[MapVoteData[i]].MapName),20);

    return ColumnData[SortColumn] $ ColumnData[PrevSortColumn];
}

defaultproperties
{
    // Map Name | Source | Type | Player Range | Quality Control | Author
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

    RedListStyleName="DHListRed"
}
