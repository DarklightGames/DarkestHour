//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHScoreBoard extends ROScoreBoard;

const DHMAXPERSIDE = 40;
const DHMAXPERSIDEWIDE = 35;

var UComparator PRIComparator;

var DHPlayer                PC;
var DHGameReplicationInfo   DHGRI;
var DHPlayerReplicationInfo MyPRI;
var DHSquadReplicationInfo  SRI;
var float BaseXPos[2], BaseLineHeight, MaxTeamYPos, MaxTeamWidth;
var int MaxPlayersListedPerSide;
var int MyTeamIndex;

var localized string MunitionPercentageText;
var localized string PlayersText;
var localized string TickHealthText;
var localized string NetHealthText;

var string TabSpaces;
var string LargeTabSpaces;

var color ScoreboardLabelColor;
var color SquadHeaderColor;
var color PlayerBackgroundColor;
var color SelfBackgroundColor;

var array<DHPlayerReplicationInfo> AxisPRI, AlliesPRI, UnassignedPRI;

var Material PatronLeadMaterial,
             PatronBronzeMaterial,
             PatronSilverMaterial,
             PatronGoldMaterial;

var Material DeveloperIconMaterial;
var Material FlagsTexture;

enum EScoreboardColumnType
{
    COLUMN_SquadMemberIndex,
    COLUMN_PlayerName,
    COLUMN_Role,
    COLUMN_Score,
    COLUMN_Kills,
    COLUMN_PointsCombat,
    COLUMN_PointsSupport,
    COLUMN_Deaths,
    COLUMN_Flag,
    COLUMN_Ping
};

struct ScoreboardColumn
{
    var localized string Title;
    var Material IconMaterial;
    var EScoreboardColumnType Type;
    var float Width;
    var bool bFriendlyOnly;
    var bool bRoundEndOnly;
    var byte Justification;
};

struct RowRenderInfo
{
    var Color       BackgroundColor;
};

struct CellRenderInfo
{
    var string      Text;
    var color       TextColor;
    var byte        Justification;
    var Material    Icon;
    var float       U, V, UL, VL;
};

var array<ScoreboardColumn> ScoreboardColumns;

function array<int> GetScoreboardColumnIndicesForTeam(int TeamIndex)
{
    local array<int> ScoreboardColumnIndices;
    local int i;

    for (i = 0; i < ScoreboardColumns.Length; ++i)
    {
        if ((ScoreboardColumns[i].bFriendlyOnly && MyTeamIndex != TeamIndex) || ScoreboardColumns[i].bRoundEndOnly && !DHGRI.bRoundIsOver)
        {
            continue;
        }

        ScoreboardColumnIndices[ScoreboardColumnIndices.Length] = i;
    }

    return ScoreboardColumnIndices;
}

// Gets the width of the team's scoreboard (in SB-space)
function float GetScoreboardTeamWidth(int TeamIndex)
{
    // TODO: get MY team index
    local float TeamWidth;
    local array<int> ScoreboardColumnIndices;
    local int i;

    ScoreboardColumnIndices = GetScoreboardColumnIndicesForTeam(TeamIndex);

    for (i = 0; i < ScoreboardColumnIndices.Length; ++i)
    {
        TeamWidth += ScoreboardColumns[ScoreboardColumnIndices[i]].Width;
    }

    return TeamWidth;
}

function GetScoreboardEmptyTeamColumnRenderInfo(int ScoreboardColumnIndex, out CellRenderInfo CRI)
{
    CRI.Icon = none;
    CRI.Justification = 0;

    switch (EScoreboardColumnType(ScoreboardColumnIndex))
    {
        case COLUMN_PlayerName:
            CRI.TextColor = class'UColor'.default.White;
            CRI.Text = "No players";
            break;
        default:
            CRI.Text = "";
            break;
    }
}

function GetScoreboardRowRenderInfo(DHPlayerReplicationInfo PRI, out RowRenderInfo RRI)
{
    if (PRI != none && PRI == MyPRI)
    {
        RRI.BackgroundColor = SelfBackgroundColor;
    }
    else
    {
        RRI.BackgroundColor = PlayerBackgroundColor;
    }
}

