// *************************************************************************
//
//  ***   DarkestHourGame (TeamGame)   ***
//
// *************************************************************************

class DarkestHourGame extends ROTeamGame;

var     DH_LevelInfo                DHLevelInfo;                // Stores the DH_LevelInfo so we can access its properties

// Ammo resupply
var     DHAmmoResupplyVolume        DHResupplyAreas[10];        // Ammo resupply area

var     array<DHSpawnArea>          DHMortarSpawnAreas;
var     DHSpawnArea                 DHCurrentMortarSpawnArea[2];

var     DH_RoleInfo                 DHAxisRoles[16];
var     DH_RoleInfo                 DHAlliesRoles[16];

var     DHVehicleManager            VehicleManager;

//-----------------------------------------------------------------------------
// PostBeginPlay - Find the level info and objectives
//-----------------------------------------------------------------------------

function PostBeginPlay()
{
    local ROLevelInfo LI;
    local DH_LevelInfo DLI;
    local DHGameReplicationInfo DHGRI;
    local ROMapBoundsNE NE;
    local ROMapBoundsSW SW;
    local ROArtilleryTrigger RAT;
    local DHAmmoResupplyVolume ARV;
    local ROMineVolume MV;
    local int i, j, k, m, n, o, p;
    local SpectatorCam ViewPoint;
    local float MaxPlayerRatio;
    local DHSpawnArea DHSA;

    Super.PostBeginPlay();

    if (MaxIdleTime > 0)
        Level.bKickLiveIdlers = true;
    else
        Level.bKickLiveIdlers = false;

    // Find the ROLevelInfo
    foreach AllActors(class'ROLevelInfo', LI)
    {
        if (LevelInfo == none)
        {
            LevelInfo = LI;
        }
        else
        {
            log("DarkestHourGame: More than one ROLevelInfo detected!");
            break;
        }
    }

    // Find the DH_LevelInfo
    foreach AllActors(class'DH_LevelInfo', DLI)
    {
        if (DHLevelInfo == none)
        {
            DHLevelInfo = DLI;
        }
        else
        {
            log("DarkestHourGame: More than one DH_LevelInfo detected!");
            break;
        }
    }

    if (LevelInfo == none)
    {
        log("DarkestHourGame: No DH_LevelInfo detected!");
    }
    else
    {
        // Spectator Viewpoints
        for (n = 0; n < LevelInfo.EntryCamTags.Length; n++)
        {
            foreach AllActors(class'SpectatorCam', ViewPoint, LevelInfo.EntryCamTags[n])
            {
                ViewPoints[ViewPoints.Length] = ViewPoint;
                //log("Added Viewpoint "$ViewPoint.Tag);
            }
        }

        RoundDuration = LevelInfo.RoundDuration * 60;

        // Setup some GRI stuff
        DHGRI = DHGameReplicationInfo(GameReplicationInfo);

        if (DHGRI == none)
            return;

        DHGRI.bAllowNetDebug = bAllowNetDebug;
        DHGRI.PreStartTime = PreStartTime;
        DHGRI.RoundDuration = RoundDuration;
        DHGRI.bReinforcementsComing[AXIS_TEAM_INDEX] = 0;
        DHGRI.bReinforcementsComing[ALLIES_TEAM_INDEX] = 0;
        DHGRI.ReinforcementInterval[AXIS_TEAM_INDEX] = LevelInfo.Axis.ReinforcementInterval;
        DHGRI.ReinforcementInterval[ALLIES_TEAM_INDEX] = LevelInfo.Allies.ReinforcementInterval;
        DHGRI.UnitName[AXIS_TEAM_INDEX] = LevelInfo.Axis.UnitName;
        DHGRI.UnitName[ALLIES_TEAM_INDEX] = LevelInfo.Allies.UnitName;
        DHGRI.NationIndex[AXIS_TEAM_INDEX] = LevelInfo.Axis.Nation;
        DHGRI.NationIndex[ALLIES_TEAM_INDEX] = LevelInfo.Allies.Nation;
        DHGRI.UnitInsignia[AXIS_TEAM_INDEX] = LevelInfo.Axis.UnitInsignia;
        DHGRI.UnitInsignia[ALLIES_TEAM_INDEX] = LevelInfo.Allies.UnitInsignia;
        DHGRI.MapImage = LevelInfo.MapImage;
        DHGRI.bPlayerMustReady = bPlayersMustBeReady;
        DHGRI.RoundLimit = RoundLimit;
        DHGRI.MaxPlayers = MaxPlayers;
        DHGRI.bShowServerIPOnScoreboard = bShowServerIPOnScoreboard;
        DHGRI.bShowTimeOnScoreboard = bShowTimeOnScoreboard;

        // Artillery
        DHGRI.ArtilleryStrikeLimit[AXIS_TEAM_INDEX] = LevelInfo.Axis.ArtilleryStrikeLimit;
        DHGRI.ArtilleryStrikeLimit[ALLIES_TEAM_INDEX] = LevelInfo.Allies.ArtilleryStrikeLimit;
        DHGRI.bArtilleryAvailable[AXIS_TEAM_INDEX] = 0;
        DHGRI.bArtilleryAvailable[ALLIES_TEAM_INDEX] = 0;
        DHGRI.LastArtyStrikeTime[AXIS_TEAM_INDEX] = LevelInfo.GetStrikeInterval(AXIS_TEAM_INDEX);
        DHGRI.LastArtyStrikeTime[ALLIES_TEAM_INDEX] = LevelInfo.GetStrikeInterval(ALLIES_TEAM_INDEX);
        DHGRI.TotalStrikes[AXIS_TEAM_INDEX] = 0;
        DHGRI.TotalStrikes[ALLIES_TEAM_INDEX] = 0;

        for (k = 0; k < ArrayCount(DHGRI.AxisRallyPoints); k++)
        {
            DHGRI.AlliedRallyPoints[k].OfficerPRI = none;
            DHGRI.AlliedRallyPoints[k].RallyPointLocation = vect(0,0,0);
            DHGRI.AxisRallyPoints[k].OfficerPRI = none;
            DHGRI.AxisRallyPoints[k].RallyPointLocation = vect(0,0,0);
        }

        // Clear help requests array
        for (k = 0; k < ArrayCount(DHGRI.AlliedHelpRequests); k++)
        {
            DHGRI.AlliedHelpRequests[k].OfficerPRI = none;
            DHGRI.AlliedHelpRequests[k].requestType = 255;
            DHGRI.AxisHelpRequests[k].OfficerPRI = none;
            DHGRI.AxisHelpRequests[k].requestType = 255;
        }

        ResetMortarTargets();

        if (LevelInfo.OverheadOffset == OFFSET_90)
        {
            DHGRI.OverheadOffset = 90;
        }
        else if (LevelInfo.OverheadOffset == OFFSET_180)
        {
            DHGRI.OverheadOffset = 180;
        }
        else if (LevelInfo.OverheadOffset == OFFSET_270)
        {
            DHGRI.OverheadOffset = 270;
        }
        else
        {
            DHGRI.OverheadOffset = 0;
        }

        // Store Allied Nationality for customising HUD
        if (DHLevelInfo.AlliedNation == NATION_Britain)
            DHGRI.AlliedNationID = 1;
        else if (DHLevelInfo.AlliedNation == NATION_Canada)
            DHGRI.AlliedNationID = 2;
        else
            DHGRI.AlliedNationID = 0;


        // Find the location of the map bounds
        foreach AllActors(class'ROMapBoundsNE', NE)
        {
             //NorthEastCorner = NE;
             DHGRI.NorthEastBounds = NE.Location;
            // log("Found Northeastcorner");
        }
        foreach AllActors(class'ROMapBoundsSW', SW)
        {
             //SouthWestCorner = SW;
             DHGRI.SouthWestBounds = SW.Location;
            // log("Found SouthWestcorner");
        }

        // Find all the radios
        foreach AllActors(class'ROArtilleryTrigger', RAT)
        {
                if (RAT.TeamCanUse == AT_Axis || RAT.TeamCanUse == AT_Both)
                {
                   DHGRI.AxisRadios[i] = RAT;
                   i++;
                }

        }

        foreach AllActors(class'ROArtilleryTrigger', RAT)
        {
                if (RAT.TeamCanUse == AT_Allies || RAT.TeamCanUse == AT_Both)
                {
                   DHGRI.AlliedRadios[j] = RAT;
                   j++;
                }

        }

        foreach AllActors(class'DHAmmoResupplyVolume', ARV)
        {
            DHResupplyAreas[m] = ARV;
            DHGRI.ResupplyAreas[m].ResupplyVolumeLocation = ARV.Location;
            DHGRI.ResupplyAreas[m].Team = ARV.Team;
            DHGRI.ResupplyAreas[m].bActive = !ARV.bUsesSpawnAreas;
            if (ARV.ResupplyType == RT_Players)
            {
                DHGRI.ResupplyAreas[m].ResupplyType = 0;
            }
            else if (ARV.ResupplyType == RT_Vehicles)
            {
                DHGRI.ResupplyAreas[m].ResupplyType = 1;
            }
            else if (ARV.ResupplyType == RT_All)
            {
                DHGRI.ResupplyAreas[m].ResupplyType = 2;
            }
            m++;
        }

        foreach AllActors(class'ROMineVolume', MV)
        {
            MineVolumes[o] = MV;
            //MineVolumes[o].bActive = !MV.bUsesSpawnAreas
            o++;
        }

        /*
        Added for our overriden DHSpawnArea class.  Saves me having to
        check in subsequent functions repeatedly.  Just lay 'em all out here once.
        Colin Basnett, 2010
        */
        foreach AllActors(class'DHSpawnArea', DHSA)
        {
            if (DHSA.bMortarmanSpawnArea)
                DHMortarSpawnAreas[p++] = DHSA;
        }

        //Scale the Reinforcement limits based on the server's capacity
        if (MaxPlayersOverride != 0 && MaxPlayersOverride < MaxPlayers)
            MaxPlayerRatio = MaxPlayersOverride / 32.0f;
        else
        {
            MaxPlayersOverride = 0;
            MaxPlayerRatio = MaxPlayers / 32.0f;
        }
        LevelInfo.Allies.SpawnLimit *= MaxPlayerRatio;
        LevelInfo.Axis.SpawnLimit *= MaxPlayerRatio;

        log("MaxPlayerRatio = "$MaxPlayerRatio);

        //Make sure MaxTeamDifference is an acceptable value
        if (MaxTeamDifference < 1)
            MaxTeamDifference = 1;

        foreach AllActors(class'DHVehicleManager', VehicleManager)
        {
            break;
        }

        if (VehicleManager == none)
        {
            Warn("DHVehicleManager could not be found");
        }
    }
}

