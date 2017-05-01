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

// Override to support json objects
function LoadList(VotingReplicationInfo LoadVRI, int GameTypeIndex)
{
    local int m,p,l;
    local array<string> PrefixList;
    local JSONObject MapObject;
    local string MapNameString;

    VRI = LoadVRI;

    Split(VRI.GameConfig[GameTypeIndex].Prefix, ",", PrefixList);

    for (m = 0; m < VRI.MapList.Length; m++)
    {
        for (p = 0; p < PreFixList.Length; p++)
        {
            // Parse the JSON object
            MapObject = (new class'JSONParser').ParseObject(VRI.MapList[m].MapName);

            if (MapObject != none && MapObject.Get("MapName").AsString() != "")
            {
                MapNameString = MapObject.Get("MapName").AsString();
            }
            else
            {
                MapNameString = VRI.MapList[m].MapName;
            }

            if (left(MapNameString, len(PrefixList[p])) ~= PrefixList[p])
            {
                l = MapVoteData.length;
                MapVoteData.insert(l,1);
                MapVoteData[l] = m;
                AddedItem();
                break;
            }
        }
    }

    OnDrawItem = DrawItem;
}

// Override to remove any prefix from lists and handle new features
function DrawItem(Canvas Canvas, int i, float X, float Y, float W, float H, bool bSelected, bool bPending)
{
    local float                     CellLeft, CellWidth;
    local eMenuState                MState;
    local GUIStyles                 DrawStyle, OldDrawTyle;
    local DHGameReplicationInfo     GRI;
    local int                       Min, Max;
    local string                    PlayerRangeString, MapNameString;
    local JSONObject                MapObject;

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

    // Parse the JSON object
    // -----------------------------------
    MapObject = (new class'JSONParser').ParseObject(VRI.MapList[MapVoteData[SortData[i].SortItem]].MapName);

    // Set the local MapNameString as it is reused
    if (MapObject != none && MapObject.Get("MapName").AsString() != "")
    {
        MapNameString = MapObject.Get("MapName").AsString();
    }
    else
    {
        MapNameString = VRI.MapList[MapVoteData[SortData[i].SortItem]].MapName;
    }

    // Map Name
    // -----------------------------------
    GetCellLeftWidth(0, CellLeft, CellWidth);
    DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, class'DHMapList'.static.GetPrettyName(MapNameString), FontScale);

    // Source
    // -----------------------------------
    GetCellLeftWidth(1, CellLeft, CellWidth);
    DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, class'DHMapList'.static.GetMapSource(MapNameString), FontScale);

    // Allied Side
    // -----------------------------------
    if (MapObject != none && MapObject.Get("Country").AsString() != "")
    {
        GetCellLeftWidth(2, CellLeft, CellWidth);
        DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, MapObject.Get("Country").AsString(), FontScale);
    }

    // Type
    // -----------------------------------
    if (MapObject != none && MapObject.Get("GameType").AsString() != "")
    {
        GetCellLeftWidth(3, CellLeft, CellWidth);
        DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, MapObject.Get("GameType").AsString(), FontScale);
    }

    // Player Range
    // -----------------------------------
    if (MapObject != none && MapObject.Get("MinPlayers").AsString() != "" && MapObject.Get("MaxPlayers").AsString() != "")
    {
        GetCellLeftWidth(4, CellLeft, CellWidth);
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
            if ((GRI.PRIArray.Length < Min || GRI.PRIArray.Length > Max) && MState != MSAT_Disabled)
            {
                DrawStyle = RedListStyle;
            }

            DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Center, PlayerRangeString, FontScale);
            DrawStyle = OldDrawTyle;
        }
    }
}

function string GetSortString(int i)
{
    local JSONObject    MapObject;
    local string        MapNameString;

    // Parse the JSON object
    MapObject = (new class'JSONParser').ParseObject(VRI.MapList[i].MapName);

    if (MapObject != none && MapObject.Get("MapName").AsString() != "")
    {
        MapNameString = MapObject.Get("MapName").AsString();
    }
    else
    {
        MapNameString = VRI.MapList[i].MapName;
    }

    switch (SortColumn)
    {
        case 0: // Map name
            return Caps(class'DHMapList'.static.GetPrettyName(MapNameString));
        case 1: // Source
            return Caps(class'DHMapList'.static.GetMapSource(MapNameString));
        case 2: // Allied country
            if (MapObject != none && MapObject.Get("Country").AsString() != "")
            {
                return Caps(MapObject.Get("Country").AsString());
            }
        case 4: // Type
            if (MapObject != none && MapObject.Get("GameType").AsString() != "")
            {
                return Caps(MapObject.Get("GameType").AsString());
            }
        default:
            break;
    }

    return "";
}

defaultproperties
{
    // Map Name | Source | Country | Type | Player Range | Quality Control | Author
    ColumnHeadings(0)="Map Name"
    ColumnHeadings(1)="Source"
    ColumnHeadings(2)="Country"
    ColumnHeadings(3)="Type"
    ColumnHeadings(4)="Player Range"

    InitColumnPerc(0)=0.25
    InitColumnPerc(1)=0.2
    InitColumnPerc(2)=0.15
    InitColumnPerc(3)=0.15
    InitColumnPerc(4)=0.25

    ColumnHeadingHints(0)="The map's name."
    ColumnHeadingHints(1)="Current domain of the level, community, legacy, or official."
    ColumnHeadingHints(2)="The Allied country for the map."
    ColumnHeadingHints(3)="What type of game or battle for the map."
    ColumnHeadingHints(4)="Recommended players for the map."

    RedListStyleName="DHListRed"
}
