//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
