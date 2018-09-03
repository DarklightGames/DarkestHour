//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHGUIMapComponent extends GUIPanel;

const   SPAWN_POINTS_MAX =                  63; // Max spawn points total (make sure this matches GRI)
const   SPAWN_VEHICLES_MAX =                8;  // Max spawn vehicles total (make sure this matches GRI)
const   SQUAD_RALLY_POINTS_MAX =            16; // Max squad rally points (make sure this matches SRI)

var automated   DHGUICheckBoxButton         b_SpawnPoints[SPAWN_POINTS_MAX];

var             DHHud                       MyHud;
var             DHGameReplicationInfo       GRI;
var             DHPlayer                    PC;
var             DHPlayerReplicationInfo     PRI;

var             GUIContextMenu              SquadRallyPointContextMenu;
var             Material                    SpawnPointBlockedOverlay;

var             vector                      MapClickLocation;
var             array<class<DHMapMarker> >  MenuItemObjects;
var             int                         MapMarkerIndexToRemove;

var             vector                      Origin;
var             int                         ZoomLevel;
var             int                         ZoomLevelMin;
var             int                         ZoomLevelMax;

var             float                       ZoomScale;
var             Range                       ZoomScaleRange;

var             Range                       ZoomScaleInterpRange;
var             float                       ZoomScaleInterpStartTime;
var             float                       ZoomScaleInterpEndTime;
var             float                       ZoomScaleInterpDuration;

var             bool                        bIsPanning;

var localized string        SquadRallyPointDestroyText;
var localized string        SquadRallyPointSetAsSecondaryText;
var localized string        RemoveText;

delegate OnSpawnPointChanged(int SpawnPointIndex, optional bool bDoubleClick);

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;

    super.InitComponent(MyController, MyOwner);

    for (i = 0; i < arraycount(b_SpawnPoints); ++i)
    {
        b_SpawnPoints[i].Tag = i;
        b_SpawnPoints[i].ContextMenu.Tag = i;
        b_SpawnPoints[i].ContextMenu.OnOpen = MyContextOpen;
        b_SpawnPoints[i].ContextMenu.OnClose = MyContextClose;
        b_SpawnPoints[i].ContextMenu.OnSelect = MyContextSelect;
    }

    if (Controller != none)
    {
        // "Hide" the mouse cursor by sticking it in a corner.
        Controller.MouseX = 4096.0;
        Controller.MouseY = 4096.0;
    }

    PC = DHPlayer(PlayerOwner());

    if (PC != none)
    {
        PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
        GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
        MyHud = DHHud(PC.myHUD);
    }

    // Set the initial zoom scale.
    ZoomScale = GetZoomScale(ZoomLevel);
}

function UpdateSpawnPointPositions()
{
    local int i;
    local Box Viewport;
    local float X, Y;

    Viewport = GetViewport();

    if (GRI == none)
    {
        return;
    }

    for (i = 0; i < arraycount(b_SpawnPoints); ++i)
    {
        if (b_SpawnPoints[i] == none || !b_SpawnPoints[i].bVisible)
        {
            continue;
        }

        GRI.GetMapCoords(GRI.SpawnPoints[i].Location, X, Y, b_SpawnPoints[i].WinWidth, b_SpawnPoints[i].WinHeight);

        X = 1.0 - X;
        Y = 1.0 - Y;

        X = (X - Viewport.Min.X) * (1.0 / (Viewport.Max.X - Viewport.Min.X));
        Y = (Y - Viewport.Min.Y) * (1.0 / (Viewport.Max.X - Viewport.Min.X));

        b_SpawnPoints[i].SetPosition(X, Y, b_SpawnPoints[i].WinWidth, b_SpawnPoints[i].WinHeight, true);
    }
}

