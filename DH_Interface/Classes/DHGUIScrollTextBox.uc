class DHGUIScrollTextBox extends GUIScrollTextBox;

defaultproperties
{
     Begin Object Class=DHGUIVertScrollBar Name=TheScrollbar
         bVisible=False
         OnPreDraw=TheScrollbar.GripPreDraw
     End Object
     MyScrollBar=DHGUIVertScrollBar'DH_Interface.DHGUIScrollTextBox.TheScrollbar'

}
