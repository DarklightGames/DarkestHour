//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHDeploymentMapMenu extends MidGamePanel; //Does not extend DHDeployMenuPanel as it will differ from other panels quite a bit

const   OBJECTIVES_MAX =                    32; // Max objectives total
const   SPAWN_POINTS_MAX =                  16; // Max spawn points active at once
const   SPAWN_POINTS_TOTAL =                64; // Max spawn points total (make sure this matches GRI)
const   SPAWN_VEHICLES_TOTAL =              10; // Max spawn vehicles total (make sure this matches GRI)

var automated ROGUIProportionalContainer    MapContainer;

var localized string                        ReinforcementText,
                                            DeployBarText[10];

var     bool                                bReadyToDeploy, bOutOfReinforcements, bResolutionChanged;
var     automated GUILabel                  l_ReinforcementCount, l_RoundTime;
var     automated GUIImage                  i_Background;
var     automated DHGUIButton               b_DeployButton, b_SpawnRoom;
var     automated GUIProgressBar            pb_DeployProgressBar;
var     automated GUIGFXButton              b_SpawnPoints[SPAWN_POINTS_MAX],
                                            b_Objectives[OBJECTIVES_MAX],
                                            b_SpawnVehicles[SPAWN_VEHICLES_TOTAL];

var     DHObjective                         ObjArray[OBJECTIVES_MAX];
var     Material                            ObjectiveIcons[3];

var     DHGameReplicationInfo               GRI;
var     DHPlayerReplicationInfo             PRI;
var     DHPlayer                            DHP;
var     DHHud                               HUD;
var     vector                              NELocation,
                                            SWLocation,
                                            SPSelectedSize,
                                            SPSize,
                                            ObjSize,
                                            SVSize,
                                            SVSelectedSize;

//Deploy Menu Access
var DHDeployMenu                            MyDeployMenu;
var DHRoleSelectPanel                       MyRoleMenu;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;
    local rotator R;

    super.InitComponent(MyController, MyOwner);

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
        if (b_Objectives[i] != none)
        {
            b_Objectives[i].Graphic = none;
        }
    }

    // Initialize spawn room button
    if (DHP.ClientLevelInfo.SpawnMode == ESM_DarkestHour)
    {
        b_SpawnRoom.SetVisibility(false);
        b_SpawnRoom.WinWidth = 0.0;
        b_SpawnRoom.WinHeight = 0.0;
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
    if (HUD != none && GRI != none)
    {
        if (!GRI.bMatchHasBegun)
        {
            CurrentTime = FMax(0.0, GRI.RoundStartTime + GRI.PreStartTime - GRI.ElapsedTime);
        }
        else
        {
            CurrentTime = FMax(0.0, GRI.RoundStartTime + GRI.RoundDuration - GRI.ElapsedTime);
        }

        l_RoundTime.Caption = HUD.default.TimeRemainingText $ HUD.GetTimeString(CurrentTime);
        l_ReinforcementCount.Caption = default.ReinforcementText @ string(GRI.DHSpawnCount[DHP.GetTeamNum()]);

        // Inform menu that our team is out of reinforcements and we can't spawn
        bOutOfReinforcements = GRI.DHSpawnCount[DHP.GetTeamNum()] == 0;
    }
}

function ClearIcon(GUIGFXButton IconB)
{
    if (IconB != none)
    {
        IconB.SetVisibility(false);
        IconB.WinWidth = 0.0;
        IconB.WinHeight = 0.0;
    }
}

function float GetDistance(float A, float B)
{
    if (A <= 0.0 && B >= 0.0)
    {
        return Abs(A) + B;
    }
    else if (A > B && A <= 0.0 && B <= 0.0)
    {
        return 0.0;
    }
    else
    {
        return Abs(A - B);
    }
}

// This function still needs to support levels with odd rotated NE and SW and "rotatation"
// Object location, sets map X, Y, based on image size W&H
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
    Y = MapContainer.WinHeight - Distance / TDistance * MapContainer.WinHeight - (H / 2); // Because the map is managed by a container, lets form to the container's winheight
}

