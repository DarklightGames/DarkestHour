//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHDeploymentMapMenu extends MidGamePanel;

const   OBJECTIVES_MAX =                    16;
const   SPAWN_POINTS_MAX =                  16;

var automated ROGUIProportionalContainer    MapContainer;

var localized string                        ReinforcementText;

var     bool                                bReadyToDeploy;
var     automated GUILabel                  l_ReinforcementCount, l_RoundTime;
var     automated GUIImage                  i_Background;
var     automated DHGUIButton               b_DeployButton, b_ExploitSpawn;
var     automated GUIProgressBar            pb_DeployProgressBar;
var     automated GUIGFXButton              b_SpawnPoints[SPAWN_POINTS_MAX],b_Objectives[OBJECTIVES_MAX];
var     DHSpawnPoint                        SpawnPoints[SPAWN_POINTS_MAX];
var     ROObjective                         Objectives[OBJECTIVES_MAX];
var     Material                            ObjectiveIcons[3];

var     DHGameReplicationInfo               GRI;
var     DHPlayerReplicationInfo             PRI;
var     DHPlayer                            PC;
var     DHHud                               HUD;
var     vector                              NELocation,SWLocation;

//Deploy Menu Access
var DHDeployMenu                            myDeployMenu;
var DHRoleSelectPanel                       myRoleMenu;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;

    Super.InitComponent(MyController, MyOwner);

    PC = DHPlayer(PlayerOwner());
    if (PC == none)
    {
        return;
    }
    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
    HUD = DHHud(PC.myHUD);
    if (GRI == none || HUD == none || PRI == none)
    {
        return;
    }

    // Assign myDeployMenu
    myDeployMenu = DHDeployMenu(PageOwner);

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

    // Initialize objective points (make hidden)
    for (i = 0; i < arraycount(b_Objectives); ++i)
    {
        b_Objectives[i].Graphic = none;
    }

    // Set the location of the map bounds
    NELocation = GRI.NorthEastBounds;
    SWLocation = GRI.SouthWestBounds;

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
    }
}

function ClearSpawnIcon(int i)
{
    if (b_SpawnPoints[i] != none)
    {
        b_SpawnPoints[i].WinWidth=0.0;
        b_SpawnPoints[i].WinHeight=0.0;
        b_SpawnPoints[i].SetVisibility(false);
    }
}