function UpdateSpawnPoints(int TeamIndex, int RoleIndex, int VehiclePoolIndex, int SpawnPointIndex)
{
    local GUI.eFontScale FS;
    local int            SquadIndex, i;

    SquadIndex = -1;

    if (PRI != none)
    {
        SquadIndex = PRI.SquadIndex;
    }

    // Spawn points
    for (i = 0; i < arraycount(b_SpawnPoints); ++i)
    {
        if (GRI != none &&
            GRI.SpawnPoints[i] != none &&
            GRI.SpawnPoints[i].IsVisibleTo(TeamIndex, RoleIndex, SquadIndex, VehiclePoolIndex))
        {
            b_SpawnPoints[i].SetVisibility(true);
            b_SpawnPoints[i].CenterText = GRI.SpawnPoints[i].GetMapText();

            if (GRI.SpawnPoints[i].CanSpawnWithParameters(GRI, TeamIndex, RoleIndex, SquadIndex, VehiclePoolIndex, true))
            {
                b_SpawnPoints[i].MenuStateChange(MSAT_Blurry);
            }
            else
            {
                if (SpawnPointIndex != -1 && SpawnPointIndex == b_SpawnPoints[i].Tag)
                {
                    SelectSpawnPoint(-1);
                }

                b_SpawnPoints[i].MenuStateChange(MSAT_Disabled);
            }

            b_SpawnPoints[i].Style = Controller.GetStyle(GRI.SpawnPoints[i].GetMapStyleName(), FS);
        }
        else
        {
            // If spawn point that was previously selected is now hidden, deselect it.
            b_SpawnPoints[i].SetVisibility(false);

            if (SpawnPointIndex == b_SpawnPoints[i].Tag)
            {
                SelectSpawnPoint(-1);
            }
        }
    }
}

function bool InternalOnDraw(Canvas C)
{
    local float ClipX, ClipY, TimeSeconds, ZoomAlpha;
    local ROHud.AbsoluteCoordsInfo SubCoords;

    // Interpolate zoom scale.
    TimeSeconds = PC.Level.TimeSeconds;

    if (TimeSeconds < ZoomScaleInterpEndTime)
    {
        ZoomAlpha = (TimeSeconds - ZoomScaleInterpStartTime) / (ZoomScaleInterpEndTime - ZoomScaleInterpStartTime);
        ZoomAlpha = FClamp(ZoomAlpha, 0.0, 1.0);
        ZoomScale = ZoomScaleInterpRange.Min + (ZoomAlpha * (ZoomScaleInterpRange.Max - ZoomScaleInterpRange.Min));
    }

    UpdateSpawnPointPositions();

    if (bVisible)
    {
        SubCoords.PosX = ActualLeft();
        SubCoords.PosY = ActualTop();
        SubCoords.Width = ActualWidth();
        SubCoords.Height = ActualHeight();

        ClipX = C.ClipX;
        ClipY = C.ClipY;

        C.ClipX = ActualWidth();
        C.ClipY = ActualHeight();

        if (MyHud != none)
        {
            MyHud.DrawMap(C, SubCoords, PC, GetViewport());
        }

        C.ClipX = ClipX;
        C.ClipY = ClipY;
    }

    return false;
}

function Box GetViewport()
{
    local Box Viewport;
    local vector Translation;

    Viewport.Min.X = Origin.X - (ZoomScale * 0.5);
    Viewport.Min.Y = Origin.Y - (ZoomScale * 0.5);
    Viewport.Max.X = Origin.X + (ZoomScale * 0.5);
    Viewport.Max.Y = Origin.Y + (ZoomScale * 0.5);

    // Translate the box within the 0-1 bounds
    Translation = -class'UVector'.static.MinComponent(Viewport.Min, vect(0, 0, 0));
    Viewport = class'UBox'.static.Translate(Viewport, Translation);

    Translation = -(class'UVector'.static.MaxComponent(Viewport.Max, vect(1, 1, 0)) - vect(1, 1, 0));
    Viewport = class'UBox'.static.Translate(Viewport, Translation);

    return Viewport;
}

