//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGUIDynArrayPage extends GUIDynArrayPage;

function AddSystemMenu(){}

defaultproperties
{
    MOType="DH_Interface.DHmoEditBox"
    Begin Object Class=DHGUIMultiOptionListBox Name=ValueListBox
        bVisibleWhenEmpty=true
        OnCreateComponent=DHGUIDynArrayPage.InternalOnCreateComponent
        WinTop=0.140209
        WinLeft=0.02125
        WinWidth=0.865001
        WinHeight=0.714452
        TabOrder=0
        bBoundToParent=true
        bScaleToParent=true
        OnChange=DHGUIDynArrayPage.InternalOnChange
    End Object
    lb_Values=DHGUIMultiOptionListBox'DH_Interface.DHGUIDynArrayPage.ValueListBox'
    ButtonStyle="DHMenuTextButtonStyle"
    Begin Object Class=AltSectionBackground Name=Bk1
        HeaderBase=Texture'DH_GUI_Tex.Menu.DHDisplay'
        LeftPadding=0.01
        RightPadding=0.15
        WinTop=0.095833
        WinLeft=0.04375
        WinWidth=0.7625
        WinHeight=0.575
        OnPreDraw=Bk1.InternalPreDraw
    End Object
    sb_Bk1=AltSectionBackground'DH_Interface.DHGUIDynArrayPage.Bk1'
    Begin Object Class=DHGUISectionBackground Name=InternalFrameImage
        WinTop=0.075
        WinLeft=0.04
        WinWidth=0.675859
        WinHeight=0.550976
        OnPreDraw=InternalFrameImage.InternalPreDraw
    End Object
    sb_Main=DHGUISectionBackground'DH_Interface.DHGUIDynArrayPage.InternalFrameImage'
    Begin Object Class=GUIButton Name=LockedCancelButton
        Caption="Cancel"
        bAutoShrink=false
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.872397
        WinLeft=0.512695
        WinWidth=0.159649
        TabOrder=99
        bBoundToParent=true
        OnClick=DHGUIDynArrayPage.InternalOnClick
        OnKeyEvent=LockedCancelButton.InternalOnKeyEvent
    End Object
    b_Cancel=GUIButton'DH_Interface.DHGUIDynArrayPage.LockedCancelButton'
    Begin Object Class=GUIButton Name=LockedOKButton
        Caption="OK"
        bAutoShrink=false
        StyleName="DHMenuTextButtonStyle"
        WinTop=0.872397
        WinLeft=0.742188
        WinWidth=0.159649
        TabOrder=100
        bBoundToParent=true
        OnClick=DHGUIDynArrayPage.InternalOnClick
        OnKeyEvent=LockedOKButton.InternalOnKeyEvent
    End Object
    b_OK=GUIButton'DH_Interface.DHGUIDynArrayPage.LockedOKButton'
    Begin Object Class=DHGUIHeader Name=TitleBar
        bUseTextHeight=true
        StyleName="DHNoBox"
        WinTop=0.017
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
    t_WindowTitle=DHGUIHeader'DH_Interface.DHGUIDynArrayPage.TitleBar'
    Begin Object Class=FloatingImage Name=FloatingFrameBackground
        Image=Texture'DH_GUI_Tex.Menu.DHDisplay_withcaption_noAlpha'
        DropShadow=none
        ImageStyle=ISTY_Stretched
        ImageRenderStyle=MSTY_Normal
        WinTop=0.02
        WinLeft=0.0
        WinWidth=1.0
        WinHeight=0.98
        RenderWeight=0.000003
    End Object
    i_FrameBG=FloatingImage'DH_Interface.DHGUIDynArrayPage.FloatingFrameBackground'
    OnCreateComponent=DHGUIDynArrayPage.InternalOnCreateComponent
}
