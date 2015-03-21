//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHDeploymentMapMenu extends MidGamePanel;

const   OBJECTIVES_MAX =                    16; // Max objectives total
const   SPAWN_POINTS_MAX =                  16; // Max spawn points active at once
const   SPAWN_POINTS_TOTAL =                64; // Max spawn points total (make sure this matches GRI)
const   SPAWN_VEHICLES_TOTAL =              10; // Max spawn vehicles total (make sure this matches GRI)

var automated ROGUIProportionalContainer    MapContainer;

var localized string                        ReinforcementText;

var     bool                                bReadyToDeploy, bOutOfReinforcements, bResolutionChanged;
var     automated GUILabel                  l_ReinforcementCount, l_RoundTime;
var     automated GUIImage                  i_Background;
var     automated DHGUIButton               b_DeployButton, b_ExploitSpawn;
var     automated GUIProgressBar            pb_DeployProgressBar;
var     automated GUIGFXButton              b_SpawnPoints[SPAWN_POINTS_MAX],
                                            b_Objectives[OBJECTIVES_MAX],
                                            b_SpawnVehicles[SPAWN_VEHICLES_TOTAL];

//var     int                                 SpawnPointIndices[SPAWN_POINTS_TOTAL];
var     int                                 SpawnVehicleIndices[SPAWN_VEHICLES_TOTAL];

var     ROObjective                         Objectives[OBJECTIVES_MAX];
var     Material                            ObjectiveIcons[3];

var     DHGameReplicationInfo               GRI;
var     DHPlayerReplicationInfo             PRI;
var     DHPlayer                            DHP;
var     DHHud                               HUD;
var     vector                              NELocation,SWLocation;

//Deploy Menu Access
var DHDeployMenu                            MyDeployMenu;
var DHRoleSelectPanel                       MyRoleMenu;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;
    local rotator R;

    Super.InitComponent(MyController, MyOwner);

    DHP = DHPlayer(PlayerOwner());
    if (DHP == none)
    {
        return;
    }
    GRI = DHGameReplicationInfo(DHP.GameReplicationInfo);
    PRI = DHPlayerReplicationInfo(DHP.PlayerReplicationInfo);
    HUD = DHHud(DHP.myHUD);
    if (GRI == none || HUD == none || PRI == none)
    {
        return;
    }

    // Assign MyDeployMenu
    MyDeployMenu = DHDeployMenu(PageOwner);

    // Set the level map image
    i_Background.Image = GRI.MapImage;

    // Have container manage level map image
    MapContainer.ManageComponent(i_Background);

    // Initialize spawn points (make hidden)
    for (i = 0; i < arraycount(b_SpawnPoints); ++i)
    {
        b_SpawnPoints[i].Graphic = none;
        b_SpawnPoints[i].SetVisibility(false);
        b_SpawnPoints[i].WinWidth=0.0;
        b_SpawnPoints[i].WinHeight=0.0;
    }

    // Initialize vehicle spawns (make hidden)
    for (i = 0; i < arraycount(b_SpawnVehicles); ++i)
    {
        b_SpawnVehicles[i].Graphic = none;
        b_SpawnVehicles[i].SetVisibility(false);
        b_SpawnVehicles[i].WinWidth=0.0;
        b_SpawnVehicles[i].WinHeight=0.0;
    }

    // Initialize objective points (make hidden)
    for (i = 0; i < arraycount(b_Objectives); ++i)
    {
        b_Objectives[i].Graphic = none;
    }

    // Set rotator based on map rotation offset
    R.Yaw = GRI.OverheadOffset * 182.044444;

    // Set the location of the map bounds
    NELocation = GRI.NorthEastBounds << R;
    SWLocation = GRI.SouthWestBounds << R;

    // Timer for updating reinforcements & time
    Timer();
    SetTimer(1.0, true);
}

// Used to update round time and reinforcements
function Timer()
{
    local int CurrentTime;

    // Update round time & reinforcement count
    if (HUD != none && GRI != none && PRI != none)
    {
        if (!GRI.bMatchHasBegun)
            CurrentTime = FMax(0.0, GRI.RoundStartTime + GRI.PreStartTime - GRI.ElapsedTime);
        else
            CurrentTime = FMax(0.0, GRI.RoundStartTime + GRI.RoundDuration - GRI.ElapsedTime);

        l_RoundTime.Caption = HUD.default.TimeRemainingText $ HUD.GetTimeString(CurrentTime);
        l_ReinforcementCount.Caption = default.ReinforcementText @ string(GRI.DHSpawnCount[PRI.Team.TeamIndex]);

        if (GRI.DHSpawnCount[PRI.Team.TeamIndex] == 0)
        {
            // Inform menu that our team is out of reinforcements and we can't spawn
            bOutOfReinforcements = true;
        }
        else
        {
            bOutOfReinforcements = false;
        }
    }
}

