//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGUIMapContainer extends GUIPanel;

var automated GUIImage              i_Border;
var automated DHGUIMapComponent     p_Map;
var automated GUIImage              c_BorderTop;
var automated GUIImage              c_BorderBottom;
var automated GUIImage              c_BorderLeft;
var automated GUIImage              c_BorderRight;

delegate OnSpawnPointChanged(int SpawnPointIndex, optional bool bDoubleClick);
delegate OnZoomLevelChanged(int ZoomLevel);

function InternalOnSpawnPointChanged(int SpawnPointIndex, optional bool bDoubleClick)
{
    OnSpawnPointChanged(SpawnPointIndex, bDoubleClick);
}

function InternalOnZoomLevelChanged(int ZoomLevel)
{
    OnZoomLevelChanged(ZoomLevel);
}

function bool InternalOnPostDraw(Canvas C)
{
    local int i, j;
    local float D, X, Y, X1, Y1, X2, Y2, Step;
    local string Symbol;

    const GRID_COUNT = 9;

    C.Font = class'DHHud'.static.GetSmallerMenuFont(C);
    C.SetDrawColor(255, 255, 255, 255);

    // Draw horizontal grid lines
    Step = 1.0 / GRID_COUNT;
    D = p_Map.Viewport.Max.X -  p_Map.Viewport.Min.X;
    i = int(p_Map.Viewport.Min.X / Step);
    j = Ceil(p_Map.Viewport.Max.X / Step);

    for (i = i; i < j; ++i)
    {
        X = ((i * Step) -  p_Map.Viewport.Min.X) / D;

        if (X < 1)
        {
            Symbol = Chr(Asc("1") + i);

            X1 = c_BorderTop.ActualLeft() + (X * c_BorderTop.ActualWidth());
            X2 = X1 + ((Step / D) * c_BorderTop.ActualWidth());
            X = X1 + ((X2 - X1) / 2);

            if (X < c_BorderTop.ActualLeft() || X > c_BorderTop.ActualLeft() + c_BorderTop.ActualWidth())
            {
                continue;
            }

            Y1 = c_BorderTop.ActualTop();
            Y2 = c_BorderTop.ActualTop() + c_BorderTop.ActualHeight();
            C.DrawTextJustified(Symbol, 1, X1, Y1, X2, Y2);

            Y1 = c_BorderBottom.ActualTop();
            Y2 = c_BorderBottom.ActualTop() + c_BorderBottom.ActualHeight();
            C.DrawTextJustified(Symbol, 1, X1, Y1, X2, Y2);
        }
    }

    D = p_Map.Viewport.Max.Y - p_Map.Viewport.Min.Y;
    i = int(p_Map.Viewport.Min.Y / Step);
    j = Ceil(p_Map.Viewport.Max.Y / Step);

    for (i = i; i < j; ++i)
    {
        // Convert from viewport-space to view-space.
        Y = ((i * Step) -  p_Map.Viewport.Min.Y) / D;

        if (Y < 1)
        {
            Symbol = Chr(Asc("A") + i);

            Y1 = c_BorderLeft.ActualTop() + (Y * c_BorderLeft.ActualHeight());
            Y2 = Y1 + ((Step / D) * c_BorderLeft.ActualHeight());
            Y = Y1 + ((Y2 - Y1) / 2);

            if (Y < c_BorderLeft.ActualTop() || Y > c_BorderLeft.ActualTop() + c_BorderLeft.ActualHeight())
            {
                continue;
            }

            X1 = c_BorderLeft.ActualLeft();
            X2 = c_BorderLeft.ActualLeft() + c_BorderLeft.ActualWidth();
            C.DrawTextJustified(Symbol, 1, X1, Y1, X2, Y2);

            X1 = c_BorderRight.ActualLeft();
            X2 = c_BorderRight.ActualLeft() + c_BorderRight.ActualWidth();
            C.DrawTextJustified(Symbol, 1, X1, Y1, X2, Y2);
        }
    }

    return false;
}

defaultproperties
{
    OnPostDraw=InternalOnPostDraw

    Begin Object Class=GUIImage Name=BorderImageObject
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        bNeverFocus=true
        ImageStyle=ISTY_Scaled
        Image=Material'DH_GUI_tex.DeployMenu.map_border'
    End Object
    i_Border=BorderImageObject

    Begin Object Class=GUIImage Name=BorderTopObject
        WinWidth=0.89
        WinHeight=0.025
        WinLeft=0.055
        WinTop=0.025
    End Object
    c_BorderTop=BorderTopObject

    Begin Object Class=GUIImage Name=BorderBottomObject
        WinWidth=0.89
        WinHeight=0.025
        WinLeft=0.055
        WinTop=0.95
    End Object
    c_BorderBottom=BorderBottomObject

    Begin Object Class=GUIImage Name=BorderLeftObject
        WinWidth=0.025
        WinHeight=0.89
        WinLeft=0.025
        WinTop=0.055
    End Object
    c_BorderLeft=BorderLeftObject

    Begin Object Class=GUIImage Name=BorderRightObject
        WinWidth=0.025
        WinHeight=0.89
        WinLeft=0.95
        WinTop=0.055
    End Object
    c_BorderRight=BorderRightObject

    Begin Object Class=DHGUIMapComponent Name=MapComponentObject
        WinWidth=0.89
        WinHeight=0.89
        WinLeft=0.055
        WinTop=0.055
        OnSpawnPointChanged=InternalOnSpawnPointChanged
        OnZoomLevelChanged=InternalOnZoomLevelChanged
    End Object
    p_Map=MapComponentObject
}

