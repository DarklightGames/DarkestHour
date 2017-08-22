//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
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

var localized string SquadLeaderAbbreviation;

var color SquadHeaderColor;
var color PlayerBackgroundColor;
var color SelfBackgroundColor;

var array<DHPlayerReplicationInfo> AxisPRI, AlliesPRI, UnassignedPRI;

enum EScoreboardColumnType
{
    COLUMN_SquadMemberIndex,
    COLUMN_PlayerName,
    COLUMN_Role,
    COLUMN_Score,
    COLUMN_Kills,
    COLUMN_Deaths,
    COLUMN_Ping
};

struct ScoreboardColumn
{
    var localized string Title;
    var EScoreboardColumnType Type;
    var float Width;
    var bool bFriendlyOnly;
    var byte Justification;
};

struct CellRenderInfo
{
    var string  Text;
    var color   TextColor;
    var byte    Justification;
    var bool    bDrawBacking;
    var color   BackingColor;
};

var array<ScoreboardColumn> ScoreboardColumns;

function array<int> GetScoreboardColumnIndicesForTeam(int TeamIndex)
{
    local array<int> ScoreboardColumnIndices;
    local int i;

    for (i = 0; i < ScoreboardColumns.Length; ++i)
    {
        if (ScoreboardColumns[i].bFriendlyOnly && MyTeamIndex != TeamIndex)
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

function GetScoreboardColumnRenderInfo(int ScoreboardColumnIndex, DHPlayerReplicationInfo PRI, out CellRenderInfo CRI)
{
    CRI.bDrawBacking = true;
    CRI.BackingColor = PlayerBackgroundColor;
    CRI.Justification = ScoreboardColumns[ScoreboardColumnIndex].Justification;

    if (PRI.bAdmin)
    {
        CRI.TextColor = class'UColor'.default.White;
    }
    else
    {
        CRI.TextColor = class'DHColor'.default.TeamColors[PRI.Team.TeamIndex];
    }

    if (PRI == MyPRI)
    {
        CRI.BackingColor = SelfBackgroundColor;
    }

    switch (ScoreboardColumns[ScoreboardColumnIndex].Type)
    {
        case COLUMN_SquadMemberIndex:
            if (PRI.SquadMemberIndex == 0)
            {
                CRI.Text = SquadLeaderAbbreviation;
            }
            else if (PRI.SquadMemberIndex != -1)
            {
                CRI.Text = string(PRI.SquadMemberIndex + 1);
            }
            else
            {
                CRI.Text = "";
            }
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
        case COLUMN_Score:
            CRI.Text = string(int(PRI.Score));
            break;
        case COLUMN_Ping:
            CRI.Text = string(4 * PRI.Ping);
            break;
        case COLUMN_Kills:
            CRI.Text = string(PRI.Kills);
            break;
        case COLUMN_Deaths:
            CRI.Text = string(int(PRI.Deaths));
            break;
    }
}

// Modified to create a special 'PRIComparator' object that is used to efficiently sort each team array, with variable methods of sorting
// Note the bAlphaSortScoreBoard option can only be enabled by changing the config file before playing, not during the game, so no need to check which option after this
simulated function PostBeginPlay()
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
simulated function SortPRIArray();
simulated function bool InOrder(PlayerReplicationInfo P1, PlayerReplicationInfo P2) { return true;}

// Emptied out as these ROScoreBoard functions were never used, so just to de-clutter & avoid possible confusion
simulated function float DrawTeam(Canvas C, int TeamNum, float YPos, int PlayerCount) { return 0.0;}
simulated function float DrawHeaders(Canvas C) { return 0.0;}

// TODO: A lot of this doesn't need to happen every frame.
// Modified to re-factor to substantially reduce repetition & use of literals,
// also simplifying, making clearer & removing some redundancy.
// Also adds some extra information in the scoreboard header.
simulated function UpdateScoreBoard(Canvas C)
{
    local class<DHHud> HUD;
    local string S;
    local float LineHeight, X, Y, XL, YL;
    local int i;

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
    C.DrawRect(texture'WhiteSquareTexture', C.ClipX, C.ClipY);

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

    //C.Font = HUD.static.GetConsoleFont(C);
    //C.DrawTextJustified(Left(DHGRI.ServerName, 64), 1, 0.0, 0.0, C.ClipX, Y);

    // TODO: draw server name somewhere

    // Now set standard font & line height
    C.Font = HUD.static.GetConsoleFont(C);
    C.TextSize("Text", XL, BaseLineHeight);
    LineHeight = BaseLineHeight * 1.25;

    // Construct a line with various information about the round & the server
    s = HUD.default.TimeRemainingText; // start with the round timer (time remaining)

    if (DHGRI.RoundDuration == 0)
    {
        s $= HUD.default.NoTimeLimitText;
    }
    else
    {
        s $= class'TimeSpan'.static.ToString(DHGRI.GetRoundTimeRemaining());
    }

    // Add time elapsed (extra in DH)
    S $= HUD.default.SpacingText $ HUD.default.TimeElapsedText $ HUD.static.GetTimeString(GRI.ElapsedTime - DHGRI.RoundStartTime);

    // Add server IP (optional)
    if (DHGRI.bShowServerIPOnScoreboard && Level.NetMode != NM_Standalone)
    {
        S $= HUD.default.SpacingText $ HUD.default.IPText $ PlayerController(Owner).GetServerIP();
    }

    // Add real world time, at server location (optional)
    if (DHGRI.bShowTimeOnScoreboard)
    {
        S $= HUD.default.SpacingText $ HUD.default.TimeText $ Level.Hour $ ":" $ class'UString'.static.ZFill(Level.Minute, 2)
        @ Level.Month $ "/" $ Level.Day $ "/" $ Level.Year;
    }

    // Add level name (extra in DH)
    s $= HUD.default.SpacingText $ HUD.default.MapNameText $ class'DHLib'.static.GetMapName(Level);

    // Add game type
    S $= HUD.default.SpacingText $ HUD.default.MapGameTypeText $ DHGRI.CurrentGameType;

    Y = CalcY(0.25, C);

    // Draw our round/server info line, with a drop shadow
    C.SetDrawColor(0, 0, 0, 128);
    X = BaseXPos[0];
    C.SetPos(X + 1, Y + 1);
    C.DrawTextClipped(S); // this is the dark 'drop shadow' text, slightly offset from the actual text

    C.DrawColor = HUD.default.WhiteColor;
    C.SetPos(X, Y);
    C.DrawTextClipped(S); // this is the actual text, drawn over the drop shadow

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
            DrawCell(C, s, 0, X, Y, BaseXPos[1] + MaxTeamWidth, LineHeight, false, HUD.default.WhiteColor);
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
    DrawCell(C, S, 0, X, Y, BaseXPos[0] + CalcX(GetScoreboardTeamWidth(AXIS_TEAM_INDEX) + GetScoreboardTeamWidth(ALLIES_TEAM_INDEX) + 0.75, C), LineHeight, false, HUD.default.WhiteColor);
}

simulated function DHDrawTeam(Canvas C, int TeamIndex, array<DHPlayerReplicationInfo> TeamPRI, out float X, out float Y, out float LineHeight)
{
    local string S, TeamName;
    local color  TeamColor;
    local int i, j, TeamTotalScore, SquadIndex;
    local array<int> ScoreboardColumnIndices;
    local CellRenderInfo CRI;
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

    // TODO: Draw flag?!

    DrawCell(C, TeamName @ "-" @ DHGRI.UnitName[TeamIndex], 0, X, Y, TeamWidth, LineHeight, false, TeamColor);

    Y += LineHeight;

    // Draw reinforcements remaining, if on team
    if (MyTeamIndex == TeamIndex || DHGRI.bRoundIsOver)
    {
        if (DHGRI.bIsInSetupPhase)
        {
            DrawCell(C, ReinforcementsText @ ":" @ "???", 0, X, Y, TeamWidth, LineHeight, false, TeamColor);
        }
        else if (DHGRI.SpawnsRemaining[TeamIndex] >= 0)
        {
            DrawCell(C, ReinforcementsText @ ":" @ DHGRI.SpawnsRemaining[TeamIndex], 0, X, Y, TeamWidth, LineHeight, false, TeamColor);
        }
        else
        {
            DrawCell(C, ReinforcementsText @ ":" @ DHGRI.ReinforcementsInfiniteText, 0, X, Y, TeamWidth, LineHeight, false, TeamColor);
        }
    }

    if (DHGRI.CurrentAlliedToAxisRatio != 0.5)
    {
        DrawCell(C, DHGRI.ForceScaleText @ ":" @ DHGRI.GetTeamScaleString(TeamIndex), 0, BaseXPos[TeamIndex] + NameLength, Y, MaxTeamWidth, LineHeight, false, TeamColor);
    }

    // Draw rounds won/remaining for the team if not limited to 1 round
    if (GRI.RoundLimit > 1)
    {
        S = RoundsWonText @ ":" @ int(GRI.Teams[TeamIndex].Score);

        if (GRI.RoundLimit != 0) // add round limit, if more than 1 round is specified
        {
            S $= "/" $ GRI.RoundLimit;
        }

        Y += LineHeight;

        DrawCell(C, S, 0, X, Y, MaxTeamWidth, LineHeight, false, TeamColor);
    }

    //==========================================================================
    // COLUMN HEADERS
    //==========================================================================
    Y += LineHeight;

    ScoreboardColumnIndices = GetScoreboardColumnIndicesForTeam(TeamIndex);

    for (i = 0; i < ScoreboardColumnIndices.Length; ++i)
    {
        DrawCell(C, ScoreboardColumns[ScoreboardColumnIndices[i]].Title, ScoreboardColumns[ScoreboardColumnIndices[i]].Justification, X, Y, CalcX(ScoreboardColumns[ScoreboardColumnIndices[i]].Width, C), LineHeight, true, class'UColor'.default.White, TeamColor);
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
            DrawCell(C, "    " $ SRI.GetSquadName(TeamIndex, SquadIndex) @ "(" $ SquadMembers.Length $ "/" $ SRI.GetTeamSquadSize(TeamIndex) $ ")", 0, X, Y, TeamWidth, LineHeight, true, class'UColor'.default.White, SquadHeaderColor);

            // Increment the Y value
            Y += LineHeight;

            // Sort the squad members.
            class'USort'.static.Sort(SquadMembers, PRIComparator);

            // Set the line height to be slightly smaller than the base line height
            LineHeight = BaseLineHeight;

            // Draw all squad members
            for (i = 0; i < SquadMembers.Length; ++i)
            {
                // If we've filled all available lines for this team, draw a final "..." to indicate there are more players not listed & exit the loop
                if (i >= MaxPlayersListedPerSide)
                {
                    DrawCell(C, "...", 0, BaseXPos[TeamIndex], Y, NameLength, LineHeight, false, class'UColor'.default.White, HighLightColor);
                    break;
                }

                X = BaseXPos[TeamIndex];

                for (j = 0; j < ScoreboardColumnIndices.Length; ++j)
                {
                    GetScoreboardColumnRenderInfo(ScoreboardColumnIndices[j], SquadMembers[i], CRI);

                    DrawCell(C, CRI.Text, CRI.Justification, X, Y, CalcX(ScoreboardColumns[ScoreboardColumnIndices[j]].Width, C), LineHeight, CRI.bDrawBacking , CRI.TextColor, CRI.BackingColor);
                    X += CalcX(ScoreboardColumns[ScoreboardColumnIndices[j]].Width, C);
                }

                // TODO: remove this??
                // Update axis team's total score
                TeamTotalScore += SquadMembers[i].Score;

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
            if (TeamPRI[i].SquadIndex == -1)
            {
                bHasUnassigned = true;
                break;
            }
        }

        if (bHasUnassigned)
        {
            // Reset the base line height
            LineHeight = BaseLineHeight * 1.25;

    //        if (Y + LineHeight > C.ClipY)
    //        {
    //            break;
    //        }

            // Reset the X position
            X = BaseXPos[TeamIndex];

            // Draw the squad header
            DrawCell(C, "    " $ UnassignedTeamName, 0, X, Y, TeamWidth, LineHeight, true, class'UColor'.default.White, SquadHeaderColor);

            // Increment the Y value
            Y += LineHeight;

            // Rest the base line height
            LineHeight = BaseLineHeight;

            for (i = 0; i < TeamPRI.Length; ++i)
            {
                if (TeamPRI[i].SquadIndex != -1)
                {
                    continue;
                }

                if (Y + LineHeight > C.ClipY)
                {
                    break;
                }

                // If we've filled all available lines for this team, draw a final "..." to indicate there are more players not listed & exit the loop
                if (i >= MaxPlayersListedPerSide)
                {
                    DrawCell(C, "...", 0, BaseXPos[TeamIndex], Y, NameLength, LineHeight, false, class'UColor'.default.White, HighLightColor);
                    break;
                }

                X = BaseXPos[TeamIndex];

                for (j = 0; j < ScoreboardColumnIndices.Length; ++j)
                {
                    GetScoreboardColumnRenderInfo(ScoreboardColumnIndices[j], TeamPRI[i], CRI);

                    DrawCell(C, CRI.Text, CRI.Justification, X, Y, CalcX(ScoreboardColumns[ScoreboardColumnIndices[j]].Width, C), LineHeight, CRI.bDrawBacking, CRI.TextColor, CRI.BackingColor);
                    X += CalcX(ScoreboardColumns[ScoreboardColumnIndices[j]].Width, C);
                }

                // TODO: remove this??
                // Update axis team's total score
                TeamTotalScore += TeamPRI[i].Score;

                // Move to next drawing line (exit drawing axis players if this takes us off the bottom of the screen)
                Y += LineHeight;
            }
        }
    }
    else
    {
        // Set the line height to be slightly smaller than the base line height
        LineHeight = BaseLineHeight;

        for (i = 0; i < TeamPRI.Length; ++i)
        {
            if (Y + LineHeight > C.ClipY)
            {
                break;
            }

            // If we've filled all available lines for this team, draw a final "..." to indicate there are more players not listed & exit the loop
            if (i >= MaxPlayersListedPerSide)
            {
                DrawCell(C, "...", 0, BaseXPos[TeamIndex], Y, NameLength, LineHeight, false, class'UColor'.default.White, HighLightColor);
                break;
            }

            X = BaseXPos[TeamIndex];

            for (j = 0; j < ScoreboardColumnIndices.Length; ++j)
            {
                GetScoreboardColumnRenderInfo(ScoreboardColumnIndices[j], TeamPRI[i], CRI);

                DrawCell(C, CRI.Text, CRI.Justification, X, Y, CalcX(ScoreboardColumns[ScoreboardColumnIndices[j]].Width, C), LineHeight, CRI.bDrawBacking, CRI.TextColor, CRI.BackingColor);
                X += CalcX(ScoreboardColumns[ScoreboardColumnIndices[j]].Width, C);
            }

            // TODO: remove this??
            // Update axis team's total score
            TeamTotalScore += TeamPRI[i].Score;

            // Move to next drawing line (exit drawing axis players if this takes us off the bottom of the screen)
            Y += LineHeight;
        }
    }

    // Calculate average ping for team
    // Need to multiply by 4 because ping gets divided by 4 before replication to net clients (so higher pings fit into one byte)
    if (TeamPRI.Length > 0)
    {
        AvgPing[TeamIndex] *= 4 / TeamPRI.Length;
    }
    else
    {
        AvgPing[TeamIndex] = 0;
    }

    // TODO: figure out a better place to draw the totals (the bottom SUCKS)
    // Draw team totals
    X = BaseXPos[TeamIndex];
    LineHeight = BaseLineHeight * 1.25;

    DrawCell(C, "", 0, X, Y, CalcX(GetScoreboardTeamWidth(TeamIndex), C), LineHeight, true, class'UColor'.default.White, TeamColor);

    MaxTeamYPos = FMax(MaxTeamYPos, Y);
}

// Modified to add a drop shadow to the text drawing (& also to remove unused variables)
simulated function DrawCell(Canvas C, coerce string Text, byte Align, float XPos, float YPos, float Width, float Height, bool bDrawBacking, Color F, optional Color B)
{
    C.SetOrigin(XPos, YPos);
    C.SetClip(XPos + Width, YPos + Height);
    C.SetPos(0.0, 0.0);

    if (bDrawBacking)
    {
        C.DrawColor = B;
        C.DrawRect(texture'WhiteSquaretexture', C.ClipX - C.OrgX, C.ClipY - C.OrgY);
    }

    C.DrawColor = class'UColor'.default.Black;
    C.DrawColor.A = 128;
    C.DrawTextJustified(Text, Align, XPos + 1, YPos + 1, C.ClipX, C.ClipY);

    C.DrawColor = F;
    C.DrawTextJustified(Text, Align, XPos, YPos, C.ClipX, C.ClipY);

    C.SetOrigin(0.0, 0.0);
    C.SetClip(C.SizeX, C.SizeY);
}

defaultproperties
{
    ScoreboardColumns(0)=(Title="#",Type=COLUMN_SquadMemberIndex,Width=1.5,Justification=1,bFriendlyOnly=true)
    ScoreboardColumns(1)=(Title="Name",Type=COLUMN_PlayerName,Width=6.0)
    ScoreboardColumns(2)=(Title="Role",Type=COLUMN_Role,Width=4.0,bFriendlyOnly=true)
//    ScoreboardColumns(3)=(Title="K",Type=COLUMN_Kills,Width=0.75,Justification=1,bFriendlyOnly=true)
//    ScoreboardColumns(4)=(Title="D",Type=COLUMN_Deaths,Width=0.75,Justification=1,bFriendlyOnly=true)
    ScoreboardColumns(3)=(Title="Score",Type=COLUMN_Score,Width=1.5,Justification=1)
    ScoreboardColumns(4)=(Title="Ping",Type=COLUMN_Ping,Width=1.0,Justification=1)

    SquadHeaderColor=(R=64,G=64,B=64,A=192)
    PlayerBackgroundColor=(R=0,G=0,B=0,A=192)
    SelfBackgroundColor=(R=32,G=32,B=32,A=192)

    HeaderImage=texture'DH_GUI_Tex.GUI.DH_Headerbar'
    TeamColors(0)=(B=80,G=80,R=200)
    TeamColors(1)=(B=75,G=150,R=80)
    HudClass=class'DH_Engine.DHHud'
    NameLength=7.0
    RoleLength=4.0
    ScoreLength=1.5
    PingLength=1.5
    MyTeamIndex=2
    SquadLeaderAbbreviation="SL"
}