function ClearIcon(GUIGFXButton IconB)
{
    if (IconB != none)
    {
        IconB.WinWidth=0.0;
        IconB.WinHeight=0.0;
        IconB.SetVisibility(false);
    }
}

function float GetDistance(float A, float B)
{
    if (A <= 0.0 && B >= 0.0)
    {
        return Abs(A) + B;
    }
    else
    {
        return Abs(A - B);
    }
}

//Theel: This function is still slightly buggy and needs to support rotation and variables renamed
//Object location, sets map X, Y, based on image size W&H
function GetMapCoords(vector Location, out float X, out float Y, float W, float H)
{
    local float TDistance;
    local float Distance;

    // Calculations for X
    TDistance = GetDistance(SWLocation.X, NELocation.X);
    Distance = GetDistance(SWLocation.X, Location.X);
    Distance = FMin(Distance, TDistance);
    X = Distance / TDistance - (W / 2);

    // Calculations for Y
    TDistance = GetDistance(SWLocation.Y, NELocation.Y);
    Distance = GetDistance(SWLocation.Y, Location.Y);
    Distance = FMin(Distance, TDistance);
    Y = MapContainer.WinHeight - Distance / TDistance * MapContainer.WinHeight - (H / 2); //Because the map is managed by a container, lets form to the container's winheight
}

//Theel: This function has floating variables
function PlaceSpawnPointOnMap(vector Location, int Index, int SPIndex, string Title)
{
    local float X, Y, W, H;

    if (Index >= 0 && Index < arraycount(b_SpawnPoints))
    {
        if (SPIndex == DHP.SpawnPointIndex)
        {
            W = 0.075;
            H = 0.035;

            GetMapCoords(Location, X, Y, W, H);

            b_SpawnPoints[Index].SetPosition(X, Y, W, H, true);
            b_SpawnPoints[Index].SetFocus(none);
        }
        else
        {
            W = 0.07;
            H = 0.03;

            GetMapCoords(Location, X, Y, W, H);

            b_SpawnPoints[Index].SetPosition(X, Y, W, H, true);
        }

        b_SpawnPoints[Index].Tag = SPIndex; // Store the SP Index in the button
        b_SpawnPoints[Index].Caption = Caps(Left(Title, 2));
        b_SpawnPoints[Index].SetVisibility(true);
    }
}

function PlaceVehicleSpawnOnMap(vector Location, int Index, int SpawnVehicleIndex)
{
    local float X, Y, W, H;

    if (Index >= 0 && Index < arraycount(b_SpawnVehicles))
    {
        if (SpawnVehicleIndex == DHP.VehiclePoolIndex)
        {
            W = 0.075;
            H = 0.035;

            GetMapCoords(Location, X, Y, W, H);

            b_SpawnVehicles[Index].SetPosition(X, Y, W, H, true);
            b_SpawnVehicles[Index].SetFocus(none);
        }
        else
        {
            W = 0.07;
            H = 0.03;

            GetMapCoords(Location, X, Y, W, H);

            b_SpawnVehicles[Index].SetPosition(X, Y, W, H, true);
        }

        b_SpawnVehicles[Index].Tag = SpawnVehicleIndex;
        b_SpawnVehicles[Index].Caption = string(Index);
        b_SpawnVehicles[Index].SetVisibility(true);
    }
}

//Theel: This function has floating variables
function PlaceObjectiveOnMap(ROObjective O, int Index)
{
    local float X, Y;

    if (O != none && Index >= 0 && Index < arraycount(b_Objectives))
    {
        GetMapCoords(O.Location, X, Y, 0.04, 0.04);

        b_Objectives[Index].SetPosition(X, Y, 0.04, 0.04, true);
        b_Objectives[Index].Graphic = ObjectiveIcons[int(GRI.Objectives[Index].ObjState)];
        b_Objectives[Index].Caption = O.ObjectiveName;

        Objectives[Index] = O;
    }
}