function PlaceSpawnPointOnMap(vector Location, byte Index, byte SPIndex, string Title)
{
    local float X, Y;

    if (Index < arraycount(b_SpawnPoints))
    {
        if (SPIndex == MyDeployMenu.SpawnPointIndex) // Selected SP
        {
            GetMapCoords(Location, X, Y, SPSelectedSize.X, SPSelectedSize.Y);

            b_SpawnPoints[Index].SetPosition(X, Y, SPSelectedSize.X, SPSelectedSize.Y, true);
            b_SpawnPoints[Index].SetFocus(none);
        }
        else // Unselected SP
        {
            GetMapCoords(Location, X, Y, SPSize.X, SPSize.Y);

            b_SpawnPoints[Index].SetPosition(X, Y, SPSize.X, SPSize.Y, true);
        }

        b_SpawnPoints[Index].Tag = SPIndex; // Store the SP Index in the button
        b_SpawnPoints[Index].Caption = Caps(Left(Title, 2));
        b_SpawnPoints[Index].SetVisibility(true);
    }
}

function PlaceVehicleSpawnOnMap(vector Location, byte Index, int SpawnVehicleIndex)
{
    local float X, Y, W, H;
    local TexRotator TR;

    if (Index < arraycount(b_SpawnVehicles))
    {
        if (SpawnVehicleIndex == MyDeployMenu.SpawnVehicleIndex)
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

        TR = TexRotator(b_SpawnVehicles[Index].Graphic);

        if (TR != none)
        {
            //TODO: verify correctness and take map rotation into consideration
            TR.Rotation.Roll = Location.Z;
        }
    }
}

function PlaceObjectiveOnMap(DHObjective O, byte Index)
{
    local float X, Y;

    if (O != none && Index < arraycount(b_Objectives) && b_Objectives[Index] != none)
    {
        GetMapCoords(O.Location, X, Y, ObjSize.X, ObjSize.X);

        b_Objectives[Index].SetPosition(X, Y, ObjSize.X, ObjSize.X, true);
        b_Objectives[Index].Graphic = ObjectiveIcons[int(GRI.DHObjectives[Index].ObjState)];
        b_Objectives[Index].Caption = O.ObjectiveName;

        ObjArray[Index] = O;
    }
}