function GetScoreboardColumnRenderInfo(int ScoreboardColumnIndex, DHPlayerReplicationInfo PRI, out CellRenderInfo CRI)
{
    if (PRI == none)
    {
        return;
    }

    CRI.Icon = none;
    CRI.Justification = ScoreboardColumns[ScoreboardColumnIndex].Justification;

    if (PRI.bAdmin)
    {
        CRI.TextColor = class'UColor'.default.Orange;
    }
    else
    {
        if (PRI == MyPRI)
        {
            CRI.TextColor = class'UColor'.default.White;
        }
        else
        {
            CRI.TextColor = class'DHColor'.default.TeamColors[PRI.Team.TeamIndex];
        }
    }

    switch (ScoreboardColumns[ScoreboardColumnIndex].Type)
    {
        case COLUMN_SquadMemberIndex:
            CRI.Text = PRI.GetNamePrefix();
            break;
        case COLUMN_PlayerName:
            if (PRI.bAdmin)
            {
                CRI.Text = PRI.PlayerName @ "(" $ AdminText $ ")";
            }
            else
            {
                CRI.Text = PRI.PlayerName;
            }

            if (PRI.IsInSquad() && (MyPRI == PRI || class'DHPlayerReplicationInfo'.static.IsInSameSquad(MyPRI, PRI)))
            {
                CRI.TextColor = class'DHColor'.default.SquadColor;
            }

            if (PRI.bIsDeveloper)
            {
                CRI.Icon = default.DeveloperIconMaterial;
                CRI.U = 0;
                CRI.V = 0;
                CRI.UL = default.DeveloperIconMaterial.MaterialUSize() - 1;
                CRI.VL = default.DeveloperIconMaterial.MaterialVSize() - 1;
            }
            else if (PRI.PatronTier != PATRON_None) // TODO expand on this (have array of icons and use the index of the enum)
            {
                switch (PRI.PatronTier)
                {
                    case PATRON_Lead:
                        CRI.Icon = default.PatronLeadMaterial;
                        break;
                    case PATRON_Bronze:
                        CRI.Icon = default.PatronBronzeMaterial;
                        break;
                    case PATRON_Silver:
                        CRI.Icon = default.PatronSilverMaterial;
                        break;
                    case PATRON_Gold:
                        CRI.Icon = default.PatronGoldMaterial;
                        break;
                }

                CRI.U = 0;
                CRI.V = 0;
                CRI.UL = CRI.Icon.MaterialUSize() - 1;
                CRI.VL = CRI.Icon.MaterialVSize() - 1;
            }
            break;
        case COLUMN_Role:
            if (PRI.RoleInfo != none)
            {
                if (ROPlayer(Owner) != none && ROPlayer(Owner).bUseNativeRoleNames)
                {
                    CRI.Text = PRI.RoleInfo.default.AltName;
                }
                else
                {
                    CRI.Text = PRI.RoleInfo.default.MyName;
                }
            }
            else
            {
                CRI.Text = "";
            }
            break;
        case COLUMN_PointsCombat:
            CRI.Text = string(PRI.CategoryScores[class'DHScoreCategory_Combat'.default.CategoryIndex]);
            break;
        case COLUMN_PointsSupport:
            CRI.Text = string(PRI.CategoryScores[class'DHScoreCategory_Support'.default.CategoryIndex]);
            break;
        case COLUMN_Score:
            CRI.Text = string(PRI.TotalScore);
            break;
        case COLUMN_Ping:
            CRI.Text = string(4 * PRI.Ping);
            break;
        case COLUMN_Kills:
            CRI.Text = string(PRI.DHKills);
            break;
        case COLUMN_Deaths:
            CRI.Text = string(int(PRI.Deaths));
            break;
        case COLUMN_Flag:
            CRI.Text = "";
            if (PRI.CountryIndex >= 0)
            {
                CRI.Icon = default.FlagsTexture;
                GetFlagCoordinates(PRI.CountryIndex, CRI.U, CRI.V, CRI.UL, CRI.VL);
            }
            break;
        default:
            break;
    }
}

static function GetFlagCoordinates(int CountryIndex, out float U, out float V, out float UL, out float VL)
{
    const FLAG_WIDTH = 24;
    const FLAG_HEIGHT = 16;
    const COLUMN_COUNT = 16;
    const ATLAS_WIDTH = 512;
    const ATLAS_HEIGHT = 256;

    local int RowIndex, ColumnIndex;

    RowIndex = CountryIndex / COLUMN_COUNT;
    ColumnIndex = CountryIndex % COLUMN_COUNT;

    U = ColumnIndex * FLAG_WIDTH;
    V = RowIndex * FLAG_HEIGHT;
    UL = FLAG_WIDTH - 1;
    VL = FLAG_HEIGHT - 1;
}

// Modified to create a special 'PRIComparator' object that is used to efficiently sort each team array, with variable methods of sorting
// Note the bAlphaSortScoreBoard option can only be enabled by changing the config file before playing, not during the game, so no need to check which option after this
function PostBeginPlay()
{
    super.PostBeginPlay();

    PRIComparator = new class'UComparator';

    if (bAlphaSortScoreBoard)
    {
        PRIComparator.CompareFunction = PRIAlphabeticalComparatorFunction;
    }
    else
    {
        PRIComparator.CompareFunction = PRIComparatorFunction;
    }

    SetTimer(0.5, true);
    Timer();
}

// TODO: this is actually kinda crap because the timer runs even when the scoreboard isn't visible.
function Timer()
{
    local int i;
    local DHPlayerReplicationInfo PRI;

    AxisPRI.Length = 0;
    AlliesPRI.Length = 0;
    UnassignedPRI.Length = 0;

    UpdateGRI();

    if (GRI == none)
    {
        return;
    }

    // Assign all players to relevant array of PRIs for their team or unassigned/spectators
    for (i = 0; i < GRI.PRIArray.Length; ++i)
    {
        PRI = DHPlayerReplicationInfo(GRI.PRIArray[i]);

        if (PRI != none)
        {
            if (PRI.Team == none)
            {
                UnassignedPRI[UnassignedPRI.Length] = PRI;
            }
            else
            {
                switch (PRI.Team.TeamIndex)
                {
                    case 0:
                        AxisPRI[AxisPRI.Length] = PRI;
                        break;
                    case 1:
                        AlliesPRI[AlliesPRI.Length] = PRI;
                        break;
                    case 2:
                        UnassignedPRI[UnassignedPRI.Length] = PRI;
                }
            }
        }
    }

    class'USort'.static.Sort(AxisPRI, PRIComparator);
    class'USort'.static.Sort(AlliesPRI, PRIComparator);
}

// Modified to remove automatic sorting of entire PRI, which instead we do for each team using the PRIComparator object
function bool UpdateGRI()
{
    if (GRI == none)
    {
        InitGRI();
    }

    return GRI != none;
}

