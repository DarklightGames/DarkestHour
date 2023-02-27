//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMapVoteCountMultiColumnList extends MapVoteCountMultiColumnList;

var(Style) string               RedListStyleName; // name of the style to use for when current player is out of recommended player range
var(Style) noexport GUIStyles   RedListStyle;

var DHMapDatabase               MapDatabase;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local DHPlayer PC;

    super.InitComponent(MyController, MyOwner);

    if (RedListStyleName != "" && RedListStyle == none)
    {
        RedListStyle = MyController.GetStyle(RedListStyleName,FontScale);
    }

    // Get a reference to the map database.
    PC = DHPlayer(MyController.ViewportOwner.Actor);

    if (PC != none)
    {
        PC.InitializeMapDatabase();

        MapDatabase = PC.MapDatabase;
    }
}

function DrawItem(Canvas Canvas, int i, float X, float Y, float W, float H, bool bSelected, bool bPending)
{
    local DHGameReplicationInfo     GRI;
    local GUIStyles                 DrawStyle, OldDrawStyle;
    local float                     CellLeft, CellWidth;
    local int                       Min, Max;
    local DHMapDatabase.SMapInfo    MI;
    local string                    MapName;

    GRI = DHGameReplicationInfo(PlayerOwner().GameReplicationInfo);

    if (VRI == none || GRI == none)
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

    MapName = VRI.MapList[VRI.MapVoteCount[SortData[i].SortItem].MapIndex].MapName;

    // Map Name
    GetCellLeftWidth(0, CellLeft, CellWidth);
    DrawStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Left, class'DHMapDatabase'.static.GetHumanReadableMapName(MapName), FontScale);

    // Vote Count
    GetCellLeftWidth(1, CellLeft, CellWidth);
    DrawStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Left, string(VRI.MapVoteCount[SortData[i].SortItem].VoteCount), FontScale);

    // Map Size
    if (MapDatabase.GetMapInfo(MapName, MI))
    {
        GetCellLeftWidth(2, CellLeft, CellWidth);
        OldDrawStyle = DrawStyle;

        class'DHMapDatabase'.static.GetMapSizePlayerCountRange(MI.Size, Min, Max);

        // Do a check if the current player count is in bounds of recommended range
        if (!GRI.IsPlayerCountInRange(Min, Max))
        {
            DrawStyle = RedListStyle;
        }

        DrawStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Center, class'DHMapDatabase'.static.GetMapSizeString(MI.Size), FontScale);
        DrawStyle = OldDrawStyle;
    }
}

function string GetSortString(int i)
{
    local DHMapDatabase.SMapInfo MI;
    local bool bHasMapInfo;

    if (MapDatabase != none)
    {
        bHasMapInfo = MapDatabase.GetMapInfo(VRI.MapList[VRI.MapVoteCount[i].MapIndex].MapName, MI);
    }

    switch (SortColumn)
    {
        case 0: // Map name
            return Locs(class'DHMapDatabase'.static.GetHumanReadableMapName(VRI.MapList[VRI.MapVoteCount[i].MapIndex].MapName));
        case 1: // Votes
            return class'UString'.static.ZFill(string(VRI.MapVoteCount[i].VoteCount), 4);
        case 2: // Size
            if (bHasMapInfo)
            {
                return string(int(MI.Size));
            }
        default:
            break;
    }

    return "";
}

defaultproperties
{
    ColumnHeadings(0)="Nominated Maps"
    ColumnHeadings(1)="Vote Weight"
    ColumnHeadings(2)="Player Range"
    ColumnHeadingHints(0)="The map's name."
    ColumnHeadingHints(1)="The combined voting power of players for the map."
    ColumnHeadingHints(2)="Recommended players for the map."
    InitColumnPerc(0)=0.4
    InitColumnPerc(1)=0.3
    InitColumnPerc(2)=0.3
    SortColumn=1
    RedListStyleName="DHListRed"
}