function bool DrawMapComponents(Canvas C)
{
    local array<DHSpawnPoint> ActiveSpawnPoints;
    local DHSpawnPoint        SP;
    local byte                SpawnPointIndex;
    local int                 i;

    // If resolution changed then resetup the menu positions
    if (bResolutionChanged)
    {
        InternalOnPostDraw(C); // Hack must keep drawing as res changed (end user shouldn't realize anything
    }

    if (MyDeployMenu == none || bOutOfReinforcements)
    {
        return false;
    }

    // Draw objectives
    for (i = 0; i < arraycount(GRI.DHObjectives); ++i)
    {
        if (GRI.DHObjectives[i] == none || !GRI.DHObjectives[i].bActive)
        {
            if (b_Objectives[i] != none)
            {
                b_Objectives[i].Graphic = none;
            }

            continue;
        }

        PlaceObjectiveOnMap(GRI.DHObjectives[i], i);
    }

    // Get Spawn Points for Current Team
    GRI.GetActiveSpawnPointsForTeam(ActiveSpawnPoints, DHP.GetTeamNum());

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

    // Deploy vehicles (Spawn Vehicles)
    if (MyDeployMenu.Tab != TAB_Vehicle)
    {
        // Loop Vehicle Spawn Points
        for (i = 0; i < arraycount(GRI.SpawnVehicles); ++i)
        {
            // Only show active, current team, and if we aren't spawning a vehicle
            if (GRI.SpawnVehicles[i].VehicleClass != none && GRI.SpawnVehicles[i].TeamIndex == DHP.GetTeamNum())
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
    //super.ResolutionChanged(ResX, ResY); // No point in calling the super!

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
function SpawnClick()
{
    MyRoleMenu.AttemptDeployApplication();
}

// TODO: replace this function and other checks with the one from DHGRI
function bool AreIndicesValid()
{
    // If we are trying to spawn vehicle, but no pool selected : return false
    if (MyDeployMenu.Tab == TAB_Vehicle && MyDeployMenu.VehiclePoolIndex == 255)
    {
        return false;
    }

    // If we are trying to spawn as infantry, but pool is selected : return false
    if (MyDeployMenu.Tab == TAB_Role && MyDeployMenu.VehiclePoolIndex != 255)
    {
        return false;
    }

    // If we have pool selected, but no spawn point : return false
    if (MyDeployMenu.VehiclePoolIndex != 255 && MyDeployMenu.SpawnPointIndex == 255)
    {
        return false;
    }

    // If we have a SpawnVehicle selected, but also one of the others set : return false
    if (MyDeployMenu.SpawnVehicleIndex != 255 && (MyDeployMenu.SpawnPointIndex != 255 || MyDeployMenu.VehiclePoolIndex != 255))
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
        case b_SpawnRoom:
            SpawnClick();
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
                    if (b_SpawnPoints[i].Tag == MyDeployMenu.SpawnPointIndex) // Player clicked twice on spawnpoint
                    {
                        // Clear spawnvehicle just in case it was set
                        if (DHP.Pawn == none)
                        {
                            MyDeployMenu.ChangeSpawnIndices(MyDeployMenu.SpawnPointIndex, MyDeployMenu.VehiclePoolIndex, 255);
                            SpawnClick();
                        }
                    }
                    else
                    {
                        // Set SpawnPoint and clear spawnvehicle point as we clicked a spawn point
                        MyDeployMenu.ChangeSpawnIndices(b_SpawnPoints[i].Tag, MyDeployMenu.VehiclePoolIndex, 255);
                    }

                    break;
                }
            }

            for (i = 0; i < arraycount(b_SpawnVehicles); ++i)
            {
                if (Selected == b_SpawnVehicles[i])
                {
                    if (b_SpawnVehicles[i].Tag == MyDeployMenu.SpawnVehicleIndex)
                    {
                        // Clear pool and spawnpoint just incase either were set
                        MyDeployMenu.ChangeSpawnIndices(255, 255, MyDeployMenu.SpawnVehicleIndex);
                        SpawnClick();
                    }
                    else
                    {
                        // Set SpawnVehiclePoint and clear pool & spawnpoint value, as we clicked a spawnvehicle point
                        MyDeployMenu.ChangeSpawnIndices(255, 255, b_SpawnVehicles[i].Tag);
                    }

                    break;
                }
            }

            break;
    }

    return false;
}