// New function used by PRIComparator object for standard sort method, primarily by player score
// Does what InOrder() function originally did - except note this is in reverse, as a true return value makes the PRIComparator swap the compared pair
private static function bool PRIComparatorFunction(Object A, Object B)
{
    local PlayerReplicationInfo P1, P2;

    P1 = PlayerReplicationInfo(A);
    P2 = PlayerReplicationInfo(B);

    // The passed objects should always be PRIs of active players on a team, but just in case we return false, signifying no need to swap
    if (P1 == none || P2 == none || P1.bOnlySpectator || P2.bOnlySpectator)
    {
        return false;
    }

    // The pair are out of order if player 2's score is higher
    if (P1.Score != P2.Score)
    {
        return P2.Score > P1.Score;
    }

    // But if scores are the same, they are out of order if player 2's deaths is lower
    if (P1.Deaths != P1.Deaths)
    {
        return P2.Deaths < P1.Deaths;
    }

    // And if everything else is the same, they are out of order if player 2 is the local human player (i.e. we move local human higher in the list)
    return PlayerController(P2.Owner) != none && Viewport(PlayerController(P2.Owner).Player) != none;
}

// New function used by PRIComparator object for alternative sort method by player names alphabetically, if that option is specified (bAlphaSortScoreBoard=true in player's config file)
private static function bool PRIAlphabeticalComparatorFunction(Object A, Object B)
{
    return Caps(PlayerReplicationInfo(A).PlayerName) > Caps(PlayerReplicationInfo(B).PlayerName);
}

// Emptied out as instead we use the PRIComparator object & it's own functions, as above
function SortPRIArray();
function bool InOrder(PlayerReplicationInfo P1, PlayerReplicationInfo P2) { return true;}

// Emptied out as these ROScoreBoard functions were never used, so just to de-clutter & avoid possible confusion
function float DrawTeam(Canvas C, int TeamNum, float YPos, int PlayerCount) { return 0.0;}
function float DrawHeaders(Canvas C) { return 0.0;}

