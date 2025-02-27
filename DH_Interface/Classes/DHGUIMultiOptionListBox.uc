//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHGUIMultiOptionListBox extends GUIMultiOptionListBox;

defaultproperties
{
    SectionStyleName="DHListSection"
    DefaultListClass="DH_Interface.DHGUIMultiOptionList"
    Begin Object Class=DHGUIVertScrollBar Name=TheScrollbar
        bVisible=false
        OnPreDraw=TheScrollbar.GripPreDraw
    End Object
    MyScrollBar=DHGUIVertScrollBar'DH_Interface.DHGUIMultiOptionListBox.TheScrollbar'
}
