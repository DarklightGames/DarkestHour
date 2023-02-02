//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGameFooterMP extends UT2K4GameFooter;

defaultproperties
{
    Begin Object Class=GUIButton Name=GamePrimaryButton
        MenuState=MSAT_Disabled
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.966146
        WinLeft=0.88
        WinWidth=0.12
        WinHeight=0.033203
        TabOrder=0
        bBoundToParent=true
        OnKeyEvent=GamePrimaryButton.InternalOnKeyEvent
    End Object
    b_Primary=GUIButton'DH_Interface.DHGameFooterMP.GamePrimaryButton'
    Begin Object Class=GUIButton Name=GameSecondaryButton
        MenuState=MSAT_Disabled
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.966146
        WinLeft=0.758125
        WinWidth=0.12
        WinHeight=0.033203
        TabOrder=1
        bBoundToParent=true
        OnKeyEvent=GameSecondaryButton.InternalOnKeyEvent
    End Object
    b_Secondary=GUIButton'DH_Interface.DHGameFooterMP.GameSecondaryButton'
    Begin Object Class=GUIButton Name=GameBackButton
        Caption="Back"
        StyleName="DHSmallTextButtonStyle"
        WinTop=0.966146
        WinWidth=0.12
        WinHeight=0.033203
        TabOrder=2
        bBoundToParent=true
        OnKeyEvent=GameBackButton.InternalOnKeyEvent
    End Object
    b_Back=GUIButton'DH_Interface.DHGameFooterMP.GameBackButton'
}
