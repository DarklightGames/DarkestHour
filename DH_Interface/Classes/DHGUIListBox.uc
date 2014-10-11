class DHGUIListBox extends ROGUIListBoxPlus;

defaultproperties
{
         Begin Object Class=DHGUIVertScrollBar Name=TheScrollbar
         bVisible=false
         OnPreDraw=TheScrollbar.GripPreDraw
     End Object
     MyScrollBar=DHGUIVertScrollBar'DH_Interface.DHGUIListBox.TheScrollbar'
}