function SelectSpawnPoint(int SpawnPointIndex)
{
    local int i;

    for (i = 0; i < arraycount(b_SpawnPoints); ++i)
    {
        b_SpawnPoints[i].SetChecked(b_SpawnPoints[i].Tag != -1 && b_SpawnPoints[i].Tag == SpawnPointIndex);
    }

    OnSpawnPointChanged(SpawnPointIndex);
}

function InternalOnCheckChanged(GUIComponent Sender, bool bChecked)
{
    local int i;

    if (bChecked)
    {
        for (i = 0; i < arraycount(b_SpawnPoints); ++i)
        {
            if (Sender == b_SpawnPoints[i])
            {
                OnSpawnPointChanged(b_SpawnPoints[i].Tag);
            }
            else
            {
                b_SpawnPoints[i].SetChecked(false);
            }
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
            OnSpawnPointChanged(b_SpawnPoints[i].Tag, true);

            return true;
        }
    }

    return false;
}

function bool MyContextOpen(GUIContextMenu Sender)
{
    local DHSpawnPoint_SquadRallyPoint SRP;
    local array<DHSpawnPoint_SquadRallyPoint> RallyPoints;

    if (Sender == none || PRI == none || GRI == none || PC == none || PC.SquadReplicationInfo == none || !PRI.IsSquadLeader())
    {
        return false;
    }

    SRP = DHSpawnPoint_SquadRallyPoint(GRI.SpawnPoints[Sender.Tag]);

    if (SRP == none || SRP.GetTeamIndex() != PC.GetTeamNum() || SRP.SquadIndex != PRI.SquadIndex || !SRP.IsActive())
    {
        return false;
    }

    Sender.ContextItems.Length = 0;
    Sender.AddItem(default.SquadRallyPointDestroyText);

    RallyPoints = PC.SquadReplicationInfo.GetActiveSquadRallyPoints(SRP.GetTeamIndex(), SRP.SquadIndex);

    if (RallyPoints.Length > 1)
    {
        Sender.AddItem("-");
        Sender.AddItem(default.SquadRallyPointSetAsSecondaryText);
    }

    return true;
}

function bool MyContextClose(GUIContextMenu Sender)
{
    return true;
}

function MyContextSelect(GUIContextMenu Sender, int Index)
{
    local DHSpawnPoint_SquadRallyPoint SRP;

    if (PRI == none || !PRI.IsSquadLeader())
    {
        return;
    }

    if (GRI != none)
    {
        SRP = DHSpawnPoint_SquadRallyPoint(GRI.SpawnPoints[Sender.Tag]);
    }

    switch (Index)
    {
        case 0:  // Destroy
            PC.ServerSquadDestroyRallyPoint(SRP);
            break;
        case 2:  // Set as secondary
            PC.ServerSquadSwapRallyPoints();
            break;
    }
}

function Material MyGetOverlayMaterial(GUIComponent Sender)
{
    local DHSpawnPointBase SP;

    if (Sender == none || GRI == none)
    {
        return none;
    }

    SP = GRI.SpawnPoints[Sender.Tag];

    if (SP != none && SP.IsBlocked())
    {
        return SpawnPointBlockedOverlay;
    }

    return none;
}

// Sort by linear insertion based on the group index!
function SortMapMarkerClasses(out array<class<DHMapMarker> > MapMarkerClasses)
{
    local int i, j;
    local class<DHMapMarker> Temp;

    for (i = 1; i < MapMarkerClasses.Length; ++i)
    {
        for (j = i; j > 0 && MapMarkerClasses[j - 1].default.GroupIndex > MapMarkerClasses[j].default.GroupIndex; j -= 1)
        {
            Temp = MapMarkerClasses[j - 1];
            MapMarkerClasses[j - 1] = MapMarkerClasses[j];
            MapMarkerClasses[j] = Temp;
        }
    }
}