function CheckResupplyVolumes()
{
    local DHGameReplicationInfo DHGRI;
    local int i;

    // Activate any vehicle factories that are actived based on spawn areas
    DHGRI = DHGameReplicationInfo(GameReplicationInfo);
    for(i = 0; i < ArrayCount(DHResupplyAreas); i++)
    {
        if (DHResupplyAreas[i] == none)
            continue;

        if (DHResupplyAreas[i].bUsesSpawnAreas)
        {
            if (DHResupplyAreas[i].Team == AXIS_TEAM_INDEX)
            {
                if ((CurrentTankCrewSpawnArea[AXIS_TEAM_INDEX] != none &&
                    CurrentTankCrewSpawnArea[AXIS_TEAM_INDEX].Tag == DHResupplyAreas[i].Tag) ||
                    CurrentSpawnArea[AXIS_TEAM_INDEX].Tag == DHResupplyAreas[i].Tag)
                {
                     DHGRI.ResupplyAreas[i].bActive = true;
                     DHResupplyAreas[i].Activate();
                }
                else
                {
                    DHGRI.ResupplyAreas[i].bActive = false;
                    DHResupplyAreas[i].Deactivate();
                }
            }

            if (DHResupplyAreas[i].Team == ALLIES_TEAM_INDEX)
            {
                if ((CurrentTankCrewSpawnArea[ALLIES_TEAM_INDEX] != none &&
                    CurrentTankCrewSpawnArea[ALLIES_TEAM_INDEX].Tag == DHResupplyAreas[i].Tag) ||
                    CurrentSpawnArea[ALLIES_TEAM_INDEX].Tag == DHResupplyAreas[i].Tag)
                {
                     DHGRI.ResupplyAreas[i].bActive = true;
                     DHResupplyAreas[i].Activate();
                }
                else
                {
                    DHGRI.ResupplyAreas[i].bActive = false;
                    DHResupplyAreas[i].Deactivate();
                }
            }
        }
        else
        {
            DHGRI.ResupplyAreas[i].bActive = !DHResupplyAreas[i].bUsesSpawnAreas;
            DHResupplyAreas[i].Activate();
        }
    }
}

