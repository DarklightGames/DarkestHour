//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHGUIScrollTextBox extends GUIScrollTextBox;

defaultproperties
{
    Begin Object Class=DHGUIVertScrollBar Name=TheScrollbar
        bVisible=false
        OnPreDraw=TheScrollbar.GripPreDraw
    End Object
    MyScrollBar=DHGUIVertScrollBar'DH_Interface.DHGUIScrollTextBox.TheScrollbar'
}