// Gets the normalized location given an absolute screen coordinate.
function vector GetNormalizedLocation(float X, float Y)
{
    local vector Location;

    Location.X = (X - ActualLeft(WinLeft)) / ActualWidth(WinWidth);
    Location.Y = (Y - ActualTop(WinTop)) / ActualHeight(WinHeight);

    return Location;
}

function bool InternalOnOpen(GUIContextMenu Sender)
{
    local int i;
    local float D;
    local array<DHGameReplicationInfo.MapMarker> MapMarkers;
    local array<int> Indices;
    local array<class<DHMapMarker> > MapMarkerClasses;
    local int GroupIndex;
    local float X, Y;
    local Box Viewport;

    if (Sender == none || PC == none || PRI == none || GRI == none)
    {
        return false;
    }

    Viewport = GetViewport();

    MapClickLocation = GetNormalizedLocation(Controller.MouseX, Controller.MouseY);
    MapClickLocation.X = 1.0 - (Viewport.Min.X + (MapClickLocation.X * (Viewport.Max.X - Viewport.Min.X)));
    MapClickLocation.Y = 1.0 - (Viewport.Min.Y + (MapClickLocation.Y * (Viewport.Max.Y - Viewport.Min.Y)));

    Sender.ContextItems.Length = 0;

    // Iterate through existing map markers and check if any were clicked on.
    GRI.GetMapMarkers(MapMarkers, Indices, PC.GetTeamNum(), PC.GetSquadIndex());

    MenuItemObjects.Length = 0;
    MapMarkerIndexToRemove = -1;

    for (i = 0; i < MapMarkers.Length; ++i)
    {
        if (!MapMarkers[i].MapMarkerClass.static.CanPlayerUse(PRI))
        {
            continue;
        }

        X = (float(MapMarkers[i].LocationX) / 255.0) - MapClickLocation.X;
        Y = (float(MapMarkers[i].LocationY) / 255.0) - MapClickLocation.Y;
        D = Sqrt(X * X + Y * Y);

        if (D <= class'DHHud'.default.MapMarkerIcon.TextureScale / 2.0)
        {
            // Clicked on an existing map marker, add the "remove" option.
            MapMarkerIndexToRemove = Indices[i];
            Sender.AddItem(RemoveText);
            MenuItemObjects[MenuItemObjects.Length] = none;
            break;
        }
    }

    // Fetch and sort map marker classes by group.
    for (i = 0; i < arraycount(GRI.MapMarkerClasses); ++i)
    {
        if (GRI.MapMarkerClasses[i] != none && GRI.MapMarkerClasses[i].static.CanPlayerUse(PRI))
        {
            MapMarkerClasses[MapMarkerClasses.Length] = GRI.MapMarkerClasses[i];
        }
    }

    SortMapMarkerClasses(MapMarkerClasses);

    // Add separator if any other items already exist.
    if (Sender.ContextItems.Length > 0 && MapMarkerClasses.Length > 0)
    {
        Sender.AddItem("-");
        MenuItemObjects[MenuItemObjects.Length] = none;
    }

    GroupIndex = -1;

    // Add an option for each map marker.
    for (i = 0; i < MapMarkerClasses.Length; ++i)
    {
        if (GroupIndex != -1 && MapMarkerClasses[i].default.GroupIndex != GroupIndex)
        {
            // New group encountered, add a separator.
            Sender.AddItem("-");
            MenuItemObjects[MenuItemObjects.Length] = none;
        }

        Sender.AddItem(MapMarkerClasses[i].default.MarkerName);
        MenuItemObjects[MenuItemObjects.Length] = MapMarkerClasses[i];
        GroupIndex = MapMarkerClasses[i].default.GroupIndex;
    }

    return Sender.ContextItems.Length > 0;
}

function bool InternalOnClose(GUIContextMenu Sender)
{
    return true;
}

