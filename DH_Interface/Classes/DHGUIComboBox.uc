//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGUIComboBox extends GUIComboBox;

defaultproperties
{
    Begin Object Class=GUIEditBox Name=EditBox1
        StyleName="DHEditBox"
        bNeverScale=true
        OnActivate=EditBox1.InternalActivate
        OnDeActivate=EditBox1.InternalDeactivate
        OnKeyType=EditBox1.InternalOnKeyType
        OnKeyEvent=EditBox1.InternalOnKeyEvent
    End Object
    Edit=GUIEditBox'DH_Interface.DHGUIComboBox.EditBox1'
    Begin Object Class=GUIComboButton Name=ShowList
        StyleName="DHGripButton"
        RenderWeight=0.6
        bNeverScale=true
        OnKeyEvent=ShowList.InternalOnKeyEvent
    End Object
    MyShowListBtn=GUIComboButton'DH_Interface.DHGUIComboBox.ShowList'
    Begin Object Class=GUIListBox Name=ListBox1
        SelectedStyleName="DHListSelectionStyle"
        OnCreateComponent=ListBox1.InternalOnCreateComponent
        StyleName="DHComboListBox"
        RenderWeight=0.7
        bTabStop=false
        bVisible=false
        bNeverScale=true
    End Object
    MyListBox=GUIListBox'DH_Interface.DHGUIComboBox.ListBox1'
    Begin Object Class=GUIToolTip Name=GUIComboBoxToolTip
    End Object
    ToolTip=GUIToolTip'DH_Interface.DHGUIComboBox.GUIComboBoxToolTip'
    OnKeyEvent=DHGUIComboBox.InternalOnKeyEvent
}
