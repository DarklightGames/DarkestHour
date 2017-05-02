//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHMapVoteCountMultiColumnList extends MapVoteCountMultiColumnList;

var(Style) string                RedListStyleName; // Name of the style to use for when current player is out of recommended player range
var(Style) noexport GUIStyles    RedListStyle;

var DHVotingReplicationInfo      DHMVRI;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.InitComponent(MyController,MyOwner);

    if (RedListStyleName != "" && RedListStyle == none)
    {
        RedListStyle = MyController.GetStyle(RedListStyleName,FontScale);
    }
}

function LoadList(VotingReplicationInfo LoadVRI)
{
    local int i;

    VRI = LoadVRI;
    DHMVRI = DHVotingReplicationInfo(LoadVRI);

    for( i=0; i<VRI.MapVoteCount.Length; i++)
        AddedItem();

    OnDrawItem = DrawItem;
}

function DrawItem(Canvas Canvas, int i, float X, float Y, float W, float H, bool bSelected, bool bPending)
{
    local float                     CellLeft, CellWidth;
    local GUIStyles                 DrawStyle, OldDrawTyle;
    local DHGameReplicationInfo     GRI;
    local int                       Min, Max, CalcIndex;
    local string                    PlayerRangeString, MapNameString;
    local JSONObject                MapObject;

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

    CalcIndex = VRI.MapVoteCount[SortData[i].SortItem].MapIndex;

    // Set the MapObject from DHVotingReplicationInfo
    if (CalcIndex > 0 && CalcIndex < DHMVRI.MapListObjects.Length)
    {
        MapObject = DHMVRI.MapListObjects[CalcIndex];
    }

    // Set the local MapNameString as it is reused
    if (MapObject != none && MapObject.Get("MapName") != none)
    {
        MapNameString = MapObject.Get("MapName").AsString();
    }
    else
    {
        MapNameString = VRI.MapList[VRI.MapVoteCount[SortData[i].SortItem].MapIndex].MapName;
    }

    // Map Name
    GetCellLeftWidth(0, CellLeft, CellWidth);
    DrawStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Left, class'DHMapList'.static.GetPrettyName(MapNameString), FontScale);

    // Vote Count
    GetCellLeftWidth(1, CellLeft, CellWidth);
    DrawStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Left, string(VRI.MapVoteCount[SortData[i].SortItem].VoteCount), FontScale);

    // Player Range
    if (MapObject != none && MapObject.Get("MinPlayers") != none && MapObject.Get("MaxPlayers") != none)
    {
        GetCellLeftWidth(2, CellLeft, CellWidth);
        OldDrawTyle = DrawStyle;
        Min = MapObject.Get("MinPlayers").AsInteger();
        Max = MapObject.Get("MaxPlayers").AsInteger();

        if (Min > 0 || Max <= GRI.MaxPlayers)
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
            if (GRI.PRIArray.Length < Min || GRI.PRIArray.Length > Max)
            {
                DrawStyle = RedListStyle;
            }

            DrawStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Center, PlayerRangeString, FontScale);
            DrawStyle = OldDrawTyle;
        }
    }
}

function string GetSortString(int i)
{
    local JSONObject    MapObject;
    local string        MapNameString;

    // Set the MapObject from DHVotingReplicationInfo
    MapObject = DHMVRI.MapListObjects[VRI.MapVoteCount[i].MapIndex];

    if (MapObject != none && MapObject.Get("MapName") != none)
    {
        MapNameString = MapObject.Get("MapName").AsString();
    }
    else
    {
        MapNameString = VRI.MapList[VRI.MapVoteCount[i].MapIndex].MapName;
    }

    switch (SortColumn)
    {
        case 0: // Map name
            return Caps(class'DHMapList'.static.GetPrettyName(MapNameString));
        case 1: // Votes
            return class'UString'.static.ZFill(string(VRI.MapVoteCount[i].VoteCount), 4);
        default:
            break;
    }

    return "";
}

defaultproperties
{
    ColumnHeadings(0)="Nominated Maps"
    ColumnHeadings(1)="Votes"
    ColumnHeadings(2)="Player Range"
    InitColumnPerc(0)=0.4
    InitColumnPerc(1)=0.3
    InitColumnPerc(2)=0.3
    ColumnHeadingHints(0)="The map's name."
    ColumnHeadingHints(1)="Number of votes registered for this map."
    ColumnHeadingHints(2)="Recommended players for the map."
    SortColumn=1
    RedListStyleName="DHListRed"
}