function InternalOnSelect(GUIContextMenu Sender, int ClickIndex)
{
    if (PC == none || ClickIndex < 0 || ClickIndex >= MenuItemObjects.Length)
    {
        return;
    }

    if (MenuItemObjects[ClickIndex] == none)
    {
        if (MapMarkerIndexToRemove != -1)
        {
            PC.ServerRemoveMapMarker(MapMarkerIndexToRemove);
        }
    }
    else
    {
        PC.ServerAddMapMarker(MenuItemObjects[ClickIndex], MapClickLocation.X, MapClickLocation.Y);
    }
}

// Gets the zoom scale based on the zoom level.
function float GetZoomScale(int ZoomLevel)
{
    local int ZoomLevelRange;
    local float T;

    ZoomLevelRange = ZoomLevelMax - ZoomLevelMin;
    T = float(ZoomLevel) * (1.0 / ZoomLevelRange);
    return class'UInterp'.static.SmoothStep(T, ZoomScaleRange.Max, ZoomScaleRange.Min);
}

// Returns true if a new zoom level was set.
function SetZoomLevel(int NewZoomLevel)
{
    NewZoomLevel = Clamp(NewZoomLevel, ZoomLevelMin, ZoomLevelMax);

    if (ZoomLevel == NewZoomLevel)
    {
        return;
    }

    ZoomLevel = NewZoomLevel;
    ZoomScaleInterpStartTime = PC.Level.TimeSeconds;
    ZoomScaleInterpEndTime = ZoomScaleInterpStartTime + ZoomScaleInterpDuration;

    ZoomScaleInterpRange.Min = ZoomScale;
    ZoomScaleInterpRange.Max = GetZoomScale(ZoomLevel);
}

// Given a viewport and a location within that viewport, get the frame coordinates.
function vector ViewportToFrame(Box Viewport, vector Location)
{
    Location.X = (Viewport.Min.X + (Location.X * (Viewport.Max.X - Viewport.Min.X)));
    Location.Y = (Viewport.Min.Y + (Location.Y * (Viewport.Max.Y - Viewport.Min.Y)));
    return Location;
}

function ZoomIn()
{
    local vector CursorLocation, Delta;
    local Box Viewport;
    local float NewZoomScale;

    // Get the pre-zoomed viewport.
    Viewport = GetViewport();

    // Get the frame location of the intended origin.
    CursorLocation = GetNormalizedLocation(Controller.MouseX, Controller.MouseY);
    Origin = ViewportToFrame(Viewport, CursorLocation);

    SetZoomLevel(ZoomLevel + 1);

    // TODO: we must keep the area under the mouse "pinned", so we need to
    // translate the origin by the difference between the new relative cursor
    // location and the middle of the viewport.

    // TODO: essentially we are lerping viewports here

    // new zoom level [0..1] frame difference of cursor loc vs. middle of viewport
    NewZoomScale = GetZoomScale(ZoomLevel);

    Viewport = GetViewport();
}

function ZoomOut()
{
    SetZoomLevel(ZoomLevel - 1);
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float Delta)
{
    local Interactions.EInputKey InputKey;
    local Interactions.EInputAction InputAction;

    InputKey = EInputKey(Key);
    InputAction = EInputAction(State);

    if (InputAction == IST_Release && InputKey == IK_MouseWheelUp)
    {
        ZoomIn();
        return true;
    }
    else if (InputAction == IST_Release && InputKey == IK_MouseWheelDown)
    {
        ZoomOut();
        return true;
    }
    // TODO: maybe a "follow me" kind of option?

    return false;
}

function InternalOnMousePressed(GUIComponent Sender, bool bRepeat)
{
    bIsPanning = true;
}

function InternalOnMouseRelease(GUIComponent Sender)
{
    bIsPanning = false;
}

