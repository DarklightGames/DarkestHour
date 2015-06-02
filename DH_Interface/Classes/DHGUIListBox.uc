//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHGUIListBox extends ROGUIListBoxPlus;

defaultproperties
{
    Begin Object Class=DHGUIVertScrollBar Name=TheScrollbar
        bVisible=false
        OnPreDraw=TheScrollbar.GripPreDraw
    End Object
    MyScrollBar=DHGUIVertScrollBar'DH_Interface.DHGUIListBox.TheScrollbar'

    DefaultListClass="DH_Interface.DHGUIList"
}

