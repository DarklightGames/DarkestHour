//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSituationMapGUIPage extends GUIPage;

var automated   ROGUIProportionalContainer  c_MapRoot;
var automated   DHGUIMapContainer           c_Map;

var string                                  HideExecs[2];
var array<int>                              HideKeys;

var int     SavedZoomLevel;
var vector  SavedOrigin;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local DHPlayer PC;
    local DHGameReplicationInfo GRI;
    local vector Origin;

    super.InitComponent(MyController, MyOwner);

    PC = DHPlayer(PlayerOwner());

    c_MapRoot.ManageComponent(c_Map);

    if (Controller != none)
    {
        // "Hide" the mouse cursor by sticking it in a corner.
        Controller.MouseX = 4096.0;
        Controller.MouseY = 4096.0;
    }

    PopulateHideKeys();

    UpdateSpawnPoints();

    if (PC != none)
    {
        c_Map.p_Map.SelectSpawnPoint(PC.SpawnPointIndex);
        GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

        if (PC.Pawn != none && GRI != none)
        {
            GRI.GetMapCoords(PC.Pawn.Location, Origin.X, Origin.Y);
            Origin.X = 1 - Origin.X;
            Origin.Y = 1 - Origin.Y;
            c_Map.p_Map.SetViewport(default.SavedOrigin, default.SavedZoomLevel);
        }
    }
}

function InternalOnOpen()
{
    Controller.bActive = false;

    SetTimer(1.0, true);

    UpdateSpawnPoints();
}

function InternalOnClose(optional bool bCancelled)
{
    default.SavedOrigin = c_Map.p_Map.GetViewportOrigin();
    default.SavedZoomLevel = c_Map.p_Map.ZoomLevel;

    Controller.bActive = true;
}

function UpdateSpawnPoints()
{
    local DHPlayer PC;

    PC = DHPlayer(PlayerOwner());

    if (PC != none)
    {
        c_Map.p_Map.UpdateSpawnPoints(PC.GetTeamNum(), PC.GetRoleIndex(), PC.VehiclePoolIndex, PC.SpawnPointIndex);
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
            PC.ServerSetPlayerInfo(255, 255, PC.DHPrimaryWeapon, PC.DHSecondaryWeapon, SpawnPointIndex, 255);

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
    local Interactions.EInputKey InputKey;
    local Interactions.EInputAction InputAction;

    InputKey = EInputKey(Key);
    InputAction = EInputAction(State);

    if (InputAction == IST_Press && (Key == 0x1B || IsHideKey(Key)))
    {
        if (PlayerOwner() != none)
        {
            HUD = DHHud(PlayerOwner().myHUD);

            if (HUD != none)
            {
                HUD.HideObjectives();
            }

            return true;
        }
    }

    return false;
}

function bool IsHideKey(byte Key)
{
    local int i;

    for (i = 0; i < HideKeys.Length; ++i)
    {
        if (Key == HideKeys[i])
        {
            return true;
        }
    }

    return false;
}

function PopulateHideKeys()
{
    local array<string> AllBindings;
    local array<string> Bindings;
    local int i, j;

    HideKeys.Length = 0;

    if (PlayerOwner() != none)
    {
        for (i = 0;  i < arraycount(HideExecs); ++i)
        {
            Split(PlayerOwner().ConsoleCommand("BINDINGTOKEY \"" $ HideExecs[i] $ "\""), ",", Bindings);

            for (j = 0; j < Bindings.Length; ++j)
            {
                AllBindings[AllBindings.Length] = Bindings[j];
            }
        }

        for (i = 0; i < AllBindings.Length; ++i)
        {
            HideKeys[HideKeys.Length] = int(PlayerOwner().ConsoleCommand("KEYNUMBER" @ AllBindings[i]));
        }
    }
}

defaultproperties
{
    bRenderWorld=true
    bAllowedAsLast=true
    bAcceptsInput=true
    bCaptureInput=true
    OnOpen=InternalOnOpen
    OnClose=InternalOnClose
    OnKeyEvent=InternalOnKeyEvent

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=MapRootContainerObject
        WinWidth=0.68
        WinHeight=0.91
        WinLeft=0.3
        WinTop=0.02
        OnPreDraw=MapContainerPreDraw
        bNeverFocus=true
    End Object
    c_MapRoot=MapRootContainerObject

    Begin Object Class=DHGUIMapContainer Name=MapContainerObject
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        bNeverFocus=true
        OnSpawnPointChanged=OnSpawnPointChanged
        //OnZoomLevelChanged=OnZoomLevelChanged
    End Object
    c_Map=MapContainerObject

    MouseCursorIndex=2

    HideExecs(0)="SHOWOBJECTIVES"
    Hideexecs(1)="JUMP"
}