// TODO: A lot of this doesn't need to happen every frame.
// Modified to re-factor to substantially reduce repetition & use of literals,
// also simplifying, making clearer & removing some redundancy.
// Also adds some extra information in the scoreboard header.
function UpdateScoreBoard(Canvas C)
{
    local class<DHHud> HUD;
    local string S;
    local float LineHeight, X, Y, XL, YL;
    local int i;
    local color HealthColor;
    local string HealthString;

    PC = DHPlayer(Owner);

    //////////////////// SET UP ////////////////////
    if (PC != none)
    {
        MyPRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
        DHGRI = DHGameReplicationInfo(GRI);
        SRI = PC.SquadReplicationInfo;
        HUD = class<DHHud>(HudClass);
    }

    if (MyPRI == none || DHGRI == none || HUD == none || C == none || SRI == none)
    {
        return;
    }

    C.Style = ERenderStyle.STY_Alpha;
    C.SetDrawColor(0, 0, 0, 128);
    C.SetPos(0.0, 0.0);
    C.DrawRect(Texture'WhiteSquareTexture', C.ClipX, C.ClipY);

    if (float(C.SizeX) / float(C.SizeY) >= 1.6)
    {
        MaxPlayersListedPerSide = DHMAXPERSIDEWIDE; // widescreen uses a different maximum per side setting (for 16:10 or 16:9 screen aspect ratio)
    }
    else
    {
        MaxPlayersListedPerSide = DHMAXPERSIDE;
    }

    if (MyPRI != none && MyPRI.Team != none)
    {
        MyTeamIndex = MyPRI.Team.TeamIndex;
    }

    BaseXPos[0] = (30.0 - (GetScoreboardTeamWidth(AXIS_TEAM_INDEX) + GetScoreboardTeamWidth(ALLIES_TEAM_INDEX) + 0.75)) * 0.5;
    BaseXPos[1] = BaseXPos[0] + GetScoreboardTeamWidth(AXIS_TEAM_INDEX) + 0.75;
    BaseXPos[0] = CalcX(BaseXPos[0], C);
    BaseXPos[1] = CalcX(BaseXPos[1], C);

    NameLength = CalcX(default.NameLength, C);
    RoleLength = CalcX(default.RoleLength, C);
    ScoreLength = CalcX(default.ScoreLength, C);
    PingLength = CalcX(default.PingLength, C);
    MaxTeamWidth = NameLength + RoleLength + ScoreLength + PingLength;

    //////////// DRAW SCOREBOARD HEADER ////////////
    // Set standard font & line height
    C.Font = HUD.static.GetConsoleFont(C);
    C.TextSize("Text", XL, BaseLineHeight);
    LineHeight = BaseLineHeight * 1.25;

    // Construct a line with various information about the round & the server (start with "time remaining")
    S = class'GameInfo'.static.MakeColorCode(ScoreboardLabelColor) $ HUD.default.TimeRemainingText;                          // Label
    S $= class'GameInfo'.static.MakeColorCode(HUD.default.WhiteColor);

    if (DHGRI.DHRoundDuration == 0)
    {
        S $= HUD.default.NoTimeLimitText;                                                                                    // Value
    }
    else
    {
        S $= class'TimeSpan'.static.ToString(DHGRI.GetRoundTimeRemaining());                                                 // Or Value
    }

    // Add time elapsed (useful if time remaining changes)
    S $= HUD.default.SpacingText $ class'GameInfo'.static.MakeColorCode(ScoreboardLabelColor) $ HUD.default.TimeElapsedText;              // Label
    S $= class'GameInfo'.static.MakeColorCode(HUD.default.WhiteColor) $ HUD.static.GetTimeString(GRI.ElapsedTime - DHGRI.RoundStartTime); // Value

    // Add server name (if not standalone)
    if (Level.NetMode != NM_Standalone)
    {
        S $= HUD.default.SpacingText $ class'GameInfo'.static.MakeColorCode(ScoreboardLabelColor) $ HUD.default.ServerNameText;           // Label
        S $= class'GameInfo'.static.MakeColorCode(HUD.default.WhiteColor) $ Left(DHGRI.ServerName, 12);                                   // Value
    }

    // Add server IP (optional)
    if (DHGRI.bShowServerIPOnScoreboard && Level.NetMode != NM_Standalone)
    {
        S $= HUD.default.SpacingText $ class'GameInfo'.static.MakeColorCode(ScoreboardLabelColor) $ HUD.default.IPText;      // Label
        S $= class'GameInfo'.static.MakeColorCode(HUD.default.WhiteColor) $ PlayerController(Owner).GetServerIP();           // Value
    }

    // Add level name (extra in DH)
    S $= HUD.default.SpacingText $ class'GameInfo'.static.MakeColorCode(ScoreboardLabelColor) $ HUD.default.MapNameText;     // Label
    S $= class'GameInfo'.static.MakeColorCode(HUD.default.WhiteColor) $ class'DHLib'.static.GetMapName(Level);               // Value

    // Add game type
    S $= HUD.default.SpacingText $ class'GameInfo'.static.MakeColorCode(ScoreboardLabelColor) $ HUD.default.MapGameTypeText; // Label
    S $= class'GameInfo'.static.MakeColorCode(HUD.default.WhiteColor) $ DHGRI.GameType.default.GameTypeName;                 // Value

    // Add Server Tick Health
    HealthString = class'DHLib'.static.GetServerHealthString(DHGRI.ServerTickHealth, HealthColor);
    S $= HUD.default.SpacingText $ class'GameInfo'.static.MakeColorCode(ScoreboardLabelColor) $ default.TickHealthText;      // Label
    S $= class'GameInfo'.static.MakeColorCode(HealthColor) $ HealthString @ "(" $ DHGRI.ServerTickHealth $ ")";              // Value

    // Add Server Loss Health
    S $= HUD.default.SpacingText $ class'GameInfo'.static.MakeColorCode(ScoreboardLabelColor) $ default.NetHealthText;       // Label
    S $= class'GameInfo'.static.MakeColorCode(HUD.default.WhiteColor) $ "(" $ DHGRI.ServerNetHealth $ ")";                   // Value

    Y = CalcY(0.25, C);

    // Draw our round/server info line, with a drop shadow
    C.SetDrawColor(0, 0, 0, 128);
    X = BaseXPos[0];
    C.SetPos(X + 1, Y + 1);
    C.DrawTextClipped(S); // this is the dark 'drop shadow' text, slightly offset from the actual text

    C.DrawColor = HUD.default.WhiteColor;
    C.SetPos(X, Y);
    C.DrawTextClipped(S); // this is the actual text, drawn over the drop shadow

    MaxTeamYPos = 0.0;

    //////////////// DRAW AXIS TEAM ////////////////
    DHDrawTeam(C, AXIS_TEAM_INDEX, AxisPRI, X, Y, LineHeight);

    /////////////// DRAW ALLIES TEAM ///////////////
    DHDrawTeam(C, ALLIES_TEAM_INDEX, AlliesPRI, X, Y, LineHeight);

    //////////////// DRAW SPECTATORS ///////////////
    Y = MaxTeamYPos;

    LineHeight = BaseLineHeight * 1.05;
    X = BaseXPos[0];
    Y += 1.5 * LineHeight;

    if (Y + LineHeight > C.ClipY)
    {
        // Spectator line would draw off the bottom of the screen, so stop drawing
        return;
    }

    // Construct a spectator line
    S = SpectatorTeamName @ "&" @ UnassignedTeamName @ "(" $ UnassignedPRI.Length $ ") : ";

    for (i = 0; i < UnassignedPRI.Length; ++i)
    {
        // Get the draw length of the player's name (XL)
        C.TextSize(S $ "," $ UnassignedPRI[i].PlayerName, XL, YL);

        if (CalcX(1.0, C) + XL > C.ClipX)
        {
            DHDrawCell(C, s, 0, X, Y, BaseXPos[1] + MaxTeamWidth, LineHeight, HUD.default.WhiteColor);
            S = "";
            Y += LineHeight;

            if (Y + LineHeight > C.ClipY)
            {
                return;
            }
        }

        S $= UnassignedPRI[i].PlayerName;

        if (i < UnassignedPRI.Length - 1)
        {
            S $= ", ";
        }
    }

    // Finally, draw our spectator line
    DHDrawCell(C, S, 0, X, Y, BaseXPos[0] + CalcX(GetScoreboardTeamWidth(AXIS_TEAM_INDEX) + GetScoreboardTeamWidth(ALLIES_TEAM_INDEX) + 0.75, C), LineHeight, HUD.default.WhiteColor);
}

function string GetColumnTitle(int TeamIndex, int ColumnIndex)
{
    local int TeamSizes[2];

    switch (ColumnIndex)
    {
        case 1: // Name
            DHGRI.GetTeamSizes(TeamSizes);
            return PlayersText @ "(" $ TeamSizes[TeamIndex] $ ")";
        default:
            return ScoreboardColumns[ColumnIndex].Title;
    }
}

function string GetTotalColumnTitle(int TeamIndex, int ColumnIndex)
{
    switch (EScoreboardColumnType(ColumnIndex))
    {
        case COLUMN_PlayerName: // Name
            return TotalsText $ ":";
        case COLUMN_SquadMemberIndex:
        case COLUMN_Role:
        case COLUMN_Score:
        case COLUMN_Ping:
            return "";
        default:
            return ScoreboardColumns[ColumnIndex].Title;
    }
}

