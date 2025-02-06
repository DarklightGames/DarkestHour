//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHmoComboBox extends moComboBox;

function Clear()
{
    RemoveItem(0, ItemCount());
}

defaultproperties
{
    ComponentClassName="DH_Interface.DHGUIComboBox"
    LabelStyleName="DHLargeText"
    StyleName="DHSmallText"
    
	Begin Object Class=DHGUIToolTip Name=GUIMenuOptionToolTip
	End Object
	ToolTip=GUIMenuOptionToolTip
}