// Theel: will eventually want to draw 'deployed' MDVs also
function bool DrawMapComponents(Canvas C)
{
    local int i, SpawnPointIndex;
    local array<DHSpawnPoint> ActiveSpawnPoints;
    local DHSpawnPoint SP;

    // If resolution changed then resetup the menu positions
    if (bResolutionChanged)
    {
        InternalOnPostDraw(C);
        bResolutionChanged = false;
    }

    if (MyDeployMenu == none || bOutOfReinforcements)
    {
        return false;
    }

    // Draw objectives
    for (i = 0; i < arraycount(GRI.Objectives); ++i)
    {
        if (GRI.Objectives[i] == none || !GRI.Objectives[i].bActive)
        {
            continue;
        }

        PlaceObjectiveOnMap(GRI.Objectives[i], i);
    }

    // Get Spawn Points for Current Team
    GRI.GetActiveSpawnPointsForTeam(ActiveSpawnPoints, PRI.Team.TeamIndex);

    for (i = 0; i < ActiveSpawnPoints.Length; ++i)
    {
        SP = ActiveSpawnPoints[i];
        SpawnPointIndex = GRI.GetSpawnPointIndex(SP);

        // Draw infantry or vehicle spawn points
        if ((MyDeployMenu.Tab == TAB_Role && SP.CanSpawnInfantry()) ||
            (MyDeployMenu.Tab == TAB_Vehicle && SP.CanSpawnVehicles()))
        {
            PlaceSpawnPointOnMap(SP.Location, i, SpawnPointIndex, SP.SpawnPointName);
        }
        else
        {
            ClearIcon(b_SpawnPoints[i]);
        }
    }

    if (MyDeployMenu.Tab != TAB_Vehicle)
    {
        // Loop Vehicle Spawn Points
        for (i = 0; i < arraycount(GRI.SpawnVehicles); ++i)
        {
            // Only show active, current team, and if we aren't spawning a vehicle
            if (GRI.SpawnVehicles[i].bIsActive && GRI.SpawnVehicles[i].TeamIndex == PRI.Team.TeamIndex)
            {
                PlaceVehicleSpawnOnMap(GRI.SpawnVehicles[i].Location, i, GRI.SpawnVehicles[i].Index);
            }
            else
            {
                ClearIcon(b_SpawnVehicles[i]);
            }
        }
    }

    return false;
}

// Resolution was changed, lets call OnPostDraw
event ResolutionChanged(int ResX, int ResY)
{
    super.ResolutionChanged(ResX, ResY); // No point in calling the super!

    bResolutionChanged = true;
}

// Make panel uniform (square) and adjust other components accordingly
// Other initialization/setup
function InternalOnPostDraw(Canvas Canvas)
{
    local float ImageHeight, ExtraHeight, ExtraWidth;

    ImageHeight = MapContainer.ActualHeight();
    MenuOwner.SetPosition(MenuOwner.WinLeft, MenuOwner.WinTop, ImageHeight, MenuOwner.WinHeight, true);
    MapContainer.SetPosition(MapContainer.WinLeft, MapContainer.WinTop, MapContainer.WinWidth, ImageHeight, true);

    ExtraHeight = 1.0 - MapContainer.WinHeight;
    ExtraWidth = 1.0 - MenuOwner.WinLeft - MenuOwner.WinWidth;

    MyDeployMenu.HandleExtraWidth(ExtraWidth);

    pb_DeployProgressBar.SetPosition(MapContainer.WinLeft, MapContainer.WinHeight, MapContainer.WinWidth, ExtraHeight, true);
    b_DeployButton.SetPosition(MapContainer.WinLeft, MapContainer.WinHeight, MapContainer.WinWidth, ExtraHeight, true);

    bInit = false;
    OnRendered = none;
    ShowPanel(true);

    // Set MyRoleMenu here to make sure it is initialized, though it should always be, do it here just in case
    if (MyDeployMenu != none && MyDeployMenu.c_LoadoutArea.TabStack.Length > 0 && MyDeployMenu.c_LoadoutArea.TabStack[0].MyPanel != none)
    {
        MyRoleMenu = DHRoleSelectPanel(MyDeployMenu.c_LoadoutArea.TabStack[0].MyPanel);
    }
}

// Deploy requested
function SpawnClick(optional bool bExploit)
{
    // Exploit spawn!
    if (bExploit && !PRI.bOnlySpectator && DHP.Pawn == none)
    {
        MyRoleMenu.AttemptRoleApplication();
        DHP.ServerAttemptDeployPlayer(DHP.DesiredAmmoAmount, true);
        Controller.CloseMenu(false); //Close menu as we clicked deploy!
        return;
    }

    if (bInit || PRI == none || PRI.bOnlySpectator || DHP.Pawn != none || MyRoleMenu == none || !bReadyToDeploy)
    {
        return;
    }

    // Complete spawn request
    MyRoleMenu.AttemptRoleApplication();
    DHP.ServerAttemptDeployPlayer(DHP.DesiredAmmoAmount);
    Controller.CloseMenu(false); //Close menu as we clicked deploy!
}

