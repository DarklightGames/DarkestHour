//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHScoreBoard extends ROScoreBoard;

//const MAXPLAYERS = 32;
//const SPECTATOR = 3;
const DHMAXPERSIDE = 25;
const DHMAXPERSIDEWIDE = 25;

var     bool      bColourCheck;     // For flagging when to rerun SetAlliedColour()
var     bool      bFirstRun;        // To force the first run through of SetAlliedColour()

simulated function SetAlliedColour()
{
    local DHGameReplicationInfo DHGRI;

    DHGRI = DHGameReplicationInfo(GRI);

    if (DHGRI != none)
    {
         if (bActorShadows || DHGRI.AlliedNationID == 1)  // Using bActorShadows as a filthy hack to circumvent a messed up package hierarchy
         {
             TeamColors[1].R=64;
             TeamColors[1].G=140;
             TeamColors[1].B=190;
         }
         else if (DHGRI.AlliedNationID == 2)
         {
             TeamColors[1].R=165;
             TeamColors[1].G=155;
             TeamColors[1].B=57;
         }
         else
         {
             TeamColors[1] = default.TeamColors[1];
         }

         bColourCheck = bActorShadows;
         if (!bFirstRun)
             bFirstRun = true;
    }
}

// HACK - Calling SetAlliedColour here because the GRI unfortunately hasn't replicated yet in PostNetBeginPlay
simulated function UpdateScoreBoard (Canvas C)
{
    local ROPlayerReplicationInfo PRI;
    local int i, j, CurMaxPerSide;
    local float X,Y,cellHeight,XL,YL,LeftY,RightY, CurrentTime;
    local color TeamColor;
    local ROPlayerReplicationInfo GermanPRI[32];
    local ROPlayerReplicationInfo RussianPRI[32];
    local ROPlayerReplicationInfo UnassignedPRI[32];
    local int GECount,RUCount,UnassignedCount, AxisTotalScore, AlliesTotalScore;
    local int AxisReqObjCount, AlliesReqObjCount, Axis2ndObjCount, Allies2ndObjCount;
    local string RoleName,S;
    local bool bHighLight, bRequiredObjectives;
    local bool bOwnerDrawn;

    if (C == none)
        return;

    if (bColourCheck != bActorShadows || bFirstRun)
       SetAlliedColour();

    //Widescreen mode uses a different maximum per side setting
    if (float(C.SizeX) / C.SizeY >= 1.60) //1.6 = 16/10 which is 16:10 ratio and 16:9 comes to 1.77
        CurMaxPerSide = DHMAXPERSIDEWIDE;
    else
        CurMaxPerSide = DHMAXPERSIDE;

    bOwnerDrawn = false;

    Padding = 0.025 * C.SizeX;

    C.Style = 5;
    C.SetDrawColor(0,0,0,128);
    C.SetPos(0.0,0.0);
    C.DrawRect(Texture'WhiteSquareTexture',C.ClipX,C.ClipY);

    C.SetPos(0.0,CalcY(0.5,C));
    C.SetDrawColor(255,255,255,255);
    C.DrawTile(HeaderImage,C.ClipX,CalcY(1,C),0.0,0.0,2048.0,64.0);

    C.SetDrawColor(0,0,0,255);
    C.Font = Class<DHHud>(HudClass).static.GetLargeMenuFont(C);
    C.DrawTextJustified(TitleText,1,0.0,0.0,C.ClipX,CalcY(2,C));
    C.DrawColor = HudClass.Default.WhiteColor;
    C.Font = Class<DHHud>(HudClass).static.GetSmallerMenuFont(C);

    C.TextSize("Text",XL,YL);
    cellHeight = YL + (YL * 0.25);

    for (i = 0; i < 4; i++)
        AvgPing[i] = 0;

    for(i = 0; i < GRI.PRIArray.Length; i++)
    {
        PRI = ROPlayerReplicationInfo(GRI.PRIArray[i]);
        if (PRI != none)
        {
            if (PRI.bOnlySpectator || PRI.RoleInfo == none)
                UnassignedPRI[UnassignedCount++] = PRI;
            else
            {
                if (PRI.Team != none)
                {
                    switch(PRI.Team.TeamIndex)
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
                    AvgPing[PRI.Team.TeamIndex] += 4 * PRI.Ping;  // because this is how it is done in ROTeamGame DRR
                }
            }
        }
    }

    for (i = 0; i < arraycount(ROGameReplicationInfo(GRI).Objectives); i++)
    {
        if (ROGameReplicationInfo(GRI).Objectives[i] == none)
            continue;

        // Count up the objective types
        if (ROGameReplicationInfo(GRI).Objectives[i].ObjState == OBJ_Axis)
        {
            if (ROGameReplicationInfo(GRI).Objectives[i].bRequired)
            {
                AxisReqObjCount++;
            }
            else
            {
                bRequiredObjectives=true;
                Axis2ndObjCount++;
            }
        }
        else if (ROGameReplicationInfo(GRI).Objectives[i].ObjState == OBJ_Allies)
        {
            if (ROGameReplicationInfo(GRI).Objectives[i].bRequired)
            {
                AlliesReqObjCount++;
            }
            else
            {
                bRequiredObjectives=true;
                Allies2ndObjCount++;
            }
        }
    }

    if (RUCount > 0)
        AvgPing[1] /= RUCount;
    else
        AvgPing[1] = 0;

    if (GECount > 0)
        AvgPing[0] /= GECount;
    else
        AvgPing[0] = 0;

    if (bAlphaSortScoreBoard)
    {
        for(i=0; i<GECount-1; i++)
            for(j=i+1; j<GECount; j++)
                if (GermanPRI[i].PlayerName > GermanPRI[j].PlayerName)
                {
                    PRI = GermanPRI[i];
                    GermanPRI[i] = GermanPRI[j];
                    GermanPRI[j] = PRI;
                }

        for(i=0; i<RUCount-1; i++)
            for(j=i+1; j<RUCount; j++)
                if (RussianPRI[i].PlayerName > RussianPRI[j].PlayerName)
                {
                    PRI = RussianPRI[i];
                    RussianPRI[i] = RussianPRI[j];
                    RussianPRI[j] = PRI;
                }
    }

    // Draw the round timer
    if (ROGameReplicationInfo(GRI) != none)
    {
        // Update round timer
        if (!ROGameReplicationInfo(GRI).bMatchHasBegun)
            CurrentTime = ROGameReplicationInfo(GRI).RoundStartTime + ROGameReplicationInfo(GRI).PreStartTime - GRI.ElapsedTime;
        else
            CurrentTime = ROGameReplicationInfo(GRI).RoundStartTime + ROGameReplicationInfo(GRI).RoundDuration - GRI.ElapsedTime;

        S = Class<DHHud>(HudClass).default.TimeRemainingText $ Class<DHHud>(HudClass).static.GetTimeString(CurrentTime);

        if (ROGameReplicationInfo(GRI).bShowServerIPOnScoreboard && PlayerController(Owner) != none)
            S $= Class<DHHud>(HudClass).default.SpacingText $ Class<DHHud>(HudClass).default.IPText $ PlayerController(Owner).GetServerIP();

        if (ROGameReplicationInfo(GRI).bShowTimeOnScoreboard)
            S $= Class<DHHud>(HudClass).default.SpacingText $ Class<DHHud>(HudClass).default.TimeText $ Level.Hour$":"$Level.Minute @ " on " @ Level.Month$"/"$Level.Day$"/"$Level.Year;

        X = CalcX(BaseGermanX,C);
        Y = CalcY(2,C);

        C.DrawColor = HudClass.Default.WhiteColor;
        C.SetPos(X, Y);
        C.DrawTextClipped(S);
    }

    // Draw German data
    X = CalcX(BaseGermanX,C);
    Y = CalcY(2,C);
    Y += cellHeight;
    TeamColor = TeamColors[0];
    DrawCell(C,TeamNameAxis$" - "$ROGameReplicationInfo(GRI).UnitName[0],0,X,Y,CalcX(13.5,C),cellHeight, false,TeamColor);

    Y += cellHeight;

    if (PlayerController(Owner).PlayerReplicationInfo.Team.TeamIndex == AXIS_TEAM_INDEX)
        DrawCell(C,ReinforcementsText $ " : " $ string(DHGameReplicationInfo(GRI).DHSpawnCount[0]),0,X,Y,CalcX(13.5,C),cellHeight, false,TeamColor);

    if (GRI.RoundLimit != 0)
        DrawCell(C,RoundsWonText $ " : " $ string(int(GRI.Teams[0].Score))$"/"$string(GRI.RoundLimit),0,CalcX(BaseGermanX + 7,C),Y,CalcX(13.5,C),cellHeight, false,TeamColor);
    else
        DrawCell(C,RoundsWonText $ " : " $ string(int(GRI.Teams[0].Score)),0,CalcX(BaseGermanX + 7,C),Y,CalcX(13.5,C),cellHeight, false,TeamColor);

    Y += cellHeight;
    if (bRequiredObjectives)
    {
        DrawCell(C,RequiredObjHeldText $ " : " $ string(AxisReqObjCount),0,X,Y,CalcX(13.5,C),cellHeight, false,TeamColor);
        DrawCell(C,SecondaryObjHeldText $ " : " $ string(Axis2ndObjCount),0,CalcX(BaseGermanX + 7,C),Y,CalcX(13.5,C),cellHeight, false,TeamColor);
    }
    else
    {
        DrawCell(C,ObjectivesHeldText $ " : " $ string(AxisReqObjCount),0,X,Y,CalcX(13.5,C),cellHeight, false,TeamColor);
    }

    Y += cellHeight;
    DrawCell(C,PlayerText $ " (" $ GECount $ ")",0,X,Y,CalcX(7,C),cellHeight, true,HudClass.Default.WhiteColor,TeamColor);

    DrawCell(C,RoleText,0,CalcX(BaseGermanX + 7,C),Y,CalcX(4.0,C),cellHeight, true,HudClass.Default.WhiteColor,TeamColor);
    DrawCell(C,ScoreText,1,CalcX(BaseGermanX + 11.0,C),Y,CalcX(1.5,C),cellHeight, true,HudClass.Default.WhiteColor,TeamColor);
    DrawCell(C,PingText,1,CalcX(BaseGermanX + 12.5,C),Y,CalcX(1.5,C),cellHeight, true,HudClass.Default.WhiteColor,TeamColor);
    Y += cellHeight;
    for(i = 0; i < GECount; i++)
    {
        //If we're on the last available spot, the owner is on this team, and we haven't drawn the owner's score
        if (i >= CurMaxPerSide - 1 && PlayerController(Owner).PlayerReplicationInfo.Team.TeamIndex == AXIS_TEAM_INDEX && !bOwnerDrawn)
        {
            //If this is not the owner, skip it
            if (GermanPRI[i] != PlayerController(Owner).PlayerReplicationInfo)
                continue;
        }
        else if (i >= CurMaxPerSide)
            break;

        if (GermanPRI[i] == PlayerController(Owner).PlayerReplicationInfo)
        {
            bHighlight = true;
            bOwnerDrawn = true;
        }
        else
            bHighlight = false;

        if (GermanPRI[i].RoleInfo != none)
        {
            if (ROPlayer(Owner) != none && ROPlayer(Owner).bUseNativeRoleNames)
            {
                RoleName = GermanPRI[i].RoleInfo.Default.AltName;
            }
            else
            {
                RoleName = GermanPRI[i].RoleInfo.Default.MyName;
            }
        }
        else
            RoleName = "";

        // Draw name
        if (Level.NetMode != NM_Standalone && ROGameReplicationInfo(GRI).bPlayerMustReady)
        {
            if (GermanPRI[i].bReadyToPlay || GermanPRI[i].bBot)
            {
                if (GermanPRI[i].bAdmin)
                {
                    // Draw Player name
                    C.StrLen(GermanPRI[i].PlayerName$" "$AdminText, XL, YL);
                    if ((XL/C.ClipX) > 0.21)
                    {
                        //C.Font = Class<ROHud>(HudClass).static.GetSmallerMenuFont(C);
                        DrawCell(C,GermanPRI[i].PlayerName$" "$AdminText,0,CalcX(BaseGermanX,C),Y,CalcX(7,C),cellHeight,bHighLight,HudClass.Default.WhiteColor,HighLightColor);
                        //C.Font = Class<ROHud>(HudClass).static.GetSmallMenuFont(C);
                    }
                    else
                    {
                        DrawCell(C,GermanPRI[i].PlayerName$" "$AdminText,0,CalcX(BaseGermanX,C),Y,CalcX(7,C),cellHeight,bHighLight,HudClass.Default.WhiteColor,HighLightColor);
                    }
                }
                else
                {
                    DrawCell(C,GermanPRI[i].PlayerName,0,CalcX(BaseGermanX,C),Y,CalcX(7,C),cellHeight,bHighLight,TeamColor,HighLightColor);
                }
            }
            else
            {
                if (GermanPRI[i].bAdmin)
                {
                    // Draw Player name
                    C.StrLen(GermanPRI[i].PlayerName$AdminWaitingText, XL, YL);
                    if ((XL/C.ClipX) > 0.22)
                    {
                        //C.Font = Class<ROHud>(HudClass).static.GetSmallerMenuFont(C);
                        DrawCell(C,GermanPRI[i].PlayerName$AdminWaitingText,0,CalcX(BaseGermanX,C),Y,CalcX(7,C),cellHeight,bHighLight,HUDClass.default.GrayColor,HighLightColor);
                        //C.Font = Class<ROHud>(HudClass).static.GetSmallMenuFont(C);
                    }
                    else
                    {
                        DrawCell(C,GermanPRI[i].PlayerName$AdminWaitingText,0,CalcX(BaseGermanX,C),Y,CalcX(7,C),cellHeight,bHighLight,HUDClass.default.GrayColor,HighLightColor);
                    }
                }
                else
                {
                    DrawCell(C,GermanPRI[i].PlayerName$WaitingText,0,CalcX(BaseGermanX,C),Y,CalcX(7,C),cellHeight,bHighLight,HUDClass.default.GrayColor,HighLightColor);
                }
            }
        }
        else
        {
            if (GermanPRI[i].bAdmin)
            {
                // Draw Player name
                C.StrLen(GermanPRI[i].PlayerName$" "$AdminText, XL, YL);
                if ((XL/C.ClipX) > 0.21)
                {
                    //C.Font = Class<ROHud>(HudClass).static.GetSmallerMenuFont(C);
                    DrawCell(C,GermanPRI[i].PlayerName$" "$AdminText,0,CalcX(BaseGermanX,C),Y,CalcX(7,C),cellHeight,bHighLight,HudClass.Default.WhiteColor,HighLightColor);
                    //C.Font = Class<ROHud>(HudClass).static.GetSmallMenuFont(C);
                }
                else
                {
                    DrawCell(C,GermanPRI[i].PlayerName$" "$AdminText,0,CalcX(BaseGermanX,C),Y,CalcX(7,C),cellHeight,bHighLight,HudClass.Default.WhiteColor,HighLightColor);
                }
            }
            else
            {
                DrawCell(C,GermanPRI[i].PlayerName,0,CalcX(BaseGermanX,C),Y,CalcX(7,C),cellHeight,bHighLight,TeamColor,HighLightColor);
            }
        }

        // Draw rolename
        C.StrLen(RoleName, XL, YL);
        if ((XL/C.ClipX) > 0.13)
        {
            //C.Font = Class<ROHud>(HudClass).static.GetSmallerMenuFont(C);
            DrawCell(C,RoleName,0,CalcX(BaseGermanX + 7,C),Y,CalcX(4.0,C),cellHeight,bHighLight,TeamColor,HighLightColor);
            //C.Font = Class<ROHud>(HudClass).static.GetSmallMenuFont(C);
        }
        else
        {
            DrawCell(C,RoleName,0,CalcX(BaseGermanX + 7,C),Y,CalcX(4.0,C),cellHeight,bHighLight,TeamColor,HighLightColor);
        }

        AxisTotalScore += GermanPRI[i].Score;

        DrawCell(C,string(int(GermanPRI[i].Score)),1,CalcX(BaseGermanX + 11.0,C),Y,CalcX(1.5,C),cellHeight,bHighLight,TeamColor,HighLightColor);
        DrawCell(C,string(4 * GermanPRI[i].Ping),1,CalcX(BaseGermanX + 12.5,C),Y,CalcX(1.5,C),cellHeight,bHighLight,TeamColor,HighLightColor);
        Y += cellHeight;
        if (Y + cellHeight > C.ClipY)
            break;
    }

    Y += cellHeight;

    DrawCell(C,TotalsText$" : ",0,CalcX(BaseGermanX,C),Y,CalcX(11,C),cellHeight, true,HudClass.Default.WhiteColor,TeamColor);
    DrawCell(C,string(AxisTotalScore),1,CalcX(BaseGermanX + 11.0,C),Y,CalcX(1.5,C),cellHeight, true,HudClass.Default.WhiteColor,TeamColor);
    DrawCell(C,string(AvgPing[0]),1,CalcX(BaseGermanX + 12.5,C),Y,CalcX(1.5,C),cellHeight, true,HudClass.Default.WhiteColor,TeamColor);

    LeftY = Y;

    // Draw Russian data
    X = CalcX(BaseRussianX,C);
    Y = CalcY(2,C);
    TeamColor = TeamColors[1];
    Y += cellHeight;
    DrawCell(C,TeamNameAllies$" - "$ROGameReplicationInfo(GRI).UnitName[1],0,X,Y,CalcX(13.5,C),cellHeight, false,TeamColor);
    Y += cellHeight;

    if (PlayerController(Owner).PlayerReplicationInfo.Team.TeamIndex == ALLIES_TEAM_INDEX)
        DrawCell(C,ReinforcementsText $ " : " $ string(DHGameReplicationInfo(GRI).DHSpawnCount[1]),0,X,Y,CalcX(13.5,C),cellHeight, false,TeamColor);

    if (GRI.RoundLimit != 0)
        DrawCell(C,RoundsWonText $ " : " $ string(int(GRI.Teams[1].Score))$"/"$string(GRI.RoundLimit),0,CalcX(BaseRussianX + 7,C),Y,CalcX(13.5,C),cellHeight, false,TeamColor);
    else
        DrawCell(C,RoundsWonText $ " : " $ string(int(GRI.Teams[1].Score)),0,CalcX(BaseRussianX + 7,C),Y,CalcX(13.5,C),cellHeight, false,TeamColor);
    Y += cellHeight;

    if (bRequiredObjectives)
    {
        DrawCell(C,RequiredObjHeldText $ " : " $ string(AlliesReqObjCount),0,X,Y,CalcX(13.5,C),cellHeight, false,TeamColor);
        DrawCell(C,SecondaryObjHeldText $ " : " $ string(Allies2ndObjCount),0,CalcX(BaseRussianX + 7,C),Y,CalcX(13.5,C),cellHeight, false,TeamColor);
    }
    else
    {
        DrawCell(C,ObjectivesHeldText $ " : " $ string(AlliesReqObjCount),0,X,Y,CalcX(13.5,C),cellHeight, false,TeamColor);
    }
    Y += cellHeight;

    DrawCell(C,PlayerText $ " (" $ RUCount $ ")",0,CalcX(BaseRussianX,C),Y,CalcX(7,C),cellHeight, true,HudClass.Default.WhiteColor,TeamColor);
    DrawCell(C,RoleText,0,CalcX(BaseRussianX + 7,C),Y,CalcX(4.0,C),cellHeight, true,HudClass.Default.WhiteColor,TeamColor);
    DrawCell(C,ScoreText,1,CalcX(BaseRussianX + 11.0,C),Y,CalcX(1.5,C),cellHeight, true,HudClass.Default.WhiteColor,TeamColor);
    DrawCell(C,PingText,1,CalcX(BaseRussianX + 12.5,C),Y,CalcX(1.5,C),cellHeight, true,HudClass.Default.WhiteColor,TeamColor);
    Y += cellHeight;
    for(i = 0; i < RUCount; i++)
    {
        //If we're on the last available spot, the owner is on this team, and we haven't drawn the owner's score
        if (i >= CurMaxPerSide - 1 && PlayerController(Owner).PlayerReplicationInfo.Team.TeamIndex == ALLIES_TEAM_INDEX && !bOwnerDrawn)
        {
            //If this is not the owner, skip it
            if (RussianPRI[i] != PlayerController(Owner).PlayerReplicationInfo)
                continue;
        }
        else if (i >= CurMaxPerSide)
            break;

        if (RussianPRI[i] == PlayerController(Owner).PlayerReplicationInfo)
        {
            bHighlight = true;
            bOwnerDrawn = true;
        }
        else
            bHighlight = false;

        if (RussianPRI[i].RoleInfo != none)
        {
            if (ROPlayer(Owner) != none && ROPlayer(Owner).bUseNativeRoleNames)
            {
                RoleName = RussianPRI[i].RoleInfo.Default.AltName;
            }
            else
            {
                RoleName = RussianPRI[i].RoleInfo.Default.MyName;
            }
        }
        else
            RoleName = "";

        // Draw name
        if (Level.NetMode != NM_Standalone && ROGameReplicationInfo(GRI).bPlayerMustReady)
        {
            if (RussianPRI[i].bReadyToPlay || RussianPRI[i].bBot)
            {
                if (RussianPRI[i].bAdmin)
                {
                    // Draw rolename
                    C.StrLen(RussianPRI[i].PlayerName$" "$AdminText, XL, YL);
                    if ((XL/C.ClipX) > 0.21)
                    {
                        //C.Font = Class<ROHud>(HudClass).static.GetSmallerMenuFont(C);
                        DrawCell(C,RussianPRI[i].PlayerName$" "$AdminText,0,CalcX(BaseRussianX,C),Y,CalcX(7,C),cellHeight,bHighLight,HudClass.Default.WhiteColor,HighLightColor);
                        //C.Font = Class<ROHud>(HudClass).static.GetSmallMenuFont(C);
                    }
                    else
                    {
                        DrawCell(C,RussianPRI[i].PlayerName$" "$AdminText,0,CalcX(BaseRussianX,C),Y,CalcX(7,C),cellHeight,bHighLight,HudClass.Default.WhiteColor,HighLightColor);
                    }
                }
                else
                {
                    DrawCell(C,RussianPRI[i].PlayerName,0,CalcX(BaseRussianX,C),Y,CalcX(7,C),cellHeight,bHighLight,TeamColor,HighLightColor);
                }
            }
            else
            {
                if (RussianPRI[i].bAdmin)
                {
                    // Draw Player name
                    C.StrLen(RussianPRI[i].PlayerName$AdminWaitingText, XL, YL);
                    if ((XL/C.ClipX) > 0.22)
                    {
                        //C.Font = Class<ROHud>(HudClass).static.GetSmallerMenuFont(C);
                        DrawCell(C,RussianPRI[i].PlayerName$AdminWaitingText,0,CalcX(BaseRussianX,C),Y,CalcX(7,C),cellHeight,bHighLight,HUDClass.default.GrayColor,HighLightColor);
                        //C.Font = Class<ROHud>(HudClass).static.GetSmallMenuFont(C);
                    }
                    else
                    {
                        DrawCell(C,RussianPRI[i].PlayerName$AdminWaitingText,0,CalcX(BaseRussianX,C),Y,CalcX(7,C),cellHeight,bHighLight,HUDClass.default.GrayColor,HighLightColor);
                    }
                }
                else
                {
                    DrawCell(C,RussianPRI[i].PlayerName$WaitingText,0,CalcX(BaseRussianX,C),Y,CalcX(7,C),cellHeight,bHighLight,HUDClass.default.GrayColor,HighLightColor);
                }
            }
        }
        else
        {
            if (RussianPRI[i].bAdmin)
            {
                // Draw rolename
                C.StrLen(RussianPRI[i].PlayerName$" "$AdminText, XL, YL);
                if ((XL/C.ClipX) > 0.21)
                {
                    //C.Font = Class<ROHud>(HudClass).static.GetSmallerMenuFont(C);
                    DrawCell(C,RussianPRI[i].PlayerName$" "$AdminText,0,CalcX(BaseRussianX,C),Y,CalcX(7,C),cellHeight,bHighLight,HudClass.Default.WhiteColor,HighLightColor);
                    //C.Font = Class<ROHud>(HudClass).static.GetSmallMenuFont(C);
                }
                else
                {
                    DrawCell(C,RussianPRI[i].PlayerName$" "$AdminText,0,CalcX(BaseRussianX,C),Y,CalcX(7,C),cellHeight,bHighLight,HudClass.Default.WhiteColor,HighLightColor);
                }
            }
            else
            {
                DrawCell(C,RussianPRI[i].PlayerName,0,CalcX(BaseRussianX,C),Y,CalcX(7,C),cellHeight,bHighLight,TeamColor,HighLightColor);
            }
        }

        // Draw rolename
        C.StrLen(RoleName, XL, YL);
        if ((XL/C.ClipX) > 0.13)
        {
            //C.Font = Class<ROHud>(HudClass).static.GetSmallerMenuFont(C);
            DrawCell(C,RoleName,0,CalcX(BaseRussianX + 7,C),Y,CalcX(4.0,C),cellHeight,bHighLight,TeamColor,HighLightColor);
            //C.Font = Class<ROHud>(HudClass).static.GetSmallMenuFont(C);
        }
        else
        {
            DrawCell(C,RoleName,0,CalcX(BaseRussianX + 7,C),Y,CalcX(4.0,C),cellHeight,bHighLight,TeamColor,HighLightColor);
        }

        AlliesTotalScore += RussianPRI[i].Score;

        DrawCell(C,string(int(RussianPRI[i].Score)),1,CalcX(BaseRussianX + 11.0,C),Y,CalcX(1.5,C),cellHeight,bHighLight,TeamColor,HighLightColor);
        DrawCell(C,string(4 * RussianPRI[i].Ping),1,CalcX(BaseRussianX + 12.5,C),Y,CalcX(1.5,C),cellHeight,bHighLight,TeamColor,HighLightColor);
        Y += cellHeight;
        if (Y + cellHeight > C.ClipY)
            break;
    }

    Y += cellHeight;

    DrawCell(C,TotalsText$" : ",0,CalcX(BaseRussianX,C),Y,CalcX(11,C),cellHeight, true,HudClass.Default.WhiteColor,TeamColor);
    DrawCell(C,string(AlliesTotalScore),1,CalcX(BaseRussianX + 11.0,C),Y,CalcX(1.5,C),cellHeight, true,HudClass.Default.WhiteColor,TeamColor);
    DrawCell(C,string(AvgPing[1]),1,CalcX(BaseRussianX + 12.5,C),Y,CalcX(1.5,C),cellHeight, true,HudClass.Default.WhiteColor,TeamColor);

    RightY = Y;

    if (LeftY <= RightY)
        Y = RightY;
    else
        Y = LeftY;

    Y += cellHeight + 3;//Add some extra spacing above the spectators

    if (Y + cellHeight > C.ClipY)
        return;

    //C.Font = Class<ROHud>(HudClass).static.GetSmallerMenuFont(C);
    C.TextSize("Text",XL,YL);
    cellHeight = YL + (YL * 0.05);
    S = SpectatorTeamName $ " & " $ UnassignedTeamName $ " (" $ UnassignedCount $ ") : ";
    for(i = 0; i < UnassignedCount; i++)
    {
        C.TextSize(S $ "," $ UnassignedPRI[i].PlayerName,XL,YL);
        if (CalcX(1,C) + XL > C.ClipX)
        {
            DrawCell(C,S,0,CalcX(BaseGermanX,C),Y,CalcX(29,C),cellHeight, false,HudClass.Default.WhiteColor);
            S = "";
            Y = Y + cellHeight;
            if (Y + cellHeight > C.ClipY)
                return;
        }

        if (i < UnassignedCount - 1)
            S = S $ UnassignedPRI[i].PlayerName $ ",";
        else
        {
            S = S $ UnassignedPRI[i].PlayerName;
            DrawCell(C,S,0,CalcX(BaseGermanX,C),Y,CalcX(29,C),cellHeight, false,HudClass.Default.WhiteColor);
        }
    }
}

defaultproperties
{
     bFirstRun=true
     HeaderImage=Texture'DH_GUI_Tex.GUI.DH_Headerbar'
     TeamColors(0)=(B=80,G=80,R=200)
     TeamColors(1)=(B=75,G=150,R=80)
     HudClass=class'DH_Engine.DHHud'
}
