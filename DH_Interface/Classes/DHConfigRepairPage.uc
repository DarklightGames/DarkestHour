//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHConfigRepairPage extends UT2K3GUIPage;

function bool InternalOnClick(GUIComponent Sender)
{
    local DHConsole NewConsole;

    if (Sender==Controls[1])
    {
        Controller.CloseMenu(false);
    }
    else
    {
        Controller.CloseMenu(false);
    }

    return true;
}

defaultproperties
{
    bRenderWorld=true
    bRequire640x480=false
    InactiveFadeColor=(B=255,G=255,R=255)
    Begin Object Class=GUIButton Name=PromptBackground
        StyleName="DHExitPageStyle"
        WinTop=0.060000
        WinLeft=0.0000
        WinWidth=1.0000
        WinHeight=0.800000
        bBoundToParent=true
        bScaleToParent=true
        bAcceptsInput=false
        bNeverFocus=true
        OnKeyEvent=PromptBackground.InternalOnKeyEvent
    End Object
    Controls(0)=GUIButton'DH_Interface.DHConfigRepairPage.PromptBackground'

    Begin Object Class=GUIButton Name=YesButton
        Caption="YES"
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.500000
        WinLeft=0.280000
        WinWidth=0.200000
        WinHeight=0.080000
        bBoundToParent=true
        OnClick=DHConfigRepairPage.InternalOnClick
        OnKeyEvent=YesButton.InternalOnKeyEvent
    End Object
    Controls(1)=GUIButton'DH_Interface.DHConfigRepairPage.YesButton'

    Begin Object Class=GUIButton Name=NoButton
        Caption="NO"
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.500000
        WinLeft=0.520000
        WinWidth=0.200000
        WinHeight=0.080000
        bBoundToParent=true
        OnClick=DHConfigRepairPage.InternalOnClick
        OnKeyEvent=NoButton.InternalOnKeyEvent
    End Object
    Controls(2)=GUIButton'DH_Interface.DHConfigRepairPage.NoButton'

    Begin Object Class=GUILabel Name=RepairDesc
        Caption="We detected an incorrect configuration value, would you like us to temporary repair it?"
        TextAlign=TXTA_Center
        TextColor=(B=255,G=255,R=255)
        TextFont="DHMenuFont"
        StyleName="none"
        WinTop=0.420000
        WinHeight=32.000000
    End Object
    Controls(3)=GUILabel'DH_Interface.DHConfigRepairPage.RepairDesc'

    WinTop=0.375000
    WinHeight=0.250000
}