function bool ConfirmIndices()
{
    // If we are trying to spawn vehicle, but no pool selected : return false
    if (MyDeployMenu.Tab == TAB_Vehicle && DHP.VehiclePoolIndex == -1)
    {
        return false;
    }

    // If we are trying to spawn as infantry, but pool is selected : return false
    if (MyDeployMenu.Tab == TAB_Role && DHP.VehiclePoolIndex != -1)
    {
        return false;
    }

    // If we have pool selected, but no spawn point : return false
    if (DHP.VehiclePoolIndex != -1 && DHP.SpawnPointIndex == -1)
    {
        return false;
    }

    // If we have a SpawnVehicle selected, but also one of the others set : return false
    if (DHP.SpawnVehicleIndex != -1 && (DHP.SpawnPointIndex != -1 || DHP.VehiclePoolIndex != -1))
    {
        return false;
    }

    // Otherwise return true
    return true;
}

function bool InternalOnClick(GUIComponent Sender)
{
    local GUIButton Selected;
    local int i;

    switch(Sender)
    {
        case b_ExploitSpawn: // Remove later
            SpawnClick(true);
            break;

        case b_DeployButton:
            SpawnClick();
            break;

        default:
            // Something else was clicked, if spawn point button handle it
            if (GUIButton(Sender) != none)
            {
                Selected = GUIButton(Sender);
            }

            if (Selected == none)
            {
                return false;
            }

            for (i = 0; i < arraycount(b_SpawnPoints); ++i)
            {
                if (Selected == b_SpawnPoints[i])
                {
                    //DEBUG
                    Log("b_SpawnPoints" $ i @ "Tag:" @ b_SpawnPoints[i].Tag $ ":" @ "and DHPSpawnPointIndex is:" @ DHP.SpawnPointIndex);

                    if (b_SpawnPoints[i].Tag == DHP.SpawnPointIndex) // Player clicked twice on spawnpoint
                    {
                        // Clear spawnvehicle just incase it was set
                        if (DHP.Pawn == none) // Avoid server call if we don't have a pawn and are already clicking the same point
                        {
                            DHP.ServerChangeSpawn(DHP.SpawnPointIndex,DHP.VehiclePoolIndex,-1);
                            SpawnClick();
                        }
                    }
                    else
                    {
                        // Set SpawnPoint and clear spawnvehicle point as we clicked a spawn point
                        DHP.ServerChangeSpawn(b_SpawnPoints[i].Tag,DHP.VehiclePoolIndex,-1);
                    }
                    break;
                }
            }

            for (i = 0; i < arraycount(b_SpawnVehicles); ++i)
            {
                if (Selected == b_SpawnVehicles[i])
                {
                    if (b_SpawnVehicles[i].Tag == DHP.SpawnVehicleIndex)
                    {
                        // Clear pool and spawnpoint just incase either were set
                        DHP.ServerChangeSpawn(-1,-1,DHP.SpawnVehicleIndex);
                        SpawnClick();
                    }
                    else
                    {
                        // Set SpawnVehiclePoint and clear pool & spawnpoint value, as we clicked a spawnvehicle point
                        DHP.ServerChangeSpawn(-1,-1,b_SpawnVehicles[i].Tag);
                    }
                    break;
                }
            }
            break;
    }
    return false;
}