function CheckMortarmanSpawnAreas()
{
    local int i, j, h, k;
    local DHSpawnArea Best[2];
    local bool bReqsMet, bSomeReqsMet;

    for (i = 0; i < DHMortarSpawnAreas.Length; i++)
    {
        if (!DHMortarSpawnAreas[i].bEnabled)
            continue;

        //axis & (no best | this one has higher precedence)
        if (DHMortarSpawnAreas[i].bAxisSpawn && (Best[AXIS_TEAM_INDEX] == none ||
            DHMortarSpawnAreas[i].AxisPrecedence > Best[AXIS_TEAM_INDEX].AxisPrecedence))
        {
            bReqsMet = true;
            bSomeReqsMet = false;

            for (j = 0; j < DHMortarSpawnAreas[i].AxisRequiredObjectives.Length; j++)
            {
                if (Objectives[DHMortarSpawnAreas[i].AxisRequiredObjectives[j]].ObjState != OBJ_Axis)
                {
                    bReqsMet = false;
                    break;
                }
            }

            for (h = 0; h < DHMortarSpawnAreas[i].AxisRequiredObjectives.Length; h++)
            {
                if (Objectives[DHMortarSpawnAreas[i].AxisRequiredObjectives[h]].ObjState == OBJ_Axis)
                {
                    bSomeReqsMet = true;
                    break;
                }
            }

            if (DHMortarSpawnAreas[i].bIncludeNeutralObjectives)
            {
                for (k = 0; k < DHMortarSpawnAreas[i].NeutralRequiredObjectives.Length; k++)
                {
                    if (Objectives[DHMortarSpawnAreas[i].NeutralRequiredObjectives[k]].ObjState == OBJ_Neutral)
                    {
                        bSomeReqsMet = true;
                        break;
                    }
                }
            }

            if (bReqsMet)
                Best[AXIS_TEAM_INDEX] = DHMortarSpawnAreas[i];
            else if (bSomeReqsMet && DHMortarSpawnAreas[i].TeamMustLoseAllRequired == SPN_Axis)
                Best[AXIS_TEAM_INDEX] = DHMortarSpawnAreas[i];
        }
        //allies & (no best | this one has higher precedence)
        if (DHMortarSpawnAreas[i].bAlliesSpawn &&
            (Best[ALLIES_TEAM_INDEX] == none || DHMortarSpawnAreas[i].AlliesPrecedence > Best[ALLIES_TEAM_INDEX].AlliesPrecedence))
        {
            bReqsMet = true;
            bSomeReqsMet = false;

            for (j = 0; j < DHMortarSpawnAreas[i].AlliesRequiredObjectives.Length; j++)
            {
                if (Objectives[DHMortarSpawnAreas[i].AlliesRequiredObjectives[j]].ObjState != OBJ_Allies)
                {
                    bReqsMet = false;
                    break;
                }
            }

            // Added in conjunction with TeamMustLoseAllRequired enum in SpawnAreas
            // Allows Mappers to force all objectives to be lost/won before moving spawns
            // Instead of just one - Ramm
            for (h = 0; h < DHMortarSpawnAreas[i].AlliesRequiredObjectives.Length; h++)
            {
                if (Objectives[DHMortarSpawnAreas[i].AlliesRequiredObjectives[h]].ObjState == OBJ_Allies)
                {
                    bSomeReqsMet = true;
                    break;
                    //log("Setting Allied  bSomeReqsMet to true");
                }
            }

            // Added in conjunction with bIncludeNeutralObjectives in SpawnAreas
            // allows mappers to have spawns be used when objectives are neutral, not just captured
            if (DHMortarSpawnAreas[i].bIncludeNeutralObjectives)
            {
                for (k = 0; k < DHMortarSpawnAreas[i].NeutralRequiredObjectives.Length; k++)
                {
                    if (Objectives[DHMortarSpawnAreas[i].NeutralRequiredObjectives[k]].ObjState == OBJ_Neutral)
                    {
                        bSomeReqsMet = true;
                        break;
                    }
                }
            }

            if (bReqsMet)
                Best[ALLIES_TEAM_INDEX] = DHMortarSpawnAreas[i];
            else if (bSomeReqsMet && DHMortarSpawnAreas[i].TeamMustLoseAllRequired == SPN_Allies)
                Best[ALLIES_TEAM_INDEX] = DHMortarSpawnAreas[i];
        }
    }

    DHCurrentMortarSpawnArea[AXIS_TEAM_INDEX] = Best[AXIS_TEAM_INDEX];
    DHCurrentMortarSpawnArea[ALLIES_TEAM_INDEX] = Best[ALLIES_TEAM_INDEX];
}

function CheckTankCrewSpawnAreas()
{
    /*
    If you're wondering what I was thinking here, this avoids me having to
    override massive state functions so I could call a fancy CheckMortarmanSpawnAreas
    function.  But since the check functions are always called in sequence together,
    there's no point in doing all that.  I'll just append this to the
    CheckTankCrewSpawnAreas function.
    -Colin, 2010
    */
    super.CheckTankCrewSpawnAreas();

    CheckMortarmanSpawnAreas();
}

function float RatePlayerStart(NavigationPoint N, byte Team, Controller Player)
{
    local PlayerStart P;
    local DH_RoleInfo DHRI;
    local float Score;
    local Controller OtherPlayer;
    local float NextDist;

    P = PlayerStart(N);

    if (P == none || Player == none)
        return -10000000;

    DHRI = DH_RoleInfo(DHPlayerReplicationInfo(Player.PlayerReplicationInfo).RoleInfo);

    if (LevelInfo.bUseSpawnAreas && CurrentSpawnArea[Team] != none)
    {
        if (CurrentTankCrewSpawnArea[Team]!= none && Player != none && DHRI.bCanBeTankCrew)
        {
            if (P.Tag != CurrentTankCrewSpawnArea[Team].Tag)
                return -9000000;
        }

        //----------------------------------------------------------------------
        //Mortar spawn addition.
        //Colin Basnett, 2010
        else if (DHCurrentMortarSpawnArea[Team] != none && Player != none && DHRI != none && DHRI.bCanUseMortars)
        {
            if (P.Tag != DHCurrentMortarSpawnArea[Team].Tag)
                return -9000000;
        }
        else
        {
            if (P.Tag != CurrentSpawnArea[Team].Tag)
                return -9000000;
        }
    }
    else if (Team != P.TeamNumber)
        return -9000000;

    //super(DeathMath).RatePlayerStart(N, Team, Controller);
    //TODO: everything after this is a modified version of DeathMath.RatePlayerStart

    P = PlayerStart(N);

    if ((P == none) || !P.bEnabled || P.PhysicsVolume.bWaterVolume)
        return -10000000;

    //assess candidate
    if (P.bPrimaryStart)
        Score = 10000000;
    else
        Score = 5000000;
    if ((N == LastStartSpot) || (N == LastPlayerStartSpot))
        Score -= 10000.0;
    else
        Score += 3000 * FRand(); //randomize

    for (OtherPlayer = Level.ControllerList; OtherPlayer != none; OtherPlayer = OtherPlayer.NextController)
    {
        if (OtherPlayer.bIsPlayer && (OtherPlayer.Pawn != none))
        {
            if (OtherPlayer.Pawn.Region.Zone == N.Region.Zone)
            {
                Score -= 1500;
            }

            NextDist = VSize(OtherPlayer.Pawn.Location - N.Location);

            if (NextDist < OtherPlayer.Pawn.CollisionRadius + OtherPlayer.Pawn.CollisionHeight)
            {
                Score -= 1000000.0;

            }
            else if ((NextDist < 3000) && FastTrace(N.Location, OtherPlayer.Pawn.Location))
            {
                Score -= (10000.0 - NextDist);
            }
            else if (NumPlayers + NumBots == 2)
            {
                Score += 2 * VSize(OtherPlayer.Pawn.Location - N.Location);

                if (FastTrace(N.Location, OtherPlayer.Pawn.Location))
                {
                    Score -= 10000;
                }
            }
        }
    }

    return FMax(Score, 5);
}

//-----------------------------------------------------------------------------
// SpawnBot - Spawns the bot and randomly give them a role
//-----------------------------------------------------------------------------