function DHDrawTeam(Canvas C, int TeamIndex, array<DHPlayerReplicationInfo> TeamPRI, out float X, out float Y, float LineHeight)
{
    local string S, TeamName, TeamInfoString;
    local color  TeamColor;
    local int i, j, SquadIndex;
    local array<int> ScoreboardColumnIndices;
    local CellRenderInfo CRI;
    local RowRenderInfo RRI;
    local array<DHPlayerReplicationInfo> SquadMembers;
    local float TeamWidth;
    local bool bHasUnassigned;

    TeamColor = class'DHColor'.default.TeamColors[TeamIndex];

    // Sort the team arrays by whatever method has been specified (by default this is primarily by score, but there is an option to sort alphabetically by name)
    class'USort'.static.Sort(TeamPRI, PRIComparator);

    X = BaseXPos[TeamIndex];
    Y = CalcY(0.5, C);

    // Draw team header info
    Y += LineHeight;

    // Get the correct name name
    if (TeamIndex == AXIS_TEAM_INDEX)
    {
        TeamName = TeamNameAxis;
    }
    else if (TeamIndex == ALLIES_TEAM_INDEX)
    {
        TeamName = TeamNameAllies;
    }

    TeamWidth = CalcX(GetScoreboardTeamWidth(TeamIndex), C);

    DHDrawCell(C, TeamName @ "-" @ DHGRI.UnitName[TeamIndex], 0, X, Y, TeamWidth, LineHeight, TeamColor);

    Y += LineHeight;

    // Draw reinforcements remaining and munitions and if needed team scale, only for your team or if round is over
    if (MyTeamIndex == TeamIndex || DHGRI.bRoundIsOver)
    {
        // Construct the string of the team info
        if (DHGRI.bIsInSetupPhase)
        {
            TeamInfoString = ReinforcementsText $ ":" @ "???";
        }
        else if (DHGRI.SpawnsRemaining[TeamIndex] >= 0)
        {
            TeamInfoString = ReinforcementsText $ ":" @ DHGRI.SpawnsRemaining[TeamIndex];
        }
        else
        {
            TeamInfoString = ReinforcementsText $ ":" @ DHGRI.ReinforcementsInfiniteText;
        }

        // Add the munition percentage
        TeamInfoString $= LargeTabSpaces $ MunitionPercentageText $ ":" @ int(DHGRI.TeamMunitionPercentages[TeamIndex]) $ "%";

        // Add the team scale if needed
        if (DHGRI.CurrentAlliedToAxisRatio != 0.5)
        {
            TeamInfoString $= LargeTabSpaces $ DHGRI.ForceScaleText $ ":" @ DHGRI.GetTeamScaleString(TeamIndex);
        }

        // Draw the team info
        DHDrawCell(C, TeamInfoString, 0, X, Y, TeamWidth, LineHeight, TeamColor);
    }

    // Draw rounds won/remaining for the team if not limited to 1 round
    if (DHGRI.DHRoundLimit > 1)
    {
        S = RoundsWonText @ ":" @ int(GRI.Teams[TeamIndex].Score);

        if (DHGRI.DHRoundLimit != 0) // add round limit, if more than 1 round is specified
        {
            S $= "/" $ DHGRI.DHRoundLimit;
        }

        Y += LineHeight;

        DHDrawCell(C, S, 0, X, Y, MaxTeamWidth, LineHeight, TeamColor);
    }

    //==========================================================================
    // COLUMN HEADERS
    //==========================================================================
    Y += LineHeight;

    ScoreboardColumnIndices = GetScoreboardColumnIndicesForTeam(TeamIndex);

    DrawRowBackground(C, BaseXPos[TeamIndex], Y, TeamWidth, LineHeight, TeamColor);

    for (i = 0; i < ScoreboardColumnIndices.Length; ++i)
    {
        if (ScoreboardColumns[ScoreboardColumnIndices[i]].IconMaterial != none)
        {
            DHDrawCell(C,
                GetColumnTitle(TeamIndex, ScoreboardColumnIndices[i]),
                ScoreboardColumns[ScoreboardColumnIndices[i]].Justification,
                X,
                Y,
                CalcX(ScoreboardColumns[ScoreboardColumnIndices[i]].Width, C),
                LineHeight,
                class'UColor'.default.White,
                ScoreboardColumns[ScoreboardColumnIndices[i]].IconMaterial,
                0.0,
                0.0,
                ScoreboardColumns[ScoreboardColumnIndices[i]].IconMaterial.MaterialUSize() - 1,
                ScoreboardColumns[ScoreboardColumnIndices[i]].IconMaterial.MaterialVSize() - 1);
        }
        else
        {
            DHDrawCell(C,
                GetColumnTitle(TeamIndex, ScoreboardColumnIndices[i]),
                ScoreboardColumns[ScoreboardColumnIndices[i]].Justification,
                X,
                Y,
                CalcX(ScoreboardColumns[ScoreboardColumnIndices[i]].Width, C),
                LineHeight,
                class'UColor'.default.White);
        }

        X += CalcX(ScoreboardColumns[ScoreboardColumnIndices[i]].Width, C);
    }

    // Loop through players & draw names, role, score & ping
    Y += LineHeight;

    if (MyTeamIndex == TeamIndex)
    {
        // We are drawing our own team, so let's draw all of the squad information!
        for (SquadIndex = 0; SquadIndex < SRI.GetTeamSquadLimit(TeamIndex); ++SquadIndex)
        {
            if (!SRI.IsSquadActive(TeamIndex, SquadIndex))
            {
                continue;
            }

            // Gather all members of the squad
            SRI.GetMembers(TeamIndex, SquadIndex, SquadMembers);

            // Reset the base line height
            LineHeight = BaseLineHeight * 1.25;

            if (Y + LineHeight > C.ClipY)
            {
                break;
            }

            // Reset the X position
            X = BaseXPos[TeamIndex];

            // Draw the squad header
            DrawRowBackground(C, BaseXPos[TeamIndex], Y, TeamWidth, LineHeight, SquadHeaderColor);
            DHDrawCell(C, TabSpaces $ SRI.GetSquadName(TeamIndex, SquadIndex) @ "(" $ SquadMembers.Length $ "/" $ SRI.GetTeamSquadSize(TeamIndex) $ ")", 0, X, Y, TeamWidth, LineHeight, class'UColor'.default.White);

            // Increment the Y value
            Y += LineHeight;

            // Sort the squad members.
            class'USort'.static.Sort(SquadMembers, PRIComparator);

            // Set the line height to be slightly smaller than the base line height
            LineHeight = BaseLineHeight;

            // Draw all squad members
            for (i = 0; i < SquadMembers.Length; ++i)
            {
                GetScoreboardRowRenderInfo(SquadMembers[i], RRI);
                DrawRowBackground(C, BaseXPos[TeamIndex], Y, TeamWidth, LineHeight, RRI.BackgroundColor);

                // If we've filled all available lines for this team, draw a final "..." to indicate there are more players not listed & exit the loop
                if (i >= MaxPlayersListedPerSide)
                {
                    DHDrawCell(C, "...", 0, BaseXPos[TeamIndex], Y, NameLength, LineHeight, class'UColor'.default.White);
                    break;
                }

                X = BaseXPos[TeamIndex];

                for (j = 0; j < ScoreboardColumnIndices.Length; ++j)
                {
                    GetScoreboardColumnRenderInfo(ScoreboardColumnIndices[j], SquadMembers[i], CRI);
                    DHDrawCell(C, CRI.Text, CRI.Justification, X, Y, CalcX(ScoreboardColumns[ScoreboardColumnIndices[j]].Width, C), LineHeight, CRI.TextColor, CRI.Icon, CRI.U, CRI.V, CRI.UL, CRI.VL);
                    X += CalcX(ScoreboardColumns[ScoreboardColumnIndices[j]].Width, C);
                }

                // Move to next drawing line (exit drawing axis players if this takes us off the bottom of the screen)
                Y += LineHeight;

                if (Y + LineHeight > C.ClipY)
                {
                    break;
                }
            }
        }

        for (i = 0; i < TeamPRI.Length; ++i)
        {
            if (TeamPRI[i] != none && TeamPRI[i].SquadIndex == -1)
            {
                bHasUnassigned = true;
                break;
            }
        }

        if (bHasUnassigned)
        {
            // Reset the base line height
            LineHeight = BaseLineHeight * 1.25;

            // Reset the X position
            X = BaseXPos[TeamIndex];

            // Draw the unassigned header
            DrawRowBackground(C, BaseXPos[TeamIndex], Y, TeamWidth, LineHeight, SquadHeaderColor);
            DHDrawCell(C, TabSpaces $ UnassignedTeamName, 0, X, Y, TeamWidth, LineHeight, class'UColor'.default.White);

            // Increment the Y value
            Y += LineHeight;

            // Rest the base line height
            LineHeight = BaseLineHeight;

            for (i = 0; i < TeamPRI.Length; ++i)
            {
                if (TeamPRI[i] == none || TeamPRI[i].SquadIndex != -1)
                {
                    continue;
                }

                if (Y + LineHeight > C.ClipY)
                {
                    break;
                }

                GetScoreboardRowRenderInfo(TeamPRI[i], RRI);
                DrawRowBackground(C, BaseXPos[TeamIndex], Y, TeamWidth, LineHeight, RRI.BackgroundColor);

                // If we've filled all available lines for this team, draw a final "..." to indicate there are more players not listed & exit the loop
                if (i >= MaxPlayersListedPerSide)
                {
                    DHDrawCell(C, "...", 0, BaseXPos[TeamIndex], Y, NameLength, LineHeight, class'UColor'.default.White);
                    break;
                }

                X = BaseXPos[TeamIndex];

                for (j = 0; j < ScoreboardColumnIndices.Length; ++j)
                {
                    GetScoreboardColumnRenderInfo(ScoreboardColumnIndices[j], TeamPRI[i], CRI);
                    DHDrawCell(C, CRI.Text, CRI.Justification, X, Y, CalcX(ScoreboardColumns[ScoreboardColumnIndices[j]].Width, C), LineHeight, CRI.TextColor, CRI.Icon, CRI.U, CRI.V, CRI.UL, CRI.VL);
                    X += CalcX(ScoreboardColumns[ScoreboardColumnIndices[j]].Width, C);
                }

                // Move to next drawing line (exit drawing axis players if this takes us off the bottom of the screen)
                Y += LineHeight;
            }
        }
    }
    else
    {
        // Set the line height to be slightly smaller than the base line height
        LineHeight = BaseLineHeight;

        if (TeamPRI.Length == 0)
        {
            X = BaseXPos[TeamIndex];

            DrawRowBackground(C, BaseXPos[TeamIndex], Y, TeamWidth, LineHeight, PlayerBackgroundColor);

            // Empty team, display "no players".
            for (j = 0; j < ScoreboardColumnIndices.Length; ++j)
            {
                GetScoreboardEmptyTeamColumnRenderInfo(ScoreboardColumnIndices[j], CRI);
                DHDrawCell(C, CRI.Text, CRI.Justification, X, Y, CalcX(ScoreboardColumns[ScoreboardColumnIndices[j]].Width, C), LineHeight, CRI.TextColor, CRI.Icon, CRI.U, CRI.V, CRI.UL, CRI.VL);
                X += CalcX(ScoreboardColumns[ScoreboardColumnIndices[j]].Width, C);
            }

            Y += LineHeight;
        }
        else
        {
            for (i = 0; i < TeamPRI.Length; ++i)
            {
                if (TeamPRI[i] == none)
                {
                    continue;
                }

                if (Y + LineHeight > C.ClipY)
                {
                    break;
                }

                DrawRowBackground(C, BaseXPos[TeamIndex], Y, TeamWidth, LineHeight, PlayerBackgroundColor);

                // If we've filled all available lines for this team, draw a final "..." to indicate there are more players not listed & exit the loop
                if (i >= MaxPlayersListedPerSide)
                {
                    DHDrawCell(C, "...", 0, BaseXPos[TeamIndex], Y, NameLength, LineHeight, class'UColor'.default.White);
                    break;
                }

                X = BaseXPos[TeamIndex];

                for (j = 0; j < ScoreboardColumnIndices.Length; ++j)
                {
                    GetScoreboardColumnRenderInfo(ScoreboardColumnIndices[j], TeamPRI[i], CRI);
                    DHDrawCell(C, CRI.Text, CRI.Justification, X, Y, CalcX(ScoreboardColumns[ScoreboardColumnIndices[j]].Width, C), LineHeight, CRI.TextColor, CRI.Icon, CRI.U, CRI.V, CRI.UL, CRI.VL);
                    X += CalcX(ScoreboardColumns[ScoreboardColumnIndices[j]].Width, C);
                }

                // Move to next drawing line (exit drawing axis players if this takes us off the bottom of the screen)
                Y += LineHeight;
            }
        }
    }

    // Draw team totals
    X = BaseXPos[TeamIndex];
    LineHeight = BaseLineHeight * 1.25;

    //===============================================
    // TEAM TOTALS
    //===============================================
    if (DHGRI.bRoundIsOver)
    {
        // Draw the column headers again.
        DrawRowBackground(C, BaseXPos[TeamIndex], Y, TeamWidth, LineHeight, TeamColor);

        for (i = 0; i < ScoreboardColumnIndices.Length; ++i)
        {
            if (ScoreboardColumns[ScoreboardColumnIndices[i]].IconMaterial != none)
            {
                DHDrawCell(C,
                    GetTotalColumnTitle(TeamIndex, ScoreboardColumnIndices[i]),
                    ScoreboardColumns[ScoreboardColumnIndices[i]].Justification,
                    X,
                    Y,
                    CalcX(ScoreboardColumns[ScoreboardColumnIndices[i]].Width, C),
                    LineHeight,
                    class'UColor'.default.White,
                    ScoreboardColumns[ScoreboardColumnIndices[i]].IconMaterial,
                    0.0,
                    0.0,
                    ScoreboardColumns[ScoreboardColumnIndices[i]].IconMaterial.MaterialUSize() - 1,
                    ScoreboardColumns[ScoreboardColumnIndices[i]].IconMaterial.MaterialVSize() - 1);
            }
            else
            {
                DHDrawCell(C,
                    GetTotalColumnTitle(TeamIndex, ScoreboardColumnIndices[i]),
                    ScoreboardColumns[ScoreboardColumnIndices[i]].Justification,
                    X,
                    Y,
                    CalcX(ScoreboardColumns[ScoreboardColumnIndices[i]].Width, C),
                    LineHeight,
                    class'UColor'.default.White);
            }

            X += CalcX(ScoreboardColumns[ScoreboardColumnIndices[i]].Width, C);
        }


        // Reset the X position
        X = BaseXPos[TeamIndex];

        // Increment the Y value
        Y += LineHeight;

        // Rest the base line height
        LineHeight = BaseLineHeight;

        DrawRowBackground(C, BaseXPos[TeamIndex], Y, TeamWidth, LineHeight, TeamColor);

        for (i = 0; i < ScoreboardColumnIndices.Length; ++i)
        {
            GetScoreboardTotalColumnRenderInfo(TeamIndex, ScoreboardColumnIndices[i], CRI);

            DHDrawCell(C, CRI.Text, CRI.Justification, X, Y, CalcX(ScoreboardColumns[ScoreboardColumnIndices[i]].Width, C), LineHeight, CRI.TextColor, CRI.Icon, CRI.U, CRI.V, CRI.UL, CRI.VL);

            X += CalcX(ScoreboardColumns[ScoreboardColumnIndices[i]].Width, C);
        }
    }
    else
    {
        // Just draw a footer block.
        DrawRowBackground(C, BaseXPos[TeamIndex], Y, TeamWidth, LineHeight, TeamColor);
    }

    MaxTeamYPos = FMax(MaxTeamYPos, Y);
}

