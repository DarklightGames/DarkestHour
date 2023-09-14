//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMutatorConfigMenu extends MutatorConfigMenu;

function AddSystemMenu(){}

defaultproperties
{
    Begin Object Class=DHGUIMultiOptionListBox Name=ConfigList
        bVisibleWhenEmpty=true
        OnCreateComponent=DHMutatorConfigMenu.InternalOnCreateComponent
        WinTop=0.143333
        WinLeft=0.0375
        WinWidth=0.918753
        WinHeight=0.697502
        RenderWeight=0.9
        TabOrder=1
        bBoundToParent=true
        bScaleToParent=true
        OnChange=DHMutatorConfigMenu.InternalOnChange
    End Object
    lb_Config=DHGUIMultiOptionListBox'DH_Interface.DHMutatorConfigMenu.ConfigList'
    Begin Object Class=DHmoCheckBox Name=AdvancedButton
        Caption="View Advanced Options"
        OnCreateComponent=AdvancedButton.InternalOnCreateComponent
        WinTop=0.911982
        WinLeft=0.0375
        WinWidth=0.31
        WinHeight=0.04
        RenderWeight=1.0
        TabOrder=1
        bBoundToParent=true
        OnChange=DHMutatorConfigMenu.InternalOnChange
    End Object
    ch_Advanced=DHmoCheckBox'DH_Interface.DHMutatorConfigMenu.AdvancedButton'
    Begin Object Class=DHGUIPlainBackground Name=InternalFrameImage
        WinTop=0.092
        WinLeft=0.04
        WinWidth=0.675859
        WinHeight=0.548976
        OnPreDraw=InternalFrameImage.InternalPreDraw
    End Object
    sb_Main=DHGUIPlainBackground'DH_Interface.DHMutatorConfigMenu.InternalFrameImage'
    Begin Object Class=GUIButton Name=LockedCancelButton
        Caption="Cancel"
        bAutoShrink=false
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.872397
        WinLeft=0.512695
        WinWidth=0.159649
        TabOrder=99
        bBoundToParent=true
        OnClick=DHMutatorConfigMenu.InternalOnClick
        OnKeyEvent=LockedCancelButton.InternalOnKeyEvent
    End Object
    b_Cancel=GUIButton'DH_Interface.DHMutatorConfigMenu.LockedCancelButton'
    Begin Object Class=GUIButton Name=LockedOKButton
        Caption="OK"
        bAutoShrink=false
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.872397
        WinLeft=0.742188
        WinWidth=0.159649
        TabOrder=100
        bBoundToParent=true
        OnClick=DHMutatorConfigMenu.InternalOnClick
        OnKeyEvent=LockedOKButton.InternalOnKeyEvent
    End Object
    b_OK=GUIButton'DH_Interface.DHMutatorConfigMenu.LockedOKButton'
    Begin Object Class=DHGUIHeader Name=TitleBar
        bUseTextHeight=true
        StyleName="DHNoBox"
        WinTop=0.02
        WinHeight=0.05
        RenderWeight=0.1
        bBoundToParent=true
        bScaleToParent=true
        bAcceptsInput=true
        bNeverFocus=false
        ScalingType=SCALE_X
        OnMousePressed=FloatingWindow.FloatingMousePressed
        OnMouseRelease=FloatingWindow.FloatingMouseRelease
    End Object
    t_WindowTitle=DHGUIHeader'DH_Interface.DHMutatorConfigMenu.TitleBar'
    Begin Object Class=FloatingImage Name=FloatingFrameBackground
        Image=Texture'DH_GUI_Tex.Menu.DHDisplay_withcaption_noAlpha'
        DropShadow=none
        ImageStyle=ISTY_Stretched
        ImageRenderStyle=MSTY_Normal
        WinTop=0.02
        WinLeft=0.0
        WinWidth=1.0
        WinHeight=1.0
        RenderWeight=0.000003
    End Object
    i_FrameBG=FloatingImage'DH_Interface.DHMutatorConfigMenu.FloatingFrameBackground'
}
