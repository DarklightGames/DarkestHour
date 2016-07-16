//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHScoreBoard extends ROScoreBoard;

const DHMAXPERSIDE = 40;
const DHMAXPERSIDEWIDE = 35;

var UComparator PRIComparator;

private static function bool PRIComparatorFunction(Object A, Object B)
{
    return Caps(PlayerReplicationInfo(A).PlayerName) > Caps(PlayerReplicationInfo(B).PlayerName);
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    PRIComparator = new class'UComparator';
    PRIComparator.CompareFunction = PRIComparatorFunction;
}

simulated function UpdateScoreBoard(Canvas C)
{
    local DHPlayerReplicationInfo myPRI, PRI;
    local array<DHPlayerReplicationInfo> GermanPRI, RussianPRI, UnassignedPRI;
    local color  TeamColor, PlayerColor;
    local float  X, Y, CellHeight, XL, YL, LeftY, RightY, CurrentTime;
    local int    i, CurMaxPerSide, GECount, RUCount, UnassignedCount, AxisTotalScore, AlliesTotalScore;
    local int    AxisReqObjCount, AlliesReqObjCount, Axis2ndObjCount, Allies2ndObjCount;
    local string RoleName, S;
    local bool   bHighLight, bRequiredObjectives, bOwnerDrawn;

    myPRI = DHPlayerReplicationInfo(PlayerController(Owner).PlayerReplicationInfo);

    if (myPRI == none)
    {
        return;
    }

    if (C == none)
    {
        return;
    }

    // Widescreen mode uses a different maximum per side setting
    if (float(C.SizeX) / C.SizeY >= 1.6) // 1.6 = 16/10, which is 16:10 ratio and 16:9 comes to 1.77
    {
        CurMaxPerSide = DHMAXPERSIDEWIDE;
    }
    else
    {
        CurMaxPerSide = DHMAXPERSIDE;
    }

    bOwnerDrawn = false;

    Padding = 0.025 * C.SizeX;

    C.Style = 5;
    C.SetDrawColor(0, 0, 0, 128);
    C.SetPos(0.0, 0.0);
    C.DrawRect(texture'WhiteSquaretexture', C.ClipX, C.ClipY);

    C.SetPos(0.0, CalcY(0.5, C));
    C.SetDrawColor(255, 255, 255, 255);
    C.DrawTile(HeaderImage, C.ClipX, CalcY(1.0, C), 0.0, 0.0, 2048.0, 64.0);

    C.SetDrawColor(0, 0, 0, 255);
    C.Font = Class<DHHud>(HudClass).static.GetLargeMenuFont(C);
    C.DrawTextJustified(TitleText, 1, 0.0, 0.0, C.ClipX, CalcY(2, C));
    C.DrawColor = HudClass.default.WhiteColor;
    C.Font = Class<DHHud>(HudClass).static.GetSmallerMenuFont(C);

    C.TextSize("Text", XL, YL);
    CellHeight = YL + (YL * 0.25);

    for (i = 0; i < 4; ++i)
    {
        AvgPing[i] = 0;
    }

    for (i = 0; i < GRI.PRIArray.Length; ++i)
    {
        PRI = DHPlayerReplicationInfo(GRI.PRIArray[i]);

        if (PRI != none)
        {
            if (PRI.bOnlySpectator || PRI.RoleInfo == none)
            {
                UnassignedPRI[UnassignedCount++] = PRI;
            }
            else
            {
                if (PRI.Team != none)
                {
                    switch (PRI.Team.TeamIndex)
                    {
                        case 0:
                            GermanPRI[GECount++] = PRI;
                            break;
                        case 1:
                            RussianPRI[RUCount++] = PRI;
                            break;
                        case 2:
                            UnassignedPRI[UnassignedCount++] = PRI;
                    }

                    AvgPing[PRI.Team.TeamIndex] += 4 * PRI.Ping; // because this is how it is done in ROTeamGame DRR
                }
            }
        }
    }

    for (i = 0; i < arraycount(DHGameReplicationInfo(GRI).DHObjectives); ++i)
    {
        if (DHGameReplicationInfo(GRI).DHObjectives[i] == none)
        {
            continue;
        }

        // Count up the objective types
        if (DHGameReplicationInfo(GRI).DHObjectives[i].ObjState == OBJ_Axis)
        {
            if (DHGameReplicationInfo(GRI).DHObjectives[i].bRequired)
            {
                AxisReqObjCount++;
            }
            else
            {
                bRequiredObjectives = true;
                Axis2ndObjCount++;
            }
        }
        else if (DHGameReplicationInfo(GRI).DHObjectives[i].ObjState == OBJ_Allies)
        {
            if (DHGameReplicationInfo(GRI).DHObjectives[i].bRequired)
            {
                AlliesReqObjCount++;
            }
            else
            {
                bRequiredObjectives = true;
                Allies2ndObjCount++;
            }
        }
    }

    if (RUCount > 0)
    {
        AvgPing[1] /= RUCount;
    }
    else
    {
        AvgPing[1] = 0;
    }

    if (GECount > 0)
    {
        AvgPing[0] /= GECount;
    }
    else
    {
        AvgPing[0] = 0;
    }

    if (bAlphaSortScoreBoard)
    {
        class'USort'.static.Sort(GermanPRI, PRIComparator);
        class'USort'.static.Sort(RussianPRI, PRIComparator);
    }

    if (DHGameReplicationInfo(GRI) != none)
    {
        // Update round timer
        if (!DHGameReplicationInfo(GRI).bMatchHasBegun)
        {
            CurrentTime = DHGameReplicationInfo(GRI).RoundStartTime + DHGameReplicationInfo(GRI).PreStartTime - GRI.ElapsedTime;
        }
        else
        {
            CurrentTime = DHGameReplicationInfo(GRI).RoundEndTime - GRI.ElapsedTime;
        }

        if (DHGameReplicationInfo(GRI).RoundDuration == 0)
        {
            S = class<DHHud>(HudClass).default.TimeRemainingText $ class<DHHud>(HudClass).default.NoTimeLimitText;
        }
        else
        {
            S = class<DHHud>(HudClass).default.TimeRemainingText $ class<DHHud>(HudClass).static.GetTimeString(CurrentTime);
        }

        // Add time elapsed after time remaining
        CurrentTime = GRI.ElapsedTime - DHGameReplicationInfo(GRI).RoundStartTime;
        S $= class<DHHud>(HudClass).default.SpacingText $ class<DHHud>(HudClass).default.TimeElapsedText $ class<DHHud>(HudClass).static.GetTimeString(CurrentTime);

        // Server IP on scoreboard
        if (DHGameReplicationInfo(GRI).bShowServerIPOnScoreboard && Level.NetMode != NM_Standalone && PlayerController(Owner) != none)
        {
            S $= class<DHHud>(HudClass).default.SpacingText $ class<DHHud>(HudClass).default.IPText $ PlayerController(Owner).GetServerIP();
        }

        // Server Time on scoreboard
        if (DHGameReplicationInfo(GRI).bShowTimeOnScoreboard)
        {
            S $= class<DHHud>(HudClass).default.SpacingText $ class<DHHud>(HudClass).default.TimeText $ Level.Hour $ ":" $ class'DHLib'.static.GetNumberString(Level.Minute, 2)
                @ " on " @ Level.Month $ "/" $ Level.Day $ "/" $ Level.Year;
        }

        // Show level name on scoreboard
        S $= class<DHHud>(HudClass).default.SpacingText $ class<DHHud>(HudClass).default.MapNameText $ Left(string(Level), InStr(string(Level), "."));;

        X = CalcX(BaseGermanX, C);
        Y = CalcY(2.0, C);

        // Drop shadow
        C.DrawColor = class'UColor'.default.Black;
        C.DrawColor.A = 128;
        C.SetPos(X + 1, Y + 1);
        C.DrawTextClipped(S);

        C.DrawColor = HudClass.default.WhiteColor;
        C.SetPos(X, Y);
        C.DrawTextClipped(S);
    }

    // Draw German data
    X = CalcX(BaseGermanX, C);
    Y = CalcY(2.0, C);
    Y += CellHeight;
    TeamColor = class'DHColor'.default.TeamColors[0];
    DrawCell(C, TeamNameAxis @ "-" @ DHGameReplicationInfo(GRI).UnitName[0], 0, X, Y, CalcX(13.5, C), CellHeight, false, TeamColor);

    Y += CellHeight;

    DrawCell(C, ReinforcementsText @ ":" @ string(DHGameReplicationInfo(GRI).SpawnsRemaining[0]), 0, X, Y, CalcX(13.5, C), CellHeight, false, TeamColor);

    if (GRI.RoundLimit != 0)
    {
        DrawCell(C, RoundsWonText @ ":" @ string(int(GRI.Teams[0].Score)) $ "/" $ string(GRI.RoundLimit), 0, CalcX(BaseGermanX + 7.0, C), Y, CalcX(13.5, C), CellHeight, false, TeamColor);
    }
    else
    {
        DrawCell(C, RoundsWonText @ ":" @ string(int(GRI.Teams[0].Score)), 0, CalcX(BaseGermanX + 7.0, C), Y, CalcX(13.5, C), CellHeight, false, TeamColor);
    }

    Y += CellHeight;

    if (bRequiredObjectives)
    {
        DrawCell(C, RequiredObjHeldText @ ":" @ string(AxisReqObjCount), 0, X, Y, CalcX(13.5, C), CellHeight, false, TeamColor);
        DrawCell(C, SecondaryObjHeldText @ ":" @ string(Axis2ndObjCount), 0, CalcX(BaseGermanX + 7.0, C), Y, CalcX(13.5, C), CellHeight, false, TeamColor);
    }
    else
    {
        DrawCell(C,ObjectivesHeldText @ ":" @ string(AxisReqObjCount), 0, X, Y, CalcX(13.5, C), CellHeight, false, TeamColor);
    }

    Y += CellHeight;
    DrawCell(C, PlayerText @ "(" $ GECount $ ")", 0, X, Y, CalcX(7.0, C), CellHeight, true, HudClass.default.WhiteColor, TeamColor);

    DrawCell(C, RoleText, 0, CalcX(BaseGermanX + 7.0, C), Y, CalcX(4.0, C), CellHeight, true, HudClass.default.WhiteColor, TeamColor);
    DrawCell(C, ScoreText, 1, CalcX(BaseGermanX + 11.0, C), Y, CalcX(1.5, C), CellHeight, true, HudClass.default.WhiteColor, TeamColor);
    DrawCell(C, PingText, 1, CalcX(BaseGermanX + 12.5, C), Y, CalcX(1.5, C), CellHeight, true, HudClass.default.WhiteColor, TeamColor);
    Y += CellHeight;

    CellHeight = YL * 0.9;
    for (i = 0; i < GECount; ++i)
    {
        // if we're on the last available spot, the owner is on this team, and we haven't drawn the owner's score
        if (i >= CurMaxPerSide - 1 && myPRI.Team != none && myPRI.Team.TeamIndex == AXIS_TEAM_INDEX && !bOwnerDrawn)
        {
            // If this is not the owner, skip it
            if (GermanPRI[i] != myPRI)
            {
                continue;
            }
        }
        else if (i >= CurMaxPerSide)
        {
            //Draw "..." to indicate there are more!
            DrawCell(C,"...", 0, CalcX(BaseGermanX, C), Y, CalcX(7.0, C), CellHeight, bHighLight, HudClass.default.WhiteColor, HighLightColor);
            break;
        }

        if (GermanPRI[i] == myPRI)
        {
            bHighlight = true;
            bOwnerDrawn = true;
        }
        else
        {
            bHighlight = false;
        }

        PlayerColor = TeamColor;

        if (GermanPRI[i].RoleInfo != none)
        {
            if (ROPlayer(Owner) != none && ROPlayer(Owner).bUseNativeRoleNames)
            {
                RoleName = GermanPRI[i].RoleInfo.default.AltName;
            }
            else
            {
                RoleName = GermanPRI[i].RoleInfo.default.MyName;
            }
        }
        else
        {
            RoleName = "";
        }

        // Draw name
        if (Level.NetMode != NM_Standalone && DHGameReplicationInfo(GRI).bPlayerMustReady)
        {
            if (GermanPRI[i].bReadyToPlay || GermanPRI[i].bBot)
            {
                if (GermanPRI[i].bAdmin)
                {
                    // Draw Player name
                    C.StrLen(GermanPRI[i].PlayerName @ AdminText, XL, YL);

                    if ((XL/C.ClipX) > 0.21)
                    {
                        DrawCell(C,GermanPRI[i].PlayerName @ AdminText, 0, CalcX(BaseGermanX, C), Y, CalcX(7.0, C), CellHeight, bHighLight, HudClass.default.WhiteColor, HighLightColor);
                    }
                    else
                    {
                        DrawCell(C,GermanPRI[i].PlayerName @ AdminText, 0, CalcX(BaseGermanX, C), Y, CalcX(7.0, C), CellHeight, bHighLight, HudClass.default.WhiteColor, HighLightColor);
                    }
                }
                else
                {
                    DrawCell(C,GermanPRI[i].PlayerName, 0, CalcX(BaseGermanX, C), Y, CalcX(7.0, C), CellHeight, bHighLight, PlayerColor, HighLightColor);
                }
            }
            else
            {
                if (GermanPRI[i].bAdmin)
                {
                    // Draw Player name
                    C.StrLen(GermanPRI[i].PlayerName $ AdminWaitingText, XL, YL);

                    if ((XL/C.ClipX) > 0.22)
                    {
                        DrawCell(C,GermanPRI[i].PlayerName $ AdminWaitingText, 0, CalcX(BaseGermanX, C), Y, CalcX(7.0, C), CellHeight, bHighLight, HudClass.default.GrayColor, HighLightColor);
                    }
                    else
                    {
                        DrawCell(C,GermanPRI[i].PlayerName $ AdminWaitingText, 0, CalcX(BaseGermanX, C), Y, CalcX(7.0, C), CellHeight, bHighLight, HudClass.default.GrayColor, HighLightColor);
                    }
                }
                else
                {
                    DrawCell(C,GermanPRI[i].PlayerName$WaitingText, 0, CalcX(BaseGermanX, C), Y, CalcX(7.0, C), CellHeight, bHighLight, HudClass.default.GrayColor, HighLightColor);
                }
            }
        }
        else
        {
            if (GermanPRI[i].bAdmin)
            {
                // Draw Player name
                C.StrLen(GermanPRI[i].PlayerName @ AdminText, XL, YL);

                if ((XL/C.ClipX) > 0.21)
                {
                    DrawCell(C,GermanPRI[i].PlayerName @ AdminText, 0, CalcX(BaseGermanX, C), Y, CalcX(7.0, C), CellHeight, bHighLight, HudClass.default.WhiteColor, HighLightColor);
                }
                else
                {
                    DrawCell(C,GermanPRI[i].PlayerName @ AdminText, 0, CalcX(BaseGermanX, C), Y, CalcX(7.0, C), CellHeight, bHighLight, HudClass.default.WhiteColor, HighLightColor);
                }
            }
            else
            {
                DrawCell(C,GermanPRI[i].PlayerName, 0, CalcX(BaseGermanX, C), Y, CalcX(7.0, C), CellHeight, bHighLight, PlayerColor, HighLightColor);
            }
        }

        // Draw rolename
        C.StrLen(RoleName, XL, YL);

        if ((XL/C.ClipX) > 0.13)
        {
            DrawCell(C, RoleName, 0, CalcX(BaseGermanX + 7.0, C), Y, CalcX(4.0, C), CellHeight, bHighLight, PlayerColor, HighLightColor);
        }
        else
        {
            DrawCell(C, RoleName, 0, CalcX(BaseGermanX + 7.0, C), Y, CalcX(4.0, C), CellHeight, bHighLight, PlayerColor, HighLightColor);
        }

        AxisTotalScore += GermanPRI[i].Score;

        DrawCell(C, string(int(GermanPRI[i].Score)), 1, CalcX(BaseGermanX + 11.0, C), Y, CalcX(1.5, C), CellHeight, bHighLight, PlayerColor, HighLightColor);
        DrawCell(C, string(4 * GermanPRI[i].Ping), 1, CalcX(BaseGermanX + 12.5, C), Y, CalcX(1.5, C), CellHeight, bHighLight, PlayerColor, HighLightColor);
        Y += CellHeight;

        if (Y + CellHeight > C.ClipY)
        {
            break;
        }
    }
    CellHeight = YL + (YL * 0.25);

    Y += CellHeight;

    DrawCell(C, TotalsText @ ": ", 0, CalcX(BaseGermanX, C), Y, CalcX(11.0, C), CellHeight, true, HudClass.default.WhiteColor, TeamColor);
    DrawCell(C, string(AxisTotalScore), 1, CalcX(BaseGermanX + 11.0, C), Y, CalcX(1.5, C), CellHeight, true, HudClass.default.WhiteColor, TeamColor);
    DrawCell(C, string(AvgPing[0]), 1, CalcX(BaseGermanX + 12.5, C), Y, CalcX(1.5, C), CellHeight, true, HudClass.default.WhiteColor, TeamColor);

    LeftY = Y;

    // Draw Russian data
    X = CalcX(BaseRussianX, C);
    Y = CalcY(2, C);

    TeamColor = class'DHColor'.default.TeamColors[1];

    Y += CellHeight;
    DrawCell(C, TeamNameAllies @ "-" @ DHGameReplicationInfo(GRI).UnitName[1], 0, X, Y, CalcX(13.5, C), CellHeight, false, TeamColor);
    Y += CellHeight;

    DrawCell(C, ReinforcementsText @ ":" @ string(DHGameReplicationInfo(GRI).SpawnsRemaining[1]), 0, X, Y, CalcX(13.5, C), CellHeight, false, TeamColor);

    if (GRI.RoundLimit != 0)
    {
        DrawCell(C, RoundsWonText @ ":" @ string(int(GRI.Teams[1].Score)) $ "/" $ string(GRI.RoundLimit), 0, CalcX(BaseRussianX + 7.0, C), Y, CalcX(13.5, C), CellHeight, false, TeamColor);
    }
    else
    {
        DrawCell(C, RoundsWonText @ ":" @ string(int(GRI.Teams[1].Score)), 0, CalcX(BaseRussianX + 7.0, C), Y, CalcX(13.5, C), CellHeight, false, TeamColor);
    }

    Y += CellHeight;

    if (bRequiredObjectives)
    {
        DrawCell(C, RequiredObjHeldText @ ":" @ string(AlliesReqObjCount), 0, X, Y, CalcX(13.5, C), CellHeight, false, TeamColor);
        DrawCell(C, SecondaryObjHeldText @ ":" @ string(Allies2ndObjCount), 0, CalcX(BaseRussianX + 7.0, C), Y, CalcX(13.5, C), CellHeight, false, TeamColor);
    }
    else
    {
        DrawCell(C,ObjectivesHeldText @ ":" @ string(AlliesReqObjCount), 0, X, Y, CalcX(13.5, C), CellHeight, false, TeamColor);
    }

    Y += CellHeight;

    DrawCell(C, PlayerText @ "(" $ RUCount $ ")", 0, CalcX(BaseRussianX, C), Y, CalcX(7.0, C), CellHeight, true, HudClass.default.WhiteColor, TeamColor);
    DrawCell(C, RoleText, 0, CalcX(BaseRussianX + 7.0, C), Y, CalcX(4.0, C), CellHeight, true, HudClass.default.WhiteColor, TeamColor);
    DrawCell(C, ScoreText, 1, CalcX(BaseRussianX + 11.0, C), Y, CalcX(1.5, C), CellHeight, true, HudClass.default.WhiteColor, TeamColor);
    DrawCell(C, PingText, 1, CalcX(BaseRussianX + 12.5, C), Y, CalcX(1.5, C), CellHeight, true, HudClass.default.WhiteColor, TeamColor);
    Y += CellHeight;

    CellHeight = YL * 0.9;
    for (i = 0; i < RUCount; ++i)
    {
        // If we're on the last available spot, the owner is on this team, and we haven't drawn the owner's score
        if (i >= CurMaxPerSide - 1 && myPRI.Team != none && myPRI.Team.TeamIndex == ALLIES_TEAM_INDEX && !bOwnerDrawn)
        {
            // If this is not the owner, skip it
            if (RussianPRI[i] != myPRI)
            {
                continue;
            }
        }
        else if (i >= CurMaxPerSide)
        {
            //Draw "..." to indicate there are more!
            DrawCell(C,"...", 0, CalcX(BaseRussianX, C), Y, CalcX(7.0, C), CellHeight, bHighLight, HudClass.default.WhiteColor, HighLightColor);
            break;
        }

        if (RussianPRI[i] == myPRI)
        {
            bHighlight = true;
            bOwnerDrawn = true;
        }
        else
        {
            bHighlight = false;
        }

        PlayerColor = TeamColor;

        if (RussianPRI[i].RoleInfo != none)
        {
            if (ROPlayer(Owner) != none && ROPlayer(Owner).bUseNativeRoleNames)
            {
                RoleName = RussianPRI[i].RoleInfo.default.AltName;
            }
            else
            {
                RoleName = RussianPRI[i].RoleInfo.default.MyName;
            }
        }
        else
        {
            RoleName = "";
        }

        // Draw name
        if (Level.NetMode != NM_Standalone && DHGameReplicationInfo(GRI).bPlayerMustReady)
        {
            if (RussianPRI[i].bReadyToPlay || RussianPRI[i].bBot)
            {
                if (RussianPRI[i].bAdmin)
                {
                    // Draw rolename
                    C.StrLen(RussianPRI[i].PlayerName @ AdminText, XL, YL);

                    if ((XL/C.ClipX) > 0.21)
                    {
                        DrawCell(C, RussianPRI[i].PlayerName @ AdminText, 0, CalcX(BaseRussianX, C), Y, CalcX(7.0, C), CellHeight, bHighLight, HudClass.default.WhiteColor, HighLightColor);
                    }
                    else
                    {
                        DrawCell(C, RussianPRI[i].PlayerName @ AdminText, 0, CalcX(BaseRussianX, C), Y, CalcX(7.0, C), CellHeight, bHighLight, HudClass.default.WhiteColor, HighLightColor);
                    }
                }
                else
                {
                    DrawCell(C,RussianPRI[i].PlayerName, 0, CalcX(BaseRussianX, C), Y, CalcX(7.0, C), CellHeight, bHighLight, PlayerColor, HighLightColor);
                }
            }
            else
            {
                if (RussianPRI[i].bAdmin)
                {
                    // Draw Player name
                    C.StrLen(RussianPRI[i].PlayerName $ AdminWaitingText, XL, YL);

                    if ((XL/C.ClipX) > 0.22)
                    {
                        DrawCell(C, RussianPRI[i].PlayerName $ AdminWaitingText, 0, CalcX(BaseRussianX, C), Y, CalcX(7.0, C), CellHeight, bHighLight, HudClass.default.GrayColor, HighLightColor);
                    }
                    else
                    {
                        DrawCell(C, RussianPRI[i].PlayerName $ AdminWaitingText, 0, CalcX(BaseRussianX, C), Y, CalcX(7.0, C), CellHeight, bHighLight, HudClass.default.GrayColor, HighLightColor);
                    }
                }
                else
                {
                    DrawCell(C, RussianPRI[i].PlayerName$WaitingText, 0, CalcX(BaseRussianX, C), Y, CalcX(7.0, C), CellHeight, bHighLight, HudClass.default.GrayColor, HighLightColor);
                }
            }
        }
        else
        {
            if (RussianPRI[i].bAdmin)
            {
                // Draw rolename
                C.StrLen(RussianPRI[i].PlayerName @ AdminText, XL, YL);

                if ((XL/C.ClipX) > 0.21)
                {
                    DrawCell(C, RussianPRI[i].PlayerName @ AdminText, 0, CalcX(BaseRussianX, C), Y, CalcX(7.0, C), CellHeight, bHighLight, HudClass.default.WhiteColor, HighLightColor);
                }
                else
                {
                    DrawCell(C, RussianPRI[i].PlayerName @ AdminText, 0, CalcX(BaseRussianX, C), Y, CalcX(7.0, C), CellHeight, bHighLight, HudClass.default.WhiteColor, HighLightColor);
                }
            }
            else
            {
                DrawCell(C,RussianPRI[i].PlayerName, 0, CalcX(BaseRussianX, C), Y, CalcX(7.0, C), CellHeight, bHighLight, PlayerColor, HighLightColor);
            }
        }

        // Draw rolename
        C.StrLen(RoleName, XL, YL);

        if ((XL/C.ClipX) > 0.13)
        {
            DrawCell(C, RoleName, 0, CalcX(BaseRussianX + 7.0, C), Y, CalcX(4.0, C), CellHeight, bHighLight, PlayerColor, HighLightColor);
        }
        else
        {
            DrawCell(C, RoleName, 0, CalcX(BaseRussianX + 7.0, C), Y, CalcX(4.0, C), CellHeight, bHighLight, PlayerColor, HighLightColor);
        }

        AlliesTotalScore += RussianPRI[i].Score;

        DrawCell(C, string(int(RussianPRI[i].Score)), 1, CalcX(BaseRussianX + 11.0, C), Y, CalcX(1.5, C), CellHeight, bHighLight, PlayerColor, HighLightColor);
        DrawCell(C, string(4 * RussianPRI[i].Ping), 1, CalcX(BaseRussianX + 12.5, C), Y, CalcX(1.5, C), CellHeight, bHighLight, PlayerColor, HighLightColor);
        Y += CellHeight;

        if (Y + CellHeight > C.ClipY)
        {
            break;
        }
    }

    CellHeight = YL + (YL * 0.25);

    Y += CellHeight;

    DrawCell(C, TotalsText @ ": ", 0, CalcX(BaseRussianX, C), Y, CalcX(11.0, C), CellHeight, true, HudClass.default.WhiteColor, TeamColor);
    DrawCell(C, string(AlliesTotalScore), 1, CalcX(BaseRussianX + 11.0, C), Y, CalcX(1.5, C), CellHeight, true, HudClass.default.WhiteColor, TeamColor);
    DrawCell(C, string(AvgPing[1]), 1, CalcX(BaseRussianX + 12.5, C), Y, CalcX(1.5, C), CellHeight, true, HudClass.default.WhiteColor, TeamColor);

    RightY = Y;

    if (LeftY <= RightY)
    {
        Y = RightY;
    }
    else
    {
        Y = LeftY;
    }

    Y += CellHeight + 3; // add some extra spacing above the spectators

    if (Y + CellHeight > C.ClipY)
    {
        return;
    }

    C.TextSize("Text", XL, YL);
    CellHeight = YL + (YL * 0.05);
    S = SpectatorTeamName @ "&" @ UnassignedTeamName @ "(" $ UnassignedCount $ ") : ";

    for (i = 0; i < UnassignedCount; ++i)
    {
        C.TextSize(S $ "," $ UnassignedPRI[i].PlayerName, XL, YL);

        if (CalcX(1, C) + XL > C.ClipX)
        {
            DrawCell(C, S, 0, CalcX(BaseGermanX, C), Y, CalcX(29.0, C), CellHeight, false, HudClass.default.WhiteColor);
            S = "";
            Y = Y + CellHeight;

            if (Y + CellHeight > C.ClipY)
            {
                return;
            }
        }

        if (i < UnassignedCount - 1)
        {
            S = S $ UnassignedPRI[i].PlayerName $ ",";
        }
        else
        {
            S = S $ UnassignedPRI[i].PlayerName;
            DrawCell(C, S, 0, CalcX(BaseGermanX, C), Y, CalcX(29.0, C), CellHeight, false, HudClass.default.WhiteColor);
        }
    }
}