function GetScoreboardTotalColumnRenderInfo(int TeamIndex, int ColumnIndex, out CellRenderInfo CRI)
{
    local int i, Score;

    if (DHGRI != none)
    {
        CRI.Icon = none;
        CRI.Justification = ScoreboardColumns[ColumnIndex].Justification;
        CRI.TextColor = class'UColor'.default.White;

        switch (ScoreboardColumns[ColumnIndex].Type)
        {
            case COLUMN_Score:
                Score = 0;
                for (i = 0; i < arraycount(DHGRI.TeamScores[TeamIndex].CategoryScores); ++i)
                {
                    Score += DHGRI.TeamScores[TeamIndex].CategoryScores[i];
                }
                CRI.Text = string(Score);
                break;
            case COLUMN_Kills:
                CRI.Text = string(DHGRI.TeamScores[TeamIndex].Kills);
                break;
            case COLUMN_PointsCombat:
                CRI.Text = string(DHGRI.TeamScores[TeamIndex].CategoryScores[class'DHScoreCategory_Combat'.default.CategoryIndex]);
                break;
            case COLUMN_PointsSupport:
                CRI.Text = string(DHGRI.TeamScores[TeamIndex].CategoryScores[class'DHScoreCategory_Support'.default.CategoryIndex]);
                break;
            case COLUMN_Deaths:
                CRI.Text = string(DHGRI.TeamScores[TeamIndex].Deaths);
                break;
            default:
                CRI.Text = "";
                break;
        }
    }
}