// TODO strings need to be made localized
function bool DrawDeployTimer(Canvas C)
{
    local float P; // Progress
    local bool bButtonEnabled, bProgressComplete;

    // Handle progress bar
    if (!bOutOfReinforcements)
    {
        P = pb_DeployProgressBar.High * (DHP.LastKilledTime + DHP.RedeployTime - DHP.Level.TimeSeconds) / DHP.RedeployTime;
        P = pb_DeployProgressBar.High - P;
        pb_DeployProgressBar.Value = FClamp(P, pb_DeployProgressBar.Low, pb_DeployProgressBar.High);

        if (pb_DeployProgressBar.Value == pb_DeployProgressBar.High)
        {
            // Progress bar is complete
            bProgressComplete = true;
        }
    }
    else
    {
        // Set progress to none
        pb_DeployProgressBar.Value = pb_DeployProgressBar.Low;
    }

    // Handle button (enabled/disabled)
    // TODO Need to see if we are trying to spawn on a spawn vehicle
    if (bProgressComplete && ConfirmIndices() && DHP.Pawn == none && (GRI.IsSpawnPointIndexValid(DHP.SpawnPointIndex, DHP.PlayerReplicationInfo.Team.TeamIndex) || GRI.CanSpawnAtVehicle(DHP.SpawnVehicleIndex, DHP)))
    {
        // Progress is complete, we have legit indices, no pawn, our spawn point is valid, and if we are spawning vehicle have a pool selected
        b_DeployButton.EnableMe();
        bButtonEnabled = true;
    }
    else
    {
        b_DeployButton.DisableMe();
    }

    // Handle button caption (reverse order of priority)
    if (!ConfirmIndices())
    {
        b_DeployButton.Caption = "Make sure you have a role and/or vehicle selected";
    }
    else if (!GRI.IsSpawnPointIndexValid(DHP.SpawnPointIndex, DHP.PlayerReplicationInfo.Team.TeamIndex))
    {
        b_DeployButton.Caption = "Select a spawnpoint or spawnvehicle"; // TODO need support for spawn vehicle
    }
    else if (bOutOfReinforcements)
    {
        b_DeployButton.Caption = "Your team is out of reinforcements";
    }
    else if (!bProgressComplete)
    {
        b_DeployButton.Caption = "Deploy in:" @ int(Ceil(DHP.LastKilledTime + DHP.RedeployTime - DHP.Level.TimeSeconds)) @ "Seconds";
    }
    else if (DHP.Pawn != none)
    {
        b_DeployButton.Caption = "You are already deployed";
    }
    else
    {
        b_DeployButton.Caption = "Deploy!";
    }

    // Set bReadyToDeploy based on button
    if (bButtonEnabled && bProgressComplete)
    {
        bReadyToDeploy = true;
    }
    else
    {
        bReadyToDeploy = false;
    }
    return false;
}

