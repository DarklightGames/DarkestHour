//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMapVoteMultiColumnList extends MapVoteMultiColumnList;

var noexport int                GameTypeIndex;
var noexport protected string   FilterPattern;

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
    local int m, p, l;
    local array<string> PrefixList;

    VRI = LoadVRI;

    if (VRI == none)
    {
        return;
    }

    Split(VRI.GameConfig[GameTypeIndex].Prefix, ",", PrefixList);

    for (m = 0; m < VRI.MapList.Length; m++)
    {
        for (p = 0; p < PreFixList.Length; p++)
        {
            if (Left(VRI.MapList[m].MapName, Len(PrefixList[p])) ~= PrefixList[p] &&
                (FilterPattern == "" || InStr(Locs(VRI.MapList[m].MapName), FilterPattern) != -1))
            {
                l = MapVoteData.Length;
                MapVoteData.Insert(l, 1);
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

    // Allied Side
    if (Parts.Length >= 2)
    {
        GetCellLeftWidth(2, CellLeft, CellWidth);
        DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, Parts[1], FontScale);
    }

    // Type
    if (Parts.Length >= 3)
    {
        GetCellLeftWidth(3, CellLeft, CellWidth);
        DrawStyle.DrawText(Canvas, MState, CellLeft, Y, CellWidth, H, TXTA_Left, Parts[2], FontScale);
    }

    // Player Range
    if (Parts.Length >= 4)
    {
        GetCellLeftWidth(4, CellLeft, CellWidth);
        OldDrawTyle = DrawStyle;
        Min = int(Parts[3]);
        Max = int(Parts[4]);

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
            if (!GRI.IsPlayerCountInRange(Min, Max) && MState != MSAT_Disabled)
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
    local array<string> Parts;

    Split(VRI.MapList[i].MapName, ";", Parts);

    switch (SortColumn)
    {
        case 0: // Map name
            if (Parts.Length > 0)
            {
                return Caps(class'DHMapList'.static.GetPrettyName(Parts[0]));
            }
        case 1: // Source
            if (Parts.Length > 1)
            {
                return Caps(class'DHMapList'.static.GetMapSource(Parts[0]));
            }
            break;
        case 2: // Allied country
            if (Parts.Length > 2)
            {
                return Caps(Parts[2]);
            }
        case 4: // Type
            if (Parts.Length > 3)
            {
                return Caps(Parts[3]);
            }
            break;
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
    ColumnHeadingHints(1)="Current domain of the level, community or official."
    ColumnHeadingHints(2)="The Allied country for the map."
    ColumnHeadingHints(3)="What type of game or battle for the map."
    ColumnHeadingHints(4)="Recommended players for the map."

    RedListStyleName="DHListRed"
}
