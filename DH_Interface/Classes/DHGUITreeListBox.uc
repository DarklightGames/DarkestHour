//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGUITreeListBox extends GUITreeListBox;

defaultproperties
{
    DefaultListClass="DH_Interface.DHGUITreeList"
    Begin Object Class=DHGUITreeScrollBar Name=DHTreeScrollbar
        bVisible=false
        OnPreDraw=DHTreeScrollbar.GripPreDraw
    End Object
    MyScrollBar=DHGUITreeScrollBar'DH_Interface.DHGUITreeListBox.DHTreeScrollbar'
    StyleName="DHSmallText"
}
