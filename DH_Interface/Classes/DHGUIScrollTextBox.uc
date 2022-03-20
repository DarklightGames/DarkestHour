//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
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
