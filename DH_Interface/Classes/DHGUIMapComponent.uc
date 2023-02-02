//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGUIMapComponent extends GUIPanel;

const   SPAWN_POINTS_MAX =                  63; // Max spawn points total (make sure this matches GRI)

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
var             bool                        bRemoveMapMarker;

var             Box                         Viewport;
var             Box                         ViewportInterpStart;
var             Box                         ViewportInterpEnd;
var             float                       ViewportInterpStartTime;
var             float                       ViewportInterpEndTime;
var             float                       ViewportInterpDuration;

var             int                         ZoomLevel;
var             int                         ZoomLevelMin;
var             int                         ZoomLevelMax;

var             Range                       ZoomScaleRange;
var             Range                       ZoomScaleInterpRange;

var             bool                        bIsPanning;
var             bool                        bIsViewportInterpolating;

var localized string        SquadRallyPointDestroyText;
var localized string        SquadRallyPointSetAsSecondaryText;
var localized string        RemoveText;
var localized string        ActiveTargetSelectText;
var localized string        ActiveTargetDeselectText;

var             bool                        bSelectArtilleryTarget;
var             bool                        bDeselectArtilleryTarget;
var             int                         TargetSquadIndex;

delegate OnSpawnPointChanged(int SpawnPointIndex, optional bool bDoubleClick);
delegate OnZoomLevelChanged(int ZoomLevel);

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

    PC = DHPlayer(PlayerOwner());

    if (PC != none)
    {
        PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
        GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
        MyHud = DHHud(PC.myHUD);
    }
}

function SetViewport(vector Origin, int ZoomLevel)
{
    SetZoomLevel(ZoomLevel);
    Viewport = ConstrainViewport(class'UBox'.static.Create(Origin, GetZoomScale(ZoomLevel)), vect(0, 0, 0), vect(1, 1, 0));
}

function vector GetViewportOrigin()
{
    return (Viewport.Min + Viewport.Max) * 0.5;
}