function Bot SpawnBot(optional string botName)
{
    local DHBot NewBot;
    local RosterEntry Chosen;
    local UnrealTeamInfo BotTeam;
    local int MyRole;
    local RORoleInfo RI;

    BotTeam = GetBotTeam();
    Chosen = BotTeam.ChooseBotClass(botName);

    if (Chosen.PawnClass == none)
        Chosen.Init(); //amb

    // Change default bot class

    Chosen.PawnClass = class<Pawn>(DynamicLoadObject(DefaultPlayerClassName, class'class'));

    // log("Chose pawn class "$Chosen.PawnClass);
    NewBot = DHBot(Spawn(Chosen.PawnClass.Default.ControllerClass));


    if (NewBot != none)
    {
        InitializeBot(NewBot,BotTeam,Chosen);

        MyRole = GetDHBotNewRole(NewBot,BotTeam.TeamIndex);

        if (MyRole >= 0)
        {
            RI = GetRoleInfo(BotTeam.TeamIndex, MyRole);
        }

        if (MyRole == -1 || RI == none)
        {
            NewBot.Destroy();
            return none;
        }

        NewBot.CurrentRole = MyRole;
        NewBot.DesiredRole = MyRole;

        // Increment the RoleCounter for the new role
        if (BotTeam.TeamIndex == AXIS_TEAM_INDEX)
            DHGameReplicationInfo(GameReplicationInfo).DHAxisRoleCount[NewBot.CurrentRole]++;
        else if (BotTeam.TeamIndex == ALLIES_TEAM_INDEX)
            DHGameReplicationInfo(GameReplicationInfo).DHAlliesRoleCount[NewBot.CurrentRole]++;

        // Tone down the "gamey" bot parameters
        NewBot.Jumpiness = 0.0;
        NewBot.TranslocUse = 0.0;

        // Set the bots favorite weapon to thier primary weapon
        NewBot.FavoriteWeapon=class<ROWeapon>(RI.PrimaryWeapons[0].Item);

        // Tweak the bots abilities and characteristics based on thier role
        switch(RI.PrimaryWeaponType)
        {
            case WT_SMG:
                NewBot.CombatStyle = 1 - (FRand() * 0.2);
                NewBot.Accuracy = 0.3;
                NewBot.StrafingAbility = 0.0;
                break;

            case WT_SemiAuto:
                NewBot.CombatStyle = 0;
                NewBot.Accuracy = 0.5;
                NewBot.StrafingAbility = -1.0;
                break;

            case WT_Rifle:
                NewBot.CombatStyle = -1 + (FRand() * 0.4);
                NewBot.Accuracy = 0.75;
                NewBot.StrafingAbility = -1.0;
                break;

            case WT_LMG:
                NewBot.CombatStyle = -1;
                NewBot.Accuracy = 0.75;
                NewBot.StrafingAbility = -1.0;
                break;

            case WT_Sniper:
                NewBot.CombatStyle = -1;
                NewBot.Accuracy = 1.0;
                NewBot.StrafingAbility = -1.0;
                break;
        }


        DHPlayerReplicationInfo(NewBot.PlayerReplicationInfo).RoleInfo = RI;
        ChangeWeapons(NewBot, -2, -2, -2);
        SetCharacter(NewBot);
    }

    return NewBot;
}

//-----------------------------------------------------------------------------
// GetDHBotNewRole - Get a new random role for a bot. If a new role is
// successfully found the role number for that role will be returned. If
// A role cannot be found, returns -1
// Replaces old GetBotNewRole to use DHBots instead
//-----------------------------------------------------------------------------
function int GetDHBotNewRole(DHBot ThisBot, int BotTeamNum)
{
    local int MyRole, Count, AltRole;

    if (ThisBot != none)
    {
        MyRole = Rand(ArrayCount(DHAxisRoles));

        do
        {
            if (FRand() < LevelInfo.VehicleBotRoleBalance /*0.3*/)
            {
                AltRole = GetVehicleRole(ThisBot.PlayerReplicationInfo.Team.TeamIndex, MyRole);

                if (AltRole != -1)
                {
                    MyRole = AltRole;
                    break;
                }
            }

            // Override to allow bots to use MG/AT for testing purposes
//          if (RoleLimitReached(ThisBot.PlayerReplicationInfo.Team.TeamIndex, MyRole))

            // Temp hack to prevent bots from getting MG roles
            if (RoleLimitReached(ThisBot.PlayerReplicationInfo.Team.TeamIndex, MyRole) || (GetRoleInfo(BotTeamNum, MyRole).PrimaryWeaponType == WT_LMG) ||
                (GetRoleInfo(BotTeamNum, MyRole).PrimaryWeaponType == WT_PTRD))
            {
                Count++;

                if (Count > 10)
                {
                    log("DarkestHourGame: Unable to find a suitable role in SpawnBot()");
                    return -1;
                }
                else
                {
                    MyRole++;

                    //if (MyRole >= ArrayCount(AxisRoles))

                    if ((BotTeamNum == 0 && MyRole >= ArrayCount(DHAxisRoles)) || (BotTeamNum == 1 && MyRole >= ArrayCount(DHAxisRoles)))
                        MyRole = 0;
                }
            }
            else
            {
                break;
            }
        }

        return MyRole;
    }

    return -1;
}

//-----------------------------------------------------------------------------
// ScoreVehicleKill - give player points for destroying an enemy vehicle
//-----------------------------------------------------------------------------
function ScoreVehicleKill(Controller Killer, ROVehicle Vehicle, float Points)
{
    if (Killer == none || Points <= 0 || Killer.PlayerReplicationInfo == none || Killer.GetTeamNum() == Vehicle.GetTeamNum())
        return;

    Killer.PlayerReplicationInfo.Score += Points;
    ScoreEvent(Killer.PlayerReplicationInfo, Points, "Vehicle_kill");
}

//-----------------------------------------------------------------------------
// ScoreMGResupply - give player a point for resupplying an MG gunner
//-----------------------------------------------------------------------------
function ScoreMGResupply(Controller Dropper, Controller Gunner)
{
    local int ResupplyAward;

    if (Dropper == Gunner)
    {
        return;
    }

    else if ((DHPlayerReplicationInfo(Dropper.PlayerReplicationInfo) != none)
        && (DHPlayerReplicationInfo(Dropper.PlayerReplicationInfo).RoleInfo != none))
    {
        ResupplyAward = 5;
        Dropper.PlayerReplicationInfo.Score += ResupplyAward;

        ScoreEvent(Dropper.PlayerReplicationInfo, ResupplyAward, "MG_resupply");
    }
}

//-----------------------------------------------------------------------------
// ScoreATResupply - give player a point for resupplying an AT gunner
//-----------------------------------------------------------------------------
function ScoreATResupply(Controller Dropper, Controller Gunner)
{
    local int ResupplyAward;

    if (Dropper == Gunner)
    {
        return;
    }

    else if ((DHPlayerReplicationInfo(Dropper.PlayerReplicationInfo) != none)
        && (DHPlayerReplicationInfo(Dropper.PlayerReplicationInfo).RoleInfo != none))
    {
        ResupplyAward = 2;
        Dropper.PlayerReplicationInfo.Score += ResupplyAward;

        ScoreEvent(Dropper.PlayerReplicationInfo, ResupplyAward, "AT_resupply");
    }
}

//-----------------------------------------------------------------------------
// ScoreATReload - give player a point for loading an AT gunner
//-----------------------------------------------------------------------------
function ScoreATReload(Controller Loader, Controller Gunner)
{
    local int LoadAward;

    if (Loader == Gunner)
    {
        return;
    }

    else if ((DHPlayerReplicationInfo(Loader.PlayerReplicationInfo) != none)
        && (DHPlayerReplicationInfo(Loader.PlayerReplicationInfo).RoleInfo != none))
    {
        LoadAward = 1;
        Loader.PlayerReplicationInfo.Score += LoadAward;

        ScoreEvent(Loader.PlayerReplicationInfo, LoadAward, "AT_reload");
    }
}

//-----------------------------------------------------------------------------
// ScoreRadioUse - give player a point for resupplying an MG gunner
//-----------------------------------------------------------------------------
function ScoreRadioUsed(Controller Radioman)
{
    local int RadioUsedAward;

    if ((DHPlayerReplicationInfo(Radioman.PlayerReplicationInfo) != none)
        && (DHPlayerReplicationInfo(Radioman.PlayerReplicationInfo).RoleInfo != none))
    {
        RadioUsedAward = 5;
        Radioman.PlayerReplicationInfo.Score += RadioUsedAward;

        ScoreEvent(Radioman.PlayerReplicationInfo, RadioUsedAward, "Radioman_used");
    }
}

//-----------------------------------------------------------------------------
// ScoreMortarResupply - give player two points for resupplying a mortar operator
//-----------------------------------------------------------------------------
function ScoreMortarResupply(Controller Dropper, Controller Gunner)
{
    local int ResupplyAward;

    if (Dropper == none || Dropper == Gunner || Dropper.PlayerReplicationInfo == none)
        return;

    Dropper.PlayerReplicationInfo.Score += 2;
    ScoreEvent(Dropper.PlayerReplicationInfo, ResupplyAward, "Mortar_resupply");
}

