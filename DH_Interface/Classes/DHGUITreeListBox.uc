// *************************************************************************
//
//	***   DHGUITreeListBox   ***
//
// *************************************************************************

class DHGUITreeListBox extends GUITreeListBox;

defaultproperties
{
     DefaultListClass="DH_Interface.DHGUITreeList"
     Begin Object Class=DHGUITreeScrollBar Name=DHTreeScrollbar
         bVisible=False
         OnPreDraw=DHTreeScrollbar.GripPreDraw
     End Object
     MyScrollBar=DHGUITreeScrollBar'DH_Interface.DHGUITreeListBox.DHTreeScrollbar'

     StyleName="DHSmallText"
}
