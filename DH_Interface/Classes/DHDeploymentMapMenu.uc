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

var     automated GUIGFXButton              b_SpawnPoints[SPAWN_POINTS_MAX],b_Objectives[OBJECTIVES_MAX];
var     DHSpawnPoint                        SpawnPoints[SPAWN_POINTS_MAX];
var     ROObjective                         Objectives[OBJECTIVES_MAX]; //Not sure if I need these

var     Material                            ObjectiveIcons[3]; //Objective flash modes

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
    local float L;

    //MapContainer.WinHeight = 0.95; //Theel: do I need this?
    L = MapContainer.ActualHeight();
    MenuOwner.SetPosition(MenuOwner.WinLeft, MenuOwner.WinTop, L, MenuOwner.WinHeight, true);
    MapContainer.SetPosition(MapContainer.WinLeft, MapContainer.WinTop, MapContainer.WinWidth, L, true);

    return false;
}

function GetMapCoords(vector Location, out float X, out float Y)
{
    local float TDistance;
    local float Distance;

    TDistance = Abs(GRI.SouthWestBounds.X) + Abs(GRI.NorthEastBounds.X);
    Distance = Abs(GRI.NorthEastBounds.X - Location.X);
    X = Distance / TDistance;

    TDistance = Abs(GRI.SouthWestBounds.Y) + Abs(GRI.NorthEastBounds.Y);
    Distance = Abs(GRI.SouthWestBounds.Y - Location.Y);
    //Because the map is managed by a container, lets form to the container's winheight
    Y = Distance / TDistance * MapContainer.WinHeight;
}

function PlaceSpawnPointOnMap(DHSpawnPoint SP, int Index)
{
    local float X, Y;

    if (SP != none && Index >= 0 && Index < arraycount(b_SpawnPoints))
    {
        GetMapCoords(SP.Location, X, Y);

        b_SpawnPoints[Index].SetPosition(X, Y, 0.05, 0.05, true);
        b_SpawnPoints[Index].Graphic = texture'InterfaceArt_tex.Tank_Hud.RedDot';
        b_SpawnPoints[Index].Caption = SP.SpawnPointName;

        SpawnPoints[Index] = SP;
    }
}

function PlaceObjectiveOnMap(ROObjective O, int Index)
{
    local float X, Y;

    if (O != none && Index >= 0 && Index < arraycount(b_Objectives))
    {
        GetMapCoords(O.Location, X, Y);

        b_Objectives[Index].SetPosition(X, Y, 0.05, 0.05, true);
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

    //Get/Draw Spawn Points for Current Team
    GRI.GetActiveSpawnPointsForTeam(ActiveSpawnPoints, PlayerOwner().PlayerReplicationInfo.Team.TeamIndex);

    for(i = 0; i < ActiveSpawnPoints.Length; ++i)
    {
        PlaceSpawnPointOnMap(ActiveSpawnPoints[i], i);
    }

    //Draw objectives
    for (i = 0; i < arraycount(GRI.Objectives); i++)
    {
        if (GRI.Objectives[i] == none || !GRI.Objectives[i].bActive)
        {
            continue;
        }

        PlaceObjectiveOnMap(GRI.Objectives[i], i);
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

    //TODO: Need a check here to make sure player has role & stuff selected!

    //Set the deisred spawn point
    //DesiredSpawnPoint = SpawnPoints[Index];

    //Player already has a pawn, so lets close entire deploymenu
    if (PC.Pawn != none)
    {
        Controller.CloseMenu(false);
    }

    //Player isn't ready to respawn, as the redeploy timer hasn't reached 0?

    //Spawn the player, teleport to spawn point, and send ammo % so it can be known to game
    PC.CurrentRedeployTime = PC.RedeployTime; //This make it so the player can't adjust Redeploytime post spawning

    if (PC.bReadyToSpawn && PC.Pawn == none)
    {
        PC.ServerDeployPlayer(SpawnPoints[Index], true);
        Controller.CloseMenu(false); //DeployPlayer needs to return true/false if succesful and this needs to be in an if statement
    }
}

function bool InternalOnClick(GUIComponent Sender)
{
    local GUIButton Selected;
    local int i;

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

    Begin Object Class=GUIGFXButton Name=SpawnPointButton
        Graphic=texture'InterfaceArt_tex.Tank_Hud.RedDot'
        Position=ICP_Justified
        bClientBound=true
        StyleName="DHGripButtonNB"
        WinWidth=0.1
        WinHeight=0.1
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
        WinWidth=0.1
        WinHeight=0.1
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