defaultproperties
{
    bNeverFocus=true
    OnRendered=DHDeploymentMapMenu.InternalOnPostDraw
    ReinforcementText="Reinforcements Remaining:"

    //Theel: need a neutral objective icon, as we actually don't have one singled out
    ObjectiveIcons(0)=Texture'DH_GUI_Tex.GUI.GerCross'
    ObjectiveIcons(1)=Texture'DH_GUI_Tex.GUI.AlliedStar'
    ObjectiveIcons(2)=Texture'DH_GUI_Tex.GUI.PlayerIcon'

    // Image for level map
    Begin Object Class=GUIImage Name=BackgroundImage
        ImageStyle=ISTY_Justified
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        bAcceptsInput=false
        OnDraw=DrawMapComponents
    End Object
    i_Background=BackgroundImage

    // Container for level map image (used for plotting of elements)
    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=MapContainer_co
        WinLeft=0.0
        WinTop=0.0
        WinWidth=1.0
        WinHeight=0.95
        TopPadding=0.0
        LeftPadding=0.0
        RightPadding=0.0
        BottomPadding=0.0
    End Object
    MapContainer=MapContainer_co

    // Deploy button
    Begin Object Class=DHGUIButton Name=DeployButton
        Caption=""
        CaptionAlign=TXTA_Center
        RenderWeight=5.85
        StyleName="DHDeployButtonStyle"
        WinWidth=0.315937
        WinHeight=0.3
        WinLeft=0.137395
        WinTop=0.010181
        OnClick=InternalOnClick
    End Object
    b_DeployButton=DeployButton

    // Exploit spawn button
    Begin Object Class=DHGUIButton Name=TempExploitButton
        Caption="Exploit Spawn"
        CaptionAlign=TXTA_Center
        RenderWeight=5.85
        StyleName="DHSpawnButtonStyle"
        WinWidth=0.2
        WinHeight=0.05
        WinLeft=0.05
        WinTop=0.7
        OnClick=InternalOnClick
    End Object
    b_ExploitSpawn=TempExploitButton

    // Deploy time progress bar
    Begin Object class=GUIProgressBar Name=DeployTimePB
        BarColor=(B=255,G=255,R=255,A=255)
        Value=0.0
        RenderWeight=1.75
        bShowValue=false
        CaptionWidth=0.0
        ValueRightWidth=0.0
        BarBack=Texture'InterfaceArt_tex.Menu.GreyDark'
        BarTop=Texture'InterfaceArt_tex.Menu.GreyLight'
        OnDraw=DrawDeployTimer
        WinWidth=0.315937
        WinHeight=0.033589
        WinLeft=0.137395
        WinTop=0.010181
        bNeverFocus=true
        bAcceptsInput=false
    End Object
    pb_DeployProgressBar=DeployTimePB

    // Spawn point buttons
    Begin Object Class=GUIGFXButton Name=SpawnPointButton
        Position=ICP_Normal
        bClientBound=true
        StyleName="DHSpawnButtonStyle"
        WinWidth=0.0
        WinHeight=0.0
        bTabStop=true
        OnClick=InternalOnClick
    End Object
    b_SpawnPoints(0)=SpawnPointButton
    b_SpawnPoints(1)=SpawnPointButton
    b_SpawnPoints(2)=SpawnPointButton
    b_SpawnPoints(3)=SpawnPointButton
    b_SpawnPoints(4)=SpawnPointButton
    b_SpawnPoints(5)=SpawnPointButton
    b_SpawnPoints(6)=SpawnPointButton
    b_SpawnPoints(7)=SpawnPointButton
    b_SpawnPoints(8)=SpawnPointButton
    b_SpawnPoints(9)=SpawnPointButton
    b_SpawnPoints(10)=SpawnPointButton
    b_SpawnPoints(11)=SpawnPointButton
    b_SpawnPoints(12)=SpawnPointButton
    b_SpawnPoints(13)=SpawnPointButton
    b_SpawnPoints(14)=SpawnPointButton
    b_SpawnPoints(15)=SpawnPointButton

    // Spawn Vehicle Buttons
    Begin Object Class=GUIGFXButton Name=SpawnVehicleButton
        Position=ICP_Normal
        bClientBound=true
        StyleName="DHSpawnButtonStyle"
        WinWidth=0.0
        WinHeight=0.0
        bTabStop=true
        OnClick=InternalOnClick
    End Object
    b_SpawnVehicles(0)=SpawnVehicleButton
    b_SpawnVehicles(1)=SpawnVehicleButton
    b_SpawnVehicles(2)=SpawnVehicleButton
    b_SpawnVehicles(3)=SpawnVehicleButton
    b_SpawnVehicles(4)=SpawnVehicleButton
    b_SpawnVehicles(5)=SpawnVehicleButton
    b_SpawnVehicles(6)=SpawnVehicleButton
    b_SpawnVehicles(7)=SpawnVehicleButton
    b_SpawnVehicles(8)=SpawnVehicleButton
    b_SpawnVehicles(9)=SpawnVehicleButton

    // Objective buttons
    Begin Object Class=GUIGFXButton Name=ObjectiveButton
        Graphic=texture'InterfaceArt_tex.Tank_Hud.RedDot'
        Position=ICP_Justified
        bClientBound=true
        StyleName="DHGripButtonNB"
        WinWidth=0.0
        WinHeight=0.0
        bTabStop=true
    End Object
    b_Objectives(0)=ObjectiveButton
    b_Objectives(1)=ObjectiveButton
    b_Objectives(2)=ObjectiveButton
    b_Objectives(3)=ObjectiveButton
    b_Objectives(4)=ObjectiveButton
    b_Objectives(5)=ObjectiveButton
    b_Objectives(6)=ObjectiveButton
    b_Objectives(7)=ObjectiveButton
    b_Objectives(8)=ObjectiveButton
    b_Objectives(9)=ObjectiveButton
    b_Objectives(10)=ObjectiveButton
    b_Objectives(11)=ObjectiveButton
    b_Objectives(12)=ObjectiveButton
    b_Objectives(13)=ObjectiveButton
    b_Objectives(14)=ObjectiveButton
    b_Objectives(15)=ObjectiveButton

    // Reinforcement Counter
    Begin Object Class=GUILabel Name=ReinforceCounter
        TextAlign=TXTA_Left
        StyleName="ComboListBox"
        WinWidth=0.45
        WinHeight=0.03
        WinLeft=0.0
        WinTop=0.03
    End Object
    l_ReinforcementCount=ReinforceCounter

    // Round Time Counter
    Begin Object Class=GUILabel Name=RoundTimeCounter
        TextAlign=TXTA_Left
        StyleName="ComboListBox"
        WinWidth=0.45
        WinHeight=0.03
        WinLeft=0.0
        WinTop=0.0
    End Object
    l_RoundTime=RoundTimeCounter
}