function UpdateSpawnPointPositions()
{
    local int i;
    local float X, Y, ViewportScale;

    if (GRI == none)
    {
        return;
    }

    ViewportScale = Viewport.Max.X - Viewport.Min.X;

    for (i = 0; i < arraycount(b_SpawnPoints); ++i)
    {
        if (b_SpawnPoints[i] == none || !b_SpawnPoints[i].bIsActive || GRI.SpawnPoints[i] == none)
        {
            continue;
        }

        GRI.GetMapCoords(GRI.SpawnPoints[i].Location, X, Y, b_SpawnPoints[i].WinWidth * ViewportScale, b_SpawnPoints[i].WinHeight * ViewportScale);

        X = 1.0 - X;
        Y = 1.0 - Y;

        X = (X - Viewport.Min.X) * (1.0 / (Viewport.Max.X - Viewport.Min.X));
        Y = (Y - Viewport.Min.Y) * (1.0 / (Viewport.Max.X - Viewport.Min.X));

        b_SpawnPoints[i].SetPosition(X, Y, b_SpawnPoints[i].WinWidth, b_SpawnPoints[i].WinHeight, true);

        // Hide if the button is not currently within the viewport.
        X += b_SpawnPoints[i].WinWidth / 2;
        Y += b_SpawnPoints[i].WinHeight / 2;
        b_SpawnPoints[i].SetVisibility(X >= 0 && X <= 1.0 && Y >= 0.0 && Y <= 1.0);
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
            b_SpawnPoints[i].bIsActive = true;
            b_SpawnPoints[i].SetVisibility(true);
            b_SpawnPoints[i].CenterText = GRI.SpawnPoints[i].GetMapText();

            if (GRI.SpawnPoints[i].CanSpawnWithParameters(GRI, TeamIndex, RoleIndex, SquadIndex, VehiclePoolIndex, true))
            {
                // Spawn is acessible to spawn at, make the button clickable.
                b_SpawnPoints[i].MenuStateChange(MSAT_Blurry);
            }
            else
            {
                if (SpawnPointIndex != -1 && SpawnPointIndex == b_SpawnPoints[i].Tag)
                {
                    // This is our currently selected spawn, but it is inaccessible.
                    // Deselect the spawn point.
                    SelectSpawnPoint(-1);
                }

                b_SpawnPoints[i].MenuStateChange(MSAT_Disabled);
            }

            b_SpawnPoints[i].Style = Controller.GetStyle(GRI.SpawnPoints[i].GetMapStyleName(), FS);
        }
        else
        {
            // If spawn point that was previously selected is now hidden, deselect it.
            b_SpawnPoints[i].bIsActive = false;
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
    local float TimeSeconds, ViewportInterpAlpha;
    local ROHud.AbsoluteCoordsInfo SubCoords;

    // Interpolate viewport.
    TimeSeconds = PC.Level.TimeSeconds;

    if (bIsViewportInterpolating)
    {
        if (TimeSeconds >= ViewportInterpEndTime)
        {
            // Turn off the viewport interpolation flag.
            bIsViewportInterpolating = false;
        }

        ViewportInterpAlpha = (TimeSeconds - ViewportInterpStartTime) / (ViewportInterpEndTime - ViewportInterpStartTime);
        ViewportInterpAlpha = FClamp(ViewportInterpAlpha, 0.0, 1.0);
        Viewport =  class'UBox'.static.Interp(class'UInterp'.static.Deceleration(ViewportInterpAlpha, 0.0, 1.0), ViewportInterpStart, ViewportInterpEnd);
    }

    UpdateSpawnPointPositions();

    if (bVisible)
    {
        SubCoords.PosX = ActualLeft();
        SubCoords.PosY = ActualTop();
        SubCoords.Width = ActualWidth();
        SubCoords.Height = ActualHeight();

        if (MyHud != none)
        {
            MyHud.DrawMap(C, SubCoords, PC, Viewport);
        }
    }

    return false;
}

function Box ConstrainViewport(Box Viewport, vector Min, vector Max)
{
    local vector Translation;

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

// TODO:
function bool IsMarkerUnderCursor(float LocationX, float LocationY, float CursorMapLocationX, float CursorMapLocationY)
{
    local float X, Y, D;

    X = LocationX - CursorMapLocationX;
    Y = LocationY - CursorMapLocationY;
    D = Sqrt(X * X + Y * Y);

    return D <= class'DHHud'.default.MapMarkerIcon.TextureScale * 0.5;
}

function bool InternalOnOpen(GUIContextMenu Sender)
{
    local int i, ElapsedTime;
    local array<DHGameReplicationInfo.MapMarker> PersonalMapMarkers;
    local array<DHGameReplicationInfo.MapMarker> PublicMapMarkers;
    local array<class<DHMapMarker> > MapMarkerClasses;
    local int GroupIndex;

    if (Sender == none || PC == none || PRI == none || GRI == none)
    {
        return false;
    }

    MapClickLocation = GetNormalizedLocation(Controller.MouseX, Controller.MouseY);
    MapClickLocation.X = 1.0 - (Viewport.Min.X + (MapClickLocation.X * (Viewport.Max.X - Viewport.Min.X)));
    MapClickLocation.Y = 1.0 - (Viewport.Min.Y + (MapClickLocation.Y * (Viewport.Max.Y - Viewport.Min.Y)));

    Sender.ContextItems.Length = 0;

    // Iterate through existing map markers and check if any were clicked on.
    PublicMapMarkers = GRI.GetMapMarkers(PC);
    PersonalMapMarkers = PC.GetPersonalMarkers();

    MenuItemObjects.Length = 0;
    MapMarkerIndexToRemove = -1;
    bRemoveMapMarker = false;
    ElapsedTime = GRI.ElapsedTime;

    for (i = 0; i < PersonalMapMarkers.Length; ++i)
    {
        if (PersonalMapMarkers[i].MapMarkerClass != none &&
           (PersonalMapMarkers[i].ExpiryTime == -1 || PersonalMapMarkers[i].ExpiryTime > ElapsedTime) &&
           PersonalMapMarkers[i].MapMarkerClass.static.CanRemoveMarker(PRI, PersonalMapMarkers[i]) &&
           IsMarkerUnderCursor(float(PersonalMapMarkers[i].LocationX) / 255.0, float(PersonalMapMarkers[i].LocationY) / 255.0, MapClickLocation.X, MapClickLocation.Y))
        {
            bRemoveMapMarker = true;
            MapMarkerIndexToRemove = i;
            Sender.AddItem(Repl(RemoveText, "{0}", PersonalMapMarkers[i].MapMarkerClass.default.MarkerName));
            MenuItemObjects[MenuItemObjects.Length] = PersonalMapMarkers[i].MapMarkerClass;
            break;
        }
    }

    if (!bRemoveMapMarker)
    {
        for (i = 0; i < PublicMapMarkers.Length; ++i)
        {
            if (PublicMapMarkers[i].MapMarkerClass != none &&
                (PublicMapMarkers[i].ExpiryTime == -1 || PublicMapMarkers[i].ExpiryTime > ElapsedTime) &&
                PublicMapMarkers[i].MapMarkerClass.static.CanRemoveMarker(PRI, PublicMapMarkers[i]) &&
                IsMarkerUnderCursor(float(PublicMapMarkers[i].LocationX) / 255.0, float(PublicMapMarkers[i].LocationY) / 255.0, MapClickLocation.X, MapClickLocation.Y))
            {
                bRemoveMapMarker = true;
                MapMarkerIndexToRemove = i;
                Sender.AddItem(Repl(RemoveText, "{0}", PublicMapMarkers[i].MapMarkerClass.default.MarkerName));
                MenuItemObjects[MenuItemObjects.Length] = PublicMapMarkers[i].MapMarkerClass;
                break;
            }

            if (PublicMapMarkers[i].MapMarkerClass != none &&
                (PublicMapMarkers[i].ExpiryTime == -1 || PublicMapMarkers[i].ExpiryTime > ElapsedTime) &&
                PublicMapMarkers[i].MapMarkerClass.default.Type == MT_OnMapArtilleryRequest &&
                PublicMapMarkers[i].MapMarkerClass.static.CanSeeMarker(PRI, PublicMapMarkers[i]) &&
                (PC.IsArtilleryOperator() && !(PC.IsArtillerySpotter() && PC.GetSquadIndex() == PublicMapMarkers[i].SquadIndex)) &&
                IsMarkerUnderCursor(float(PublicMapMarkers[i].LocationX) / 255.0, float(PublicMapMarkers[i].LocationY) / 255.0, MapClickLocation.X, MapClickLocation.Y))
            {
                if (PC.ArtillerySupportSquadIndex == PublicMapMarkers[i].SquadIndex)
                {
                    bDeselectArtilleryTarget = true;
                    TargetSquadIndex = -1;
                    MenuItemObjects[MenuItemObjects.Length] = PublicMapMarkers[i].MapMarkerClass;
                    Sender.AddItem(ActiveTargetDeselectText);
                    PC.ReceiveLocalizedMessage(class'DHArtilleryMessage', 10);
                }
                else
                {
                    bSelectArtilleryTarget = true;
                    TargetSquadIndex = PublicMapMarkers[i].SquadIndex;
                    MenuItemObjects[MenuItemObjects.Length] = PublicMapMarkers[i].MapMarkerClass;
                    Sender.AddItem(ActiveTargetSelectText);
                }

                break;
            }
        }
    }

    // Fetch and sort map marker classes by group.
    for (i = 0; i < arraycount(GRI.MapMarkerClasses); ++i)
    {
        if (GRI.MapMarkerClasses[i] != none && GRI.MapMarkerClasses[i].static.CanPlaceMarker(PRI))
        {
            MapMarkerClasses[MapMarkerClasses.Length] = GRI.MapMarkerClasses[i];
        }
    }

    if (!bDeselectArtilleryTarget && !bSelectArtilleryTarget)
    {
        for (i = 0; i < class'DHPlayer'.default.PersonalMapMarkerClasses.Length; ++i)
        {
            if (class'DHPlayer'.default.PersonalMapMarkerClasses[i].static.CanPlaceMarker(PRI))
            {
                MapMarkerClasses[MapMarkerClasses.Length] = class'DHPlayer'.default.PersonalMapMarkerClasses[i];
            }
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
    if (PC == none || ClickIndex < 0 || ClickIndex >= MenuItemObjects.Length || MenuItemObjects[ClickIndex] == none)
    {
        return;
    }

    if (bRemoveMapMarker && ClickIndex == 0 && MenuItemObjects[ClickIndex] != none)
    {
        PC.RemoveMarker(MenuItemObjects[ClickIndex], MapMarkerIndexToRemove);
    }
    else
    {
        if (bSelectArtilleryTarget && ClickIndex == 0)
        {
            PC.ServerSaveArtillerySupportSquadIndex(TargetSquadIndex);
            bSelectArtilleryTarget = false;
        }
        else if (bDeselectArtilleryTarget && ClickIndex == 0)
        {
            PC.ServerSaveArtillerySupportSquadIndex(255);
            bDeselectArtilleryTarget = false;
        }
        else
        {
            PC.AddMarker(MenuItemObjects[ClickIndex], MapClickLocation.X, MapClickLocation.Y);
        }
    }
}

// Gets the zoom scale based on the zoom level.
function float GetZoomScale(int ZoomLevel)
{
    local int ZoomLevelRange;
    local float T;

    ZoomLevelRange = ZoomLevelMax - ZoomLevelMin;
    T = float(ZoomLevel) * (1.0 / ZoomLevelRange);
    return class'UInterp'.static.Deceleration(T, ZoomScaleRange.Max, ZoomScaleRange.Min);
}

function SetZoomLevel(int NewZoomLevel)
{
    ZoomLevel = Clamp(NewZoomLevel, ZoomLevelMin, ZoomLevelMax);

    OnZoomLevelChanged(ZoomLevel);
}

// Given a viewport and a location within that viewport, get the frame coordinates.
function vector ViewportToFrame(Box Viewport, vector Location)
{
    Location.X = Viewport.Min.X + (Location.X * (Viewport.Max.X - Viewport.Min.X));
    Location.Y = Viewport.Min.Y + (Location.Y * (Viewport.Max.Y - Viewport.Min.Y));
    return Location;
}

function bool CanZoomIn()
{
    return ZoomLevel < ZoomLevelMax;
}

function bool CanZoomOut()
{
    return ZoomLevel > ZoomLevelMin;
}

function InterpolateToViewport(Box NewViewport)
{
    NewViewport = ConstrainViewport(NewViewport, vect(0, 0, 0), vect(1, 1, 1));

    ViewportInterpStart = Viewport;
    ViewportInterpEnd = NewViewport;
    ViewportInterpStartTime = PC.Level.TimeSeconds;
    ViewportInterpEndTime = ViewportInterpStartTime + ViewportInterpDuration;

    bIsViewportInterpolating = true;
}

function ZoomIn()
{
    local vector ViewportLocation;
    local Box NewViewport;
    local float OldZoomScale, NewZoomScale;

    if (!CanZoomIn())
    {
        return;
    }

    // Save the old zoom scale.
    OldZoomScale = Viewport.Max.X - Viewport.Min.X;

    // Increment the zoom level.
    SetZoomLevel(ZoomLevel + 1);

    // Calculate the new zoom scale.
    NewZoomScale = GetZoomScale(ZoomLevel);

    // Get viewport-space location of mouse cursor.
    ViewportLocation = GetNormalizedLocation(Controller.MouseX, Controller.MouseY);

    // Get the new viewport by scaling the current viewport with the mouse
    // location as the scaling origin.
    NewViewport = class'UBox'.static.Scale(Viewport, ViewportLocation, NewZoomScale / OldZoomScale);

    InterpolateToViewport(NewViewport);
}

function ZoomOut()
{
    local vector ViewportLocation;
    local Box NewViewport;
    local float OldZoomScale, NewZoomScale;

    if (!CanZoomOut())
    {
        return;
    }

    // Save the old zoom scale.
    OldZoomScale = Viewport.Max.X - Viewport.Min.X;

    // Increment the zoom leve.
    SetZoomLevel(ZoomLevel - 1);

    // Calculate the new zoom scale.
    NewZoomScale = GetZoomScale(ZoomLevel);

    // Get viewport-space location of mouse cursor.
    ViewportLocation = GetNormalizedLocation(Controller.MouseX, Controller.MouseY);

    // TODO: scale by max/min of current viewport
    ViewportLocation = Viewport.Min + (ViewportLocation * (Viewport.Max - Viewport.Min));

    // Get the new viewport by scaling the current viewport with the mouse
    // location as the scaling origin.
    NewViewport = class'UBox'.static.Scale(Viewport, ViewportLocation, NewZoomScale / OldZoomScale);

    InterpolateToViewport(NewViewport);
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
    if (ZoomLevel > 0)
    {
        bIsPanning = true;
    }
}

function InternalOnMouseRelease(GUIComponent Sender)
{
    bIsPanning = false;
}

function bool InternalOnCapturedMouseMove(float DeltaX, float DeltaY)
{
    local float W, H;
    local vector OriginDelta;

    if (!bIsViewportInterpolating && bIsPanning)
    {
        W = ActualWidth(WinWidth);
        H = ActualHeight(WinHeight);

        OriginDelta.X -= (DeltaX / W) * GetZoomScale(ZoomLevel);
        OriginDelta.Y += (DeltaY / H) * GetZoomScale(ZoomLevel);

        Viewport = class'UBox'.static.Translate(Viewport, OriginDelta);
        Viewport = ConstrainViewport(Viewport, vect(0, 0, 0), vect(1, 1, 0));

        return true;
    }

    // TODO: Check if cursor is overtop of a player.

    return false;
}

function bool InternalOnHover(GUIComponent Sender)
{
    if (Sender == self)
    {
        SetFocus(none);
    }

    return false;
}

defaultproperties
{
    bAcceptsInput=true
    bCaptureMouse=true

    SquadRallyPointDestroyText="Destroy Rally"
    SquadRallyPointSetAsSecondaryText="Set as Secondary"
    RemoveText="Remove {0}"
    ActiveTargetSelectText="Select as Active Target"
    ActiveTargetDeselectText="Deselect Active Target"
    TargetSquadIndex=-1;

    OnKeyEvent=InternalOnKeyEvent
    OnMousePressed=InternalOnMousePressed
    OnMouseRelease=InternalOnMouseRelease
    OnCapturedMouseMove=InternalOnCapturedMouseMove
    OnHover=InternalOnHover

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

    ZoomLevelMax=3
    ZoomScaleRange=(Min=0.25,Max=1.0)
    ViewportInterpDuration=0.33
    Viewport=(Min=(X=0,Y=0),Max=(X=1,Y=1))
}