// Colin: Modified to add a drop shadow to the text drawing.
simulated function DrawCell(Canvas C, coerce string Text, byte Align, float XPos, float YPos, float Width, float Height, bool bDrawBacking, Color F, optional Color B)
{
    local float X, Y, XL, YL;

    X = XPos;
    Y = YPos;

    C.TextSize("TEST", XL, YL);
    C.SetOrigin(X, Y);
    C.SetClip(XPos + Width, YPos + Height);

    if (bDrawBacking)
    {
        C.SetPos(0.0, 0.0);
        C.DrawColor = B;
        C.DrawRect(texture'WhiteSquaretexture', C.ClipX - C.OrgX, C.ClipY - C.OrgY);
    }

    if (Text != "")
    {
        C.SetPos(0, 0);

        C.DrawColor = class'UColor'.default.Black;
        C.DrawColor.A = 128;
        C.DrawTextJustified(Text, Align, X + 1, Y + 1, C.ClipX, C.ClipY);

        C.DrawColor = F;
        C.DrawTextJustified(Text, Align, X, Y, C.ClipX, C.ClipY);
    }

    C.SetOrigin(0.0, 0.0);
    C.SetClip(C.SizeX, C.SizeY);
}

defaultproperties
{
    HeaderImage=texture'DH_GUI_Tex.GUI.DH_Headerbar'
    TeamColors(0)=(B=80,G=80,R=200)
    TeamColors(1)=(B=75,G=150,R=80)
    HudClass=class'DH_Engine.DHHud'
}
