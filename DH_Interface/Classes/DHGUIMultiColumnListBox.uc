//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGUIMultiColumnListBox extends GUIMultiColumnListBox;

defaultproperties
{
    Begin Object Class=GUIMultiColumnListHeader Name=MyHeader
        BarStyleName="DHMultiColBar"
        StyleName="DHMultiColBar"
    End Object
    Header=GUIMultiColumnListHeader'DH_Interface.DHGUIMultiColumnListBox.MyHeader'
    DefaultListClass="DH_Interface.DHGUIMultiColumnList"
    Begin Object Class=DHGUIVertScrollBar Name=TheScrollbar
        bVisible=false
        OnPreDraw=TheScrollbar.GripPreDraw
    End Object
    MyScrollBar=DHGUIVertScrollBar'DH_Interface.DHGUIMultiColumnListBox.TheScrollbar'
}
