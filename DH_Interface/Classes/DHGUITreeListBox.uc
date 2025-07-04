//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHGUITreeListBox extends GUITreeListBox;

defaultproperties
{
    DefaultListClass="DH_Interface.DHGUITreeList"
    Begin Object Class=DHGUITreeScrollBar Name=DHTreeScrollbar
        bVisible=false
        OnPreDraw=DHTreeScrollbar.GripPreDraw
    End Object
    MyScrollBar=DHGUITreeScrollBar'DH_Interface.DHTreeScrollbar'
    StyleName="DHSmallText"
}
