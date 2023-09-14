//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBrowser_ServersList extends UT2K4Browser_ServersList;

const MAX_RULES_REFRESH_ATTEMPTS = 5;

var(Style) noexport GUIStyles           WrongVersionStyle;
var(Style) string                       WrongVersionStyleName;
var        color                        WrongVersionColor;

var int    ServerRulesRefreshAttempts;

function InitComponent(GUIController InController, GUIComponent InOwner)
{
    Super.InitComponent(InController, InOwner);

    if (WrongVersionStyleName != "" && WrongVersionStyle == none)
    {
        WrongVersionStyle = InController.GetStyle(WrongVersionStyleName,FontScale);
    }

    SetTimer(1.5,true);
}

event Timer()
{
    local int OriginalIndex, i;

    // Will refresh and get server rules for all servers (this is a hack to "fetch" all the listed server rules so player can know them without selecting them)
    if (ServerRulesRefreshAttempts < MAX_RULES_REFRESH_ATTEMPTS)
    {
        // This will always force a server to be selected (required to get the ball rolling)
        if (Index == -1)
        {
            SetIndex(0);
        }

        // Store the current index
        OriginalIndex = Index;

        // Force the system to "select" each server on the list
        for (i = 0; IsValidIndex(i); ++i)
        {
            SetIndex(i);
        }

        // Restore the original index
        SetIndex(OriginalIndex);

        // We don't want this to happen forever, as the info isn't going to change in real time, we just need to fetch it once
        ++ServerRulesRefreshAttempts;
    }
}

function MyOnDrawItem(Canvas Canvas, int i, float X, float Y, float W, float H, bool bSelected, bool bPending)
{
    local float CellLeft, CellWidth, DrawX;
    local float IconPosX, IconPosY;
    local string Ping, VersionString, LocationString, HealthString;
    local int k, j, flags, checkFlag;
    local color HealthColor;
    local GUIStyles DStyle;

    // Get values for columns (have to use j as i is passed in as arguement)
    for (j = 0; j < Servers[SortData[i].SortItem].ServerInfo.Length; ++j)
    {
        // Get the server's performance string
        if (Servers[SortData[i].SortItem].ServerInfo[j].Key ~= "AverageTick")
        {
            HealthString = class'DHLib'.static.GetServerHealthString(byte(Servers[SortData[i].SortItem].ServerInfo[j].Value), HealthColor);
            HealthString = class'GameInfo'.static.MakeColorCode(HealthColor) $ HealthString;
        }

        // Get the server's location string
        if (Servers[SortData[i].SortItem].ServerInfo[j].Key ~= "Location")
        {
            LocationString = Servers[SortData[i].SortItem].ServerInfo[j].Value;
        }

        // Get the game version the server is running
        if (Servers[SortData[i].SortItem].ServerInfo[j].Key ~= "Version")
        {
            VersionString = Servers[SortData[i].SortItem].ServerInfo[j].Value;
        }
    }

    // Choose style, we will grey out servers which don't match version
    if (VersionString != class'DarkestHourGame'.default.Version.ToString())
    {
        VersionString = class'GameInfo'.static.MakeColorCode(WrongVersionColor) $ VersionString;

        if (bSelected)
        {
            WrongVersionStyle.Draw(Canvas,MenuState,X,Y,W,H+1);
        }

        DStyle = WrongVersionStyle;
    }
    else
    {
        if (bSelected)
        {
            Style.Draw(Canvas,MenuState,X,Y,W,H+1);
        }

        DStyle = Style;
    }

    //////////////////////////////////////////////////////////////////////
    // Here we get the flags for this server.
    // Passworded      1
    // Stats           2
    // LatestVersion   4
    // Listen Server   8
    // Vac Secured     16       //  Was Instagib        16
    // Standard        32
    // UT CLassic      64
    Flags = Servers[SortData[i].SortItem].Flags;

    GetCellLeftWidth( 0, CellLeft, CellWidth );
    IconPosX = CellLeft;
    IconPosY = Y;

    // First flag is in the second to most sig bit (dont want to mess with sign bit). Then we work down.
    checkFlag = 1;

    // While we still have icon, and we can fit another one in.
    for (k = 0; k < Icons.Length && IconPosX < CellLeft + CellWidth; k++)
    {
        if (Icons[k] != none)
        {
            if ((flags & checkFlag) != 0)
            {
                DrawX = Min(14, (CellLeft + CellWidth) - IconPosX);

                Canvas.DrawColor = Canvas.MakeColor(255, 255, 255, 255);

                Canvas.SetPos(IconPosX, IconPosY);
                Canvas.DrawTile(Icons[k], DrawX, 14, 0, 0, DrawX+1.0, 15.0);

                IconPosX += 14;
            }
        }

        checkFlag = checkFlag << 1;
    }

    // Server Name
    GetCellLeftWidth(1, CellLeft, CellWidth);
    DStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Left, Servers[SortData[i].SortItem].ServerName, FontScale);

    // Server Health
    GetCellLeftWidth(2, CellLeft, CellWidth);
    DStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Center, HealthString, FontScale);

    // Location
    GetCellLeftWidth(3, CellLeft, CellWidth);
    DStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Center, LocationString, FontScale);

    // Version
    GetCellLeftWidth(4, CellLeft, CellWidth);
    DStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Center, VersionString, FontScale);

    // Map
    GetCellLeftWidth(5, CellLeft, CellWidth);
    DStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Center, Servers[SortData[i].SortItem].MapName, FontScale);

    // Players
    GetCellLeftWidth(6, CellLeft, CellWidth);
    if (Servers[SortData[i].SortItem].CurrentPlayers > 0 || Servers[SortData[i].SortItem].MaxPlayers > 0)
    {
        DStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Center, string(Servers[SortData[i].SortItem].CurrentPlayers) $ "/" $ string((Servers[SortData[i].SortItem].MaxPlayers & 255)), FontScale);
    }

    // Ping
    GetCellLeftWidth(7, CellLeft, CellWidth);

    if (Servers[SortData[i].SortItem].Ping == 9999)
    {
        Ping = "?";
    }
    else if (Servers[SortData[i].SortItem].Ping > 9999)
    {
        Ping = "N/A";
    }
    else
    {
        Ping = string(Servers[SortData[i].SortItem].Ping);
    }

    DStyle.DrawText(Canvas, MenuState, CellLeft, Y, CellWidth, H, TXTA_Center, Ping, FontScale);
}

defaultproperties
{
    SelectedStyleName="DHListSelectionStyle"
    SectionStyleName="DHListSelectionStyle"
    StyleName="DHListSelectionStyle"
    WrongVersionStyleName="DHListSelectionGreyStyle"
    WrongVersionColor=(R=188,G=32,B=38)

    ColumnHeadings(0)=""
    ColumnHeadings(1)="Server Name"
    ColumnHeadings(2)="Health"
    ColumnHeadings(3)="Location"
    ColumnHeadings(4)="Version"
    ColumnHeadings(5)="Map"
    ColumnHeadings(6)="Players"
    ColumnHeadings(7)="Ping"

    InitColumnPerc(0)=0.04  // icons
    InitColumnPerc(1)=0.22  // name
    InitColumnPerc(2)=0.09  // health
    InitColumnPerc(3)=0.10  // location
    InitColumnPerc(4)=0.10  // version
    InitColumnPerc(5)=0.27  // map
    InitColumnPerc(6)=0.10  // slots
    InitColumnPerc(7)=0.08  // ping

    SortColumn=7 //ping?
    SortDescending=false
}
