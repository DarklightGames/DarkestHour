//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHGUIVertScrollBar extends GUIVertScrollBar;

defaultproperties
{
    Begin Object Class=GUIVertScrollZone Name=ScrollZone
        OnScrollZoneClick=GUIVertScrollBar.ZoneClick
        StyleName="DHEditBox"
        OnClick=ScrollZone.InternalOnClick
    End Object
    MyScrollZone=GUIVertScrollZone'DH_Interface.ScrollZone'
    Begin Object Class=DHGUIVertScrollButton Name=DownBut
        bIncreaseButton=true
        OnClick=GUIVertScrollBar.IncreaseClick
        OnKeyEvent=DownBut.InternalOnKeyEvent
    End Object
    MyIncreaseButton=DHGUIVertScrollButton'DH_Interface.DownBut'
    Begin Object Class=DHGUIVertScrollButton Name=UpBut
        OnClick=GUIVertScrollBar.DecreaseClick
        OnKeyEvent=UpBut.InternalOnKeyEvent
    End Object
    MyDecreaseButton=DHGUIVertScrollButton'DH_Interface.UpBut'
    Begin Object Class=GUIVertGripButton Name=Grip
        StyleName="DHGripButton"
        OnMousePressed=GUIVertScrollBar.GripPressed
        OnKeyEvent=Grip.InternalOnKeyEvent
    End Object
    MyGripButton=GUIVertGripButton'DH_Interface.Grip'
    OnPreDraw=DHGUIVertScrollBar.GripPreDraw
}
