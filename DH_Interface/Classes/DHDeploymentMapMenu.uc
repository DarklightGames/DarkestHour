//-----------------------------------------------------------
// DHDeploymentMapMenu
//-----------------------------------------------------------
//Theel: ToDo: This class still has a ton of work
//- Remove uneeded shit
//- Fix draw map problems
//- Clean up code
//This will require a black room, but the player will never see or experience it and it is strictly
//to reduce the required number of player starts and allow pawns to start "inside" eachother
//Allowing for smaller cover to protect spawns!!!

class DHDeploymentMapMenu extends MidGamePanel;

const OBJECTIVES_MAX = 16;
const SPAWN_POINTS_MAX = 16;

var automated ROGUIProportionalContainer    MapContainer;

var()   float                               DeploymentMapCenterX, DeploymentMapCenterY, DeploymentMapRadius;

var     automated GUIImage                  i_Background;

var     automated DHGUIButton               b_DeployButton;

var     automated GUIProgressBar            pb_DeployProgressBar;

var     automated GUIGFXButton              b_SpawnPoints[SPAWN_POINTS_MAX],b_Objectives[OBJECTIVES_MAX];
var     DHSpawnPoint                        SpawnPoints[SPAWN_POINTS_MAX];
var     ROObjective                         Objectives[OBJECTIVES_MAX]; //Not sure if I need these

var     Material                            ObjectiveIcons[3]; //Objective flash modes

var     bool                                bReadyToDeploy;

// Actor references - these must be cleared at level change
var     DHGameReplicationInfo               GRI;
var     DHPlayerReplicationInfo             PRI;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;

    Super.InitComponent(MyController, MyOwner);

    GRI = DHGameReplicationInfo(PlayerOwner().GameReplicationInfo);

    //Set the level image
    i_Background.Image = GRI.MapImage;

    MapContainer.ManageComponent(i_Background);
    //Background = GRI.MapImage;

    for (i = 0; i < arraycount(b_SpawnPoints); ++i)
    {
        b_SpawnPoints[i].Graphic = none;
    }

    for (i = 0; i < arraycount(b_Objectives); ++i)
    {
        b_Objectives[i].Graphic = none;
    }
}

event Opened(GUIComponent Sender)
{
    super.Opened(Sender);
}

//Not sure what this does yet.
function ShowPanel(bool bShow)
{
    local string ColorName, Caption;

    super.ShowPanel(bShow);

    if (bShow && PRI != none && PRI.Team != none)
    {
        ColorName = PRI.Team.ColorNames[PRI.Team.TeamIndex];
    }
}

function bool InternalOnPreDraw( Canvas C )
{
    return false;
}

function bool PreDrawMap(Canvas C)
{
    local float L, ML, BL;

    //MapContainer.WinHeight = 0.95; //Theel: do I need this?
    L = MapContainer.ActualHeight();
    MenuOwner.SetPosition(MenuOwner.WinLeft, MenuOwner.WinTop, L, MenuOwner.WinHeight, true); //Tab docking panel
    MapContainer.SetPosition(MapContainer.WinLeft, MapContainer.WinTop, MapContainer.WinWidth, L, true); //Container map is in!

    //We should move the deploy button + progress bar to match/fit bottom of map
    //Need to calculate how far down to place
    //ML = L + MenuOwner.WinTop; //need one more + the height of tab dock
    //BL = 1.0 - L
    BL = 1.0 - MapContainer.WinHeight;

    pb_DeployProgressBar.SetPosition(MapContainer.WinLeft, MapContainer.WinHeight, MapContainer.WinWidth, BL, true);
    b_DeployButton.SetPosition(MapContainer.WinLeft, MapContainer.WinHeight, MapContainer.WinWidth, BL, true);

    return false;
}

function GetMapCoords(vector Location, out float X, out float Y)
{
    local float TDistance;
    local float Distance;

    TDistance = Abs(GRI.SouthWestBounds.X) + Abs(GRI.NorthEastBounds.X);
    if (Location.X >= 0.0)
    {
        Distance = Abs(GRI.SouthWestBounds.X) + Location.X;
    }
    else
    {
        Distance = Abs(GRI.SouthWestBounds.X) - Abs(Location.X);
    }

    if (Distance > TDistance)
    {
        Distance = TDistance;
    }
    X = Distance / TDistance;

    TDistance = Abs(GRI.SouthWestBounds.Y) + Abs(GRI.NorthEastBounds.Y);
    if (Location.Y >= 0.0)
    {
        Distance = Abs(GRI.SouthWestBounds.Y) + Location.Y;
    }
    else
    {
        Distance = Abs(GRI.SouthWestBounds.Y) - Abs(Location.Y);
    }

    if (Distance > TDistance)
    {
        Distance = TDistance;
    }
    //Because the map is managed by a container, lets form to the container's winheight
    Y = Distance / TDistance * MapContainer.WinHeight;
}