function bool DrawDeployTimer(Canvas C)
{
    local float P; // Progress
    local bool bButtonEnabled, bProgressComplete;

    // Handle progress bar
    if (!bOutOfReinforcements)
    {
        P = pb_DeployProgressBar.High * (DHP.LastKilledTime + DHP.SpawnTime - DHP.Level.TimeSeconds) / DHP.SpawnTime;
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
    if (GRI.bMatchHasBegun && !bOutOfReinforcements && (AreIndicesValid() || DHP.ClientLevelInfo.SpawnMode == ESM_RedOrchestra))
    {
        // match started, team not out of reinforcements, have legit indices, and no pawn
        if (MyDeployMenu.Tab == TAB_Vehicle && GRI.IsVehiclePoolIndexValid(MyDeployMenu.VehiclePoolIndex, MyRoleMenu.desiredRole))
        {
            // We are deploying a vehicle and our vehicle pool index is valid
            b_DeployButton.EnableMe();
            bButtonEnabled = true;
        }
        else if (MyDeployMenu.Tab == TAB_Role && (GRI.IsSpawnPointIndexValid(MyDeployMenu.SpawnPointIndex, DHP.GetTeamNum()) ||
                                                  GRI.CanSpawnAtVehicle(MyDeployMenu.SpawnVehicleIndex, DHP)))
        {
            // We are deploying infantry and either our spawn point or vehicle spawn point is valid
            b_DeployButton.EnableMe();
            bButtonEnabled = true;
        }
        else if (DHP.ClientLevelInfo.SpawnMode == ESM_RedOrchestra)
        {
            // We are on a RO spawn room map
            b_DeployButton.EnableMe();
            bButtonEnabled = true;
        }
        else
        {
            b_DeployButton.DisableMe();
        }
    }
    else
    {
        b_DeployButton.DisableMe();
    }

    // Handle button caption
    if (!GRI.bMatchHasBegun)
    {
        b_DeployButton.Caption = DeployBarText[6]; // "Round not in play"
    }
    else if (!AreIndicesValid())
    {
        b_DeployButton.Caption = DeployBarText[0]; // "Make sure you have a role and/or vehicle selected"
    }
    else if (!GRI.IsSpawnPointIndexValid(MyDeployMenu.SpawnPointIndex, DHP.GetTeamNum()) && !GRI.CanSpawnAtVehicle(MyDeployMenu.SpawnVehicleIndex, DHP) && DHP.ClientLevelInfo.SpawnMode == ESM_DarkestHour)
    {
        b_DeployButton.Caption = DeployBarText[1]; // "Select a spawnpoint"
    }
    else if (bOutOfReinforcements)
    {
        b_DeployButton.Caption = DeployBarText[2]; // "Your team is out of reinforcements"
    }
    else if (!bProgressComplete)
    {
        b_DeployButton.Caption = DeployBarText[3] @ int(Ceil(DHP.LastKilledTime + DHP.SpawnTime - DHP.Level.TimeSeconds)) @ DeployBarText[4];
    }
    else
    {
        b_DeployButton.Caption = DeployBarText[7]; // "Deploy!"
    }

    if (bButtonEnabled && bProgressComplete)
    {
        bReadyToDeploy = true;
    }

    return false;
}

defaultproperties
{
    bNeverFocus=true
    OnRendered=DHDeploymentMapMenu.InternalOnPostDraw
    ReinforcementText="Reinforcements Remaining:"

    DeployBarText(0)="Make sure you have a role and/or vehicle selected"
    DeployBarText(1)="Select a spawnpoint"
    DeployBarText(2)="Your team is out of reinforcements"
    DeployBarText(3)="Deploy in:"
    DeployBarText(4)="seconds | Close & Deploy When Ready"
    DeployBarText(5)="You are already deployed"
    DeployBarText(6)="Round not in play"
    DeployBarText(7)="Deploy!"
    DeployBarText(8)=""
    DeployBarText(9)=""

    SPSelectedSize=(X=0.075,Y=0.035)
    SPSize=(X=0.07,Y=0.03)
    ObjSize=(X=0.04,Y=0.04)
    //SVSize=
    //SVSelectedSize=

    ObjectiveIcons(0)=Texture'DH_GUI_Tex.GUI.GerCross'
    ObjectiveIcons(1)=Texture'DH_GUI_Tex.GUI.AlliedStar'
    ObjectiveIcons(2)=Texture'DH_GUI_Tex.GUI.NeutralObj'

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

    // Spawn room button
    Begin Object class=DHGUIButton Name=SpawnRoomButton
        Caption="Spawn Room"
        CaptionAlign=TXTA_Center
        RenderWeight=5.85
        StyleName="DHSpawnButtonStyle"
        WinWidth=0.3
        WinHeight=0.1
        WinLeft=0.35
        WinTop=0.45
        OnClick=InternalOnClick
    End Object
    b_SpawnRoom=SpawnRoomButton

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
    b_Objectives(16)=ObjectiveButton
    b_Objectives(17)=ObjectiveButton
    b_Objectives(18)=ObjectiveButton
    b_Objectives(19)=ObjectiveButton
    b_Objectives(20)=ObjectiveButton
    b_Objectives(21)=ObjectiveButton
    b_Objectives(22)=ObjectiveButton
    b_Objectives(23)=ObjectiveButton
    b_Objectives(24)=ObjectiveButton
    b_Objectives(25)=ObjectiveButton
    b_Objectives(26)=ObjectiveButton
    b_Objectives(27)=ObjectiveButton
    b_Objectives(28)=ObjectiveButton
    b_Objectives(29)=ObjectiveButton
    b_Objectives(30)=ObjectiveButton
    b_Objectives(31)=ObjectiveButton

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
