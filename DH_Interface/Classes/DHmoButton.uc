//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHmoButton extends moButton;

var(Option) string DHButtonStyleName;

function InternalOnCreateComponent(GUIComponent NewComp, GUIComponent Sender)
{
    super.InternalOnCreateComponent(NewComp, Sender);

    NewComp.StyleName = DHButtonStyleName;
}

defaultproperties
{
    DHButtonStyleName="DHSmallTextButtonStyle"
    CaptionWidth=0.0
    ComponentClassName="DH_Interface.DHGUIButton"
    LabelStyleName="DHLargeText"
    StyleName="DHSmallTextButtonStyle"
    WinHeight=0.04
}
