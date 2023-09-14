//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHQuitPage extends UT2K3GUIPage;

function bool InternalOnClick(GUIComponent Sender)
{
    if (Sender == Controls[1])
    {
        PlayerOwner().ConsoleCommand("exit");
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
    Begin Object Class=GUIButton Name=QuitBackground
        StyleName="DHExitPageStyle"
        WinTop=0.06
        WinLeft=0.27
        WinWidth=0.47
        WinHeight=0.8
        bBoundToParent=true
        bScaleToParent=true
        bAcceptsInput=false
        bNeverFocus=true
        OnKeyEvent=QuitBackground.InternalOnKeyEvent
    End Object
    Controls(0)=GUIButton'DH_Interface.DHQuitPage.QuitBackground'
    Begin Object Class=GUIButton Name=YesButton
        Caption="YES"
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.5
        WinLeft=0.28
        WinWidth=0.2
        WinHeight=0.08
        bBoundToParent=true
        OnClick=DHQuitPage.InternalOnClick
        OnKeyEvent=YesButton.InternalOnKeyEvent
    End Object
    Controls(1)=GUIButton'DH_Interface.DHQuitPage.YesButton'
    Begin Object Class=GUIButton Name=NoButton
        Caption="NO"
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.5
        WinLeft=0.52
        WinWidth=0.2
        WinHeight=0.08
        bBoundToParent=true
        OnClick=DHQuitPage.InternalOnClick
        OnKeyEvent=NoButton.InternalOnKeyEvent
    End Object
    Controls(2)=GUIButton'DH_Interface.DHQuitPage.NoButton'
    Begin Object Class=GUILabel Name=QuitDesc
        Caption="Are you sure you wish to quit?"
        TextAlign=TXTA_Center
        TextColor=(B=255,G=255,R=255)
        TextFont="DHMenuFont"
        StyleName="none"
        WinTop=0.42
        WinHeight=32.0
    End Object
    Controls(3)=GUILabel'DH_Interface.DHQuitPage.QuitDesc'
    WinTop=0.375
    WinHeight=0.25
}