//-----------------------------------------------------------------------------
// ScoreMortarSpotAssist - Give spotter a point or two for spotting a kill.
//-----------------------------------------------------------------------------
function ScoreMortarSpotAssist(Controller Spotter, Controller Mortarman)
{
    if (Spotter == none || Spotter == Mortarman ||
    Spotter.PlayerReplicationInfo == none || Mortarman == none ||
    Mortarman.PlayerReplicationInfo == none)
        return;

    Spotter.PlayerReplicationInfo.Score += 2;
    Mortarman.PlayerReplicationInfo.Score += 1;
}

//-----------------------------------------------------------------------------
// ReduceDamage - Handles reduction or elimination of damage
//-----------------------------------------------------------------------------

function int ReduceDamage(int Damage, pawn injured, pawn instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
    // Check if the player has just used a select-a-spawn teleport and should be protected from damage
    if ((InstigatedBy != none) && (Injured != none) && (InstigatedBy != Injured) && (Injured.PlayerReplicationInfo != none) && DH_Pawn(Injured).TeleSpawnProtected())
    {
        return 0;
    }
    else
        Return Super.ReduceDamage(Damage, injured, instigatedBy, HitLocation, Momentum, DamageType);
}

// Stop the game from automatically trimming longer names
event PlayerController Login
(
    string Portal,
    string Options,
    out string Error
)
{
    local string InName;
    local PlayerController NewPlayer;

    InName = Left(ParseOption (Options, "Name"), 32);
    NewPlayer = Super.Login(Portal, Options, Error);
    ChangeName(NewPlayer, InName, false);

    return NewPlayer;
}

// Overridden to increase max name length from 20 to 32 chars
function ChangeName(Controller Other, string S, bool bNameChange)
{
    local Controller APlayer,C, P;

    if (S == "")
        return;

    S = StripColor(s);  // Strip out color codes

    if (Other.PlayerReplicationInfo.playername~=S)
        return;

    S = Left(S,32);
    //ReplaceText(S, " ", "_");
    ReplaceText(S, "\"", "");

    if (bEpicNames && (Bot(Other) != none))
    {
        if (TotalEpic < 21)
        {
            S = EpicNames[EpicOffset % 21];
            EpicOffset++;
            TotalEpic++;
        }
        else
        {
            S = NamePrefixes[NameNumber%10]$"CliffyB"$NameSuffixes[NameNumber%10];
            NameNumber++;
        }
    }

    for(APlayer=Level.ControllerList; APlayer!=none; APlayer=APlayer.nextController)
        if (APlayer.bIsPlayer && (APlayer.PlayerReplicationInfo.playername~=S))
        {
            if (Other.IsA('PlayerController'))
            {
                PlayerController(Other).ReceiveLocalizedMessage(GameMessageClass, 8);
                return;
            }
            else
            {
                if (Other.PlayerReplicationInfo.bIsFemale)
                {
                    S = FemaleBackupNames[FemaleBackupNameOffset%32];
                    FemaleBackupNameOffset++;
                }
                else
                {
                    S = MaleBackupNames[MaleBackupNameOffset%32];
                    MaleBackupNameOffset++;
                }
                for(P=Level.ControllerList; P!=none; P=P.nextController)
                    if (P.bIsPlayer && (P.PlayerReplicationInfo.playername~=S))
                    {
                        S = NamePrefixes[NameNumber%10]$S$NameSuffixes[NameNumber%10];
                        NameNumber++;
                        break;
                    }
                break;
            }
            S = NamePrefixes[NameNumber%10]$S$NameSuffixes[NameNumber%10];
            NameNumber++;
            break;
        }

    if (bNameChange)
        GameEvent("NameChange",s,Other.PlayerReplicationInfo);

    if (S ~= "CliffyB")
        bEpicNames = true;
    Other.PlayerReplicationInfo.SetPlayerName(S);
    // notify local players
    if  (bNameChange)
        for (C=Level.ControllerList; C!=none; C=C.NextController)
            if ((PlayerController(C) != none) && (Viewport(PlayerController(C).Player) != none))
                PlayerController(C).ReceiveLocalizedMessage(class'GameMessage', 2, Other.PlayerReplicationInfo);
}

function BroadcastLastObjectiveMessage(int team_that_is_about_to_win)
{
    BroadcastLocalizedMessage(class'DHLastObjectiveMsg', team_that_is_about_to_win);
}

//-----------------------------------------------------------------------------
// AddDefaultInventory
//-----------------------------------------------------------------------------

function AddDefaultInventory(Pawn aPawn)
{
    if (DH_Pawn(aPawn) != none)
        DH_Pawn(aPawn).AddDefaultInventory();

    SetPlayerDefaults(aPawn);
}

/*
The following is a clusterfuck of hacky overriding of RO's arbitrarily low limit
of roles from 10 to 16.
-Basnett 23/12/2010
*/

function AddRole(RORoleInfo NewRole)
{
    local DHGameReplicationInfo DHGRI;
    local DH_RoleInfo DHRI;

    DHGRI = DHGameReplicationInfo(GameReplicationInfo);
    DHRI = DH_RoleInfo(NewRole);

    if (NewRole.Side == SIDE_Allies)
    {
        if (AlliesRoleIndex >= ArrayCount(DHAlliesRoles))
        {
            warn(NewRole @ "ignored when adding Allied roles to the map, exceeded limit");
            return;
        }

        DHAlliesRoles[AlliesRoleIndex] = DHRI;
        DHGRI.DHAlliesRoles[AlliesRoleIndex] = DHRI;
        AlliesRoleIndex++;
    }
    else
    {
        if (AxisRoleIndex >= ArrayCount(DHAxisRoles))
        {
            warn(NewRole @ "ignored when adding Axis roles to the map, exceeded limit");
            return;
        }

        DHAxisRoles[AxisRoleIndex] = DHRI;
        DHGRI.DHAxisRoles[AxisRoleIndex] = DHRI;
        AxisRoleIndex++;
    }
}

function RORoleInfo GetRoleInfo(int Team, int Num)
{
    if (Team > 1 || Num < 0 || Num >= ArrayCount(DHAxisRoles))
        return none;

    if (Team == AXIS_TEAM_INDEX)
        return DHAxisRoles[Num];
    else if (Team == ALLIES_TEAM_INDEX)
        return DHAlliesRoles[Num];

    return none;
}

function bool RoleLimitReached(int Team, int Num)
{
    local DHGameReplicationInfo DHGRI;

    // This shouldn't even happen, but if it does, just say the limit was reached
    if (Team > 1 || Num < 0 || (Team == AXIS_TEAM_INDEX && DHAxisRoles[Num] == none) || (Team == ALLIES_TEAM_INDEX && DHAlliesRoles[Num] == none) || Num >= ArrayCount(DHAxisRoles))
        return true;

    DHGRI = DHGameReplicationInfo(GameReplicationInfo);

    if (Team == AXIS_TEAM_INDEX && DHAxisRoles[Num].GetLimit(DHGRI.MaxPlayers) != 0 && DHGRI.DHAxisRoleCount[Num] >= DHAxisRoles[Num].GetLimit(DHGRI.MaxPlayers))
        return true;
    else if (Team == ALLIES_TEAM_INDEX && DHAlliesRoles[Num].GetLimit(DHGRI.MaxPlayers) != 0 && DHGRI.DHAlliesRoleCount[Num] >= DHAlliesRoles[Num].GetLimit(DHGRI.MaxPlayers))
        return true;

    return false;
}

