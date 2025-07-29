//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHGUIFloatEdit extends GUIFloatEdit;

defaultproperties
{
    Begin Object Class=DHGUIEditBox Name=cMyEditBox
        bFloatOnly=true
        bNeverScale=true
        OnActivate=cMyEditBox.InternalActivate
        OnDeActivate=cMyEditBox.InternalDeactivate
        OnKeyType=cMyEditBox.InternalOnKeyType
        OnKeyEvent=cMyEditBox.InternalOnKeyEvent
    End Object
    MyEditBox=DHGUIEditBox'DH_Interface.cMyEditBox'
    Begin Object Class=GUISpinnerButton Name=cMySpinner
        StyleName="DHSpinner"
        bTabStop=false
        bNeverScale=true
        OnClick=cMySpinner.InternalOnClick
        OnKeyEvent=cMySpinner.InternalOnKeyEvent
    End Object
    MySpinner=GUISpinnerButton'DH_Interface.cMySpinner'
}
