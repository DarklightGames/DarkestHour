//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMapVoteCountMultiColumnList extends MapVoteCountMultiColumnList;

var localized string             TotalVotePowerText;

var(Style) string                RedListStyleName; // name of the style to use for when current player is out of recommended player range
var(Style) noexport GUIStyles    RedListStyle;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.InitComponent(MyController,MyOwner);

    if (RedListStyleName != "" && RedListStyle == none)
    {
        RedListStyle = MyController.GetStyle(RedListStyleName,FontScale);
    }
}

function DrawItem(Canvas Canvas, int i, float X, float Y, float W, float H, bool bSelected, bool bPending)
{
    local DHGameReplicationInfo GRI;
    local GUIStyles             DrawStyle, OldDrawTyle;
    local array<string>         Parts;
    local string                PlayerRangeString;
    local float                 CellLeft, CellWidth;
    local int                   Min, Max;

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

    // Split the MapName string, which may be consolidated with other variables
    Split(VRI.MapList[VRI.MapVoteCount[SortData[i].SortItem].MapIndex].MapName, ";", Parts);

    // Map Name
    GetCellLeftWidth(0, CellLeft, CellWidth);
    DrawStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Left, class'DHMapList'.static.GetPrettyName(Parts[0]), FontScale);

    // Vote Count
    GetCellLeftWidth(1, CellLeft, CellWidth);
    DrawStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Left, TotalVotePowerText @ string(VRI.MapVoteCount[SortData[i].SortItem].VoteCount), FontScale);

    // Player Range
    if (Parts.Length >= 5)
    {
        GetCellLeftWidth(2, CellLeft, CellWidth);
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
            if (!GRI.IsPlayerCountInRange(Min, Max))
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
    local array<string> Parts;

    Split(VRI.MapList[VRI.MapVoteCount[i].MapIndex].MapName, ";", Parts);

    switch (SortColumn)
    {
        case 0: // Map name
            if (Parts.Length > 0)
            {
                return Caps(class'DHMapList'.static.GetPrettyName(Parts[0]));
            }
        case 1: // Votes
            return class'UString'.static.ZFill(string(VRI.MapVoteCount[i].VoteCount), 4);
        default:
            break;
    }

    return "";
}

defaultproperties
{
    TotalVotePowerText="Combined Weight:"

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