function bool HumanWantsRole(int Team, int Num)
{
    local Controller C;
    local ROBot BotHasRole;
    local DHGameReplicationInfo DHGRI;

    // This shouldn't even happen, but if it does, just say the limit was reached
    if (Team > 1 || Num < 0 || (Team == AXIS_TEAM_INDEX && DHAxisRoles[Num] == none) || (Team == ALLIES_TEAM_INDEX && DHAlliesRoles[Num] == none) || Num >= ArrayCount(DHAxisRoles))
        return false;

    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        if (C.PlayerReplicationInfo != none && C.PlayerReplicationInfo.Team != none && C.PlayerReplicationInfo.Team.TeamIndex == Team)
        {
            if (ROBot(C) != none && ROBot(C).CurrentRole == Num)
            {
                BotHasRole = ROBot(C);
                break;
            }
        }
    }

    DHGRI = DHGameReplicationInfo(GameReplicationInfo);

    if (BotHasRole != none)
    {
        BotHasRole.Destroy();

        if (Team == AXIS_TEAM_INDEX)
        {
            DHGRI.DHAxisRoleCount[Num] --;
            DHGRI.DHAxisRoleBotCount[Num] --;
        }
        else if (Team == ALLIES_TEAM_INDEX)
        {
            DHGRI.DHAlliesRoleCount[Num] --;
            DHGRI.DHAlliesRoleBotCount[Num] --;
        }

        return true;
    }

    return false;
}

function int GetVehicleRole(int Team, int Num)
{
    local int i;

    // This shouldn't even happen, but if it does, just say the limit was reached
    if (Team > 1 || Num < 0 || (Team == AXIS_TEAM_INDEX && DHAxisRoles[Num] == none) || (Team == ALLIES_TEAM_INDEX && DHAlliesRoles[Num] == none) || Num >= ArrayCount(DHAxisRoles))
        return -1;

    // Should probably do this team specific in case the teams have different amounts of roles
    for (i = 0; i < ArrayCount(DHAxisRoles); i++)
    {
        if (GetRoleInfo(Team, i) != none && GetRoleInfo(Team, i).bCanBeTankCrew && !RoleLimitReached(Team, i))
        {
            return i;
        }
    }

    return -1;
}

function int GetBotNewRole(ROBot ThisBot, int BotTeamNum)
{
    local int MyRole, Count, AltRole;

    if (ThisBot != none)
    {
        MyRole = Rand(ArrayCount(DHAxisRoles));

        do
        {
            if (FRand() < LevelInfo.VehicleBotRoleBalance /*0.3*/)
            {
                AltRole = GetVehicleRole(ThisBot.PlayerReplicationInfo.Team.TeamIndex, MyRole);

                if (AltRole != -1)
                {
                    MyRole = AltRole;
                    break;
                }
            }

            // Temp hack to prevent bots from getting MG roles
            if (RoleLimitReached(ThisBot.PlayerReplicationInfo.Team.TeamIndex, MyRole) || (GetRoleInfo(BotTeamNum, MyRole).PrimaryWeaponType == WT_LMG) ||
                (GetRoleInfo(BotTeamNum, MyRole).PrimaryWeaponType == WT_PTRD))
            {
                Count++;

                if (Count > ArrayCount(DHAxisRoles))
                {
                    log("ROTeamGame: Unable to find a suitable role in SpawnBot()");
                    return -1;
                }
                else
                {
                    MyRole++;

                    if (MyRole >= ArrayCount(DHAxisRoles))
                        MyRole = 0;
                }
            }
            else
            {
                break;
            }
        }

        return MyRole;
    }

    return -1;
}

function UpdateRoleCounts()
{
    local Controller C;
    local int i;
    local DHGameReplicationInfo DHGRI;

    DHGRI = DHGameReplicationInfo(GameReplicationInfo);

    for (i = 0; i < ArrayCount(DHAxisRoles); i++)
    {
        if (DHAxisRoles[i] != none)
        {
            DHGRI.DHAxisRoleCount[i] = 0;
            DHGRI.DHAxisRoleBotCount[i] = 0;
        }
    }

    for (i = 0; i < ArrayCount(DHAlliesRoles); i++)
    {
        if (DHAlliesRoles[i] != none)
        {
            DHGRI.DHAlliesRoleCount[i] = 0;
            DHGRI.DHAlliesRoleBotCount[i] = 0;
        }
    }

    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        if (C.PlayerReplicationInfo != none && C.PlayerReplicationInfo.Team != none)
        {
            if (ROPlayer(C) != none && ROPlayer(C).CurrentRole != -1)
            {
                if (C.PlayerReplicationInfo.Team.TeamIndex == ALLIES_TEAM_INDEX)
                {
                    DHGRI.DHAlliesRoleCount[ROPlayer(C).CurrentRole]++;
                }
                else if (C.PlayerReplicationInfo.Team.TeamIndex == AXIS_TEAM_INDEX)
                {
                    DHGRI.DHAxisRoleCount[ROPlayer(C).CurrentRole]++;
                }
            }
            else if (ROBot(C) != none && ROBot(C).CurrentRole != -1)
            {
                if (C.PlayerReplicationInfo.Team.TeamIndex == ALLIES_TEAM_INDEX)
                {
                    DHGRI.DHAlliesRoleCount[ROBot(C).CurrentRole]++;
                    DHGRI.DHAlliesRoleBotCount[ROBot(C).CurrentRole]++;
                }
                else if (C.PlayerReplicationInfo.Team.TeamIndex == AXIS_TEAM_INDEX)
                {
                    DHGRI.DHAxisRoleCount[ROBot(C).CurrentRole]++;
                    DHGRI.DHAxisRoleBotCount[ROBot(C).CurrentRole]++;
                }
            }
        }
    }
}