// TODO: use this to draw row backgrounds for all cells (move it out of DHDrawCell)
function DrawRowBackground(Canvas C, float XPos, float YPos, float Width, float Height, Color Color)
{
    C.SetOrigin(XPos, YPos);
    C.SetClip(XPos + Width, YPos + Height);
    C.SetPos(0.0, 0.0);
    C.DrawColor = Color;
    C.DrawRect(Texture'WhiteSquareTexture', C.ClipX - C.OrgX, C.ClipY - C.OrgY);
    C.SetOrigin(0.0, 0.0);
    C.SetClip(C.SizeX, C.SizeY);
}

// Modified to add a drop shadow to the text drawing (& also to remove unused variables)
function DHDrawCell(Canvas C, coerce string Text, byte Align, float XPos, float YPos, float Width, float Height, Color F, optional Material Icon, optional float U, optional float V, optional float UL, optional float VL)
{
    local float XL;

    C.SetOrigin(XPos, YPos);
    C.SetClip(XPos + Width, YPos + Height);
    C.SetPos(0.0, 0.0);

    if (Icon != none)
    {
        C.DrawColor = class'UColor'.default.White;
        XL = Height * ((1.0 + UL) / (1.0 + VL));
        C.SetPos(0.0, 0.0);
        C.DrawTile(Icon, XL, Height, U, V, UL, VL);
        XPos += XL + 4.0;
    }

    if (Text != "")
    {
        C.DrawColor = class'UColor'.default.Black;
        C.DrawColor.A = 128;
        C.DrawTextJustified(Text, Align, XPos + 1, YPos + 1, C.ClipX, C.ClipY);

        C.DrawColor = F;
        C.DrawTextJustified(Text, Align, XPos, YPos, C.ClipX, C.ClipY);
    }

    C.SetOrigin(0.0, 0.0);
    C.SetClip(C.SizeX, C.SizeY);
}

