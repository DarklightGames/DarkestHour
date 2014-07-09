// *************************************************************************
//
//	***   DHGUIComboBox   ***
//
// *************************************************************************

class DHGUIComboBox extends GUIComboBox;

defaultproperties
{
     Begin Object Class=GUIEditBox Name=EditBox1
         StyleName="DHEditBox"
         bNeverScale=True
         OnActivate=EditBox1.InternalActivate
         OnDeActivate=EditBox1.InternalDeactivate
         OnKeyType=EditBox1.InternalOnKeyType
         OnKeyEvent=EditBox1.InternalOnKeyEvent
     End Object
     Edit=GUIEditBox'DH_Interface.DHGUIComboBox.EditBox1'

     Begin Object Class=GUIComboButton Name=ShowList
         StyleName="DHGripButton"
         RenderWeight=0.600000
         bNeverScale=True
         OnKeyEvent=ShowList.InternalOnKeyEvent
     End Object
     MyShowListBtn=GUIComboButton'DH_Interface.DHGUIComboBox.ShowList'

     Begin Object Class=GUIListBox Name=ListBox1
         SelectedStyleName="DHListSelectionStyle"
         OnCreateComponent=ListBox1.InternalOnCreateComponent
         StyleName="DHComboListBox"
         RenderWeight=0.700000
         bTabStop=False
         bVisible=False
         bNeverScale=True
     End Object
     MyListBox=GUIListBox'DH_Interface.DHGUIComboBox.ListBox1'

     Begin Object Class=GUIToolTip Name=GUIComboBoxToolTip
     End Object
     ToolTip=GUIToolTip'DH_Interface.DHGUIComboBox.GUIComboBoxToolTip'

     OnKeyEvent=DHGUIComboBox.InternalOnKeyEvent
}