function ChangeRole(Controller aPlayer, int i, optional bool bForceMenu)
{
    local RORoleInfo RI;
    local ROPlayer Playa;
    local ROBot MrRoboto;

    if (aPlayer == none || !aPlayer.bIsPlayer || aPlayer.PlayerReplicationInfo.Team == none || aPlayer.PlayerReplicationInfo.Team.TeamIndex > 1)
        return;

    RI = GetRoleInfo(aPlayer.PlayerReplicationInfo.Team.TeamIndex, i);

    if (RI == none)
        return;

    // Lets try and avoid 50 casts - Ramm
    Playa = ROPlayer(aPlayer);

    if (Playa == none)
    {
        MrRoboto = ROBot(aPlayer);
    }


    if (Playa != none)
    {
        Playa.DesiredRole = i;

        //if (Playa.CurrentRole == i)
        //  return;

        if (aPlayer.Pawn == none)
        {
            // Try and kick a bot out of this role if bots are occupying it
            if (RoleLimitReached(aPlayer.PlayerReplicationInfo.Team.TeamIndex, i))
            {
                 HumanWantsRole(aPlayer.PlayerReplicationInfo.Team.TeamIndex, i);
            }

            if (!RoleLimitReached(aPlayer.PlayerReplicationInfo.Team.TeamIndex, i))
            {
                if (bForceMenu)
                {
                    Playa.ClientReplaceMenu("ROInterface.ROUT2K4PlayerSetupPage", false, "Weapons");
                }
                else
                {
                    // Decrement the RoleCounter for the old role
                    if (Playa.CurrentRole != -1)
                    {
                        if (aPlayer.PlayerReplicationInfo.Team.TeamIndex == AXIS_TEAM_INDEX)
                            DHGameReplicationInfo(GameReplicationInfo).DHAxisRoleCount[Playa.CurrentRole]--;
                        else if (aPlayer.PlayerReplicationInfo.Team.TeamIndex == ALLIES_TEAM_INDEX)
                            DHGameReplicationInfo(GameReplicationInfo).DHAlliesRoleCount[Playa.CurrentRole]--;
                    }

                    Playa.CurrentRole = i;

                    // Increment the RoleCounter for the new role
                    if (aPlayer.PlayerReplicationInfo.Team.TeamIndex == AXIS_TEAM_INDEX)
                        DHGameReplicationInfo(GameReplicationInfo).DHAxisRoleCount[Playa.CurrentRole]++;
                    else if (aPlayer.PlayerReplicationInfo.Team.TeamIndex == ALLIES_TEAM_INDEX)
                        DHGameReplicationInfo(GameReplicationInfo).DHAlliesRoleCount[Playa.CurrentRole]++;

                    ROPlayerReplicationInfo(aPlayer.PlayerReplicationInfo).RoleInfo = RI;
                    Playa.PrimaryWeapon = -1;
                    Playa.SecondaryWeapon = -1;
                    Playa.GrenadeWeapon = -1;
                    Playa.bWeaponsSelected = false;
                    SetCharacter(aPlayer);
                }
            }
            else
            {
                Playa.DesiredRole = Playa.CurrentRole;
                PlayerController(aPlayer).ReceiveLocalizedMessage(GameMessageClass, 17, none, none, RI);
            }

            // Since we're changing roles, clear all associated requests/rally points
            ClearSavedRequestsAndRallyPoints(Playa, false);
        }
        else
        {
            PlayerController(aPlayer).ReceiveLocalizedMessage(GameMessageClass, 16, none, none, RI);
        }
    }
    else if (MrRoboto != none)
    {
        if (MrRoboto.CurrentRole == i)
            return;

        MrRoboto.DesiredRole = i;

        if (aPlayer.Pawn == none)
        {
            if (!RoleLimitReached(aPlayer.PlayerReplicationInfo.Team.TeamIndex, i))
            {
                // Decrement the RoleCounter for the old role
                if (MrRoboto.CurrentRole != -1)
                {
                    if (aPlayer.PlayerReplicationInfo.Team.TeamIndex == AXIS_TEAM_INDEX)
                        DHGameReplicationInfo(GameReplicationInfo).DHAxisRoleCount[MrRoboto.CurrentRole]--;
                    else if (aPlayer.PlayerReplicationInfo.Team.TeamIndex == ALLIES_TEAM_INDEX)
                        DHGameReplicationInfo(GameReplicationInfo).DHAlliesRoleCount[MrRoboto.CurrentRole]--;
                }

                MrRoboto.CurrentRole = i;

                // Increment the RoleCounter for the new role
                if (aPlayer.PlayerReplicationInfo.Team.TeamIndex == AXIS_TEAM_INDEX)
                    DHGameReplicationInfo(GameReplicationInfo).DHAxisRoleCount[MrRoboto.CurrentRole]++;
                else if (aPlayer.PlayerReplicationInfo.Team.TeamIndex == ALLIES_TEAM_INDEX)
                    DHGameReplicationInfo(GameReplicationInfo).DHAlliesRoleCount[MrRoboto.CurrentRole]++;

                ROPlayerReplicationInfo(aPlayer.PlayerReplicationInfo).RoleInfo = RI;
                SetCharacter(aPlayer);
            }
            else
            {
                MrRoboto.DesiredRole = ROBot(aPlayer).CurrentRole;
            }
        }
    }
}

function Killed(Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> DamageType)
{
    /* Removes console spam whenever you kill an empty tank. */
    if (Killed != none)
        super.Killed(Killer, Killed, KilledPawn, DamageType);
}

function bool RoleExists(byte TeamID, DH_RoleInfo RI)
{
    local int i;

    if (TeamID == 0)
        for(i = 0; i < ArrayCount(DHAxisRoles); i++)
            if (DHAxisRoles[i] == RI)
                return true;
    if (TeamID == 1)
        for(i = 0; i < ArrayCount(DHAlliesRoles); i++)
            if (DHAlliesRoles[i] == RI)
                return true;

    return false;
}

state RoundInPlay
{
    function BeginState()
    {
        super.BeginState();

        ResetMortarTargets();

        DHGameReplicationInfo(GameReplicationInfo).DHSpawnCount[ALLIES_TEAM_INDEX] = LevelInfo.Allies.SpawnLimit;
        DHGameReplicationInfo(GameReplicationInfo).DHSpawnCount[AXIS_TEAM_INDEX] = LevelInfo.Axis.SpawnLimit;
    }

    function EndRound(int Winner)
    {
        local string MapName;
        local int i, j;
        local bool bMatchOver, bRussianSquadLeader;

        switch (Winner)
        {
            case AXIS_TEAM_INDEX:
                Teams[AXIS_TEAM_INDEX].Score += 1.0;
                BroadcastLocalizedMessage(class'DHRoundOverMsg', 0,,, DHLevelInfo);
                TeamScoreEvent(AXIS_TEAM_INDEX, 1, "team_victory");
                break;
            case ALLIES_TEAM_INDEX:
                Teams[ALLIES_TEAM_INDEX].Score += 1.0;
                BroadcastLocalizedMessage(class'DHRoundOverMsg', 1,,, DHLevelInfo);
                TeamScoreEvent(ALLIES_TEAM_INDEX, 1, "team_victory");
                break;
            default:
                BroadcastLocalizedMessage(class'RORoundOverMsg', 2);
                break;
        }

        RoundCount++;

        // Used for Steam Stats below
        bMatchOver = true;

        if (RoundLimit != 0 && RoundCount >= RoundLimit)
            EndGame(none, "RoundLimit");
        else if (WinLimit != 0 && (Teams[AXIS_TEAM_INDEX].Score >= WinLimit || Teams[ALLIES_TEAM_INDEX].Score >= WinLimit))
            EndGame(none, "WinLimit");
        else
        {
            bMatchOver = false;
            GotoState('RoundOver');
        }

        // Get the MapName out of the URL
        MapName = Level.GetLocalURL();
        i = InStr(MapName, "/");
        if (i < 0)
        {
            i = 0;
        }
        j = InStr(MapName, "?");
        if (j < 0)
        {
            j = Len(MapName);
        }
        if (Mid(MapName, j - 3, 3) ~= "rom")
        {
            j -= 5;
        }
        MapName = Mid(MapName, i + 1, j - i);

        // Set the map as won in the Steam Stats of everyone on the Winning Team
        for (i = 0; i < GameReplicationInfo.PRIArray.Length; i++)
        {
            if (ROSteamStatsAndAchievements(GameReplicationInfo.PRIArray[i].SteamStatsAndAchievements) != none)
            {
                if (GameReplicationInfo.PRIArray[i].Team != none && GameReplicationInfo.PRIArray[i].Team.TeamIndex == Winner)
                {
                    if (bMatchOver)
                    {
                        if (GameReplicationInfo.PRIArray[i].Team.TeamIndex == ALLIES_TEAM_INDEX && ROPlayerReplicationInfo(GameReplicationInfo.PRIArray[i]) != none)
                        {
                            bRussianSquadLeader = ROPlayerReplicationInfo(GameReplicationInfo.PRIArray[i]).RoleInfo.bIsLeader && !ROPlayerReplicationInfo(GameReplicationInfo.PRIArray[i]).RoleInfo.bCanBeTankCrew;
                        }
                        else
                        {
                            bRussianSquadLeader = false;
                        }

                        // NOTE: This MUST be called before ROSteamStatsAndAchievements.MatchEnded()
                        ROSteamStatsAndAchievements(GameReplicationInfo.PRIArray[i].SteamStatsAndAchievements).WonMatch(MapName, Winner, bRussianSquadLeader);
                    }
                    else
                    {
                        // NOTE: This MUST be called before ROSteamStatsAndAchievements.MatchEnded()
                        ROSteamStatsAndAchievements(GameReplicationInfo.PRIArray[i].SteamStatsAndAchievements).WonRound();
                    }
                }

                ROSteamStatsAndAchievements(GameReplicationInfo.PRIArray[i].SteamStatsAndAchievements).MatchEnded();
            }
        }
    }

    function EndState()
    {
        local Pawn P;

        super.EndState();

        foreach DynamicActors(class'Pawn', P)
        {
            P.StopWeaponFiring();
        }
    }
}

