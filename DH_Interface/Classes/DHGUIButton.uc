//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHGUIButton extends GUIButton;

defaultproperties
{
    StyleName="DHMenuTextButtonStyle"
    OnKeyEvent=DHGUIButton.InternalOnKeyEvent
    Begin Object Class=DHGUIToolTip Name=GUIButtonToolTip
    End Object
    ToolTip=GUIButtonToolTip
}
