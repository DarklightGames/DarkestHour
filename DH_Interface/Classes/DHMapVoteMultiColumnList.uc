//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMapVoteMultiColumnList extends MapVoteMultiColumnList;

var noexport           int       GameTypeIndex;
var noexport protected string    FilterPattern;

// Style for maps that are out of player range
var(Style)             string    RedListStyleName;
var(Style)    noexport GUIStyles RedListStyle;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.InitComponent(MyController,MyOwner);

    if (RedListStyleName != "" && RedListStyle == none)
    {
        RedListStyle = MyController.GetStyle(RedListStyleName, FontScale);
    }
}

function string GetFilterPattern() { return FilterPattern; }

function SetFilterPattern(string FilterPattern)
{
    self.FilterPattern = Locs(FilterPattern);
    Clear();
    LoadList(VRI, GameTypeIndex);
}

function LoadList(VotingReplicationInfo LoadVRI, int GameTypeIndex)
{
    local int i, m, p, l;
    local string MapName;
    local int FilterTokenMatchCount;
    local array<string> PrefixList;
    local array<string> FilterTokens;

    VRI = LoadVRI;

    if (VRI == none)
    {
        return;
    }

    Split(VRI.GameConfig[GameTypeIndex].Prefix, ",", PrefixList);

    // Split the filter pattern by whitespace into filter tokens.
    Split(Locs(FilterPattern), " ", FilterTokens);

    // Remove empty filter tokens.
    for (i = FilterTokens.Length - 1; i >= 0; --i)
    {
        if (FilterTokens[i] == "")
        {
            FilterTokens.Remove(i, 1);
        }
    }

    // Iterate through all maps in the map list
    for (m = 0; m < VRI.MapList.Length; m++)
    {
        for (p = 0; p < PreFixList.Length; p++)
        {
            if (Left(VRI.MapList[m].MapName, Len(PrefixList[p])) ~= PrefixList[p])
            {
                // Store the map name without the prefix
                MapName = Locs(Right(VRI.MapList[m].MapName, Len(VRI.MapList[m].MapName) - Len(PrefixList[p])));

                // Match the tokens in the filter to the name of the map and ensure that all tokens match.
                FilterTokenMatchCount = 0;

                for (i = 0; i < FilterTokens.Length; ++i)
                {
                    if (InStr(MapName, FilterTokens[i]) == -1)
                    {
                        break;
                    }

                    ++FilterTokenMatchCount;
                }

                // If all tokens match (or there are no tokens at all), add the map to the list.
                if (FilterTokenMatchCount == FilterTokens.Length)
                {
                    l = MapVoteData.Length;
                    MapVoteData.Insert(l, 1);
                    MapVoteData[l] = m;
                    AddedItem();
                    break;
                }
            }
        }
    }

    OnDrawItem = DrawItem;
}

// Override to remove any prefix from lists and handle new features
function DrawItem(Canvas Canvas, int i, float X, float Y, float W, float H, bool bSelected, bool bPending)
{
    local float CellLeft, CellWidth;
    local eMenuState MState;
    local GUIStyles DrawStyle, OldDrawStyle;
    local DHGameReplicationInfo GRI;
    local int Min, Max;
    local DHPlayer PC;
    local DHMapDatabase MapDatabase;
    local DHMapDatabase.SMapInfo MI;

    GRI = DHGameReplicationInfo(PlayerOwner().GameReplicationInfo);

    if (VRI == none || GRI == none)
    {
        return;
    }

    PC = DHPlayer(PlayerOwner());

    if (PC != none)
    {
        PC.InitializeMapDatabase();

        MapDatabase = PC.MapDatabase;
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

    // Begin Drawing!
    // Map Name
    GetCellLeftWidth(0, CellLeft, CellWidth);
    DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, class'DHMapDatabase'.static.GetHumanReadableMapName(VRI.MapList[MapVoteData[SortData[i].SortItem]].MapName), FontScale);

    if (MapDatabase != none && MapDatabase.GetMapInfo(VRI.MapList[MapVoteData[SortData[i].SortItem]].MapName, MI))
    {
        // Allied Side
        GetCellLeftWidth(1, CellLeft, CellWidth);
        DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, class'DHMapDatabase'.static.GetAlliedNationString(MI.AlliedNation), FontScale);

        // Axis Side
        GetCellLeftWidth(2, CellLeft, CellWidth);
        DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, class'DHMapDatabase'.static.GetAxisNationString(MI.AxisNation), FontScale);

        // Type
        GetCellLeftWidth(3, CellLeft, CellWidth);
        DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, MI.GameTypeClass.default.GameTypeName, FontScale);

        // Map Size
        GetCellLeftWidth(4, CellLeft, CellWidth);
        OldDrawStyle = DrawStyle;

        class'DHMapDatabase'.static.GetMapSizePlayerCountRange(MI.Size, Min, Max);

        // Do a check if the current player count is in bounds of recommended range
        if (!GRI.IsPlayerCountInRange(Min, Max) && MState != MSAT_Disabled)
        {
            DrawStyle = RedListStyle;
        }

        DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, class'DHMapDatabase'.static.GetMapSizeString(MI.Size), FontScale);
        DrawStyle = OldDrawStyle;
    }
}

function string GetSortString(int i)
{
    local DHPlayer PC;
    local DHMapDatabase MD;
    local DHMapDatabase.SMapInfo MI;
    local bool bHasMapInfo;

    PC = DHPlayer(PlayerOwner());

    if (PC != none)
    {
        MD = PC.MapDatabase;

        if (MD != none)
        {
            bHasMapInfo = MD.GetMapInfo(VRI.MapList[i].MapName, MI);
        }
    }


    switch (SortColumn)
    {
        case 0: // Map name
            return Locs(class'DHMapDatabase'.static.GetHumanReadableMapName(VRI.MapList[i].MapName));
        case 1: // Allied country
            if (bHasMapInfo)
            {
                return class'DHMapDatabase'.static.GetAlliedNationString(MI.AlliedNation);
            }
        case 2: // Axis country
            if (bHasMapInfo)
            {
                return class'DHMapDatabase'.static.GetAxisNationString(MI.AxisNation);
            }
        case 3: // Game Type
            if (bHasMapInfo)
            {
                return MI.GameTypeClass.default.GameTypeName;
            }
        case 4: // Map Size
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
    // Map Name | Allied Nation | Axis Nation | Game Type | Map Size
    ColumnHeadings(0)="Map Name"
    ColumnHeadings(1)="Allied Nation"
    ColumnHeadings(2)="Axis Nation"
    ColumnHeadings(3)="Game Type"
    ColumnHeadings(4)="Map Size"

    InitColumnPerc(0)=0.40
    InitColumnPerc(1)=0.15
    InitColumnPerc(2)=0.15
    InitColumnPerc(3)=0.15
    InitColumnPerc(4)=0.15

    ColumnHeadingHints(0)="The map's name."
    ColumnHeadingHints(1)="The Allied country for the map."
    ColumnHeadingHints(2)="The Axis country for the map."
    ColumnHeadingHints(3)="What type of game or battle for the map."
    ColumnHeadingHints(4)="Recommended players for the map."

    RedListStyleName="DHListRed"
}
