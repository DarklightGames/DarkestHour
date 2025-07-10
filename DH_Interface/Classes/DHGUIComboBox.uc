//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHGUIComboBox extends GUIComboBox;

defaultproperties
{
    Begin Object Class=DHGUIEditBox Name=EditBox1
        StyleName="DHEditBox"
        bNeverScale=true
        OnActivate=EditBox1.InternalActivate
        OnDeActivate=EditBox1.InternalDeactivate
        OnKeyType=EditBox1.InternalOnKeyType
        OnKeyEvent=EditBox1.InternalOnKeyEvent
    End Object
    Edit=EditBox1
    Begin Object Class=GUIComboButton Name=ShowList
        StyleName="DHGripButton"
        RenderWeight=0.6
        bNeverScale=true
        OnKeyEvent=ShowList.InternalOnKeyEvent
    End Object
    MyShowListBtn=ShowList
    Begin Object Class=DHGUIListBox Name=ListBox1
        SelectedStyleName="DHListSelectionStyle"
        OnCreateComponent=ListBox1.InternalOnCreateComponent
        StyleName="DHComboListBox"
        RenderWeight=0.7
        bTabStop=false
        bVisible=false
        bNeverScale=true
    End Object
    MyListBox=ListBox1
    OnKeyEvent=DHGUIComboBox.InternalOnKeyEvent
}
