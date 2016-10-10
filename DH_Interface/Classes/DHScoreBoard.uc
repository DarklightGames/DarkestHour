//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHScoreBoard extends ROScoreBoard;

const DHMAXPERSIDE = 40;
const DHMAXPERSIDEWIDE = 35;

var UComparator PRIComparator;

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
simulated function SortPRIArray() ;
simulated function bool InOrder(PlayerReplicationInfo P1, PlayerReplicationInfo P2) { return true;}

// Emptied out as these ROScoreBoard functions were never used, so just to de-clutter & avoid possible confusion
simulated function float DrawTeam(Canvas C, int TeamNum, float YPos, int PlayerCount) { return 0.0;}
simulated function float DrawHeaders(Canvas C) { return 0.0;}

// Modified to re-factor to substantially reduce repetition & use of literals, also simplifying, making clearer & removing some redundancy
// Also adds some extra information in the scoreboard header
simulated function UpdateScoreBoard(Canvas C)
{
    local array<ROPlayerReplicationInfo> AxisPRI, AlliesPRI, UnassignedPRI;
    local ROPlayerReplicationInfo        PRI;
    local PlayerReplicationInfo          MyPRI;
    local DHGameReplicationInfo          DHGRI;
    local class<DHHud>                   HUD;
    local color  TeamColor, PlayerNameColor;
    local string NameSuffix, RoleName, s;
    local float  BaseLineHeight, LineHeight, MaxAxisYPos, BaseXPos[2], MaxTeamWidth, X, Y, XL, YL;
    local int    MaxPlayersListedPerSide, RequiredObjCount[2], SecondaryObjCount[2], TeamIndex, TeamTotalScore, i;
    local bool   bHighLight, bOwnerDrawn;

    //////////////////// SET UP ////////////////////

    if (PlayerController(Owner) != none)
    {
        MyPRI = PlayerController(Owner).PlayerReplicationInfo;
        DHGRI = DHGameReplicationInfo(GRI);
        HUD = class<DHHud>(HudClass);
    }

    if (MyPRI == none || DHGRI == none || HUD == none || C == none)
    {
        return;
    }

    C.Style = ERenderStyle.STY_Alpha;
    C.SetDrawColor(0, 0, 0, 128);
    C.SetPos(0.0, 0.0);
    C.DrawRect(texture'WhiteSquaretexture', C.ClipX, C.ClipY);

    if (float(C.SizeX) / float(C.SizeY) >= 1.6)
    {
        MaxPlayersListedPerSide = DHMAXPERSIDEWIDE; // widescreen uses a different maximum per side setting (for 16:10 or 16:9 screen aspect ratio)
    }
    else
    {
        MaxPlayersListedPerSide = DHMAXPERSIDE;
    }

    AvgPing[AXIS_TEAM_INDEX] = 0; // reset
    AvgPing[ALLIES_TEAM_INDEX] = 0;

    // Assign all players to relevant array of PRIs for their team or unassigned/spectators
    for (i = 0; i < GRI.PRIArray.Length; ++i)
    {
        PRI = ROPlayerReplicationInfo(GRI.PRIArray[i]);

        if (PRI != none)
        {
            if (PRI.bOnlySpectator || PRI.RoleInfo == none || PRI.Team == none)
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

                // Temporarily build AvgPing into a total ping total for the team, so later we can calculate an average team ping
                AvgPing[PRI.Team.TeamIndex] += PRI.Ping;
            }
        }
    }

    // Sort the team arrays by whatever method has been specified (by default this is primarily by score, but there is an option to sort alphabetically by name)
    class'USort'.static.Sort(AxisPRI, PRIComparator);
    class'USort'.static.Sort(AlliesPRI, PRIComparator);

    // Count up how many objectives each team holds
    for (i = 0; i < arraycount(DHGRI.DHObjectives); ++i)
    {
        if (DHGRI.DHObjectives[i] != none && DHGRI.DHObjectives[i].ObjState != OBJ_Neutral)
        {
            if (DHGRI.DHObjectives[i].bRequired)
            {
                RequiredObjCount[DHGRI.DHObjectives[i].ObjState]++;
            }
            else
            {
                SecondaryObjCount[DHGRI.DHObjectives[i].ObjState]++;
            }
        }
    }

    // To avoid repeated CalcX calculations & use of literals
    BaseXPos[AXIS_TEAM_INDEX] = CalcX(BaseGermanX, C);
    BaseXPos[ALLIES_TEAM_INDEX] = CalcX(BaseRussianX, C);
    NameLength = CalcX(default.NameLength, C);
    RoleLength = CalcX(default.RoleLength, C);
    ScoreLength = CalcX(default.ScoreLength, C);
    PingLength = CalcX(default.PingLength, C);
    MaxTeamWidth = NameLength + RoleLength + ScoreLength + PingLength;

    //////////// DRAW SCOREBOARD HEADER ////////////

    // Draw scoreboard banner along top of screen
    C.DrawColor = HUD.default.WhiteColor;
    C.SetPos(0.0, 0.0);
    Y = CalcY(1.0, C);
    C.DrawTile(HeaderImage, C.ClipX, Y, 0.0, 0.0, 2048.0, 64.0);

    C.DrawColor = HUD.default.BlackColor;
    C.Font = HUD.static.GetLargeMenuFont(C);
    C.DrawTextJustified(TitleText, 1, 0.0, 0.0, C.ClipX, Y);

    // Now set standard font & line height
    C.Font = HUD.static.GetSmallerMenuFont(C);
    C.TextSize("Text", XL, BaseLineHeight);
    LineHeight = BaseLineHeight * 1.25;

    // Construct a line with various information about the round & the server
    s = HUD.default.TimeRemainingText; // start with the round timer (time remaining)

    if (DHGRI.RoundDuration == 0)
    {
        s $= HUD.default.NoTimeLimitText;
    }
    else if (DHGRI.bMatchHasBegun)
    {
        s $= class'TimeSpan'.static.ToString(DHGRI.RoundEndTime - GRI.ElapsedTime);
    }
    else
    {
        s $= class'TimeSpan'.static.ToString(DHGRI.RoundStartTime + DHGRI.PreStartTime - GRI.ElapsedTime);
    }

    // Add time elapsed (extra in DH)
    s $= HUD.default.SpacingText $ HUD.default.TimeElapsedText $ HUD.static.GetTimeString(GRI.ElapsedTime - DHGRI.RoundStartTime);

    // Add server IP (optional)
    if (DHGRI.bShowServerIPOnScoreboard && Level.NetMode != NM_Standalone)
    {
        s $= HUD.default.SpacingText $ HUD.default.IPText $ PlayerController(Owner).GetServerIP();
    }

    // Add real world time, at server location (optional)
    if (DHGRI.bShowTimeOnScoreboard)
    {
        s $= HUD.default.SpacingText $ HUD.default.TimeText $ Level.Hour $ ":" $ class'UString'.static.ZFill(Level.Minute, 2)
        @ Level.Month $ "/" $ Level.Day $ "/" $ Level.Year;
    }

    // Add level name (extra in DH)
    s $= HUD.default.SpacingText $ HUD.default.MapNameText $ Left(Level, InStr(Level, "."));

    // Add game type
    s $= HUD.default.SpacingText $ HUD.default.MapGameTypeText $ DHGRI.CurrentGameType;

    // Draw our round/server info line, with a drop shadow
    C.DrawColor.A = 128; // DrawColor is already black for shadow
    X = BaseXPos[AXIS_TEAM_INDEX];
    C.SetPos(X + 1, Y + 1);
    C.DrawTextClipped(s);

    C.DrawColor = HUD.default.WhiteColor;
    C.SetPos(X, Y);
    C.DrawTextClipped(s);

    //////////////// DRAW AXIS TEAM ////////////////

    TeamIndex = AXIS_TEAM_INDEX;
    TeamColor = class'DHColor'.default.TeamColors[TeamIndex];

    // Draw axis team header info
    Y += LineHeight;
    DrawCell(C, TeamNameAxis @ "-" @ DHGRI.UnitName[TeamIndex], 0, X, Y, MaxTeamWidth, LineHeight, false, TeamColor);

    Y += LineHeight;

    if (DHGRI.SpawnsRemaining[TeamIndex] >= 0)
    {
        DrawCell(C, ReinforcementsText @ ":" @ DHGRI.SpawnsRemaining[TeamIndex], 0, X, Y, MaxTeamWidth, LineHeight, false, TeamColor);
    }
    else
    {
        DrawCell(C, ReinforcementsText @ ":" @ DHGRI.ReinforcementsInfiniteText, 0, X, Y, MaxTeamWidth, LineHeight, false, TeamColor);
    }

    if (DHGRI.CurrentAlliedToAxisRatio != 0.5)
    {
        DrawCell(C, DHGRI.ForceScaleText @ ":" @ DHGRI.GetTeamScaleString(TeamIndex), 0, BaseXPos[TeamIndex] + NameLength, Y, MaxTeamWidth, LineHeight, false, TeamColor);
    }

    if (GRI.RoundLimit > 1)
    {
        s = RoundsWonText @ ":" @ int(GRI.Teams[TeamIndex].Score);

        if (GRI.RoundLimit != 0) // add round limit, if more than 1 round is specified
        {
            S  $= "/" $ GRI.RoundLimit;
        }

        Y += LineHeight;

        DrawCell(C, s, 0, X, Y, MaxTeamWidth, LineHeight, false, TeamColor);
    }

    Y += LineHeight;

    if (SecondaryObjCount[TeamIndex] > 0)
    {
        DrawCell(C, RequiredObjHeldText @ ":" @ RequiredObjCount[TeamIndex], 0, X, Y, MaxTeamWidth, LineHeight, false, TeamColor);
        DrawCell(C, SecondaryObjHeldText @ ":" @ SecondaryObjCount[TeamIndex], 0, BaseXPos[TeamIndex] + NameLength, Y, MaxTeamWidth, LineHeight, false, TeamColor);
    }
    else
    {
        DrawCell(C, ObjectivesHeldText @ ":" @ RequiredObjCount[TeamIndex], 0, X, Y, MaxTeamWidth, LineHeight, false, TeamColor);
    }

    // Draw axis column headers for players
    Y += LineHeight;
    DrawCell(C, PlayerText @ "(" $ AxisPRI.Length $ ")", 0, X, Y, NameLength, LineHeight, true, HUD.default.WhiteColor, TeamColor);
    DrawCell(C, RoleText, 0, X += NameLength, Y, RoleLength, LineHeight, true, HUD.default.WhiteColor, TeamColor);
    DrawCell(C, ScoreText, 1, X += RoleLength, Y, ScoreLength, LineHeight, true, HUD.default.WhiteColor, TeamColor);
    DrawCell(C, PingText, 1, X += ScoreLength, Y, PingLength, LineHeight, true, HUD.default.WhiteColor, TeamColor);

    // Loop through axis players & draw names, role, score & ping
    Y += LineHeight;
    LineHeight = BaseLineHeight * 0.9; // smaller lines to fit more players on the scoreboard

    for (i = 0; i < AxisPRI.Length; ++i)
    {
        if (AxisPRI[i] == none)
        {
            continue;
        }

        // If we're on the last available line for our own team & we haven't yet drawn our own player, then reserve the last slot for him
        if (i >= MaxPlayersListedPerSide - 1 && MyPRI.Team != none && MyPRI.Team.TeamIndex == TeamIndex && !bOwnerDrawn)
        {
            if (AxisPRI[i] != MyPRI)
            {
                continue;
            }
        }
        // If we've filled all available lines for this team, draw a final "..." to indicate there are more players not listed & exit the loop
        else if (i >= MaxPlayersListedPerSide)
        {
            DrawCell(C,"...", 0, BaseXPos[TeamIndex], Y, NameLength, LineHeight, false, HUD.default.WhiteColor, HighLightColor);
            break;
        }

        // If this is our own player, set it to draw highlighted & record that we've drawn him
        if (AxisPRI[i] == MyPRI)
        {
            bHighlight = true;
            bOwnerDrawn = true;
        }
        else
        {
            bHighlight = false;
        }

        // Set drawing color & any name suffix text
        if (DHGRI.bPlayerMustReady && !AxisPRI[i].bReadyToPlay && !AxisPRI[i].bBot && Level.NetMode != NM_Standalone)
        {
            PlayerNameColor = HUD.default.GrayColor;

            if (AxisPRI[i].bAdmin)
            {
                NameSuffix = AdminWaitingText;
            }
            else
            {
                NameSuffix = WaitingText;
            }
        }
        else if (AxisPRI[i].bAdmin)
        {
            PlayerNameColor = HUD.default.WhiteColor;
            NameSuffix = AdminText;
        }
        else
        {
            PlayerNameColor = TeamColor;
            NameSuffix = "";
        }

        // Get role name
        if (AxisPRI[i].RoleInfo != none)
        {
            if (ROPlayer(Owner) != none && ROPlayer(Owner).bUseNativeRoleNames)
            {
                RoleName = AxisPRI[i].RoleInfo.default.AltName;
            }
            else
            {
                RoleName = AxisPRI[i].RoleInfo.default.MyName;
            }
        }
        else
        {
            RoleName = "";
        }

        // Draw axis player's name, role, score & ping
        X = BaseXPos[TeamIndex];
        DrawCell(C, AxisPRI[i].PlayerName $ NameSuffix, 0, X, Y, NameLength, LineHeight, bHighlight, PlayerNameColor, HighLightColor);
        DrawCell(C, RoleName, 0, X += NameLength, Y, RoleLength, LineHeight, bHighlight, TeamColor, HighLightColor);
        DrawCell(C, int(AxisPRI[i].Score), 1, X += RoleLength, Y, ScoreLength, LineHeight, bHighLight, TeamColor, HighLightColor);
        DrawCell(C, 4 * AxisPRI[i].Ping, 1, X += ScoreLength, Y, PingLength, LineHeight, bHighLight, TeamColor, HighLightColor);

        // Update axis team's total score
        TeamTotalScore += AxisPRI[i].Score;

        // Move to next drawing line (exit drawing axis players if this takes us off the bottom of the screen)
        Y += LineHeight;

        if (Y + LineHeight > C.ClipY)
        {
            break;
        }
    }

    // Calculate average ping for axis team
    // Need to multiply by 4 because ping gets divided by 4 before replication to net clients (so higher pings fit into one byte)
    if (AxisPRI.Length > 0)
    {
        AvgPing[TeamIndex] *= 4 / AxisPRI.Length;
    }
    else
    {
        AvgPing[TeamIndex] = 0;
    }

    // Draw axis team totals
    X = BaseXPos[TeamIndex];
    LineHeight = BaseLineHeight * 1.25;
    Y += LineHeight;
    DrawCell(C, TotalsText @ ": ", 0, X, Y, NameLength + RoleLength, LineHeight, true, HUD.default.WhiteColor, TeamColor);
    DrawCell(C, TeamTotalScore, 1, X += NameLength + RoleLength, Y, ScoreLength, LineHeight, true, HUD.default.WhiteColor, TeamColor);
    DrawCell(C, AvgPing[TeamIndex], 1, X += ScoreLength, Y, PingLength, LineHeight, true, HUD.default.WhiteColor, TeamColor);

    MaxAxisYPos = Y; // record lowest drawing position of axis team, so later we can work out where to start drawing a spectator line

    /////////////// DRAW ALLIES TEAM ///////////////

    TeamIndex = ALLIES_TEAM_INDEX;
    TeamColor = class'DHColor'.default.TeamColors[TeamIndex];
    TeamTotalScore = 0;
    X = BaseXPos[TeamIndex];
    Y = CalcY(1.0, C);

    // Draw allies team header info
    Y += LineHeight;
    DrawCell(C, TeamNameAllies @ "-" @ DHGRI.UnitName[TeamIndex], 0, X, Y, MaxTeamWidth, LineHeight, false, TeamColor);

    Y += LineHeight;

    // Draw reinforcement remaining
    if (DHGRI.SpawnsRemaining[TeamIndex] >= 0)
    {
        DrawCell(C, ReinforcementsText @ ":" @ DHGRI.SpawnsRemaining[TeamIndex], 0, X, Y, MaxTeamWidth, LineHeight, false, TeamColor);
    }
    else
    {
        DrawCell(C, ReinforcementsText @ ":" @ DHGRI.ReinforcementsInfiniteText, 0, X, Y, MaxTeamWidth, LineHeight, false, TeamColor);
    }

    if (DHGRI.CurrentAlliedToAxisRatio != 0.5)
    {
        DrawCell(C, DHGRI.ForceScaleText @ ":" @ DHGRI.GetTeamScaleString(TeamIndex), 0, BaseXPos[TeamIndex] + NameLength, Y, MaxTeamWidth, LineHeight, false, TeamColor);
    }

    // Draw rounds won/remaining for the team if not limited to 1 round
    if (GRI.RoundLimit > 1)
    {
        s = RoundsWonText @ ":" @ int(GRI.Teams[TeamIndex].Score);

        if (GRI.RoundLimit != 0) // add round limit, if more than 1 round is specified
        {
            S  $= "/" $ GRI.RoundLimit;
        }

        Y += LineHeight;

        DrawCell(C, s, 0, X, Y, MaxTeamWidth, LineHeight, false, TeamColor);
    }

    Y += LineHeight;

    if (SecondaryObjCount[TeamIndex] > 0)
    {
        DrawCell(C, RequiredObjHeldText @ ":" @ RequiredObjCount[TeamIndex], 0, X, Y, MaxTeamWidth, LineHeight, false, TeamColor);
        DrawCell(C, SecondaryObjHeldText @ ":" @ SecondaryObjCount[TeamIndex], 0, BaseXPos[TeamIndex] + NameLength, Y, MaxTeamWidth, LineHeight, false, TeamColor);
    }
    else
    {
        DrawCell(C, ObjectivesHeldText @ ":" @ RequiredObjCount[TeamIndex], 0, X, Y, MaxTeamWidth, LineHeight, false, TeamColor);
    }

    // Draw allies column headers for players
    Y += LineHeight;
    DrawCell(C, PlayerText @ "(" $ AlliesPRI.Length $ ")", 0, X, Y, NameLength, LineHeight, true, HUD.default.WhiteColor, TeamColor);
    DrawCell(C, RoleText, 0, X += NameLength, Y, RoleLength, LineHeight, true, HUD.default.WhiteColor, TeamColor);
    DrawCell(C, ScoreText, 1, X += RoleLength, Y, ScoreLength, LineHeight, true, HUD.default.WhiteColor, TeamColor);
    DrawCell(C, PingText, 1, X += ScoreLength, Y, PingLength, LineHeight, true, HUD.default.WhiteColor, TeamColor);

    // Loop through allies players & draw names, role, score & ping
    Y += LineHeight;
    LineHeight = BaseLineHeight * 0.9; // smaller lines to fit more players on the scoreboard

    for (i = 0; i < AlliesPRI.Length; ++i)
    {
        if (AlliesPRI[i] == none)
        {
            continue;
        }

        // If we're on the last available line for our own team & we haven't yet drawn our own player, then reserve the last slot for him
        if (i >= MaxPlayersListedPerSide - 1 && MyPRI.Team != none && MyPRI.Team.TeamIndex == TeamIndex && !bOwnerDrawn)
        {
            if (AlliesPRI[i] != MyPRI)
            {
                continue;
            }
        }
        // If we've filled all available lines for this team, draw a final "..." to indicate there are more players not listed & exit the loop
        else if (i >= MaxPlayersListedPerSide)
        {
            DrawCell(C,"...", 0, BaseXPos[TeamIndex], Y, NameLength, LineHeight, false, HUD.default.WhiteColor, HighLightColor);
            break;
        }

        // If this is our own player, set it to draw highlighted & record that we've drawn him
        if (AlliesPRI[i] == MyPRI)
        {
            bHighlight = true;
            bOwnerDrawn = true;
        }
        else
        {
            bHighlight = false;
        }

        // Set drawing color & any name suffix text
        if (DHGRI.bPlayerMustReady && !AlliesPRI[i].bReadyToPlay && !AlliesPRI[i].bBot && Level.NetMode != NM_Standalone)
        {
            PlayerNameColor = HUD.default.GrayColor;

            if (AlliesPRI[i].bAdmin)
            {
                NameSuffix = AdminWaitingText;
            }
            else
            {
                NameSuffix = WaitingText;
            }
        }
        else if (AlliesPRI[i].bAdmin)
        {
            PlayerNameColor = HUD.default.WhiteColor;
            NameSuffix = AdminText;
        }
        else
        {
            PlayerNameColor = TeamColor;
            NameSuffix = "";
        }

        // Get role name
        if (AlliesPRI[i].RoleInfo != none)
        {
            if (ROPlayer(Owner) != none && ROPlayer(Owner).bUseNativeRoleNames)
            {
                RoleName = AlliesPRI[i].RoleInfo.default.AltName;
            }
            else
            {
                RoleName = AlliesPRI[i].RoleInfo.default.MyName;
            }
        }
        else
        {
            RoleName = "";
        }

        // Draw allies player's name, role, score & ping
        X = BaseXPos[TeamIndex];
        DrawCell(C, AlliesPRI[i].PlayerName $ NameSuffix, 0, X, Y, NameLength, LineHeight, bHighlight, PlayerNameColor, HighLightColor);
        DrawCell(C, RoleName, 0, X += NameLength, Y, RoleLength, LineHeight, bHighlight, TeamColor, HighLightColor);
        DrawCell(C, int(AlliesPRI[i].Score), 1, X += RoleLength, Y, ScoreLength, LineHeight, bHighLight, TeamColor, HighLightColor);
        DrawCell(C, 4 * AlliesPRI[i].Ping, 1, X += ScoreLength, Y, PingLength, LineHeight, bHighLight, TeamColor, HighLightColor);

        // Update allies team's total score
        TeamTotalScore += AlliesPRI[i].Score;

        // Move to next drawing line (exit drawing allies players if this takes us off the bottom of the screen)
        Y += LineHeight;

        if (Y + LineHeight > C.ClipY)
        {
            break;
        }
    }

    // Calculate average ping for allies team
    // Need to multiply by 4 because ping gets divided by 4 before replication to net clients (so higher pings fit into one byte)
    if (AlliesPRI.Length > 0)
    {
        AvgPing[TeamIndex] *= 4 / AlliesPRI.Length;
    }
    else
    {
        AvgPing[TeamIndex] = 0;
    }

    // Draw allies team totals
    LineHeight = BaseLineHeight * 1.25;
    X = BaseXPos[TeamIndex];
    Y += LineHeight;
    DrawCell(C, TotalsText @ ": ", 0, X, Y, NameLength + RoleLength, LineHeight, true, HUD.default.WhiteColor, TeamColor);
    DrawCell(C, TeamTotalScore, 1, X += NameLength + RoleLength, Y, ScoreLength, LineHeight, true, HUD.default.WhiteColor, TeamColor);
    DrawCell(C, AvgPing[TeamIndex], 1, X += ScoreLength, Y, PingLength, LineHeight, true, HUD.default.WhiteColor, TeamColor);

    //////////////// DRAW SPECTATORS ///////////////

    // Draw spectators underneath the biggest team
    if (MaxAxisYPos > Y)
    {
        Y = MaxAxisYPos;
    }

    LineHeight = BaseLineHeight * 1.05;
    X = BaseXPos[AXIS_TEAM_INDEX];
    Y += 1.5 * LineHeight;

    if (Y + LineHeight > C.ClipY)
    {
        return; // spectator line would draw off the bottom of the screen, so stop drawing
    }

    // Construct a spectator line
    s = SpectatorTeamName @ "&" @ UnassignedTeamName @ "(" $ UnassignedPRI.Length $ ") : ";

    for (i = 0; i < UnassignedPRI.Length; ++i)
    {
        C.TextSize(s $ "," $ UnassignedPRI[i].PlayerName, XL, YL); // get the draw length of the player's name (XL)

        if (CalcX(1.0, C) + XL > C.ClipX)
        {
            DrawCell(C, s, 0, X, Y, BaseXPos[ALLIES_TEAM_INDEX] + MaxTeamWidth, LineHeight, false, HUD.default.WhiteColor);
            s = "";
            Y = Y + LineHeight;

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
    DrawCell(C, s, 0, X, Y, BaseXPos[ALLIES_TEAM_INDEX] + MaxTeamWidth, LineHeight, false, HUD.default.WhiteColor);
}

// Colin: modified to add a drop shadow to the text drawing (& also to remove unused variables)
simulated function DrawCell(Canvas C, coerce string Text, byte Align, float XPos, float YPos, float Width, float Height, bool bDrawBacking, Color F, optional Color B)
{
    if (Text != "")
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
}

defaultproperties
{
    HeaderImage=texture'DH_GUI_Tex.GUI.DH_Headerbar'
    TeamColors(0)=(B=80,G=80,R=200)
    TeamColors(1)=(B=75,G=150,R=80)
    HudClass=class'DH_Engine.DHHud'
    NameLength=7.0
    RoleLength=4.0
    ScoreLength=1.5
    PingLength=1.5
    AdminText=" (Admin)"
}