defaultproperties
{
    TabSpaces="    "
    LargeTabSpaces="        "

    ScoreboardColumns(0)=(Title="#",Type=COLUMN_SquadMemberIndex,Width=1.5,Justification=1,bFriendlyOnly=true)
    ScoreboardColumns(1)=(Type=COLUMN_PlayerName,Width=5.0)
    ScoreboardColumns(2)=(Title="",Type=COLUMN_Flag,Width=0.75)
    ScoreboardColumns(3)=(Title="Role",Type=COLUMN_Role,Width=5.0,bFriendlyOnly=true)
    ScoreboardColumns(4)=(Title="",Type=COLUMN_PointsCombat,Width=1.5,bFriendlyOnly=true,IconMaterial=Material'DH_InterfaceArt2_tex.Icons.points_combat')
    ScoreboardColumns(5)=(Title="",Type=COLUMN_PointsSupport,Width=1.5,bFriendlyOnly=true,IconMaterial=Material'DH_InterfaceArt2_tex.Icons.points_support')
    ScoreboardColumns(6)=(Title="K",Type=COLUMN_Kills,Width=0.75,Justification=1,bRoundEndOnly=true)
    ScoreboardColumns(7)=(Title="D",Type=COLUMN_Deaths,Width=0.75,Justification=1,bRoundEndOnly=true)
    ScoreboardColumns(8)=(Title="Score",Type=COLUMN_Score,Width=1.5,Justification=1)
    ScoreboardColumns(9)=(Title="Ping",Type=COLUMN_Ping,Width=1.0,Justification=1)

    ScoreboardLabelColor=(R=128,G=128,B=128)
    SquadHeaderColor=(R=64,G=64,B=64,A=192)
    PlayerBackgroundColor=(R=0,G=0,B=0,A=192)
    SelfBackgroundColor=(R=32,G=32,B=32,A=224)

    TeamColors(0)=(B=80,G=80,R=200)
    TeamColors(1)=(B=75,G=150,R=80)
    HudClass=class'DH_Engine.DHHud'
    NameLength=7.0
    RoleLength=4.0
    ScoreLength=1.5
    PingLength=1.5
    MyTeamIndex=2
    PlayersText="Players"
    TickHealthText="Tick: "
    NetHealthText="Loss: "
    MunitionPercentageText="Munitions"
    PatronLeadMaterial=Texture'DH_InterfaceArt2_tex.Patron_Icons.PATRON_Lead'
    PatronBronzeMaterial=Texture'DH_InterfaceArt2_tex.Patron_Icons.PATRON_Bronze'
    PatronSilverMaterial=Texture'DH_InterfaceArt2_tex.Patron_Icons.PATRON_Silver'
    PatronGoldMaterial=Texture'DH_InterfaceArt2_tex.Patron_Icons.PATRON_Gold'
    DeveloperIconMaterial=Texture'DH_InterfaceArt2_tex.HUD.developer'
    FlagsTexture=Texture'DH_InterfaceArt2_tex.Scoreboard.Flags'
}