function bool InternalOnCapturedMouseMove(float DeltaX, float DeltaY)
{
    local float W, H;
    local Box Viewport;
    local Box OriginViewport;
    local vector HalfViewportExtents;

    if (bIsPanning)
    {
        W = ActualWidth(WinWidth);
        H = ActualHeight(WinHeight);

        Viewport = GetViewport();
        OriginViewport = Viewport;

        HalfViewportExtents = class'UBox'.static.Extents(Viewport) / 2;
        OriginViewport.Min = HalfViewportExtents;
        OriginViewport.Max = vect(1, 1, 0) - HalfViewportExtents;

        Origin.X -= (DeltaX / W) * ZoomScale;
        Origin.Y += (DeltaY / H) * ZoomScale;

        Origin = class'UVector'.static.MaxComponent(Origin, OriginViewport.Min);
        Origin = class'UVector'.static.MinComponent(Origin, OriginViewport.Max);

        return true;
    }

    return false;
}

defaultproperties
{
    SquadRallyPointDestroyText="Destroy"
    SquadRallyPointSetAsSecondaryText="Set as Secondary"
    RemoveText="Remove"

    OnKeyEvent=InternalOnKeyEvent
    OnMousePressed=InternalOnMousePressed
    OnMouseRelease=InternalOnMouseRelease
    OnCapturedMouseMove=InternalOnCapturedMouseMove

    SpawnPointBlockedOverlay=Texture'DH_GUI_tex.DeployMenu.spawn_point_disabled'

    OnDraw=InternalOnDraw

    Begin Object Class=GUIContextMenu Name=SRPContextMenu
        OnOpen=DHGUIMapComponent.MyContextOpen
        OnClose=DHGUIMapComponent.MyContextClose
        OnSelect=DHGUIMapComponent.MyContextSelect
    End Object


    // Spawn points
    Begin Object Class=DHGUICheckBoxButton Name=SpawnPointButton
        StyleName="DHSpawnButtonStyle"
        WinWidth=0.04
        WinHeight=0.04
        bTabStop=false
        OnClick=OnClick
        OnDblClick=OnDblClick
        bVisible=false
        CheckedOverlay(0)=Material'DH_GUI_Tex.DeployMenu.spawn_point_osc'
        CheckedOverlay(1)=Material'DH_GUI_Tex.DeployMenu.spawn_point_osc'
        CheckedOverlay(2)=Material'DH_GUI_Tex.DeployMenu.spawn_point_osc'
        CheckedOverlay(3)=Material'DH_GUI_Tex.DeployMenu.spawn_point_osc'
        CheckedOverlay(4)=Material'DH_GUI_Tex.DeployMenu.spawn_point_osc'
        OnCheckChanged=InternalOnCheckChanged
        bCanClickUncheck=false
        ContextMenu=SRPContextMenu
        GetOverlayMaterial=MyGetOverlayMaterial
    End Object

    Begin Object Class=GUIContextMenu Name=MapMarkerMenu
        OnOpen=InternalOnOpen
        OnClose=InternalOnClose
        OnSelect=InternalOnSelect
    End Object
    ContextMenu=MapMarkerMenu

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
    b_SpawnPoints(48)=SpawnPointButton
    b_SpawnPoints(49)=SpawnPointButton
    b_SpawnPoints(50)=SpawnPointButton
    b_SpawnPoints(51)=SpawnPointButton
    b_SpawnPoints(52)=SpawnPointButton
    b_SpawnPoints(53)=SpawnPointButton
    b_SpawnPoints(54)=SpawnPointButton
    b_SpawnPoints(55)=SpawnPointButton
    b_SpawnPoints(56)=SpawnPointButton
    b_SpawnPoints(57)=SpawnPointButton
    b_SpawnPoints(58)=SpawnPointButton
    b_SpawnPoints(59)=SpawnPointButton
    b_SpawnPoints(60)=SpawnPointButton
    b_SpawnPoints(61)=SpawnPointButton
    b_SpawnPoints(62)=SpawnPointButton

    bAcceptsInput=true
    bCaptureMouse=true

    Origin=(X=0.5,Y=0.5)
    ZoomLevel=0
    ZoomLevelMin=0
    ZoomLevelMax=4
    ZoomScaleRange=(Min=0.25,Max=1.0)
    ZoomScaleInterpDuration=0.33
}

