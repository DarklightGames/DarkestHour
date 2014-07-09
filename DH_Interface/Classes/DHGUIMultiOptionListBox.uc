class DHGUIMultiOptionListBox extends GUIMultiOptionListBox;

defaultproperties
{
     SectionStyleName="DHListSection"
     DefaultListClass="DH_Interface.DHGUIMultiOptionList"
     Begin Object Class=DHGUIVertScrollBar Name=TheScrollbar
         bVisible=False
         OnPreDraw=TheScrollbar.GripPreDraw
     End Object
     MyScrollBar=DHGUIVertScrollBar'DH_Interface.DHGUIMultiOptionListBox.TheScrollbar'

}
