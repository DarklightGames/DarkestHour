//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHGUINumericEdit extends GUINumericEdit;

var()   int                 MidValue;

defaultproperties
{
    Begin Object Class=DHGUIEditBox Name=cMyEditBox
        bIntOnly=true
        bNeverScale=true
        OnActivate=cMyEditBox.InternalActivate
        OnDeActivate=cMyEditBox.InternalDeactivate
        OnKeyType=cMyEditBox.InternalOnKeyType
        OnKeyEvent=cMyEditBox.InternalOnKeyEvent
    End Object
    MyEditBox=cMyEditBox
    Begin Object Class=DHGUISpinnerButton Name=cMySpinner
        StyleName="DHSpinner"
        bTabStop=false
        bNeverScale=true
        OnClick=cMySpinner.InternalOnClick
        OnKeyEvent=cMySpinner.InternalOnKeyEvent
    End Object
    MySpinner=cMySpinner

    Begin Object Class=DHGUIToolTip Name=GUIButtonTooltip
	End Object
	ToolTip=GUIButtonTooltip
}
