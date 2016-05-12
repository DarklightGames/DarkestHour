//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHGUIMapComponent extends GUIPanel;

const   SPAWN_POINTS_MAX =                  48; // Max spawn points total (make sure this matches GRI)
const   SPAWN_VEHICLES_MAX =                8;  // Max spawn vehicles total (make sure this matches GRI)

var automated   DHGUICheckBoxButton         b_SpawnPoints[SPAWN_POINTS_MAX],
                                            b_SpawnVehicles[SPAWN_VEHICLES_MAX];

var             DHHud                       MyHud;
var             DHGameReplicationInfo       GRI;
var             DHPlayer                    PC;

delegate OnSpawnPointChanged(byte SpawnPointIndex, byte SpawnVehicleIndex, optional bool bDoubleClick);

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
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

    MyHud = DHHud(PC.myHUD);

    if (MyHud == none)
    {
        return;
    }
}

function bool InternalOnDraw(Canvas C)
{
    local ROHud.AbsoluteCoordsInfo SubCoords;

    if (!bVisible)
    {
        return false;
    }

    SubCoords.PosX = ActualLeft();
    SubCoords.PosY = ActualTop();
    SubCoords.Width = ActualWidth();
    SubCoords.Height = ActualHeight();

    DHHud(PlayerOwner().myHUD).DrawMap(C, SubCoords, PC);

    return false;
}

function SelectSpawnPoint(byte SpawnPointIndex, byte SpawnVehicleIndex)
{
    local int i;

    for (i = 0; i < arraycount(b_SpawnPoints); ++i)
    {
        b_SpawnPoints[i].SetChecked(b_SpawnPoints[i].Tag == SpawnPointIndex);
    }

    for (i = 0; i < arraycount(b_SpawnVehicles); ++i)
    {
        b_SpawnVehicles[i].SetChecked(b_SpawnVehicles[i].Tag == SpawnVehicleIndex);
    }

    OnSpawnPointChanged(SpawnPointIndex, SpawnVehicleIndex);
}

function InternalOnCheckChanged(GUIComponent Sender, bool bChecked)
{
    local int i;

    if (!bChecked)
    {
        return;
    }

    for (i = 0; i < arraycount(b_SpawnPoints); ++i)
    {
        if (Sender == b_SpawnPoints[i])
        {
            OnSpawnPointChanged(b_SpawnPoints[i].Tag, 255);
        }
        else
        {
            b_SpawnPoints[i].SetChecked(false);
        }
    }

    for (i = 0; i < arraycount(b_SpawnVehicles); ++i)
    {
        if (Sender == b_SpawnVehicles[i])
        {
            OnSpawnPointChanged(255, b_SpawnVehicles[i].Tag);
        }
        else
        {
            b_SpawnVehicles[i].SetChecked(false);
        }
    }
}

function bool OnDblClick(GUIComponent Sender)
{
    local int i;

    for (i = 0; i < arraycount(b_SpawnPoints); ++i)
    {
        if (Sender == b_SpawnPoints[i])
        {
            OnSpawnPointChanged(b_SpawnPoints[i].Tag, 255, true);

            return true;
        }
    }

    for (i = 0; i < arraycount(b_SpawnVehicles); ++i)
    {
        if (Sender == b_SpawnVehicles[i])
        {
            OnSpawnPointChanged(255, b_SpawnVehicles[i].Tag, true);

            return true;
        }
    }

    return false;
}

function bool MyContextOpen(GUIContextMenu Menu)
{
    //return HandleContextMenuOpen(List, Menu, Menu.MenuOwner);
    return false;
}

function bool MyContextClose(GUIContextMenu Sender)
{
    //return HandleContextMenuClose(Sender);
    return false;
}

function MyContextSelect(GUIContextMenu Sender, int Index)
{
    //NotifyContextSelect(Sender, Index);
}

defaultproperties
{
    OnDraw=InternalOnDraw

    // Spawn points
    Begin Object Class=DHGUICheckBoxButton Name=SpawnPointButton
        StyleName="DHSpawnButtonStyle"
        WinWidth=0.04
        WinHeight=0.04
        bTabStop=false
        OnClick=OnClick
        OnDblClick=OnDblClick
        bVisible=false
        CheckedOverlay(0)=material'DH_GUI_Tex.DeployMenu.spawn_point_osc'
        CheckedOverlay(1)=material'DH_GUI_Tex.DeployMenu.spawn_point_osc'
        CheckedOverlay(2)=material'DH_GUI_Tex.DeployMenu.spawn_point_osc'
        CheckedOverlay(3)=material'DH_GUI_Tex.DeployMenu.spawn_point_osc'
        CheckedOverlay(4)=material'DH_GUI_Tex.DeployMenu.spawn_point_osc'
        OnCheckChanged=InternalOnCheckChanged
        bCanClickUncheck=false
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
    Begin Object Class=DHGUICheckBoxButton Name=SpawnVehicleButton
        StyleName="DHSpawnVehicleButtonStyle"
        WinWidth=0.04
        WinHeight=0.04
        bTabStop=false
        OnCheckChanged=InternalOnCheckChanged
        OnDblClick=OnDblClick
        bVisible=false
        CheckedOverlay(0)=material'DH_GUI_Tex.DeployMenu.spawn_point_osc'
        CheckedOverlay(1)=material'DH_GUI_Tex.DeployMenu.spawn_point_osc'
        CheckedOverlay(2)=material'DH_GUI_Tex.DeployMenu.spawn_point_osc'
        CheckedOverlay(3)=material'DH_GUI_Tex.DeployMenu.spawn_point_osc'
        CheckedOverlay(4)=material'DH_GUI_Tex.DeployMenu.spawn_point_osc'
        bCanClickUncheck=false
    End Object

    b_SpawnVehicles(0)=SpawnVehicleButton
    b_SpawnVehicles(1)=SpawnVehicleButton
    b_SpawnVehicles(2)=SpawnVehicleButton
    b_SpawnVehicles(3)=SpawnVehicleButton
    b_SpawnVehicles(4)=SpawnVehicleButton
    b_SpawnVehicles(5)=SpawnVehicleButton
    b_SpawnVehicles(6)=SpawnVehicleButton
    b_SpawnVehicles(7)=SpawnVehicleButton

    Begin Object Class=GUIContextMenu Name=RCMenu
        ContextItems(0)="Attack"
        ContextItems(1)="Defend"
        ContextItems(2)="-"
        ContextItems(3)="Clear"
        OnOpen=MyContextOpen
        OnClose=MyContextClose
        OnSelect=MyContextSelect
    End Object
    ContextMenu=GUIContextMenu'DH_Interface.DHGUIMapComponent.RCMenu'
}