function ResetMortarTargets()
{
    local int k;
    local DHGameReplicationInfo GRI;

    if (GameReplicationInfo == none)
        return;

    GRI = DHGameReplicationInfo(GameReplicationInfo);

    if (GRI == none)
        return;

    //Clear mortar allied targets.
    for(k = 0; k < ArrayCount(GRI.AlliedMortarTargets); k++)
    {
        GRI.AlliedMortarTargets[k].Location = vect(0, 0, 0);
        GRI.AlliedMortarTargets[k].HitLocation = vect(0, 0, 0);
        GRI.AlliedMortarTargets[k].Controller = none;
        GRI.AlliedMortarTargets[k].Time = 0;
    }

    //Clear mortar german targets.
    for(k = 0; k < ArrayCount(GRI.GermanMortarTargets); k++)
    {
        GRI.GermanMortarTargets[k].Location = vect(0, 0, 0);
        GRI.GermanMortarTargets[k].HitLocation = vect(0, 0, 0);
        GRI.GermanMortarTargets[k].Controller = none;
        GRI.GermanMortarTargets[k].Time = 0;
    }
}

//------------------------------------------------------------------------------
// Overridden so we show how many actual individual reinforcements we have.
// Basnett - January 19th, 2010
function RestartPlayer(Controller aPlayer)
{
    local ROPlayer playa;

    if (aPlayer == none)
        return;

    SetCharacter(aPlayer);

    Super(TeamGame).RestartPlayer(aPlayer);

    if (aPlayer.PlayerReplicationInfo.Team.TeamIndex == ALLIES_TEAM_INDEX && LevelInfo.Allies.SpawnLimit > 0)
    {
        DHGameReplicationInfo(GameReplicationInfo).DHSpawnCount[ALLIES_TEAM_INDEX] = LevelInfo.Allies.SpawnLimit - ++SpawnCount[ALLIES_TEAM_INDEX];

        //If the Allies have used up 85% of their reinforcements, send them a reinforcements low message
        if (SpawnCount[ALLIES_TEAM_INDEX] == int(LevelInfo.Allies.SpawnLimit * 0.85))
            SendReinforcementMessage(ALLIES_TEAM_INDEX, 0);
    }
    else if (aPlayer.PlayerReplicationInfo.Team.TeamIndex == AXIS_TEAM_INDEX && LevelInfo.Axis.SpawnLimit > 0)
    {
        DHGameReplicationInfo(GameReplicationInfo).DHSpawnCount[AXIS_TEAM_INDEX] = LevelInfo.Axis.SpawnLimit - ++SpawnCount[AXIS_TEAM_INDEX];

        //If Axis has used up 85% of their reinforcements, send them a reinforcements low message
        if (SpawnCount[AXIS_TEAM_INDEX] == int(LevelInfo.Axis.SpawnLimit * 0.85))
            SendReinforcementMessage(AXIS_TEAM_INDEX, 0);
    }

    // hax?
    playa = ROPlayer(aPlayer);
    if (playa != none)
    {
        if (playa.bFirstRoleAndTeamChange && GetStateName() == 'RoundInPlay')
        {
            playa.NotifyOfMapInfoChange();
            playa.bFirstRoleAndTeamChange = true;
        }
    }
}

defaultproperties
{
     WinLimit=3
     ROHints(1)="You can 'cook' an Allied Mk II grenade by pressing the opposite fire button while holding the grenade back."
     ROHints(13)="You cannot change the 30 Cal barrel, be careful not to overheat!"
     ROHints(17)="Once you've fired the Bazooka or Panzerschreck get to fresh cover FAST, as the smoke of your backblast will reveal your location. Return fire almost certainly follow!"
     ROHints(18)="Do not stand directly behind rocket weapons when they're firing; you can sustain serious injury from the exhaust!"
     ROHints(19)="AT soldiers should always take a friend with them for ammo supplies, faster reloads and protection."
     ROHints(20)="AT weapons will be automatically unloaded if you change to another weapon. It is a good idea to stick with a team-mate to speed up reloading when needed."
     RussianNames(0)="Colin Basnett"
     RussianNames(1)="Graham Merrit"
     RussianNames(2)="Ian Campbell"
     RussianNames(3)="Eric Parris"
     RussianNames(4)="Tom McDaniel"
     RussianNames(5)="Sam Cousins"
     RussianNames(6)="Jeff Duquette"
     RussianNames(7)="Chris Young"
     RussianNames(8)="Kenneth Kjeldsen"
     RussianNames(9)="John Wayne"
     RussianNames(10)="Clint Eastwood"
     RussianNames(11)="Tom Hanks"
     RussianNames(12)="Leroy Jenkins"
     RussianNames(13)="Telly Savalas"
     RussianNames(14)="Audie Murphy"
     RussianNames(15)="George Baker"
     GermanNames(0)="Günther Liebing"
     GermanNames(1)="Heinz Werner"
     GermanNames(2)="Rudolf Giesler"
     GermanNames(3)="Seigfried Hauber"
     GermanNames(4)="Gustav Beier"
     GermanNames(5)="Joseph Peitsch"
     GermanNames(6)="Willi Eiken"
     GermanNames(7)="Wolfgang Steyer"
     GermanNames(8)="Rolf Steiner"
     GermanNames(9)="Anton Müller"
     GermanNames(10)="Klaus Triebig"
     GermanNames(11)="Hans Grüschke"
     GermanNames(12)="Wilhelm Krüger"
     GermanNames(13)="Herrmann Dietrich"
     GermanNames(14)="Erich Klein"
     GermanNames(15)="Horst Altmann"
     LoginMenuClass="DH_Interface.DHPlayerSetupPage"
     DefaultPlayerClassName="DH_Engine.DH_Pawn"
     ScoreBoardType="DH_Interface.DHScoreBoard"
     HUDType="DH_Engine.DHHud"
     MapListType="DH_Interface.DHMapList"
     MapPrefix="DH"
     BeaconName="DH"
     BroadcastHandlerClass="DH_Engine.DHBroadcastHandler"
     PlayerControllerClassName="DH_Engine.DHPlayer"
     GameReplicationInfoClass=Class'DH_Engine.DHGameReplicationInfo'
     GameName="DarkestHourGame"
     DecoTextName="DH_Engine.DarkestHourGame"
     Acronym="DH"
     VoiceReplicationInfoClass=Class'DH_Engine.DHVoiceReplicationInfo'
     VotingHandlerType="DH_Engine.DHVotingHandler"
}
