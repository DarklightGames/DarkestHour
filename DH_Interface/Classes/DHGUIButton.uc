//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