// Make panel uniform (square) and adjust other components accordingly
function bool PreDrawMap(Canvas C)
{
    local float ImageHeight, LeftOverSpace;

    ImageHeight = MapContainer.ActualHeight();
    MenuOwner.SetPosition(MenuOwner.WinLeft, MenuOwner.WinTop, ImageHeight, MenuOwner.WinHeight, true);
    MapContainer.SetPosition(MapContainer.WinLeft, MapContainer.WinTop, MapContainer.WinWidth, ImageHeight, true);

    LeftOverSpace = 1.0 - MapContainer.WinHeight;

    pb_DeployProgressBar.SetPosition(MapContainer.WinLeft, MapContainer.WinHeight, MapContainer.WinWidth, LeftOverSpace, true);
    b_DeployButton.SetPosition(MapContainer.WinLeft, MapContainer.WinHeight, MapContainer.WinWidth, LeftOverSpace, true);

    return false;
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
function PlaceSpawnPointOnMap(DHSpawnPoint SP, int Index)
{
    local float X, Y, W, H;

    if (SP != none && Index >= 0 && Index < arraycount(b_SpawnPoints))
    {
        if (SP == PC.DesiredSpawnPoint)
        {
            W = 0.075;
            H = 0.035;

            GetMapCoords(SP.Location, X, Y, W, H);

            b_SpawnPoints[Index].SetPosition(X, Y, W, H, true);
            b_SpawnPoints[Index].SetFocus(none);
        }
        else
        {
            W = 0.07;
            H = 0.03;

            GetMapCoords(SP.Location, X, Y, W, H);

            b_SpawnPoints[Index].SetPosition(X, Y, W, H, true);
        }

        b_SpawnPoints[Index].Caption = Caps(Left(SP.SpawnPointName, 2));
        b_SpawnPoints[Index].SetVisibility(true);
        SpawnPoints[Index] = SP;
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

//Theel: will eventually want to draw 'deployed' MDVs also
function bool DrawMapComponents(Canvas C)
{
    local int i;
    local array<DHSpawnPoint> ActiveSpawnPoints;

    if (myDeployMenu == none)
    {
        return false;
    }

    //Draw objectives
    for (i = 0; i < arraycount(GRI.Objectives); ++i)
    {
        if (GRI.Objectives[i] == none || !GRI.Objectives[i].bActive)
        {
            continue;
        }

        PlaceObjectiveOnMap(GRI.Objectives[i], i);
    }

    //Get Spawn Points for Current Team
    GRI.GetActiveSpawnPointsForTeam(ActiveSpawnPoints, PRI.Team.TeamIndex);

    for (i = 0; i < ActiveSpawnPoints.Length; ++i)
    {
        // Draw infantry or vehicle spawn points
        if (!myDeployMenu.bSpawningVehicle && ActiveSpawnPoints[i].Type == ESPT_Infantry)
        {
            PlaceSpawnPointOnMap(ActiveSpawnPoints[i], i);
        }
        else if (myDeployMenu.bSpawningVehicle && ActiveSpawnPoints[i].Type == ESPT_Vehicles)
        {
            PlaceSpawnPointOnMap(ActiveSpawnPoints[i], i);
        }
        else
        {
            ClearSpawnIcon(i);
        }
    }

    return false;
}

// Actually shows the panel once it's rendered (Needs confirmed and tested)
function InternalOnPostDraw(Canvas Canvas)
{
    bInit = false;
    OnRendered = none;
    ShowPanel(true);

    // Set myRoleMenu here to make sure it is initialized, though it should always be, do it here just in case
    if (myDeployMenu != none && myDeployMenu.c_LoadoutArea.TabStack.Length > 0 && myDeployMenu.c_LoadoutArea.TabStack[0].MyPanel != none)
    {
        myRoleMenu = DHRoleSelectPanel(myDeployMenu.c_LoadoutArea.TabStack[0].MyPanel);
    }
}

// Player clicked a spawn point
function bool SpawnClick(int Index)
{
    if (bInit || PRI == none || PRI.bOnlySpectator)
    {
        return true;
    }

    if (Index != -1 && SpawnPoints[Index] == none)
    {
        Log("No spawn point found! Error!");
        return true;
    }

    // Check if we clicked the desired spawn point
    if (Index == -1 || SpawnPoints[Index] == PC.DesiredSpawnPoint)
    {
        // We clicked desired spawn point! lets try to spawn
        // Only deploy if we clicked the selected SP and are ready
        if (bReadyToDeploy && PC.Pawn == none && myRoleMenu != none)
        {
            myRoleMenu.AttemptRoleApplication();
            PC.ServerAttemptDeployPlayer(PC.DesiredSpawnPoint, PC.DesiredAmmoAmount);
            Controller.CloseMenu(false); //Close menu as we clicked deploy!
        }
    }
    else
    {
        // Set the desired spawn point
        PC.DesiredSpawnPoint = SpawnPoints[Index];
    }
}

function bool InternalOnClick(GUIComponent Sender)
{
    local GUIButton Selected;
    local int i;

    switch(Sender)
    {
        case b_ExploitSpawn:
            if (PC.Pawn == none && myRoleMenu != none)
            {
                myRoleMenu.AttemptRoleApplication();
                PC.ServerAttemptDeployPlayer(PC.DesiredSpawnPoint, PC.DesiredAmmoAmount, true);
                Controller.CloseMenu(false); //Close menu as we clicked deploy!
            }

            break;

        case b_DeployButton: //Below should be a separate function so it can be reused when player clicks a desired spawn point
            if (PC.DesiredSpawnPoint != none)
            {
                SpawnClick(-1);
            }
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
                    SpawnClick(i);
                    break;
                }
            }
            break;
    }
    return false;
}

// This function will require heavy redesign when I make things someone server sided
function bool DrawDeployTimer(Canvas C)
{
    local float P;

    //Handle progress bar values (so they move/advance based on deploy time)
    if (!bReadyToDeploy)
    {
        P = pb_DeployProgressBar.High * (PC.LastKilledTime + PC.RedeployTime - PC.Level.TimeSeconds) / PC.RedeployTime;
        P = pb_DeployProgressBar.High - P;
        pb_DeployProgressBar.Value = FClamp(P, pb_DeployProgressBar.Low, pb_DeployProgressBar.High);

        if (pb_DeployProgressBar.Value == pb_DeployProgressBar.High)
        {
            //Progress is done
            bReadyToDeploy = true;
            b_DeployButton.EnableMe();
        }
        else
        {
            //Progress isn't done
            b_DeployButton.Caption = "Deploy in:" @ int(Ceil(PC.LastKilledTime + PC.RedeployTime - PC.Level.TimeSeconds)) @ "Seconds";
            bReadyToDeploy = false;
            b_DeployButton.DisableMe();
        }
    }
    else
    {
        if (PC.DesiredSpawnPoint == none)
        {
            //b_DeployButton.Caption = "Select a spawn point";
            // Temp hack to make it so you can spawn on maps without spawn points
            b_DeployButton.Caption = "Select a spawn point or Deploy to SpawnArea";
            b_DeployButton.EnableMe();
        }
        else if (PC.Pawn != none)
        {
            b_DeployButton.Caption = "Deployed"; //If we have a pawn and progress bar has finished, we are deployed
            b_DeployButton.DisableMe();
        }
        else
        {
            b_DeployButton.EnableMe();
            pb_DeployProgressBar.Value = pb_DeployProgressBar.High;
            b_DeployButton.Caption = "Deploy!";
        }
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
        OnPreDraw=DHDeploymentMapMenu.PreDrawMap
        OnDraw=DHDeploymentMapMenu.DrawMapComponents
    End Object
    i_Background=GUIImage'DH_Interface.DHDeploymentMapMenu.BackgroundImage'

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
        OnClick=DHDeploymentMapMenu.InternalOnClick
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
        OnClick=DHDeploymentMapMenu.InternalOnClick
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
        OnDraw=DHDeploymentMapMenu.DrawDeployTimer
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
        OnClick=DHDeploymentMapMenu.InternalOnClick
    End Object
    b_SpawnPoints(0)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(1)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(2)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(3)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(4)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(5)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(6)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(7)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(8)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(9)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(10)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(11)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(12)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(13)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(14)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'
    b_SpawnPoints(15)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.SpawnPointButton'

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
    b_Objectives(0)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.ObjectiveButton'
    b_Objectives(1)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.ObjectiveButton'
    b_Objectives(2)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.ObjectiveButton'
    b_Objectives(3)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.ObjectiveButton'
    b_Objectives(4)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.ObjectiveButton'
    b_Objectives(5)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.ObjectiveButton'
    b_Objectives(6)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.ObjectiveButton'
    b_Objectives(7)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.ObjectiveButton'
    b_Objectives(8)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.ObjectiveButton'
    b_Objectives(9)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.ObjectiveButton'
    b_Objectives(10)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.ObjectiveButton'
    b_Objectives(11)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.ObjectiveButton'
    b_Objectives(12)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.ObjectiveButton'
    b_Objectives(13)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.ObjectiveButton'
    b_Objectives(14)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.ObjectiveButton'
    b_Objectives(15)=GUIGFXButton'DH_Interface.DHDeploymentMapMenu.ObjectiveButton'

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
