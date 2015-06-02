//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHDeploymentMapMenu extends GUIPanel;

const   OBJECTIVES_MAX =                    32; // Max objectives total
const   SPAWN_POINTS_MAX =                  48; // Max spawn points total (make sure this matches GRI)
const   SPAWN_VEHICLES_MAX =                8;  // Max spawn vehicles total (make sure this matches GRI)

var     automated GUIImage                  i_Background;
var     automated GUIGFXButton              b_SpawnPoints[SPAWN_POINTS_MAX],
                                            b_Objectives[OBJECTIVES_MAX],
                                            b_SpawnVehicles[SPAWN_VEHICLES_MAX];

var     int                                 SpawnPoint;
var     int                                 SpawnVehicle;

var     Material                            ObjectiveIcons[3];

var     DHGameReplicationInfo               GRI;
var     DHPlayer                            PC;
var     vector                              NELocation,
                                            SWLocation;

//Deploy Menu Access
var DHDeployMenu                            MyDeployMenu;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local rotator R;

    super.InitComponent(MyController, MyOwner);

    PC = DHPlayer(PlayerOwner());

    if (PC == none)
    {
        return;
    }

    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

    if (GRI == none)
    {
        return;
    }

    // Assign MyDeployMenu
    MyDeployMenu = DHDeployMenu(PageOwner);

    // Set the level map image
    i_Background.Image = GRI.MapImage;

    // Set rotator based on map rotation offset
    R.Yaw = GRI.OverheadOffset * 182.044444;

    // Set the location of the map bounds
    NELocation = GRI.NorthEastBounds << R;
    SWLocation = GRI.SouthWestBounds << R;

    //TODO: this is sloppy, figure out a better way
    Update();

    SetTimer(1.0, true);
}

function Update()
{
    local int i;
    local float X, Y;
    local TexRotator TR;

    // Objectives
    for (i = 0; i < arraycount(b_Objectives); ++i)
    {
        if (GRI.DHObjectives[i] != none &&
            GRI.DHObjectives[i].bActive)
        {
            GetMapCoords(GRI.DHObjectives[i].Location, X, Y, b_Objectives[i].WinWidth, b_Objectives[i].WinHeight);

            //TODO: fuck this, graphic is going to be replaced with special plan
            b_Objectives[i].Graphic = ObjectiveIcons[int(GRI.DHObjectives[i].ObjState)];
            b_Objectives[i].SetPosition(X, Y, b_Objectives[i].WinWidth, b_Objectives[i].WinHeight, true);
            b_Objectives[i].SetVisibility(true);
        }
        else
        {
            b_Objectives[i].SetVisibility(false);
        }
    }

    // Spawn points
    for (i = 0; i < arraycount(b_SpawnPoints); ++i)
    {
        if (GRI.SpawnPoints[i] != none &&
            GRI.SpawnPoints[i].TeamIndex == MyDeployMenu.CurrentTeam &&
            GRI.IsSpawnPointActive(GRI.SpawnPoints[i]) &&
            ((MyDeployMenu.LoadoutMode == LM_Equipment && GRI.SpawnPoints[i].CanSpawnInfantry()) ||
             (MyDeployMenu.LoadoutMode == LM_Vehicle && GRI.SpawnPoints[i].CanSpawnVehicles())))
        {
            GetMapCoords(GRI.SpawnPoints[i].Location, X, Y, b_SpawnPoints[i].WinWidth, b_SpawnPoints[i].WinHeight);

            b_SpawnPoints[i].Tag = i;
            b_SpawnPoints[i].SetPosition(X, Y, b_SpawnPoints[i].WinWidth, b_SpawnPoints[i].WinHeight, true);
            b_SpawnPoints[i].SetVisibility(true);
        }
        else
        {
            b_SpawnPoints[i].SetVisibility(false);
        }
    }

    // Spawn vehicles
    for (i = 0; i < arraycount(b_SpawnVehicles); ++i)
    {
        if (MyDeployMenu.LoadoutMode != LM_Vehicle &&
            GRI.SpawnVehicles[i].VehicleClass != none &&
            GRI.SpawnVehicles[i].TeamIndex == MyDeployMenu.CurrentTeam)
        {
            GetMapCoords(GRI.SpawnVehicles[i].Location, X, Y, b_SpawnVehicles[i].WinWidth, b_SpawnVehicles[i].WinHeight);

            b_SpawnVehicles[i].Tag = i;
            b_SpawnVehicles[i].SetPosition(X, Y, b_SpawnVehicles[i].WinWidth, b_SpawnVehicles[i].WinHeight, true);
            b_SpawnVehicles[i].SetVisibility(true);

            TR = TexRotator(b_SpawnVehicles[i].Graphic);

            if (TR != none)
            {
                //TODO: verify correctness and take map rotation into consideration
                TR.Rotation.Roll = GRI.SpawnVehicles[i].Location.Z;
            }
        }
        else
        {
            b_SpawnVehicles[i].SetVisibility(false);
        }
    }
}

function Timer()
{
    Update();
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

// This function still needs to support levels with odd rotated NE and SW and "rotation"
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
    Y = (1.0 - (Distance / TDistance)) - (H / 2);
}