function PlaceSpawnPointOnMap(DHSpawnPoint SP, int Index)
{
    local float X, Y;

    if (SP != none && Index >= 0 && Index < arraycount(b_SpawnPoints))
    {
        GetMapCoords(SP.Location, X, Y);

        if (SP == DHPlayer(PlayerOwner()).DesiredSpawnPoint)
        {
            b_SpawnPoints[Index].SetPosition(X, Y, 0.06, 0.03, true);
        }
        else
        {
            b_SpawnPoints[Index].SetPosition(X, Y, 0.06, 0.03, true);
        }
        b_SpawnPoints[Index].Graphic = material'DH_GUI_Tex.DeployMenu.SpawnPointIndicator';
        b_SpawnPoints[Index].Caption = Caps(Left(SP.SpawnPointName, 2));

        SpawnPoints[Index] = SP;
    }
}

function PlaceObjectiveOnMap(ROObjective O, int Index)
{
    local float X, Y;

    if (O != none && Index >= 0 && Index < arraycount(b_Objectives))
    {
        GetMapCoords(O.Location, X, Y);

        b_Objectives[Index].SetPosition(X, Y, 0.04, 0.04, true);
        b_Objectives[Index].Graphic = ObjectiveIcons[int(GRI.Objectives[Index].ObjState)];
        b_Objectives[Index].Caption = O.ObjectiveName;

        Objectives[Index] = O;
    }
}

function bool DrawMapComponents(Canvas C)
{
    local int i;
    local array<DHSpawnPoint> ActiveSpawnPoints;
    local float H, W, L;

    //Draw objectives
    for (i = 0; i < arraycount(GRI.Objectives); i++)
    {
        if (GRI.Objectives[i] == none || !GRI.Objectives[i].bActive)
        {
            continue;
        }

        PlaceObjectiveOnMap(GRI.Objectives[i], i);
    }

    //Get/Draw Spawn Points for Current Team
    GRI.GetActiveSpawnPointsForTeam(ActiveSpawnPoints, PlayerOwner().PlayerReplicationInfo.Team.TeamIndex);

    for(i = 0; i < ActiveSpawnPoints.Length; ++i)
    {
        PlaceSpawnPointOnMap(ActiveSpawnPoints[i], i);
    }

    return false;
}

//After initial drawing is complete this is ran?
//Needs repurposed, this I guess actually shows the panel once it's rendered
function InternalOnPostDraw(Canvas Canvas)
{
    PRI = DHPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo);

    if (PRI != none)
    {
        bInit = false;
        OnRendered = None;

        ShowPanel(true);
    }
}

//Hehe this is a good function that handles either spawning or teleporting
function bool SpawnClick(int Index)
{
    local DHPlayer PC;

    //Log("Trying to call server restart player!!!");

    if (bInit || PRI == none || PRI.bOnlySpectator)
    {
        return true;
    }

    if (SpawnPoints[Index] == none)
    {
        Log("No spawn point found! Error!");

        return true;
    }

    PC = DHPlayer(PlayerOwner());

    //Check if we clicked the desired spawn point
    if (SpawnPoints[Index] == PC.DesiredSpawnPoint)
    {
        //We clicked desired spawn point! lets try to spawn
        //Only deploy if we clicked the selected SP and are ready
        if (PC.bReadyToSpawn && PC.Pawn == none)
        {
            PC.CurrentRedeployTime = PC.RedeployTime; //This make it so the player can't adjust Redeploytime post spawning
            PC.ServerDeployPlayer(SpawnPoints[Index], true);
            Controller.CloseMenu(false); //DeployPlayer needs to return true/false if succesful and this needs to be in an if statement
        }
    }
    else
    {
        //Set the desired spawn point
        PC.DesiredSpawnPoint = SpawnPoints[Index];

        //Should we close as below????
        //Player already has a pawn, so lets close deploymenu
        if (PC.Pawn != none)
        {
            Controller.CloseMenu(false);
        }
    }
}

