//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHSituationMapGUIPage extends GUIPage;

var automated   ROGUIProportionalContainer  c_MapRoot;
var automated   ROGUIProportionalContainer  c_Map;
var automated   GUIImage                    i_MapBorder;
var automated   DHGUIMapComponent           p_Map;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    super.InitComponent(MyController, MyOwner);

    c_MapRoot.ManageComponent(c_Map);

    c_Map.ManageComponent(i_MapBorder);
    c_Map.ManageComponent(p_Map);
}

function InternalOnOpen()
{
    Controller.bActive = false;

    SetTimer(1.0, true);

    UpdateSpawnPoints();
}

function InternalOnClose(optional bool bCancelled)
{
    Controller.bActive = true;
}

function UpdateSpawnPoints()
{
    local DHPlayer PC;

    PC = DHPlayer(PlayerOwner());

    if (PC != none)
    {
        p_Map.UpdateSpawnPoints(PC.GetTeamNum(), PC.GetRoleIndex(), PC.VehiclePoolIndex, PC.SpawnPointIndex);
    }
}

function Timer()
{
    UpdateSpawnPoints();
}

function bool MapContainerPreDraw(Canvas C)
{
    local float Offset;

    Offset = (c_MapRoot.ActualWidth() - c_MapRoot.ActualHeight()) / 2.0;
    Offset /= ActualWidth();

    c_Map.SetPosition(c_MapRoot.WinLeft + Offset,
                      c_MapRoot.WinTop,
                      c_MapRoot.ActualHeight(),
                      c_MapRoot.ActualHeight(),
                      true);

    return true;
}

function OnSpawnPointChanged(int SpawnPointIndex, optional bool bDoubleClick)
{
    local DHPlayer PC;
    local DHHud HUD;

    if (bDoubleClick)
    {
        PC = DHPlayer(PlayerOwner());

        if (PC != none)
        {
            PC.ServerSetPlayerInfo(255, 255, 255, 255, SpawnPointIndex, 255);

            HUD = DHHud(PC.myHUD);

            if (HUD != none)
            {
                HUD.HideObjectives();
            }
        }
    }
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float Delta)
{
    local DHHud HUD;

    Log("InternalOnKeyEvent" @ Key @ State @ Delta);

    if (Key == 0x1B || IsShowObjectivesKey(key))
    {
        if (PlayerOwner() != none)
        {
            HUD = DHHud(PlayerOwner().myHUD);

            if (HUD != none)
            {
                Log("TRYING TO HIDE OBJECTIVES");

                HUD.HideObjectives();
            }

            return true;
        }
    }

    return false;
}

function bool IsShowObjectivesKey(byte Key)
{
    local array<string> Bindings;
    local int i;

    if (PlayerOwner() != none)
    {
        Split(PlayerOwner().ConsoleCommand("BINDINGTOKEY \"SHOWOBJECTIVES\""), ",", Bindings);

        for (i = 0; i < Bindings.Length; ++i)
        {
            if (Key == int(PlayerOwner().ConsoleCommand("KEYNUMBER" @ Bindings[i])))
            {
                return true;
            }
        }
    }

    return false;
}

defaultproperties
{
    bRenderWorld=true
    bAllowedAsLast=true
    bAcceptsInput=false
    bCaptureInput=false
    OnOpen=InternalOnOpen
    OnClose=InternalOnClose
    OnKeyEvent=InternalOnKeyEvent

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=MapRootContainerObject
        WinWidth=0.68
        WinHeight=0.91
        WinLeft=0.3
        WinTop=0.02
        OnPreDraw=MapContainerPreDraw
    End Object
    c_MapRoot=MapRootContainerObject

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=MapContainerObject
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        bNeverFocus=true
    End Object
    c_Map=MapContainerObject

    Begin Object Class=GUIImage Name=MapBorderImageObject
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        bNeverFocus=true
        ImageStyle=ISTY_Scaled
        Image=material'DH_GUI_tex.DeployMenu.map_border'
    End Object
    i_MapBorder=MapBorderImageObject

    Begin Object Class=DHGUIMapComponent Name=MapComponentObject
        WinWidth=0.89
        WinHeight=0.89
        WinLeft=0.055
        WinTop=0.055
        bNeverFocus=true
        OnSpawnPointChanged=OnSpawnPointChanged
    End Object
    p_Map=MapComponentObject

    MouseCursorIndex=2
}