function bool OnDblClick(GUIComponent Sender)
{
    local int i;

    for (i = 0; i < arraycount(b_SpawnPoints); ++i)
    {
        if (Sender == b_SpawnPoints[i])
        {
            SpawnPoint = b_SpawnPoints[i].Tag;
            MyDeployMenu.Apply();

            return true;
        }
    }

    for (i = 0; i < arraycount(b_SpawnVehicles); ++i)
    {
        if (Sender == b_SpawnVehicles[i])
        {
            SpawnVehicle = b_SpawnVehicles[i].Tag;
            MyDeployMenu.Apply();

            return true;
        }
    }

    return false;
}

function bool OnClick(GUIComponent Sender)
{
    local int i;

    for (i = 0; i < arraycount(b_SpawnPoints); ++i)
    {
        if (Sender == b_SpawnPoints[i])
        {
            SpawnPoint = b_SpawnPoints[i].Tag;
            return true;
        }
    }

    for (i = 0; i < arraycount(b_SpawnVehicles); ++i)
    {
        if (Sender == b_SpawnVehicles[i])
        {
            SpawnVehicle = b_SpawnVehicles[i].Tag;

            return true;
        }
    }

    return false;
}

defaultproperties
{
    bNeverFocus=true

    SpawnVehicle=255;
    SpawnPoint=255

    //TODO: special plans for this
    ObjectiveIcons(0)=Texture'DH_GUI_Tex.GUI.GerCross'
    ObjectiveIcons(1)=Texture'DH_GUI_Tex.GUI.AlliedStar'
    ObjectiveIcons(2)=Texture'DH_GUI_Tex.GUI.NeutralObj'

    // Image for level map
    Begin Object Class=GUIImage Name=BackgroundImage
        ImageStyle=ISTY_Scaled
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        bAcceptsInput=false
    End Object
    i_Background=BackgroundImage

    // Spawn points
    Begin Object Class=GUIGFXButton Name=SpawnPointButton
        Position=ICP_Normal
        bClientBound=true
        StyleName="DHSpawnButtonStyle"
        WinWidth=0.04
        WinHeight=0.04
        bTabStop=true
        OnClick=OnClick
        OnDblClick=OnDblClick
        bVisible=false
    End Object

    //TODO: This is begging to be put into a loop somewhere
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
    b_SpawnPoints(16)=SpawnPointButton
    b_SpawnPoints(17)=SpawnPointButton
    b_SpawnPoints(18)=SpawnPointButton
    b_SpawnPoints(19)=SpawnPointButton
    b_SpawnPoints(20)=SpawnPointButton
    b_SpawnPoints(21)=SpawnPointButton
    b_SpawnPoints(22)=SpawnPointButton
    b_SpawnPoints(23)=SpawnPointButton
    b_SpawnPoints(24)=SpawnPointButton
    b_SpawnPoints(25)=SpawnPointButton
    b_SpawnPoints(26)=SpawnPointButton
    b_SpawnPoints(27)=SpawnPointButton
    b_SpawnPoints(28)=SpawnPointButton
    b_SpawnPoints(29)=SpawnPointButton
    b_SpawnPoints(30)=SpawnPointButton
    b_SpawnPoints(31)=SpawnPointButton
    b_SpawnPoints(32)=SpawnPointButton
    b_SpawnPoints(33)=SpawnPointButton
    b_SpawnPoints(34)=SpawnPointButton
    b_SpawnPoints(35)=SpawnPointButton
    b_SpawnPoints(36)=SpawnPointButton
    b_SpawnPoints(37)=SpawnPointButton
    b_SpawnPoints(38)=SpawnPointButton
    b_SpawnPoints(39)=SpawnPointButton
    b_SpawnPoints(40)=SpawnPointButton
    b_SpawnPoints(41)=SpawnPointButton
    b_SpawnPoints(42)=SpawnPointButton
    b_SpawnPoints(43)=SpawnPointButton
    b_SpawnPoints(44)=SpawnPointButton
    b_SpawnPoints(45)=SpawnPointButton
    b_SpawnPoints(46)=SpawnPointButton
    b_SpawnPoints(47)=SpawnPointButton

    // Spawn Vehicle Buttons
    Begin Object Class=GUIGFXButton Name=SpawnVehicleButton
        Position=ICP_Normal
        bClientBound=true
        StyleName="DHSpawnButtonStyle"
        WinWidth=0.04
        WinHeight=0.04
        bTabStop=true
        OnClick=OnClick
        OnDblClick=OnDblClick
        bVisible=false
    End Object

    b_SpawnVehicles(0)=SpawnVehicleButton
    b_SpawnVehicles(1)=SpawnVehicleButton
    b_SpawnVehicles(2)=SpawnVehicleButton
    b_SpawnVehicles(3)=SpawnVehicleButton
    b_SpawnVehicles(4)=SpawnVehicleButton
    b_SpawnVehicles(5)=SpawnVehicleButton
    b_SpawnVehicles(6)=SpawnVehicleButton
    b_SpawnVehicles(7)=SpawnVehicleButton

    // Objective buttons
    Begin Object Class=GUIGFXButton Name=ObjectiveButton
        Graphic=texture'InterfaceArt_tex.Tank_Hud.RedDot'
        Position=ICP_Justified
        bClientBound=true
        StyleName="DHGripButtonNB"
        WinWidth=0.04
        WinHeight=0.04
        bTabStop=true
        bVisible=false
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
}