function bool InternalOnClick(GUIComponent Sender)
{
    local GUIButton Selected;
    local int i;

    switch(Sender)
    {
        case b_DeployButton:
            //Send request to server to spawn as we think we can
            if (bReadyToDeploy)
            {
                DHPlayer(PlayerOwner()).CurrentRedeployTime = DHPlayer(PlayerOwner()).RedeployTime; //This make it so the player can't adjust Redeploytime post spawning
                DHPlayer(PlayerOwner()).ServerDeployPlayer(DHPlayer(PlayerOwner()).DesiredSpawnPoint, true);
                Controller.CloseMenu(false); //Close menu as we clicked deploy!
            }
            break;

        default:
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

//This function will require heavy redesign when I make things someone server sided
function bool DrawDeployTimer(Canvas C)
{
    local DHPlayer DHP;
    local float P;

    DHP = DHPlayer(PlayerOwner());

    //Handle progress bar values (so they move/advance based on deploy time)
    if (!DHP.bReadyToSpawn)
    {
        P = pb_DeployProgressBar.High * (DHP.LastKilledTime + DHP.CurrentRedeployTime - DHP.Level.TimeSeconds) / DHP.CurrentRedeployTime;
        P = pb_DeployProgressBar.High - P;
        pb_DeployProgressBar.Value = FClamp(P, pb_DeployProgressBar.Low, pb_DeployProgressBar.High);

        if (pb_DeployProgressBar.Value == pb_DeployProgressBar.High)
        {
            //Progress is done
            bReadyToDeploy = true;
        }
        else
        {
            //Progress isn't done
            b_DeployButton.Caption = "Deploy in:" @ int(DHP.LastKilledTime + DHP.CurrentRedeployTime - DHP.Level.TimeSeconds) @ "Seconds";
            bReadyToDeploy = false;
        }
    }
    else
    {
        if (DHP.DesiredSpawnPoint == none)
        {
            b_DeployButton.Caption = "Select a spawn point";
        }
        else if (DHP.Pawn != none)
        {
            b_DeployButton.Caption = "Deployed"; //If we have a pawn and progress bar has finished, we are deployed
            bReadyToDeploy = false;
        }
        else
        {
            bReadyToDeploy = true;
            pb_DeployProgressBar.Value = pb_DeployProgressBar.High;
            b_DeployButton.Caption = "Deploy!";
        }
    }
    return false;
}

//Hmmm wtf is this doing?
function Timer()
{
    local PlayerController PC;

    PC = PlayerOwner();
    PC.ServerRestartPlayer();
    PC.bFire = 0;
    PC.bAltFire = 0;
    Controller.CloseMenu(false);
}

defaultproperties
{
    //bFillHeight=True
    //WinWidth=1.0
    //WinHeight=0.8
    //WinLeft=0.0
    //WinTop=0.0

    //Background=Texture'DH_GUI_Tex.Menu.DHBox'
    bNeverFocus=true
    OnPreDraw=DHDeploymentMapMenu.InternalOnPreDraw
    OnRendered=DHDeploymentMapMenu.InternalOnPostDraw

    ObjectiveIcons(0)=Texture'DH_GUI_Tex.GUI.GerCross'
    ObjectiveIcons(1)=Texture'DH_GUI_Tex.GUI.AlliedStar'
    ObjectiveIcons(2)=Texture'DH_GUI_Tex.GUI.PlayerIcon'

    //These might need repurposed to support 512x512 and 1024x1024!
    DeploymentMapCenterX=0.650000   // THESE DO NOTHIGN NOW! ??
    DeploymentMapCenterY=0.400000
    DeploymentMapRadius=0.300000

    Begin Object Class=GUIImage Name=BackgroundImage
        //Image=Texture'DH_GUI_Tex.Menu.DHBox'
        ImageStyle=ISTY_Justified //Scaled
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        bAcceptsInput=false
        OnPreDraw=DHDeploymentMapMenu.PreDrawMap
        OnDraw=DHDeploymentMapMenu.DrawMapComponents
    End Object
    i_Background=GUIImage'DH_Interface.DHDeploymentMapMenu.BackgroundImage'

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
        StyleName="DHLargeText"
        WinWidth=0.315937
        WinHeight=0.033589
        WinLeft=0.137395
        WinTop=0.010181
        //bNeverFocus=true
        OnClick=DHDeploymentMapMenu.InternalOnClick
    End Object
    b_DeployButton=DeployButton

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

    Begin Object Class=GUIGFXButton Name=SpawnPointButton
        Graphic=material'DH_GUI_Tex.DeployMenu.SpawnPointIndicator'
        Position=ICP_Normal
        bClientBound=true
        StyleName="DHSmallTextButtonStyle"
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
}
